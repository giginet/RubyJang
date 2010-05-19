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
        @mentsu_stack = Array.new(4)
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
    #上がっているかどうか
    def agari?
        a = get_agari
        get_yaku
        return !a.empty?
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
    #和了形の一覧を配列で返す
    def get_agari
        @agaris = Array.new
        @tmp_tehai = @pais.dup.push(@pai)
        h = @tmp_tehai.search_heads
        if h.length==7
            #七対子の判定
            #頭の候補を絞った段階で、対子が７種類存在すれば七対子
            @agaris.push(Agari.new(@pais,@pai,h,self))    
        elsif kokushi?
            #国士無双の判定
            #面倒だから別メソッドにしました
            @agaris.push(Agari.new(@pais,@pai,h,self))    
        elsif false
            #十三不塔の判定
            #そんなルールはない！！！
        end
        #その他の和了形の判定
        h.each do |head|
            #手牌tmpをリセット
            @tmp_tehai = @pais.dup.push(@pai)
            #頭候補をtmpから削除
            @tmp_tehai = @tmp_tehai.pop_mentsu(head)
            #想定しうる、面子のリストを作成
            @mentsus = @tmp_tehai.search_koutsu+@tmp_tehai.search_syuntsu
            4.times do 
                h = Hash.new
                @mentsus.each do |m|
                    h[m] = false
                end
                @cursols.push(h)
            end
            #再帰的に順子、刻子を発見して、tmpの長さが０になったら和了
            if @mentsus.length >= 4
                while @stack_cursol >= 0 && !@tmp_tehai.empty?
                    search_agari
                end
                #tmpが空になったら和了確定
                if @tmp_tehai.empty?
                    #面子スタックの先頭に頭を格納
                    @mentsu_stack.unshift(head)
                    @agaris.push(Agari.new(@pais,@pai,@mentsu_stack,self))    
                    #break
                end
                @cursols = Array.new
                @stack_cursol = 0
                @mentsu_stack = Array.new
            end
        end

        return @agaris
    end
    #テンパってるかどうか
    #面倒くさい
    #待ちの判定も一緒にやっちゃう
    def tempai?
        @machis.clear
        ed = false
        #まず上がっているかどうか
        if !agari?
            tmp = Array.new
            @tmp_tehai = @pais.dup.push(@pai)
            #七対子系テンパイ
            #国士無双系テンパイ
            #四面子完成形（単騎）
            #三面子二頭（シャンポン）
            #一頭三面子一塔子（カンチャン、リャンメン、ペンチャン）
            #のパターン判定
            #まず面子が３つ作れるか調査。話はそれからだ。
            @mentsus = @tmp_tehai.search_koutsu+@tmp_tehai.search_syuntsu
            @tmp_tehai = @pais.dup.push(@pai)
            @cursols = Array.new
            3.times do 
                h = Hash.new
                @mentsus.each do |m|
                    h[m] = false
                end
                @cursols.push(h)
            end
            while !end_search?
                search_tempai
                if @stack_cursol >= 3
                    tmp.push(@tmp_tehai)
                    @tmp_tehai = @pais.dup.push(@pai)
                    @stack_cursol = 0
                end
                ed = true
            end
            if !tmp.empty?
                puts tmp.length
                tmp.each do |u|
                    puts "-----------"
                    u.each do |p|
                        puts p.get_name
                    end
                    @tmp_tehai = u.dup
                    #例のスタック法で面子が３つ作れたら、残り5枚の中で、面子できる、対子2つできる、対子一つと塔子できるのいずれかに場合分け。
                    #上記何れかならテンパイ
                    h = @tmp_tehai.search_heads
                    if h.length ==2
                        #シャンポン待ち
                        result = true
                        h.each do |m|
                            @machis.push(m.get_pais.first)
                        end
                    end
                    @tmp_tehai = u.dup
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
                    @tmp_tehai = u.dup
                    if h.length > 0
                        #そのほかの待ち
                        #対子＋塔子の組み合わせかどうかを調べる
                        h.each do |m|
                            tehai = @tmp_tehai.dup
                            tehai.pop_mentsu(m)
                            #対子を抜いた残り3枚のうち、塔子があるか調べる
                            if !tehai.search_tartsu.empty?
                                #塔子があるばあい、各塔子について、足りない牌を調べて待ち牌に格納
                                tehai.search_tartsu.each do |m|
                                    m.get_machi.each do |p|
                                        @machis.push(p)
                                    end
                                end
                            end
                        end
                    end
                end
            elsif
                #そもそも面子が３つ作れなかったら特殊系へ
                @tmp_tehai = @pais.dup.push(@pai)
                #チートイのテンパイ（頭候補６つ楽勝）
                if @tmp_tehai.search_heads.length == 6
                    #６つの対子を引っこ抜いて、のこり2牌を待ち候補に
                    @tmp_tehai.search_heads.each do |m|
                        @tmp_tehai.pop_mentsu(m)
                    end
                    @tmp_tehai.each do |p|
                        @machis.push(p)
                    end
                elsif @tmp_tehai.count_yaochu >= 13
                    #国士のテンパイ
                    if @tmp_tehai.count_kinds == 13
                        #一三面待ち
                    elsif @tmp_tehai.count_kinds ==12
                        #その他の待ち

                    end
                end
            end
            @cursols = Array.new
            @stack_cursol = 0
            @mentsu_stack = Array.new
        end
        @machis.uniq!
        return !@machis.empty?
    end
    #待ち牌をArrayで返す
    #テンパイ書いてから
    def get_machi
        return @machis
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
    def search_agari
        #サーチ開始位置
        count = false
        if @stack_cursol >= 0 && @stack_cursol <4
            @mentsus.each_with_index do |m,i|
                #現段階の手牌でmが作れるならば、スタックに追加
                #現カーソル位置での初期位置を現在の位置+1に
                if @tmp_tehai.has_mentsu?(m) && !@cursols[@stack_cursol][m]
                    @cursols[@stack_cursol][m] = true
                    next_stack(m)
                    count = true
                    break
                end
            end
        end
        #一つも面子が作れなかった場合は、初期位置をリセットしてスタックを戻す
        if !count
            prev_stack
        end
        return @stack_cursol > 3
    end
    def search_tempai
        #サーチ開始位置
        count = false
        if @stack_cursol >= 0 && @stack_cursol <3
            @mentsus.each_with_index do |m,i|
                #現段階の手牌でmが作れるならば、スタックに追加
                #現カーソル位置での初期位置を現在の位置+1に
                if @tmp_tehai.has_mentsu?(m) && !@cursols[@stack_cursol][m]
                    @cursols[@stack_cursol][m] = true
                    next_stack(m)
                    count = true
                    break
                end
            end
        end
        #一つも面子が作れなかった場合は、初期位置をリセットしてスタックを戻す
        if !count
            prev_stack
        end
        return @stack_cursol > 2
    end
    def end_search?
        flag = true
        @cursols.each do |h|
            h.each do |k,v|
                if !v
                    flag = false
                    break
                end
            end
        end
        return flag
    end

    def kokushi?
        #国士無双の判定
        r = false
        #対子が一つである
        if @tmp_tehai.search_heads.length ==1
            #手牌が全てヤオ九牌である
            c = 0
            @tmp_tehai.each do |p|
                if p.yaochu?
                    c+=1
                end
            end
            if c==14
                #手牌の種類を調べて、13種類あれば国士無双
                if @tmp_tehai.count_kinds ==13
                    r = true
                end
            end
        end
        return r
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
