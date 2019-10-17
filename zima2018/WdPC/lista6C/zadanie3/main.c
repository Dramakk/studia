#include <stdio.h>
#include <stdlib.h>

void moveUP(){

}
void moveDOWN(){

}
void moveLEFT(){

}
void moveRIGHT(){

}
void changeDirection(){

}

struct node{
    int x;
    int y;
    int *L;
    int *R;
    int *U;
    int *D;
    int stan;
};

void createNode(int drzewo[10002][7], int *L, int *R, int *D, int *U, int stan, int x, int y, int i){
    drzewo[i][0] = x;
    drzewo[i][1] = y;
    drzewo[i][2] = L;
    drzewo[i][3] = R;
    drzewo[i][4] = U;
    drzewo[i][5] = D;
    drzewo[i][6] = stan;
}

int main()
{
    int m, n;
    int drzewo[10002][7];
    int plansza[101][101];
    scanf("%d%d", &m, &n);
    for(int i = 0; i<n; i++){
        for(int j = 0; j<m; j++){
            scanf(" %c", &plansza[i][j]);
        }
    }
    int p = 0;
    for(int i = 0; i<n; i++){
        for(int j = 0; j<m; j++){
            if((i == 0 && j == 0)){
                createNode(drzewo, NULL, &plansza[i][j+1], &plansza[i+1][j], NULL, plansza[i][j], j, i, p);
            }
            else if(i == 0){
                createNode(drzewo, &plansza[i][j-1], &plansza[i][j+1], &plansza[i+1][j], NULL, plansza[i][j], j, i, p);
            }
            else if(i == 0 && j == m-1){
                createNode(drzewo, &plansza[i][j-1], NULL, &plansza[i+1][j], NULL, plansza[i][j], j, i, p);
            }
            else if(j == 0){
                createNode(drzewo, NULL, &plansza[i][j+1], &plansza[i+1][j], &plansza[i-1][j], plansza[i][j], j, i, p);
            }
            else if(i == n-1 && j == m-1){
                createNode(drzewo, &plansza[i][j-1], NULL, NULL, &plansza[i-1][j], plansza[i][j], j, i, p);
            }
            else if(j == m-1){
                createNode(drzewo, &plansza[i][j-1], NULL, &plansza[i+1][j], &plansza[i-1][j], plansza[i][j], j, i, p);
            }
            else if(i == n-1){
                createNode(drzewo, &plansza[i][j-1], &plansza[i][j+1], NULL, &plansza[i-1][j], plansza[i][j], j, i, p);
            }
            p++;
        }
    }
    return 0;
}
