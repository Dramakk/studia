#include <stdio.h>
#include <stdlib.h>

int main()
{
    int x, y, c;
    char o;
    int liczPion = 0;
    int liczPoziom = 0;
    int prostokat[1000][1000] = {0};
    int k = 0;
    scanf("%c %d %d", &o, &x, &y);
    while ((c = getchar()) != EOF && c != '\n');
    if(o == 'K'){
        int zakodowane[1000000];
        do{
            c = getchar();
            prostokat[liczPoziom][liczPion] = c;
            liczPoziom++;
            if(liczPoziom == x){
                liczPoziom = 0;
                liczPion++;
            }
            if((liczPoziom == 0 && liczPion == y) || c == EOF){
                liczPion = 0;
                liczPoziom = 0;
                for(int i = 0; i<=x;i++){
                    for(int j = 0; j<=y; j++){
                        if(prostokat[i][j] != 0){
                            zakodowane[k] = prostokat[i][j];
                            k++;
                        }
                        prostokat[i][j] = 0;
                    }
                }
                continue;
            }
        }while( c != EOF);
        for(int i = 0; i<k-1; i++){
            printf("%c", zakodowane[i]);
        }
    }
    int licznik = 0;
    else if(o == 'D'){
        int odkodowane[1000000];
        do{
            c = getchar();
            prostokat[liczPoziom][liczPion] = c;
            liczPion++;
            if(liczPion == y){
                liczPion = 0;
                liczPoziom++;
            }
            if((liczPoziom == x && liczPion == 0) || c == EOF){
                liczPion = 0;
                liczPoziom = 0;
                for(int j = 0; j<=y;j++){
                    for(int i = 0; i<=x; i++){
                        if(prostokat[i][j] != 0){
                            odkodowane[k] = prostokat[i][j];
                            k++;
                        }
                        prostokat[i][j] = 0;
                    }
                }
                licznik++;
                continue;
            }
        }while(c != EOF);
        for(int i = 0; i<k-1; i++){
            printf("%c", odkodowane[i]);
        }
    }
    return 0;
}
