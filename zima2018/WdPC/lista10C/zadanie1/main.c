#include <stdio.h>
#include <stdlib.h>

int chodzG(int pozx, int pozy, int jakiBudynek){

}
int chodzD(int pozx, int pozy, int jakiBudynek){

}
int chodzL(int pozx, int pozy, int jakiBudynek){

}
int chodzP(int pozx, int pozy, int jakiBudynek){

}

int main()
{
    int n, m;
    scanf(" %d%d", &n, &m);
    int mapa[m][n];
    for(int i = 0; i<m; i++){
        for(int j = 0; j<n; j++){
            scanf(" %c", &mapa[i][j]);
        }
    }
    for(int i = 0; i<m; i++){
        for(int j = 0; j<n; j++){
            printf("%c", mapa[i][j]);
        }
        printf("\n");
    }

    return 0;
}
