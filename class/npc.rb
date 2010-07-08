#NPCクラス、AIとかが乗る予定
class NPC < Player
    def initialize(n,k)
        super
    end
    def render_tehai
    end
    def start
        @wait_timer.reset
        @wait_timer.play
    end
    #ツモ切り安定
    def act
        super
        if @wait_timer.up?
            d = check_dahai
            dahai(d)
            if check_ron(d) 
                return false
            else
                @wait_timer.play
                return true
            end
        end
    end
    def debug

    end
    #何を切るかのAI部分
    def check_dahai
        return @pai
    end
end
