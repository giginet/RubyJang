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
        $players = Array.new
        (0...4).to_a.each do |p|
            if p==0
                $players.push(Myplayer.new(p))
            else
                $players.push(Player.new(p))
            end
        end
        @mwin = MessageWindow.new
        $stage = Stage.new
    end
    def start
        #$pais = Array.new
    end
    def act
        return nil
    end
    def render
        $screen.fill_rect(0,0,SCREEN_W,SCREEN_H,[0,51,153])
        $pais.each do |p|
            p.render
        end
        @mwin.render
    end
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
