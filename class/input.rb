class Input
  def initialize
    @@press_z = false
    @@press_pause = false
    @lock = false
  end
  def poll
    SDL::Key.scan
    SDL::Event2.poll
    if !z?
      @@press_z = false 
    end
    if !SDL::Key.press?(SDL::Key::RETURN) && @@press_pause
      @@press_pause =false
    end
  end
  def right?
    return SDL::Key.press?(SDL::Key::RIGHT) && !@lock
  end
  def left?
    return SDL::Key.press?(SDL::Key::LEFT) && !@lock
  end
  def up?
    return SDL::Key.press?(SDL::Key::UP) && !@lock
  end
  def down?
    return SDL::Key.press?(SDL::Key::DOWN) && !@lock
  end
  def z?
    return SDL::Key.press?(SDL::Key::Z) && !@lock
  end
  def enter?
    return SDL::Key.press?(SDL::Key::RETURN) && !@lock
  end
  def r?
    return SDL::Key.press?(SDL::Key::R) && !@lock
  end
  def t?
    return SDL::Key.press?(SDL::Key::T) && !@lock
  end
  def x?
    return SDL::Key.press?(SDL::Key::X) && !@lock
  end
  def b?
    return SDL::Key.press?(SDL::Key::B) && !@lock
  end
  def a?
    return SDL::Key.press?(SDL::Key::A) && !@lock
  end
  def pause?
    if SDL::Key.press?(SDL::Key::RETURN) && !@@press_pause
      @@press_pause = true
      return true
    else
      return false
    end
  end
  def shot?
    #if z? && !@@press_z 
    #  @@press_z = true
    #  return true
    #else
    #  return false
    #end
    z?
  end
  def shift?
    return SDL::Key.press?(SDL::Key::LSHIFT)
  end
  attr_accessor :lock
end
