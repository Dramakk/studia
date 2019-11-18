class Kolekcja
   def initialize(arr)
      @arr = arr
      @len = arr.length
   end

  def swap(i, j)
    if (i>=@len or j>=@len) or (i<0 or j<0)
      puts "Invalid arguments"
      0
    else
      temp = @arr[i]
      @arr[i] = @arr[j]
      @arr[j] = temp
    end
  end

  def length
    @len-1
  end

  def get(i)
    if i<0 or i>=@len
      puts "Invalid argument"
    end
    return @arr[i]
  end

  def to_s
    @arr.to_s
  end
end

class Sortowanie
  def initialize
  end
  def sort1(kol)
    for i in 0..kol.length-1
      min = i
      for j in i+1..kol.length
        if kol.get(j) <= kol.get(min)
          min = j
        end
        kol.swap(i, min)
      end
    end
  end
  def sort2(kol, from=0, to=nil)
    if to == nil
        to = kol.length
    end
    if from >= to
        return
    end
    pivot = kol.get(to)
    p_index = from
    i = from
    while i < to
      if kol.get(i) <= pivot
        kol.swap(i, p_index)
        p_index += 1;
      end
      i += 1
    end
    kol.swap(to, p_index)
    sort2(kol, from, p_index-1)
    sort2(kol, p_index+1, to)
  end
end
array = [3, 1, 4, 8, 7, 10, 9, 20, 15, 2]
k = Kolekcja.new(array)
k.swap(0, 10)
s = Sortowanie.new
s.sort2(k)
puts k
