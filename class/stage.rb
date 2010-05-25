#Stageクラス。主に場を管理。
class Stage
    def initialize
        $stage = self
        #壁牌
        @yama = Array.new
        #場風
        @bakaze = 0
        @kyoku = 1
        @honba = 0       
        @render = Array.new
        @next_timer = Timer.new(120)
        reset
    end
    def act
        if !@ryukyoku
            if @player.act
                if get_yama > 0
                    next_player
                else
                    @ryukyoku = true
                    Message.new("流局")
                    @next_timer.play
                end
            end
        end
        if @next_timer.up?
            @next_timer.reset
            @next_timer.stop
            next_game
        end
    end
    def render
        @render.each do |i|
            i.render
        end
    end
    def next_player
        @phase=(@phase+1)%4
        phase_start
    end
    def reset
        #現在、何順目か
        @turn = 0
        #現在、誰が打っているか
        @phase = 0
        @doras = Array.new
        @uradoras = Array.new
        #何回カンしたか
        @kan_count = 0
        @render = Array.new
        @ryukyoku = false
        @yama.clear
        @render.clear
        set
        @player = $players[0]
    end
    #次の局、場に進む
    def next_game
        if false
            #親が継続するときの判定、処理
        else 
            #しないときの処理
            @kyoku = @kyoku+1
            if @kyoku == 5
                @kyoku =1
                @bakaze +=1
            end
            reset
        end
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
        @player.render_tehai
        #和了、テンパイチェック
        @player.check
    end
    #局の最初に呼び出される
    def set
        #プレイヤーを配置する
        $players = Array.new
        (0...4).to_a.each do |p|
            if p==0
                $players.push(Myplayer.new(p,p))
            else
                $players.push(NPC.new(p,p))
            end
        end
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
        $players[0].debug
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
                x = 210+(i/2).floor*32
                y = 200
            elsif i%2 == 0
                x = 210+(i/2).floor*32
                y = 215
            end
            p.set_pos(x,y)
            @render << p
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
        if @yama.length-14 > 0
            return @yama.length-14
        else
            return 0
        end
    end
    def get_player
        return @phase
    end
    attr_reader :bakaze,:turn
end
