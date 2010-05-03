#classファイル読み込み
Dir.foreach("class"){|f|
    if f.to_s =~ /\.rb$/
        require "class/#{f.to_s}"
    end
}
#既存クラスのオーバーロード
class Integer
  #数字を漢数字で返すメソッド
  def cc
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
$scene = GameScene.new
