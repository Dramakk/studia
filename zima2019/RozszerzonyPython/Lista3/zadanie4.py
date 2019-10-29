import random

def uprosc_zdanie(tekst, dl_slowa, liczba_slow):
  text = tekst.split()
  text = list(filter(lambda word: len(word) <= dl_slowa, text))
  text_length = len(text)
  while text_length > liczba_slow:
    text.pop(random.randint(0, text_length-1))
    text_length-=1
  print(text)

tekst = "Podział peryklinalny inicjałów wrzecionowatych \
kambium charakteryzuje się ścianą podziałową inicjowaną \
w płaszczyźnie maksymalnej."

tekst2 = "Już wstążkę pawilonu wiatr zaledwie muśnie,\
Cichemi gra piersiami rozగaśniona woda;\
Morze\
Jak marząca o szczęściu narzeczona młoda,\
Zbuǳi się, aby westchnąć, i wnet znowu uśnie.\
Żagle, na kształt chorągwi gdy woగnę skończono,\
Drzémią na masztach nagich; okręt lekkim ruchem\
Kołysa się, గak gdyby przykuty łańcuchem;\
Maగtek wytchnął, podróżne rozśmiało się grono.\
O morze! pośród twoich wesołych żyగątek\
Jest polip, co śpi na dnie, gdy się niebo chmurzy,\
A na ciszę długiemi wywĳa ramiony"
uprosc_zdanie(tekst, 10, 5)
uprosc_zdanie(tekst2, 10, 5)
