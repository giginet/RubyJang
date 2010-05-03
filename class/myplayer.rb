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
#        @pais = Tehai.new([
#                          Pai.new(1,3),
#                          Pai.new(0,4),
#                          Pai.new(0,5),
#                          Pai.new(0,6),
#                          Pai.new(2,9),
#                          Pai.new(2,9),
#                          Pai.new(2,9),
#                          Pai.new(1,3),
#                          Pai.new(1,4),
#                          Pai.new(1,5),
#                          Pai.new(3,5),
#                          Pai.new(3,5),
#                          Pai.new(3,5)
#        ])
#        tsumo(Pai.new(1,3))
        @pais = Tehai.new([
                          Pai.new(3,1),
                          Pai.new(3,2),
                          Pai.new(3,3),
                          Pai.new(3,4),
                          Pai.new(3,5),
                          Pai.new(3,6),
                          Pai.new(3,7),
                          Pai.new(1,1),
                          Pai.new(1,9),
                          Pai.new(0,1),
                          Pai.new(0,9),
                          Pai.new(2,1),
                          Pai.new(2,9)
        ])
        tsumo(Pai.new(1,1))
    end
end
