#include <stdio.h>
#include <stdlib.h>
int main()
{
    double x;
    int p, d, r;
    int licz = 0;
    int tab[100];
    int tab2[100];
    char znaki[22];
    for(int i = 0; i<22; i++){
        znaki[i] = 'A' + i;
    }
    do{
        scanf("%lf %d %d", &x, &p, &d);
    }while((x<0) || (p<2 || p>36) || (d<0));
    int c = (int)x;
    x = x - c;
    if(c<=0){
        printf("0");
    }
    else{
        while(c!=0){
            r = c%p;
            c = c/p;
            tab[licz] = r;
            licz++;
        }
        printf("\n");
        for(int i = licz-1; i>-1; i--){
            if(tab[i] >= 10){
                printf("%c", znaki[tab[i] - 10]);
            }
            else{
                printf("%d", tab[i]);
            }
        }
    }
    printf(",");
    int licz2 = 0;
    while(d>0){
        x*=p;
        if(x<1.0){
            tab2[licz2] = 0;
        }
        else{
            tab2[licz2] = (int)x;
            x-=(int)x;
        }
        d--;
        licz2++;
    }
    for(int i = 0; i<licz2; i++){
        if(tab2[i] >= 10){
            printf("%c", znaki[tab2[i] - 10]);
        }
        else{
            printf("%d", tab2[i]);
        }
    }
    return 0;
}
