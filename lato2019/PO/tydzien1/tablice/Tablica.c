#include <stdio.h>
#include "Tablica.h"
#include <stdlib.h>
pListaElement stworz(){
    pListaElement tab = (pListaElement)(malloc(sizeof(listaElement)));
    tab->indeks = NULL;
    tab->wartosc = NULL;
    tab->nast = NULL;
    tab->poprz = NULL;
    tab->dol = 0;
    tab->gora = 0;
    return tab;
}
void dodaj(void *war, int indeks, pListaElement tab){
    if(!tab){
        tab->indeks = indeks;
        tab->wartosc = war;
        tab->nast = NULL;
        tab->poprz = NULL;
    }
    else{
        if(indeks > tab->gora) tab->gora = indeks;
        if(indeks < tab->dol) tab->dol = indeks;
        if(tab->indeks == indeks) tab->wartosc = war;
        else if(tab->indeks < indeks){
            for(int i = tab->indeks; i<=indeks; i++){
                if(i == indeks) tab->wartosc = war;
                if(tab->nast == NULL){
                    pListaElement temp = (pListaElement)(malloc(sizeof(listaElement)));
                    temp->wartosc = NULL;
                    temp->indeks = i;
                    temp->nast = NULL;
                    temp->poprz = tab;
                    tab->nast = temp;
                    tab = temp;
                }
                else tab=tab->nast;
            }
        }
        else if(tab->indeks > indeks){
            for(int i = tab->indeks; i>=indeks; i--){
                if(i == indeks) tab->wartosc = war;
                if(tab->poprz == NULL){
                    pListaElement temp = (pListaElement)(malloc(sizeof(listaElement)));
                    temp->wartosc = NULL;
                    temp->indeks = i;
                    temp->nast = tab;
                    temp->poprz = NULL;
                    tab->poprz = temp;
                    tab = temp;
                }
                else tab = tab->poprz;
            }
        }
    }
}
void *pobierz(int indeks, pListaElement tab){
    if(indeks < tab->dol || indeks > tab->gora){
        return NULL;
    }
    if(tab->indeks == indeks){
        return tab->wartosc;
    }
    else if(tab->indeks < indeks){
        while(tab->nast->indeks != indeks){
            tab = tab->nast;
        }
        return tab->wartosc;
    }
    else if(tab->indeks > indeks){
        while(tab->poprz->indeks != indeks){
            tab = tab->poprz;
        }
        return tab->wartosc;
    }
}
