#ifndef TABLICA_H_INCLUDED
#define TABLICA_H_INCLUDED
typedef struct lista {
    void *wartosc;
    int indeks;
    int dol;
    int gora;
    struct lista* nast;
    struct lista* poprz;
} listaElement;
typedef struct lista * pListaElement;
pListaElement stworz();
void dodaj(void *war, int indeks, pListaElement tab);
void* pobierz(int indeks, pListaElement tab);
#endif // TABLICA_H_INCLUDED
