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

N = 10000
print(timeit.timeit(lambda: primes_im(N), number=100))

print(timeit.timeit(lambda: primes_lc(N), number=100))

print(timeit.timeit(lambda: primes_fun(N), number=100))

