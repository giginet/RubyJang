class MessageWindow
    def initialize 
        @message_que = Array.new
        $mwin = self
        @sx = 10
        @sy = 10
        @max_line = 5
        @size = 18
        @margin = 12
        @line = 0
        @background = Image.new(@sx-5,@sy-5,"mwindow.png")
        @text = ""
        @show = true
        @fonts = Array.new
        (0...@max_line).to_a.each do |i|
            font = Text.new("",@sx,@sy+(@size+@margin)*i,@size)
            font.color(255,255,255)
            shadow = Text.new("",@sx+2,@sy+(@size+@margin)*i+2,@size)
            shadow.color(64,64,64)
            @fonts.push({:font=>font,:shadow=>shadow})
        end
    end
    def set_message(mes)
        @message_que.push(mes)
    end
    def act
    end
    def show
        @show = true
    end
    def hide
        @show = false
    end
    def reset
      @text=""
      @message_que.clear
    end
    def render
        if @show
            @background.render
            if !@message_que[@line].nil?
                if !@message_que[@line].move?
                    @message_que[@line].play
                elsif @message_que[@line].up?
                    @line+=1
                end
            end
            if @message_que.length > @max_line
                @message_que.shift
            end
            @message_que.each_with_index do |m,i|
                text = m.get_text
                if text.length > 0
                    @fonts[i][:shadow].draw(text)
                    @fonts[i][:font].draw(text)
                end
            end
        end
    end
end
class Message
    def initialize(mes)
        @message = mes
        @cursol = 0 
        @timer = Timer.new(1)
        $mwin.set_message(self)
    end
    def play
        @timer.play
    end
    def move?
        @timer.move?
    end
    def up?
        return @cursol == @message.length
    end
    def get_text
        if !@message.nil?
            if @timer.up?
                @cursol +=1
                @timer.reset
                @timer.play
            end
            return @message[0...@cursol]
        else
            return ""
        end
    end
    def act
    end
    def render
    end
end
