#ツールチップクラス。主に待ち牌表示
class Chip
    def initialize(x,y)
        @x = x
        @y = y
        @pais = Tehai.new
        @image = Image.new(x,y,"tipwindow.png")
        @show = false
    end
    def act
    end
    def render
        if @show
            @image.x = @x
            @image.y = @y
            @image.render
            a = Tehai.new
            @pais.each do |p|
                a<<p[0]
            end
            a.ripai.uniq.each_with_index do |p,i|
                p.set_pos(25+i*33,430)
                p.render
            end

        end
    end
    def set(array)
        @pais =array.dup
    end
    def hide
        @show = false
    end
    def show
        @show = true
    end
    attr_reader :x,:y
end
