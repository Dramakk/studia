class Integer
  def czynniki
    arr = Array.new
    x = 0
    for i in 1..Math.sqrt(self)
      if (self % i) == 0
        arr.insert(x, i);
        if (self/i) != i
          arr.insert(arr.length-x, self/i)
        end
        x = x+1
      end
    end
    return arr
  end

  def ack(y)
    if self == 0
      return y+1
    elsif y == 0
      return (self-1).ack(1)
    else
      return (self-1).ack(self.ack(y-1))
    end
  end

  def doskonala
    arr = self.czynniki
    arr.pop
    s = 0
    arr.each { |i| s+=i }
    if s == self
      return true
    else
      return false
    end
  end

  def slownie
    start = self
    lookup = ["zero", "jeden", "dwa", "trzy", "cztery", "pięć", "sześć", "siedem", "osiem", "dziewięć"]
    wynik = String.new
    while start != 0
      wynik = lookup[start % 10] + " " + wynik
      start = start/10
    end
    return wynik
  end
end
puts 3.ack(3)
puts 6.doskonala
print 16.czynniki, "\n"
puts 123.slownie
