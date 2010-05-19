class Player
    def initialize(n)
        #プレイヤー番号（東南西北順）
        @number = n
        #手牌
        @pais = Tehai.new
        #ツモ牌
        @pai
        @reach = false
        @menzen = true
        @score = 25000
        #立直後の打順
        @reach_count = 0
        @kaze = n
        #河
        @kawa = Array.new
        #和了検索用の変数群
        @tmp_tehai = Tehai.new
        @mentsu_stack = Array.new
        @stack_cursol = 0
        @mentsus = Array.new
        @cursols = Array.new
        #和了形格納
        @agaris = Array.new
        #待ち牌
        @machis = Tehai.new
    end
    #手牌を理牌する
    def ripai
        @pais.ripai!
    end
    #手牌に配列をセット
    def push_tehai(elm)
        @pais.push(elm)
    end
    #ツモる
    def tsumo(p)
        ripai
        @pai = p
    end
    #和了、テンパイの判定
    def check
        get_agari
        if !@agaris.empty?
            get_yaku
        elsif !@machis.empty?
            Message.new("テンパってる")
            get_machi.each do |m|
                Message.new(m.get_name)
            end
        else
            Message.new("テンパってない")
        end
    end
    def get_yaku
        #高点法
        max = 0
        result =nil
        if !@agaris.empty?
            @agaris.each do |a|
                score = a.get_score
                if max < score[:score]
                    max = score[:score]
                    result = score
                end
            end
            result[:yaku].each do |y|
                Message.new("#{y.get_name}(#{y.get_fan.to_cc}飜)")
            end
            Message.new(result[:message])
            Message.new("#{result[:score].to_cc}点")
        end
    end
    #和了、テンパイ系の一覧を配列で返す
    def get_agari
        @agaris.clear
        tmp = Array.new
        @tmp_tehai = @pais.dup.push(@pai)
        heads = @tmp_tehai.search_heads
        if heads.length==7
            #七対子の判定
            #頭の候補を絞った段階で、対子が７種類存在すれば七対子
            @agaris.push(Agari.new(@pais,@pai,heads,self))    
        elsif false
            #十三不塔の判定
            #そんなルールはない！！！
        end
        #その他の和了形、テンパイ系の判定
        #想定しうる、面子のリストを作成
        @mentsus = @tmp_tehai.search_koutsu+@tmp_tehai.search_syuntsu
        @cursols.clear
        if @mentsus.length >= 3
            3.times do 
                hash = Hash.new
                @mentsus.each do |m|
                    hash[m] = false
                end
                @cursols.push(hash)
            end
            while @stack_cursol >= 0
                search_tempai
                if @stack_cursol >= 3
                    tmp.push(@mentsu_stack.dup) 
                    prev_stack
                end
            end
        end
        if !tmp.empty?
            tmp.each do |stack|
                #例のスタック法で面子が３つ作れたら、残り5枚の中で、面子できる、対子2つできる、対子一つと塔子できるのいずれかに場合分け。
                #上記何れかならテンパイ
                #1面子1対子なら和了
                u = @pais.dup.push(@pai)
                stack.each do |m|
                  u.pop_mentsu(m)
                end
                @tmp_tehai = u.dup
                heads = @tmp_tehai.search_heads
                #対子が一つもないとき
                if heads.empty?
                    if (@tmp_tehai.search_koutsu + @tmp_tehai.search_syuntsu).length > 0
                        #単騎待ち
                        (@tmp_tehai.search_koutsu + @tmp_tehai.search_syuntsu).each do |m|
                            tehai = @tmp_tehai.dup
                            #選んだ面子を抜き取り、それぞれを待ち牌に格納
                            tehai.pop_mentsu(m).each do |p|
                                @machis.push(p)
                            end
                        end
                    end
                else
                    heads.each do |h|
                        @tmp_tehai = u.dup
                        @tmp_tehai.pop_mentsu(h)
                        #残った3枚の中に面子があるかどうか
                        mens = @tmp_tehai.search_syuntsu + @tmp_tehai.search_koutsu
                        if !mens.empty?
                            #和了
                            ag = stack.dup
                            ag = ag.unshift(h)<<mens.first
                            @agaris.push(Agari.new(@pais,@pai,ag,self))    
                        else
                            #ない場合は和了ってはいないけど、テンパイの可能性
                            #頭の候補が2個の時
                            if heads.length == 2
                                #シャンポン待ち
                                heads.each do |m|
                                    @machis.push(m.get_pais.first)
                                end
                            end
                            #そのほかの待ち
                            #対子＋塔子の組み合わせかどうかを調べる
                            #対子を抜いた残り3枚のうち、塔子があるか調べる
                            if !@tmp_tehai.search_tartsu.empty?
                                #塔子があるばあい、各塔子について、足りない牌を調べて待ち牌に格納
                                @tmp_tehai.search_tartsu.each do |m|
                                    m.get_machi.each do |p|
                                        @machis.push(p)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        elsif
            #そもそも面子が３つ作れなかったら特殊系へ
            @tmp_tehai = @pais.dup.push(@pai)
            #国士のテンパイ
            kokushipais = [Pai.new(0,1),
                Pai.new(0,9),
                Pai.new(1,1),
                Pai.new(1,9),
                Pai.new(2,1),
                Pai.new(2,9),
                Pai.new(3,1),
                Pai.new(3,2),
                Pai.new(3,3),
                Pai.new(3,4),
                Pai.new(3,5),
                Pai.new(3,6),
                Pai.new(3,7)]

            #チートイのテンパイ（頭候補６つ楽勝）
            if @tmp_tehai.search_heads.length == 6
                #６つの対子を引っこ抜いて、のこり2牌を待ち候補に
                @tmp_tehai.search_heads.each do |m|
                    @tmp_tehai.pop_mentsu(m)
                end
                @tmp_tehai.each do |p|
                    @machis.push(p)
                end
            elsif @tmp_tehai.count_yaochu == 14
                if @tmp_tehai.count_yaochu_kinds == 13
                    #国士無双和了形
                    h = @tmp_tehai.search_heads
                    @agaris.push(Agari.new(@pais,@pai,h,self))    
                elsif @tmp_tehai.count_yaochu_kinds ==12
                    #その他の待ち
                    #国士牌から、含まれていない物を検索
                    kokushipais.each do |p|
                        if !@tmp_tehai.has?(p)
                            @machis << p
                            break
                        end
                    end
                end
            elsif @tmp_tehai.count_yaochu == 13 && @tmp_tehai.count_yaochu_kinds == 13
                #一三面待ち
                #全ての国士牌を待ちへ
                #ハードコーディング安定
                @machis.concat(kokushipais)
            end
        end
        @machis.uniq!
    end
    #待ち牌をArrayで返す
    #テンパイ書いてから
    def get_machi
        return @machis.ripai
    end
    #付いた役をArrayで返す
    def get_yakus
        if agari?

        end
    end
    #点数を返す
    def get_score
    end
    #スタックを一つ前に戻すメソッド
    #既にスタックに入ってる一番上の面子を取り出して、手牌に書き戻す
    def prev_stack
        m = @mentsu_stack.pop 
       if !m.nil?
            @tmp_tehai = @tmp_tehai.push_mentsu(m)
        end
        @stack_cursol -=1
    end
    #スタックに指定された面子を格納する
    #カーソルを一つ進めて、指定された面子に必要な牌を手牌バッファから抜き出す
    def next_stack(mentsu)
        if @tmp_tehai.has_mentsu?(mentsu)
            @mentsu_stack.push[@stack_cursol] = mentsu
            @tmp_tehai = @tmp_tehai.pop_mentsu(mentsu)
            @stack_cursol +=1
        else
            return false
        end
    end
    def search_tempai
        #サーチ開始位置
        count = false
        #if @stack_cursol >= 0 && @stack_cursol <3
        @mentsus.each_with_index do |m,i|
            #現段階の手牌でmが作れるならば、スタックに追加
            if @tmp_tehai.has_mentsu?(m) && !@cursols[@stack_cursol][m]
                @mentsus[0..i].each do |n|
                    @cursols[@stack_cursol][n] = true
                end
                next_stack(m)
                count = true
                break
            end
        end
        #end
        #一つも面子が作れなかった場合は、初期位置をリセットしてスタックを戻す
        if !count
            st = 0
            @mentsus.each_with_index do |m,i|
              if @cursols[@stack_cursol-1][m]
                  st = i+1
              end
            end
            @mentsus[st..@mentsus.length].each do |m|
              @cursols[@stack_cursol][m] = false
            end
            prev_stack
        end
        return @stack_cursol > 2
    end
    def poota?
        #十三不塔の判定
        #Mentsu.tartsu?が乗ってから作る
    end
    def reach?
        return @reach
    end
    attr_reader :kaze
end
