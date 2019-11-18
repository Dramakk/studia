#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
int *szyna;
bool *odwiedzone;
int main()
{
    int opisStanow[32][4];
    int ileStanow;
    scanf("%d", &ileStanow);
    for(int i = 0; i<2*ileStanow; i++){
        scanf("%d%d%d%d", &opisStanow[i][0], &opisStanow[i][1], &opisStanow[i][2], &opisStanow[i][3]);
    }
    int ileKrokow, ruch;
    scanf("%d", &ileKrokow);
    szyna = malloc(sizeof(int*) * (2*ileKrokow));
    odwiedzone = malloc(sizeof(bool *) * (2*ileKrokow));
    for(int i = 0; i<2*ileKrokow; i++){
        szyna[i] = 0;
        odwiedzone[i] = 0;
    }
    int poczatek = ileKrokow;
    int stanP = 0, maksLewo = poczatek, maksPrawo = poczatek;
    int czyDziala = 0, stanT;
    for(int i = 0; i<ileKrokow; i++){
        int znak = szyna[poczatek];
        odwiedzone[poczatek] = 1;
        if(!czyDziala){
            if(znak == 0){
                ruch = opisStanow[2*stanP][1];
                szyna[poczatek] = opisStanow[2*stanP][0];
                czyDziala = opisStanow[2*stanP][2];
                stanT = opisStanow[2*stanP][3];
            }
            else if(znak == 1){
                ruch = opisStanow[2*stanP+1][1];
                szyna[poczatek] = opisStanow[2*stanP+1][0];
                czyDziala = opisStanow[2*stanP+1][2];
                stanT = opisStanow[2*stanP+1][3];
            }
            if(czyDziala == 1) break;
            else{
                if((i+1) == ileKrokow){
                    int gdzie;
                    if(ruch == 0) gdzie = -1;
                    else gdzie = 1;
                    odwiedzone[poczatek+gdzie] = 1;
                }
                if(ruch == 0){
                    poczatek--;
                }
                else if(ruch == 1){
                    poczatek++;
                }
                if(poczatek<maksLewo){
                    maksLewo = poczatek;
                }
                if(poczatek>maksPrawo){
                    maksPrawo = poczatek;
                }
                stanP = stanT;
            }
        }
    }
    int aktualna = poczatek - ileKrokow;
    if(!czyDziala){
        int l = (maksLewo - ileKrokow);
        int p = (maksPrawo - ileKrokow);
        printf("running %d\n", aktualna);
        printf("%d ", l);
        for(int i = maksLewo; i<=maksPrawo; i++){
            if(odwiedzone[i] == 1) printf("%d", szyna[i]);
        }
        printf(" %d", p);
    }
    else{
        int l = (maksLewo - ileKrokow);
        int p = (maksPrawo - ileKrokow);
        printf("halted %d\n", aktualna);
        printf("%d ", l);
        for(int i = maksLewo; i<=maksPrawo; i++){
            if(odwiedzone[i] == 1) printf("%d", szyna[i]);
        }
        printf(" %d", p);
    }
    return 0;
}
