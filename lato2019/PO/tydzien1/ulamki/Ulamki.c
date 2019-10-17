#include <stdio.h>
#include "Ulamki.h"
//funkcje pomocnicze
pUlamek stworz_ulamek(int licznik, int mianownik){
    int x = nwd(licznik, mianownik);
    if(x != 1){
        licznik = licznik/x;
        mianownik = mianownik/x;
    }
    pUlamek ulamek;
    ulamek = (pUlamek)(malloc(sizeof(Ulamek)));
    ulamek->licznik = licznik;
    if(mianownik > 0){
            ulamek->mianownik = mianownik;
            return ulamek;
    }
    else if(mianownik == 0){
        printf("Niepoprawny ulamek");
        return -1;
    }
    else{
        ulamek->licznik*=-1;
        ulamek->mianownik = mianownik*-1;
    }
}
int nwd(int a, int b){
    if(a < 0) a*=-1;
    if(b < 0) b*=-1;
    while(a!=b){
        if(a>b) a=a-b;
        if(b>a) b=b-a;
    }
    return a;
}
//funkcje zwracajace wskaźnik
pUlamek dodaj_ulamki(pUlamek pierwszy, pUlamek drugi){
    int NWW = (pierwszy->mianownik*drugi->mianownik)/nwd(pierwszy->mianownik, drugi->mianownik);
    int l1 = pierwszy->licznik*(NWW/pierwszy->mianownik);
    int l2 = drugi->licznik*(NWW/drugi->mianownik);
    return stworz_ulamek(l1+l2, NWW);
}
pUlamek odejmij_ulamki(pUlamek pierwszy, pUlamek drugi){
    int NWW = (pierwszy->mianownik*drugi->mianownik)/nwd(pierwszy->mianownik, drugi->mianownik);
    int l1 = pierwszy->licznik*(NWW/pierwszy->mianownik);
    int l2 = drugi->licznik*(NWW/drugi->mianownik);
    return stworz_ulamek(l1-l2, NWW);
}
pUlamek pomnoz_ulamki(pUlamek pierwszy, pUlamek drugi){
    int p = pierwszy->licznik*drugi->licznik;
    int q = drugi->mianownik*pierwszy->mianownik;
    return stworz_ulamek(p, q);
}
pUlamek podziel_ulamki(pUlamek pierwszy, pUlamek drugi){
    int p = pierwszy->licznik*drugi->mianownik;
    int q = drugi->licznik*pierwszy->mianownik;
    return stworz_ulamek(p, q);
}
//funkcje modyfikujace drugi z ulamkow
void dodaj_ulamkiVoid(pUlamek pierwszy, pUlamek drugi){
    int NWW = (pierwszy->mianownik*drugi->mianownik)/nwd(pierwszy->mianownik, drugi->mianownik);
    int l1 = pierwszy->licznik*(NWW/pierwszy->mianownik);
    int l2 = drugi->licznik*(NWW/drugi->mianownik);
    pUlamek temp = stworz_ulamek(l1+l2, NWW);
    drugi->licznik = temp->licznik;
    drugi->mianownik = temp->mianownik;
    free(temp);
}
void odejmij_ulamkiVoid(pUlamek pierwszy, pUlamek drugi){
    int NWW = (pierwszy->mianownik*drugi->mianownik)/nwd(pierwszy->mianownik, drugi->mianownik);
    int l1 = pierwszy->licznik*(NWW/pierwszy->mianownik);
    int l2 = drugi->licznik*(NWW/drugi->mianownik);
    pUlamek temp = stworz_ulamek(l1+l2, NWW);
    drugi->licznik = temp->licznik;
    drugi->mianownik = temp->mianownik;
    free(temp);
}
void pomnoz_ulamkiVoid(pUlamek pierwszy, pUlamek drugi){
    int p = pierwszy->licznik*drugi->licznik;
    int q = drugi->mianownik*pierwszy->mianownik;
    pUlamek temp = stworz_ulamek(p, q);
    drugi->licznik = temp->licznik;
    drugi->mianownik = temp->mianownik;
    free(temp);
}
void podziel_ulamkiVoid(pUlamek pierwszy, pUlamek drugi){
    int p = pierwszy->licznik*drugi->mianownik;
    int q = drugi->licznik*pierwszy->mianownik;
    pUlamek temp = stworz_ulamek(p, q);
    drugi->licznik = temp->licznik;
    drugi->mianownik = temp->mianownik;
    free(temp);
}
////////
