class Jawna
  def initialize(text)
    @text = text
  end

  def to_s
    @text
  end

  def zaszyfruj(klucz)
    wynik = String.new
    @text.each_char { |chr| wynik+=klucz[chr]}
    return Zaszyfrowane.new(wynik)
  end
end

class Zaszyfrowane
  def initialize(text)
    @text = text
  end

  def to_s
    @text
  end

  def odszyfruj(klucz)
    wynik = String.new
    @text.each_char { |chr| wynik+=klucz[chr]}
    return Jawna.new(wynik)
  end
end

klucz = Hash[ "a" => "b",
"b" => "r",
"r" => "y",
"y" => "u",
"u" => "a"
]
napis = Jawna.new("ruby")
szyfr = napis.zaszyfruj(klucz)
puts szyfr
