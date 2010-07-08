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
        $cursols = Array.new
        @mwin = MessageWindow.new
        @mwin.hide
        @stage_tx = Text.new("",620,10)
        @stage_tx.color(255,255,255)
        @yama_tx = Text.new("",620,40)
        @yama_tx.color(255,255,255)
        @turn_tx = Text.new("",620,70)
        @turn_tx.color(255,255,255)
        @pai_cursol = Cursol.new
        $stage = Stage.new
        @chip = Chip.new(20,420)
        @debug = Text.new("",620,100)
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
        $stage.render
        $players.each do |p|
            p.render
        end
        @mwin.render
        @pai_cursol.render
        @chip.render
        @stage_tx.draw($stage.get_stage)
        @yama_tx.draw($stage.get_yama)
        @turn_tx.draw("#{$stage.turn}順目")
        @debug.draw($my.mode)
    end
    attr_reader :pai_cursol,:chip
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
