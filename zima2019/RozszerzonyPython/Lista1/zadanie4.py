def zaszyfruj(tekst, klucz):
  secretMessage = ""
  for character in tekst:
    character = ord(character)
    character = character ^ klucz
    secretMessage += chr(character)
  return secretMessage


def odszyfruj(tekst, klucz):
  return zaszyfruj(tekst, klucz)


print(zaszyfruj("Python", 7))
print(odszyfruj(zaszyfruj("Python", 7), 7))
