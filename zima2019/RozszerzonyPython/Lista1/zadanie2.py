def change(change_to_give):
  denominations = [20, 10, 5, 2, 1]
  i = 0
  change = {}
  while change_to_give != 0:
    if change_to_give >= denominations[i]:
      if denominations[i] in change:
        change[denominations[i]] += 1
      else:
        change[denominations[i]] = 1
      change_to_give-=denominations[i]
    else:
      i+=1
  return change

print(change(123))

