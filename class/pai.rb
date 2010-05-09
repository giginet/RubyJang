class Pai
    def initialize(t,n)
        @x = 0
        @y = 0
        #0萬子1索子2筒子3字牌
        @kind = t
        #普通は数字、字牌の場合は1から順に東南西北白發中
        @number = n
        set_image
        #赤ドラかどうか
        @red = false
    end
    def hash
        [@number,@kind].hash
    end
    def eql?(other)
        @kind.eql?(other.kind) && @number.eql?(other.number)
    end
    def ==(other)
        return eql?(other)
    end
    #n個先の牌を返す
    def +(n)
        n = @number+n
        if n>9
            n=nil
        end
        if n.nil?
            return nil
        else
            return Pai.new(@kind,n)
        end
    end
    #n個前の牌を返す
    def -(n)
        n = @number-n
        if n<0
            n=nil
        end
        if n.nil?
            return nil
        else
            return Pai.new(@kind,n)
        end
    end
    def next
        if @kind ==3
            @number = (@number+1)%7
        else
            @number = (@number+1)%9
        end
    end
    def prev
        if @kind ==3
            @number = (@number-1)%7
        else
            @number = (@number-1)%9
        end

    end
    #牌の名前を日本語で返す
    def get_name
        names =["萬","索","筒"]
        jihais = ["","東","南","西","北","白","發","中"]
        if @kind==3
            return jihais[@number]
        else
            return "#{@number.to_cc}#{names[@kind]}"
        end
    end
    #Imageオブジェクトをセットする
    def set_image
        k = ["ms","ss","ps","ji"][@kind]
        if jihai?
            na = ["","e","s","w","n","haku","h","c"]
            n = "_#{na[@number]}"
        else
            n = @number
        end
        fn = "pai/p_#{k}#{n}_0.gif"
        @image = Image.new(0,0,fn)
    end
    def render
        @image.x = @x
        @image.y = @y
        @image.render
    end
    #特定の牌かどうかをブールで返す
    def yaochu?
        @kind==3 || @number==1 || @number==9
    end
    def sangen?
        @kind==3 && @number >=5
    end
    def dora?
        dora = false
        $stage.get_doras.each do |d|
            if d==self
                dora = true
            end
        end
        return @red || dora
    end
    def jihai?
        return @kind==3
    end
    def jikaze?(w)
        @kind == 3 && @number == w+1
    end
    def bakaze?
        @kind == 3 && @number == $stage.bakaze + 1
    end
    def yakuhai?(w)
        return sangen? || bakaze? || jikaze?(w)
    end
    def hashihai?
        if @kind !=3
            return @number == 1 || @number == 9
        else
            return false
        end
    end
    #描画位置設定
    def set_pos(x,y)
        @x = x
        @y = y
        $pais.push(self)
    end
    #緑一色用
    def green?
        return (@kind == 1 && @number >=2 && @number <=8 && @number != 7) || (@kind == 3 && @number == 6)
    end
    attr_reader :kind,:number
end
