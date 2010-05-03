#Stageクラス。主に場を管理。
class Stage
    def initialize
        #壁牌
        @yama = Array.new
        #場風
        @bakaze = 0
        @kyoku = 0
        @honba = 0
        @doras = Array.new
        @uradoras = Array.new
        #何回カンしたか
        @kan_count = 0
        set
    end
    #局の最初に呼び出される
    def set
        #山に牌をセットする
        4.times do 
            (0..3).to_a.each do |n|
                if n==3
                    max = 7
                else
                    max = 9
                end
                (1..max).to_a.each do |m|
                    p = Pai.new(n,m)
                    @yama.push(p)
                end
            end
        end
        #洗牌
        shuffle
        #ドラをセット
        (126..133).to_a.each do |p|
            if p%2==0
                @doras.unshift(p)
            else
                @uradoras.unshift(p)
            end
        end
        #プレイヤーに牌を配る
        (0...13).to_a.each do |i|
            if i==12
                (0...4).to_a.each do |j|
                    p = $players[j]
                    p.push_tehai(@yama.shift)
                end
            else
                p = $players[i%4]
                (0...4).to_a.each do |j|
                    p.push_tehai(@yama.shift)
                end
            end
        end
        $players[0].tsumo(@yama.shift)
        $players[0].debug
        $players[0].get_tehai
        puts $players[0].agari?
    end
    #洗牌
    def shuffle
        @yama.shuffle!
    end
    #現在のドラをArrayで返す
    def get_doras(reach=false)
        result = Array.new
        (0..@kan).to_a.each do |d|
            result.push(@doras[d])
            if reach
                result.push(@uradoras[d])
            end
        end
    end
    attr_reader :bakaze
end
