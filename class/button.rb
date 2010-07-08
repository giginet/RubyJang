class Button
    def initialize(x,y,n)
        @x = x
        @y = y
        @kind = n
        texts = ["ポン","チー","カン","ロン","ツモ","立直","戻る"]
        tx = texts[@kind]
        @text = Text.new(tx,x+27,y+6,48)
        @image = Image.new(x,y,"button.png")
        @text.color(255,255,255)
        @press = false
    end
    def act
        if hover?
            @image.load_image("button_hover.png")
        else
            @image.load_image("button.png")
        end
        if press? && !@press
            @press = true
            return @kind
        end
        if !press?
          @press = false
        end
    end
    def render
        @image.x = @x
        @image.y = @y
        @image.render
        @text.draw
    end
    #カーソルが当たっているかどうか
    def hover?
        x = SDL::Mouse.state[0]
        y = SDL::Mouse.state[1]
        return @x <= x && x <= @x+@image.w && @y <= y && y <= @y+@image.h
    end
    def press?
        hover? && SDL::Mouse.state[2]
    end
end
