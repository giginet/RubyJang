require 'sdl'
#るびじゃん！！
#Rubyで麻雀作ろうぜ

require "lib/fpstimer"
#classファイル読み込み
Dir.foreach("class"){|f|
    if f.to_s =~ /\.rb$/
        require "class/#{f.to_s}"
    end
}
#既存クラスのオーバーロード
class Integer
    #数字を漢数字で返すメソッド
    def to_cc
        cs =["〇","一","二","三","四","五","六","七","八","九"]
        result = String.new
        self.to_s.split(//).each do |n|
            result += cs[n.to_i]
        end
        return result
    end
end
class Array
    def choice
        at(rand(length))
    end
    def swap!(n,m)
        tmp =self[n]
        self[n] = self[m]
        self[m] = tmp
        return self
    end
    def shuffle!
        for i in 0...length
            self.swap!(i,rand(length))
        end
    end
end
class Hash
    def choice
        keys.choice
    end
end
#定数
SCREEN_W = 640
SCREEN_H = 480
STAGE_X = 640
STAGE_Y = 4800
HOLIZON = 400
RATE = 30
puts SDL::Joystick.num
#joy = SDL::Joystick.open(0)
$timers = Array.new
$frames = 0
#Windowまわり
SDL.init(SDL::INIT_EVERYTHING)
SDL::WM.setCaption("るびじゃん！","")
$screen = SDL.set_video_mode(SCREEN_W,SCREEN_H,16,SDL::SWSURFACE)
SDL::Mixer.open
$effect = Fade.new
#FPS
$input = Input.new
timer = FPSTimerLight.new(fps=RATE)
timer.reset
#メインループ
Scenes = {:title=>TitleScene.new,:game=>GameScene.new,:over=>OverScene.new,:config=>ConfigScene.new}
$scene = Scenes[:title]
h = Pai.new(1,1)
loop do
    $input.poll
    if !$pause 
        $timers.each do |t|
            t.tick
        end
    end
    #シーケンス遷移
    next_scene = $scene.act
    if next_scene
        $scene = Scenes[next_scene]
        $scene.start
        if $effect.now != 0
            $effect.play(15,true)
        end
    end
    $scene.render
    #$effect.render
    timer.wait_frame do
        $screen.update_rect(0,0,0,0)
    end
end
