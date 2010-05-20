#Stageクラス。主に場を管理。
class Stage
    def initialize
        $stage = self
        #現在、何順目か
        @turn = 0
        #現在、誰が打っているか
        @phase = 0
        @player = $players[0]
        #壁牌
        @yama = Array.new
        #場風
        @bakaze = 0
        @kyoku = 1
        @honba = 0
        @doras = Array.new
        @uradoras = Array.new
        #何回カンしたか
        @kan_count = 0
        set
    end
    def act
        if @player.act
          next_player
        end
    end
    def next_player
        @phase=(@phase+1)%4
        phase_start
    end
    def phase_start
        @player = $players[@phase]
        @player.start
        if @phase==0
            #最初の番の時、ターン数を加算
            @turn +=1
        end
        #ツモってくる
        @player.tsumo(@yama.shift)
        #@who.debug
        @player.render_tehai
        #和了、テンパイチェック
        @player.check
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
        @yama[124..131].each_with_index do |p,i|
            if i%2==0
                @doras.unshift(p)
            else
                @uradoras.unshift(p)
            end
        end
        set_wanpai
        #プレイヤーに牌を配る
        (0...13).to_a.each do |i|
            if i==12
                $players.to_a.each do |p|
                    p.push_tehai(@yama.shift)
                end
            else
                p = $players[i%4]
                (0...4).to_a.each do |j|
                    p.push_tehai(@yama.shift)
                end
            end
        end
        phase_start
    end
    #洗牌
    def shuffle
        @yama.shuffle!
    end
    #現在のドラをArrayで返す
    def get_doras(reach=false)
        result = Array.new
        (0..@kan_count).to_a.each do |d|
            result.push(@doras[d].next)
            if reach
                result.push(@uradoras[d].next)
            end
        end
        return result
    end
    #王牌の描画
    def set_wanpai 
        #122~135が王牌
        @yama[122..135].reverse.each_with_index do |p,i|
            p.change_image(1)
            p.set_back
            if i%2 ==1
                x = 500+(i/2).floor*33
                y = 200
            elsif i%2 == 0
                x = 500+(i/2).floor*33
                y = 215
            end
            p.set_pos(x,y)
            #ドラ表示牌を表にする
            (0..@kan_count).each do |i|
                @yama[130-i*2].set_front
            end
        end
    end
    def get_stage
        a = ["東","南","西","北"]
        if @honba > 0
            return "#{a[@bakaze]}#{@kyoku.to_cc}局#{@honba.to_cc}本場"
        else
            return "#{a[@bakaze]}#{@kyoku.to_cc}局"
        end
    end
    def get_yama
        return @yama[0...@yama.length-14].length
    end
    attr_reader :bakaze
end
