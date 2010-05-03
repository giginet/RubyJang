#面子クラス
class Mentsu
    def initialize(a,b,c=nil,d=nil)
        @pais = Tehai.new([a,b,c,d])
        @pais.compact!
        #対子、順子、刻子、槓子 
        @kind = set_kind
        #暗刻、暗槓 、暗順子かどうか
        @fooroh = false
    end
    def eql?(other)
      @pais.ripai == other.get_pais.pihai
    end
    def ==(other)
      eql?(other)
    end
    def hash
      [@pais].hash
    end
    #入力された牌から、面子の種類を判定する
    def set_kind
        if @pais.length==2 && @pais[0]==@pais[1]
            return 0
        elsif @pais.length==4 && @pais.uniq.length==1
            return 3
        elsif @pais.length==3
            if @pais.uniq.length ==1
                return 2
            else
                return 1
            end
        end
    end
    #面子の種類を取り出す
    def get_kind
        return @kind
    end
    #面子から牌を取り出す
    def get_pais
        return @pais
    end
    #面子
    def get_name
        @pais.each do |p|
            puts "#{p.get_name}:"
        end
    end
    #特定の牌を含んでいるかどうか
    def has?(p)
        @pais.has?(p)
    end
    attr_reader :fooroh
end
