class TitleScene
    def initialize 
    end
    def start
    end
    def act
        return :game
    end
    def render
    end
end
class GameScene
    def initialize
        $pais = Array.new
        $cursols = Array.new
        $players = Array.new
        (0...4).to_a.each do |p|
            if p==0
                $players.push(Myplayer.new(p,p))
            else
                $players.push(NPC.new(p,p))
            end
        end
        @mwin = MessageWindow.new
        @stage_tx = Text.new("",620,10)
        @stage_tx.color(255,255,255)
        @yama_tx = Text.new("",620,40)
        @yama_tx.color(255,255,255)
        @pai_cursol = Cursol.new
        $stage = Stage.new
    end
    def start
        #$pais = Array.new
    end
    def act
        @pai_cursol.act
        $stage.act
        return nil
    end
    def render
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[0,51,153])
        $pais.each do |p|
            p.render
        end
        @mwin.render
        @pai_cursol.render
        @stage_tx.draw($stage.get_stage)
        @yama_tx.draw($stage.get_yama)
    end
    attr_reader :pai_cursol
end
class OverScene
    def initialize

    end
    def start
    end
    def act
    end
    def render
    end
end
class ConfigScene
    def initialize

    end
    def start
    end
    def act
    end
    def render
    end
end
class ResultScene
    def initialize
    end
    def start
    end
    def act
    end
    def render
    end
end
