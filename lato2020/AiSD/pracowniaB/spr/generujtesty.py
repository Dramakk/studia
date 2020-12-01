import math as m
import random as ra
import sys


def dist(p1, p2):
    #print(p1,p1[0],p2,p2[0],p2[1])
    a = p2[0] - p1[0]
    b = a**2
    #print(a, b)
    c = p2[1] - p1[1]
    d = c**2
    #print(c, d)
    e = b+d
    f = m.sqrt(e)
    #print(e, f)

    return f

def per(p1, p2, p3):
    return dist(p1, p2)+dist(p2, p3)+dist(p1, p3)


def generujtest(ktory):
    MAP = set()

    n = ra.randint(3, ILE)
    path = "in/"+str(ktory)+".in"
    fo = open(path, "w")

    fo.write(str(n)+"\n")

    ## generuj mapę

    wspol = 800000000
    pole = m.floor(m.sqrt((wspol//4)*n))

    while len(MAP) != n:
        x = ra.randint(-pole, pole)
        y = ra.randint(-pole, pole)
        xy = (x,y)
        if xy not in MAP:
            MAP.add(xy)
            fo.write(str(x)+" "+str(y)+"\n")

    fo.close()
    #################

    path1 = "out/"+str(ktory)+".out"
    fo = open(path1, "w")

    ## rozwiaz
    mindist = 1e20

    for p1 in MAP:
        for p2 in MAP:
            if p2 == p1: continue
            for p3 in MAP:
                if p3 == p1 or p3==p2: continue
                mindist = min(mindist, per(p1,p2,p3))

    fo.write(str(repr(float(mindist))))
    fo.close()
    ###############



ILE = int(sys.argv[1])

for i in range(ILE):
    generujtest(i)
