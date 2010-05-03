require "class/player"
class Myplayer < Player
    def initialize(n)
        super(n)
    end
    def get_tehai
        ripai
        @pais.each do |p|
            puts p.get_name
        end
        puts ""
        puts @pai.get_name
    end
    #手牌をデバッグ用の牌にする
    def debug
        @pais = Tehai.new([
                          Pai.new(1,3),
                          Pai.new(0,4),
                          Pai.new(0,5),
                          Pai.new(0,6),
                          Pai.new(2,9),
                          Pai.new(2,9),
                          Pai.new(2,9),
                          Pai.new(1,3),
                          Pai.new(1,4),
                          Pai.new(1,5),
                          Pai.new(3,5),
                          Pai.new(3,5),
                          Pai.new(3,5)
        ])
        tsumo(Pai.new(1,3))
    end
end
