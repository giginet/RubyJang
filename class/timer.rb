class Timer
  def initialize(n=0)
    set(n)
    @timer = 0
    $timers.push(self)
  end
  def set(n)
    @mtimer = n
    #@timer = 0
  end
  def tick
    if @flag
      @timer+=1
    end
  end
  def up?(f=false)
    if @mtimer<=@timer
      if f
        destroy
      end
      return true
    else
      return false
    end
  end
  def stop
    @flag = false
  end
  def play
    @flag = true
  end
  def reset
    @timer = 0
  end
  def destroy
    $timers.delete_if{|t|t==self}
  end
  def move?
    return @flag
  end
  def set_random(n=60)
    t = 1
    x = ((n-1)*2)
    x.times{|i|
      if rand(2)==0
        t +=1
      end
    }
    set(t)
  end
  def now
    return @timer
  end
end
