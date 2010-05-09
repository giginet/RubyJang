#役クラス
class Yaku
  def initialize(name,fan)
      @name = name
      @fan = fan
      @score = get_score
      #役満なら１、ダブル役満なら２
      @yakuman = (@fan/13).floor
  end
  def get_score
      #飜数から点数を返す
  end
  def get_name
      return @name
  end
  def get_fan
    return @fan
  end
  def yakuman?
    return @fan>=13
  end
  attr_reader :score,:fan
end
