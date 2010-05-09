class Image
    def initialize(x=0,y=0,fn="")
        @x = x
        @y = y
        alpha(100)
        load_image(fn)
        @anime = false
        @transparent = false
    end
    def act
    end
    def alpha(n,f=false)
        if f
            n = n
        else
            n = (n*2.55).round
        end
        @alpha = n
    end
    def render
        if @alpha !=255
            @image.set_alpha(SDL::SRCALPHA,@alpha)
        end
        $screen.put(@image,@x,@y)
    end
    def anime?
        return @anime
    end
    def load_image(fn)
        @image = SDL::Surface.load("image/#{fn}")
        @h = @image.h
        @w = @image.w
    end
    #回転メソッド
    #SGEがないとダメっぽ？
    def rotate(deg)
        SDL.transform(@image,$screen,deg,1,1,@x,@y,@x,@y,SDL::TRANSFORM_SAFE||SDL::TRANSFORM_TMAP)
    end
    def enable_alpha
        @transparent = true
        if @transparent
            @image.set_color_key(SDL::SRCCOLORKEY,@image.get_pixel(0,0))
        end
    end
    attr_accessor :x,:y,:w,:h,:v
end
