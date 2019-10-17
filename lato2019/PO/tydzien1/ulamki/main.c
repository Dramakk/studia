#include <stdio.h>
#include <stdlib.h>
#include "Ulamki.h"
int main()
{
    pUlamek x, z, v;
    x = stworz_ulamek(1,3);
    pUlamek y = stworz_ulamek(2, 7);
    pUlamek d = stworz_ulamek(6, 17);
    podziel_ulamkiVoid(x, y);
    z = dodaj_ulamki(x, y);
    v = odejmij_ulamki(x, y);
    printf("%d/%d || %d/%d || %d/%d || ", y->licznik, y->mianownik, z->licznik, z->mianownik, v->licznik, v->mianownik);
    pomnoz_ulamkiVoid(x, d);
    printf("%d/%d", d->licznik, d->mianownik);
    return 0;
}
