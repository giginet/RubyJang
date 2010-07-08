#カーソルクラス
class Cursol
    def initialize
        @flag = false
        @enable = true
        @obj = nil
        @image = Image.new(0,0,"cursol.png")
        @prev = nil
        @hover = false
        @@se = SE.new("bosu08.wav")
    end
    def act
        @flag = false
        l = $my.get_tehai.select{|p|p.hit_cursol?}
        if !l.empty?
            @obj = l.first
            if @prev != @obj
                @hover = false
                @prev = l.first
            end
            @prev = l.first
            if !@hover
                $scene.chip.hide
                @@se.play
                if !$my.ex_machi(@obj).empty?
                    $scene.chip.show
                    $scene.chip.set($my.ex_machi(@obj))
                end
                @hover = true
                $my.hover_tehai(@obj)
            end
            @x = @obj.get_pos[:x]
            @y = @obj.get_pos[:y]
            @flag = true
        else
            $scene.chip.hide
            @hover = false
            @obj = nil
        end
    end
    def render
        if @enable && @flag
            @image.x = @x
            @image.y = @y
            @image.render
        end
    end 
    def disable
        @enable = false
    end
    def enable
        @enable = true
    end
    #現在触れている物のオブジェクトを返す
    def get_hover
        return @obj
    end
end
