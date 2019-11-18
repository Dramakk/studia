import math
import timeit

def primes_im(n):
    res = []
    for i in range(2,n):
        rge = math.floor(math.sqrt(i))
        if i == 2 or i == 3:
            res.append(i)
        else:
            for j in range(2,rge+1):
                if i%j == 0:
                    break
                elif j == rge:
                    res.append(i)
    return res

def primes_lc(n):
    return [x for x in range(2, n) if x == 2 or x == 3 or all(x % y != 0 for y in range(2, math.floor(math.sqrt(n))+1))]

def is_prime_fun(n):
    return len(list(filter(lambda k: n%k == 0 and n != 2, range(2,math.floor(math.sqrt(n))+1)))) == 0

def primes_fun(n):
    return list(filter(is_prime_fun,range(2,n)))

class PrimesIter:
    def __init__(self, up_to):
        self.current = 2
        self.up_to = up_to

    def __iter__(self):
        return self

    def __next__(self):
        while True:
            if self.current > self.up_to:
                raise StopIteration
            is_prime = True
            for x in range(2, math.floor(math.sqrt(self.current))):
                if self.current % x == 0:
                    is_prime = False
                    self.current += 1
                    break
            if is_prime:
                ret = self.current
                self.current += 1
                return ret

timeit_setup = '''from zadanie1 import (
        PrimesIter
    )'''
for i in range(0, 1000, 100):
    print(timeit.timeit(lambda: primes_im(i), number=50))
    print(timeit.timeit(lambda: primes_lc(i), number=50))
    print(timeit.timeit(lambda: primes_fun(i), number=50))
    print(timeit.timeit(f'for n in PrimesIter({i}): n', setup=timeit_setup, number=50))
    print('-'*10)