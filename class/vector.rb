class Vector
  def initialize(x=0,y=0)
    @x = x
    @y = y
  end
  #演算子のオーバーライド
  def ==(v)
    v.x == @x && v.y == @y
  end
  def *(n)
    @x*=n
    @y*=n
    return self
  end
  def +(v)
    @x +=v.x
    @y +=v.y  
    return self
  end
  def -(v)
    @x -=v.x
    @y -=v.y
    return self
  end
  def /(n)
    unless n==0
      @x /=n
      @y /=n
    end
    return self
  end
  def round
    @x = @x.round
    @y = @y.round
    return self
  end
  attr_accessor :x,:y
  def length
    Math.sqrt(@x**2+@y**2)
  end
  def scale(n)
    @x *=n
    @y *=n
    return self
  end
  def normalize
    unless length==0
      return scale(1/length)
    else
      return Vector.new
    end
  end
  def resize(n)
    normalize.scale(n)
  end
  def reverse
    tmpx = @x*-1
    tmpy = @y*-1
    return Vector.new(tmpx,tmpy)
  end
  def reverse!
    @x *=-1
    @y *=-1
    return self
  end
  def set(x,y)
    @x = x
    @y = y
  end
  #起点を中心にdeg度回転させる
  def rotate(deg)
    rad = atr(deg)
    return Vector.new(@x*Math.cos(rad)-@y*Math.sin(rad),@x*Math.sin(rad)+@y*Math.cos(rad))  
  end
  def rotate!(deg)
    rad = atr(deg)
    x = @x
    y = @y
    @x = x*Math.cos(rad)-y*Math.sin(rad)
    @y = x*Math.sin(rad)+y*Math.cos(rad)
    return self
  end
end

