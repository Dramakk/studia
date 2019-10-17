#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main()
{
    bool tab[2001] = {0};
    tab[1000] = 1;
    int n;
    scanf("%d", &n);
    int liczba;
    int suma;
    bool tabSum[2001] = {0};
    for(int i = 0; i<n; i++){
        scanf("%d", &liczba);
        for(int j = 0; j<2001; j++){
            if(tab[j] == 1){
                suma = j+liczba;
                if(suma>=0 && suma<=2000){
                    tabSum[suma] = 1;
                }
            }
        }
        for(int j = 0; j<= 2000; j++){
            tab[j] = tab[j] || tabSum[j];
        }
    }
    for(int i = 0; i<2001; i++){
        if(tab[i] == 1){
            printf("%d ", i-1000);
        }
    }
}
