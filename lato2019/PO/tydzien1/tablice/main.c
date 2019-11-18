#include <stdio.h>
#include <stdlib.h>
#include "Tablica.h"
typedef struct punkt{
    int x;
    int y;
} pkt;
int main()
{
    pListaElement tab = stworz();
    pkt x, y, z;
    x.x = 1;
    x.y = -8;
    y.x = -2;
    y.y = -3;
    z.x = -12;
    z.y = -20;
    int *p = 124;
    dodaj(&x, 2, tab);
    dodaj(&y, -3, tab);
    dodaj(&y, 5, tab);
    dodaj(p, 1, tab);
    pkt *a = pobierz(2, tab);
    pkt *b = pobierz(-3, tab);
    printf("%d %d %d %d", a->x, pobierz(-1, tab), b->y, pobierz(1, tab));
    return 0;
}
