from random import *
test = open('test.txt', 'w')
print("1000000 20\n", file=test)
t = ''
for i in range(1000001):
	t += str(randint(0, 10**9)) + " "
print(t, file=test)
