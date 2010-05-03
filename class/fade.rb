class Fade
    def initialize
        @image = Image.new(-320,-240,"effect.png")
        @speed = 10
        @flag = false
        @alpha = 0
        @reverse = true
    end
    def play(n=nil,reverse=false)
        if !n.nil?
            @speed = n
        end
        @reverse = reverse
        @flag = true
    end
    def stop
        @flag = false
    end
    def reset
        @alpha = 0
    end
    def render
        if @flag
            if !@reverse
                @alpha +=@speed
            else
                @alpha -=@speed
            end
            if @alpha > 99
                @alpha =99
            elsif @alpha < 0
                @alpha = 0
            end
        end
        if @alpha !=0
            @image.render(true)
            @image.alpha(@alpha)
        end
    end
    def now
        return @alpha
    end
end
