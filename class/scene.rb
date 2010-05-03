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
        $players = Array.new
        (0...4).to_a.each do |p|
            if p==0
                $players.push(Myplayer.new(p))
            else
                $players.push(Player.new(p))
            end
        end
        $stage = Stage.new
    end
    def start
    end
    def act
    end
    def render
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
