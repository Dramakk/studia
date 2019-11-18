#ifndef ULAMKI_H_INCLUDED
#define ULAMKI_H_INCLUDED
typedef struct ulamek{
    int licznik;
    int mianownik;
} Ulamek;
typedef struct ulamek *pUlamek;

pUlamek stworz_ulamek(int licznik, int mianownik);
void dodaj_ulamkiVoid(pUlamek pierwszy, pUlamek drugi);
void odejmij_ulamkiVoid(pUlamek pierwszy, pUlamek drugi);
void pomnoz_ulamkiVoid(pUlamek pierwszy, pUlamek drugi);
void podziel_ulamkiVoid(pUlamek pierwszy, pUlamek drugi);
pUlamek dodaj_ulamki(pUlamek pierwszy, pUlamek drugi);
pUlamek odejmij_ulamki(pUlamek pierwszy, pUlamek drugi);
pUlamek pomnoz_ulamki(pUlamek pierwszy, pUlamek drugi);
pUlamek podziel_ulamki(pUlamek pierwszy, pUlamek drugi);
#endif // ULAMKI_H_INCLUDED
