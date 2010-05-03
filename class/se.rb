class SE
  def initialize(fn)
    @sound = SDL::Mixer::Wave.load("sound/#{fn}")
    @chanel = 0
    SDL::Mixer.set_volume(-1, 16)
  end
  def play
    begin
      @channel = SDL::Mixer.play_channel(-1,@sound,0)
      set_channel(16)
    rescue
    end
  end
  def set_volume(v)
      SDL::Mixer.set_volume(@channel, v)
  end
end
