import math
import timeit

def perfect_im(n):
    res = []
    for i in range(1,n):
        s = 0
        for j in range(1,i):
            if not i%j:
                s += j
        if s == i:
            res.append(i)
    return res

def perfect_lc(n):
    return [x for x in range(1, n) if x == sum([y for y in range(1,x) if not x % y])]

def is_perfect(n):
    return n == sum(list(filter(lambda x: not n % x, range(1,n))))

def perfect_fun(n):
    return list(filter(is_perfect, range(1, n)))

N = 1000
print(timeit.timeit(lambda: perfect_im(N), number=100))

print(timeit.timeit(lambda: perfect_lc(N), number=100))

print(timeit.timeit(lambda: perfect_fun(N), number=100))
