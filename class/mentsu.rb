#面子クラス
class Mentsu
    def initialize(a,b,c=nil,d=nil)
        @pais = Tehai.new([a,b,c,d])
        @pais.compact!
        #対子、順子、刻子、槓子、塔子
        @kind = set_kind
        #暗刻、暗槓 、暗順子かどうか
        @fooroh = false
    end
    def eql?(other)
        @pais.ripai == other.get_pais.ripai
    end
    def ==(other)
        eql?(other)
    end
    def hash
        [@pais].hash
    end
    #入力された牌から、面子の種類を判定する
    def set_kind
        if @pais.length==2
            if @pais[0]==@pais[1]
                #対子
                return 0
            else
                #塔子
                return 4
            end
        elsif @pais.length==4 && @pais.uniq.length==1
            #槓子 
            return 3
        elsif @pais.length==3
            if @pais.uniq.length ==1
                #刻子
                return 2
            else
                #順子
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
        @pais.ripai
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
    #入力された面子は違う記号、同じ構成牌での面子か
    def same_number?(other)
        return (other.get_kind ==1 && get_kind==1)&&(@pais.ripai.first.number == other.get_pais.first.number)
    end
    def ex_pais
        @pais.each do |p|
            puts "#{p.get_name}"
        end
        puts "--------------"
    end
    #塔子の足りない牌について調べる
    def get_machi
        if @kind == 4
            @pais.ripai
            #二つの牌が隣接してるとき
            if (@pais.last.number - @pais.first.number).abs == 1
                if !@pais.first.hashihai?
                    return [@pais.first-1,@pais.last+1]
                else
                    if @pais.first.number == 9
                        return [@pais.first-1]
                    else
                        return [@pais.last+1]
                    end
                end
                #二つの牌が隣接していないとき、間の牌が待ち牌
            else
                return [@pais.first+1]
            end
        end
    end
    attr_reader :fooroh
end
