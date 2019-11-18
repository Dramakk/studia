#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define ROW 20

int round(double x){
    int cal = x;
    if((x - cal) >= 0.5){
        return (cal+1);
    }
    else{
        return cal;
    }
    return 0;
}

void rysuj(int procent){
    for(int i = 0; i<(round((procent*ROW)/100.0)); i++){
        printf("*");
    }
}

int main()
{
    int znaki[256] = {0};
    int c;
    double ile = 0;
    while((c = getchar()) != EOF){
        if(isgraph(c) > 0){
            znaki[c]++;
            ile++;
        }
    }
    for(int i = 0; i<256; i++){
        if(znaki[i] != 0){
            int procent = round((znaki[i]/ile)*100.0);
            printf("%c %d%% ", i, procent);
            rysuj(procent);
            printf("\n");
        }
    }
}
