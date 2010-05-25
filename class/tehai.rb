#手牌検索用のコンテナ。Arrayにいろいろと機能追加してみた。
class Tehai < Array
    def dup
        return Tehai.new(self)
    end
    #特定の牌の数を数える。
    def count(pai)
        c = 0
        each do |p|
            if pai.eql?(p)
                c +=1
            end
        end
        return c
    end
    #ヤオ九牌の数を数える
    #タンヤオとか、混老頭とか、九種九牌の判定用
    def count_yaochu
        c = 0
        each do |p|
            if p.yaochu?
                c+=1
            end
        end
        return c
    end
    def count_yaochu_kinds
        array = self.dup
        return array.delete_if{|p|!p.yaochu?}.count_kinds
    end
    #対子を配列で返す
    def search_heads
        a = Array.new
        uniq.each do |p|
            if count(p)>=2
                a.push(Mentsu.new(p,p))
            end
        end
        return a
    end
    #塔子を配列で返す
    def search_tartsu
        a = Array.new
        each do |p|
            each do |q|
                if !p.jihai? && !q.jihai? && p.kind==q.kind
                    if p.number > q.number
                        if (p.number-q.number).abs < 3
                            a.push(Mentsu.new(p,q))
                        end
                    end
                end
            end
        end
        return a
    end
    #手牌の中に何種類の牌があるかを返す。
    def count_kinds
        return uniq.length
    end
    #指定した牌の刻子はあるか
    def has_koutsu?(p)
        return count(p) >=3
    end
    #指定した牌を含む順子はあるか
    def has_syuntsu?(p)
    end
    #刻子の候補を配列で返す
    def search_koutsu
        a = Array.new
        uniq.each do |p|
            if has_koutsu?(p)
                a.push(Mentsu.new(p,p,p))
            end
        end
        return a
    end
    #順子の候補を配列で返す
    def search_syuntsu
        a = Array.new
        each do |p|
            if !p.jihai?
                unless (p+1).nil? || (p+2).nil? || p.kind==3
                    if count(p+1)>0 && count(p+2)>0
                        a.push(Mentsu.new(p,p+1,p+2))
                    end
                end
            end
        end
        return a
    end
    #暗刻の候補を配列で返する
    def search_ankou
        return search_koutsu.delete_if{|m|m.fooroh}
    end
    #入力された面子を削除するメソッド
    def pop_mentsu(mentsu)
        if has_mentsu?(mentsu)
            mentsu.get_pais.get_hash.each do |k,v|
                v.times do
                    delete_at(index(k))
                    each do |p|
                        p.get_name
                    end
                end
            end
        end
        return self
    end
    #入力された面子を書き戻すメソッド
    def push_mentsu(mentsu)
        return concat(mentsu.get_pais)
    end
    #面子を持っているかどうかを判定するメソッド
    def has_mentsu?(mentsu)
        h = get_hash
        i = mentsu.get_pais.get_hash
        bool = true
        i.each do |k,v|
            unless v<=h[k]
                bool = false
            end
        end
        return bool
    end
    #手牌に含まれている牌をハッシュにして返す
    def get_hash
        hash = Hash.new
        hash.default = 0
        each do |v|
            hash[v] +=1
        end
        return hash
    end
    def ripai
        return sort{|a,b|(a.kind<=>b.kind).nonzero? || a.number<=>b.number}
    end
    def ripai!
        return sort!{|a,b|(a.kind<=>b.kind).nonzero? || a.number<=>b.number}
    end
    def has?(p)
        return count(p) > 0
    end
    #最大の値を返す
    def max
        n = 0
        r = 0
        each do |p|
            if p.number > n
                n = p.number
                r = p
            end
        end
        return r 
    end
    #最小の値を返す
    def min
        n = 9
        r = 0
        each do |p|
            if p.number < n
                n = p.number
                r = p
            end
        end
        return r 
    end

end
