class Snapshot
  def initialize(file)
    @file = File.open(file, "w")
  end
  def run(format=0)
    ObjectSpace.each_object(){|x| x}
  end
end
class FormatHTML
  def openDiv()
    "<div>"
  end
  def closeDiv()
    "</div>"
  def format(thing, tag)
    if thing
      self.gsub(/#{hlstr}/,"<#{tag}>#{hlstr}</#{tag}>")
    else
      "<#{tag}>#{self}</#{tag}>"
    end
  end
end
s = Snapshot.new
s.run()
file = File.open(nazwa, "w")

x = b
dx = (b - a) / 1000.0
for i in 1..1000
    file.puts (a+i*dx).to_s + " " + value(a + i*dx).to_s #+ " lineto"
end
#file.puts "stroke"
#file.puts "showpage"

file.close
