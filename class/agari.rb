#和了形クラス。和了形の面子の解釈の状態を保持
require "class/check.rb"
class Agari
    include Check
    def initialize(tehai,tsumohai,mentsus,player,tsumo=true)
        @pais = tehai
        @pai = tsumohai
        @tehai = @pais.dup.push(@pai)
        #ツモ上がりしたかどうか
        #@tsumo = tsumo
        @tsumo = tsumo
        #面子のスタックをそのまま格納
        #おそらく容量５で頭＋面子*4が格納されているはず
        @mentsus = mentsus.dup
        #役の一覧
        @yakus = Array.new
        @player = player
        #面前かどうか（全ての面子を検索して、全てが副露してないとき）
        @menzen = menzen?
        @yakuman = false
        @fu = 20
        @fan = 0
        @pinhuo = false
        @tiitoi = false
        @checked = false #役の判定が終わっているかどうか
    end
    #面前かどうか調べる
    def menzen?
        b = true
        @mentsus.each do |m|
            if m.fooroh
                b = false
                break
            end
        end
        return b
    end
    def get_yaku
        if @mentsus.length == 1
            #国士無双形の場合
            kokushi?
        else
            if @mentsus.length == 7
                #七対子形の場合
                @yakus.push(Yaku.new("七対子",2))
                @tiitoi = true
            end
            @mentsus.each do |m|
                m.ex_pais
            end
            check_yaku
        end
        #役満が一つでも含まれていたら、他の役を全て無効に
        yakuman = @yakus.select{|y|y.yakuman?}
        if !yakuman.empty?
            @yakus.delete_if{|y|!y.yakuman?}
            @mes = "役満"
            @yakuman = true
        end
        return @yakus
    end
    def get_score
        calc_score
        return {:fu=>@fu,:fan=>@fan,:score=>@score,:message=>@mes,:yaku=>@yakus}
    end
    #点数を計算する
    def calc_score
        #yakus配列を全て調査
        #一つでも役満があったら、役満以外を消去
        #役満がなかったら、役の合計から半数を求める。
        #数え役満はとりあえずなしの方向で（合計が13飜以上になったときに別処理）
        get_yaku
        #ドラの加算
        dora=0
        $stage.get_doras(@player.reach?).each do |d|
            dora +=@tehai.count(d)
        end
        if dora > 0
            @yakus.push(Yaku.new("ドラ",dora))
        end
        #符の計算
        if @tiitoi
            #七対子なら25符確定
            @fu = 25
        else
            #門前ロン
            if @menzen && !@tsumo
                @fu +=10
            elsif !@menzen && !@tsumo && @pinhu
                #喰い平和ロン上がりで30符
                @fu +=10
            end

            #刻子、槓子を元に符を出す
            @mentsus.each do |m|
                if m.get_kind == 2 || m.get_kind == 3
                    if m.get_pais.count_yaochu >= 3
                        f = 0
                        if m.get_kind == 2
                            if m.fooroh
                                f = 2
                            else
                                f = 4
                            end
                        elsif m.get_kind == 3
                            if m.fooroh
                                f = 8
                            else
                                f = 16
                            end
                        end
                        #ヤオ九牌なら符を二倍
                        if m.get_pais.count_yaochu >=3
                            f *=2
                        end
                        @fu +=f
                    end
                end
            end
            #雀頭が役牌の時2符
            if @mentsus.first.get_pais.first.yakuhai?(@player.kaze)
                @fu +=2
            end
            #ツモ和了の時に2符
            if @tsumo
                @fu +=2
            end
            #ペンチャン、カンチャン、単騎待ちのときに2符
            machi = get_machi
            if machi[0] || machi[2] || machi[4]
                @fu +=2
            end
            #符の10の位を切り上げる
            @fu = ((@fu.to_f/10).ceil)*10
        end
        #飜数の計算
        @fan = 0
        @yakus.each do |y|
            @fan += y.get_fan
        end
        @score = @fu*(2**(@fan+2))
        #10の位で切り上げる
        @score = ((@score*4.to_f/100)).ceil*100
        if @score >= 8000
            if @yakuman
                @mes = "役満"
                @score = (@fan/13)*48000
            elsif @fan == 5
                @mes = "満貫"
                @score = 8000 
            elsif @fan < 8
                @mes = "跳満"
                @score = 12000 
            elsif @fan < 11
                @mes = "倍満"
                @score = 16000 
            elsif @fan < 13
                @mes = "三倍満"
                @score = 24000 
            elsif!@yakuman
                @mes = "数え役満"
                @score = 32000 
            end
        else
            @mes = "#{@fu}符#{@fan}飜"
        end
    end
    def get_machi
        #ツモ牌を含む面子を検索
        machi = Array.new(5,false)
        @mentsus.each do |m|
            if m.get_pais.has?(@pai)
                #その面子が副露されていない
                if !m.fooroh
                    if m.get_kind == 0
                        #対子だった場合→単騎待ち(0)
                        machi[0] =true
                    elsif m.get_kind == 3
                        #刻子だった場合→シャンポン待ち(1)
                        machi[1] =true
                    elsif m.get_kind == 1
                        #順子だった場合
                        #その順子からツモ牌を抜く
                        tartsu = m.get_pais.dup.delete_if{|p|p==@pai}
                        if tartsu.first.number + tartsu.last.number == 3 || tartsu.first.number + tartsu.last.number == 17
                            #残った二つの牌が1,2または8,9だったとき→ペンチャン待ち(2)
                            machi[2] = true
                        elsif (tartsu.first.number-tartsu.last.number).abs == 1
                            #残った二つの牌が続いていたとき→両面待ち(3)
                            machi[3] = true
                        else
                            #その他→カンチャン待ち
                            machi[4] = true
                        end
                    end
                end
            end
        end
        return machi
    end
end
