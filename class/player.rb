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
        @cursols = [0,0,0,0]
        #和了形格納
        @agaris = Array.new
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
        @pai = p
    end
    #上がっているかどうか
    def agari?
        a = get_agari
        get_yaku
        return !a.empty?
    end
    def get_yaku
        @agaris.each do |a|
            a.get_yaku
            puts "---------------------"
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
                    break
                end
                @cursols = [0,0,0,0]
                @stack_cursol = 0
                @mentsu_stack = Array.new
            end
        end

        return @agaris
    end
    #テンパってるかどうか
    #面倒くさい
    #
    def tempai?
    end
    #待ち牌をArrayで返す
    #テンパイ書いてから
    def get_machis
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
        count = 0
        if @stack_cursol >= 0 && @stack_cursol <4
            st = @cursols[@stack_cursol]
            @mentsus[st...@mentsus.length].each_with_index do |m,i|
                #現段階の手牌でmが作れるならば、スタックに追加
                #現カーソル位置での初期位置を現在の位置+1に
                if @tmp_tehai.has_mentsu?(m)
                    @cursols[@stack_cursol] = i+1
                    next_stack(m)
                    count +=1
                    break
                end
            end
        end
        #一つも面子が作れなかった場合は、初期位置をリセットしてスタックを戻す
        if count == 0
            @cursols[@stack_cursol] = 0
            prev_stack
        end
        return @stack_cursol > 3
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
    attr_reader :kaze
end
