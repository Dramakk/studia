def vat_faktura(lista):
  value = sum(lista)
  return value * 23 / 100


def vat_paragon(lista):
  lista = list(map(lambda x : (x * 23 / 100), lista))
  return sum(lista)


zakupy = [0.2, 0.5, 4.59, 6]
print(vat_faktura(zakupy) == vat_paragon(zakupy))
