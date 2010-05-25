require "class/player"
class Myplayer < Player
    def initialize(n,k)
        super
        $my = self
    end
    def start
        @press = false
    end
    def hover_tehai(p)
      a = ex_machi(p)
      a.each do |v|
        puts "不要牌：#{v[1].get_name}、待ち牌：#{v[0].get_name}、type:#{v[2]}"
      end
    end
    def ex_machi(p)
        #選択した牌が、不要牌である待ちを抽出
        return @machis.select{|machi|machi[1] == p}
    end
    #次の番に進むとき、trueを返す
    def act
        super
        if SDL::Mouse.state[2]
            if !@press
                select = $scene.pai_cursol.get_hover
                @press = true
                if !select.nil?
                    dahai(select)
                    ed = true
                end
            end
        else
            @press = false
        end
        return ed
    end
    def render_tehai
        @pais.each_with_index do |p,i|
            p.set_pos(20+i*33,510)
            p.enable_cursol
            p.render
        end
        if !@pai.nil?
            @pai.set_pos(20+13.5*33,510)
            @pai.enable_cursol
            @pai.render
        end
    end
    def ex_tehai
        ripai
        @pais.each do |p|
            puts p.get_name
        end
        puts ""
        puts @pai.get_name
    end
    #手牌をデバッグ用の牌にする
    def debug
        if false
            @pais = Tehai.new([
                              Pai.new(0,3),
                              Pai.new(0,4),
                              Pai.new(0,5),
                              Pai.new(1,3),
                              Pai.new(1,4),
                              Pai.new(1,5),
                              Pai.new(2,4),
                              Pai.new(2,5),
                              Pai.new(2,6),
                              Pai.new(2,7),
                              Pai.new(2,8),
                              Pai.new(3,3),
                              Pai.new(3,3)
            ])
        end
    end
    def tsumo(p)
        if false
          super(Pai.new(2,5))
        else
          super
        end
    end
end
