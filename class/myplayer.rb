require "class/player"
class Myplayer < Player
    def initialize(n,k)
        super
        @buttons = Array.new
        $my = self
    end
    def start
        @press = false
        if @mode==0
            #テンパっていたら立直ボタンを表示
            if tempai? && !reach?
                create_button(5)
                #和了っていたら、ツモボタンを表示
            elsif agari?
                create_button(4)
            end
            #立直だったらタイマー作動
            if reach?
                @reach_count+=1
                @wait_timer.reset
                @wait_timer.play
            end
        elsif @mode==1
            #ロンの時ターンが回ってきたら
            create_button(3)
            create_button(6)
        end
    end
    def hover_tehai(p)
    end
    def create_button(type)
        b = Button.new(640,100+@buttons.length*64,type)
        @buttons << b
        return b
    end
    def ex_machi(p)
        #選択した牌が、不要牌である待ちを抽出
        if !agari?
            return @machis.select{|machi|machi[1] == p}
        else
            return Tehai.new
        end
    end
    #次の番に進むとき、trueを返す
    def act
        super
        if !reach?
            #通常時
            if @mode ==0
                if SDL::Mouse.state[2]
                    if !@press
                        select = $scene.pai_cursol.get_hover
                        @press = true
                        if !select.nil?
                            $scene.chip.hide
                            dahai(select)
                            ed = !check_ron(select)
                        end
                    end
                else
                    @press = false
                end
            end
        else
            #立直の時、ツモ切り
            if @mode==0 && !agari? && @wait_timer.up?
                #ツモ切り
                dahai(@pai)
                ed = !check_ron(select)
            else
                ed = false
            end
        end
        press = nil
        @buttons.each do |b|
            x = b.act
            if !x.nil?
                press = x
            end
        end
        #ボタンを押して、nil以外が帰ってきたら
        if !press.nil?
            push_button(press)
        end
        return ed
    end
    def render_tehai
        @pais.each_with_index do |p,i|
            p.set_pos(20+i*33,510)
            p.enable_cursol
            p.render
        end
        if !@pai.nil?
            @pai.set_pos(20+13.5*33,510)
            @pai.enable_cursol
            @pai.render
        end
        @buttons.each do |b|
            b.render
        end

    end
    def ex_tehai
        ripai
        @pais.each do |p|
            puts p.get_name
        end
        puts ""
        puts @pai.get_name
    end
    #ターン終了時の処理
    def turn_end
        super
        @buttons.clear 
    end
    #手牌をデバッグ用の牌にする
    def debug
        if false
            @pais = Tehai.new([
                              Pai.new(0,1),
                              Pai.new(0,9),
                              Pai.new(1,1),
                              Pai.new(1,9),
                              Pai.new(2,1),
                              Pai.new(2,9),
                              Pai.new(3,1),
                              Pai.new(3,2),
                              Pai.new(3,3),
                              Pai.new(3,4),
                              Pai.new(3,5),
                              Pai.new(3,6),
                              Pai.new(3,7)
            ])
        end
    end
    def tsumo(p)
        if false
            super(Pai.new(3,1))
        else
            super
        end
    end
    def push_button(kind)
        if kind==0
            #ポン
        elsif kind==1
            #チー
        elsif kind==2
            #カン
        elsif kind==3
            #ロン
            check
            get_yaku
            @tsumo = false
            $stage.end = true
            $mwin.show
        elsif kind==4
            #ツモ
            check
            get_yaku
            $stage.end = true
            $mwin.show
        elsif kind==5
            #立直
            @reach = true
            @wait_timer.reset
            @wait_timer.play
        elsif kind==6
            #戻る
            $stage.change_player($stage.last_player.next_player)
        end
    end
end
