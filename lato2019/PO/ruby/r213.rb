class Funkcja
  def initialize(&block)
    @fun = block
  end

  def value(x)
    @fun.call(x)
  end

  def zerowe(a, b, eps)
		x = (a+b)/2.0
		val = value(x)
		if (val >= -eps) and (val <= eps)
			return x
		else
			left = value(a)
			rigth = value(b)
			if left < 0 and val > 0
				return f_root(a,x,eps)
			elsif left > 0 and val < 0
				return f_root(a,x,eps)
			elsif rigth > 0 and val < 0
				return f_root(x,b,eps)
			elsif rigth < 0 and val > 0
				return f_root(x,b,eps)
			elsif value == 0
				return x
			else
				nil
			end
		end
	end

  def poch(x)
    h = 0.000000001
	  (value(x+h)-value(x))/h
  end

  def pole(a,b)
    p = 0.0
    n = 10000.0
    frag = (b-a)/n
    for i in 1..n
      p += value(a+i*frag)*frag
    end
    return p
  end

  def plot(a, b, nazwa)

        file = File.open(nazwa, "w")

        x = b
        dx = (b - a) / 1000.0
	      for i in 1..1000
            file.puts (a+i*dx).to_s + " " + value(a + i*dx).to_s #+ " lineto"
        end
        #file.puts "stroke"
        #file.puts "showpage"

        file.close
    end
end

f = Funkcja.new {|x| Math.sin(x)}
f.zerowe(-10,10,0.0000001)
puts f.pole(-1,1)
puts f.poch(1)
puts f.value(10)
f.plot(0,100, "x2.txt")
