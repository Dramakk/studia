def kompresja(tekst):
  compressed = ''
  howMany = 1
  for i in range(len(tekst)):
    if i < len(tekst) - 1 and tekst[i + 1] == tekst[i]:
      howMany += 1
    else:
      if howMany > 1:
        compressed += str(howMany) + tekst[i]
      else:
        compressed += tekst[i]
      howMany = 1

  return compressed


def dekompresja(tekst):
  decompressed = ''
  howMany = ''
  for i in range(len(tekst)):
    if tekst[i].isdigit():
      howMany += tekst[i]
    elif howMany:
      decompressed+=int(howMany)*tekst[i]
      howMany = ''
    else:
      decompressed+=tekst[i]
  return decompressed
print(kompresja("aaaaaabbbbbbbbbbbbbbbb,,.."))
print(dekompresja(kompresja("aaaaaabbbbbbbbbbbbbbbb,,..")))
