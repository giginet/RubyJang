class Text
  def initialize(text="",x=0,y=0,size=24)
    SDL::TTF.init
    @size = size
    begin
      @font = SDL::TTF.open("./font/font.otf",@size)
    rescue
      puts "Font Error"
    end
    @x = x
    @y = y
    @text = text
    @r = 0
    @g = 0
    @b = 0
  end
  def draw(text="")
    unless text==""
      @text=text
    end
    begin
      @font.draw_blended_utf8($screen,@text.to_s,@x,@y,@r,@g,@b)
    rescue
      puts "深刻なエラーが発生しました。"
    end
  end
  def color(r,g,b)
    @r = r
    @g = g
    @b = b
  end
  def set_pos(x,y)
    @x = x
    @y = y
  end
end
