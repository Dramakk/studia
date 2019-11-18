def pierwiastek(n):
  s, i = 0, 1
  while s < n:
    s, i = s+2 * i - 1, i+1
  return i - 1

print(pierwiastek(121))
