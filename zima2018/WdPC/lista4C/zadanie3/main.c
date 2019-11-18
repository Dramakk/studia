#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#define RZEDY 8
#define KOLUMNY 9

int wieza(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    int ile_kier = 0;
    if(!(szachownica[x+1][y] != '.')){
        ile_kier++;
        for(int j = x; j<8; j++){
            if(szachownica[y][j] == 'p' || szachownica[y][j] == 'h' || szachownica[y][j] == 's' || szachownica[y][j] == 'g' || szachownica[y][j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[y][j] == '.') licznik++;
        }
    }
    if(!(szachownica[x-1][y] != '.')){
        ile_kier++;
        for(int j = x; j>=0; j--){
            if(szachownica[y][j] == 'p' || szachownica[y][j] == 'h' || szachownica[y][j] == 's' || szachownica[y][j] == 'g' || szachownica[y][j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[y][j] == '.') licznik++;
        }
    }
    if(!(szachownica[x][y-1] != '.')){
        ile_kier++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][x] == 'p' || szachownica[i][x] == 'h' || szachownica[i][x] == 's' || szachownica[i][x] == 'g' || szachownica[i][x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x] == '.') licznik++;
        }
    }
    if(!(szachownica[x][y+1] != '.')){
        ile_kier++;
        for(int i = y; i<8; i++){
            if(szachownica[i][x] == 'p' || szachownica[i][x] == 'h' || szachownica[i][x] == 's' || szachownica[i][x] == 'g' || szachownica[i][x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x] == '.') licznik++;
        }
    }
    return licznik-ile_kier;
}

int pionek(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    for(int i = 0; i<8; i++){
        for(int j = 0; j<8; j++){
            if(szachownica[y-1][x] != '.') break;
            else if(j == x && i == y){
                    if(szachownica[i-1][j] == '.'){
                        licznik+=1;
                    }
                    if(y == 6){
                        if(szachownica[i-2][j] == '.'){
                            licznik+=1;
                        }
                    }
                }
            }
        }
    if(szachownica[y-1][x-1] == 'p' || szachownica[y-1][x-1] == 'h' || szachownica[y-1][x-1] == 's' || szachownica[y-1][x-1] == 'g' || szachownica[y-1][x-1] == 'w'){
                licznik++;
    }
    if(szachownica[y-1][x+1] == 'p' || szachownica[y-1][x+1] == 'h' || szachownica[y-1][x+1] == 's' || szachownica[y-1][x+1] == 'g' || szachownica[y-1][x+1] == 'w'){
                licznik++;
    }
    if(((y - 1) == 0) || (y = 0)){
        licznik+=5;
    }
    return licznik;
}

int goniec(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    int j = 0;
    int ile_kier2 = 0;
    if(!(szachownica[y+1][x+1] != '.')){
        ile_kier2++;
        for(int i = y; i<8; i++){
            if(szachownica[i][x+j] == 'p' || szachownica[i][x+j] == 'h' || szachownica[i][x+j] == 's' || szachownica[i][x+j] == 'g' || szachownica[i][x+j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x+j] == '.'){
                licznik++;
                j++;
            }
        }
    }
    j = 7;
    if(!(szachownica[y+1][x-1] != '.')){
        ile_kier2++;
        for(int i = y; i<8; i++){
            if(szachownica[i][j-x] == 'p' || szachownica[i][j-x] == 'h' || szachownica[i][j-x] == 's' || szachownica[i][j-x] == 'g' || szachownica[i][j-x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][j-x] == '.'){
                licznik++;
                j--;
            }
        }
    }
    j = 0;
    if(!(szachownica[y-1][x+1] != '.')){
        ile_kier2++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][x+j] == 'p' || szachownica[i][x+j] == 'h' || szachownica[i][x+j] == 's' || szachownica[i][x+j] == 'g' || szachownica[i][x+j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x+j] == '.'){
                licznik++;
                j++;
            }
        }
    }
    j = 7;
    if(!(szachownica[y-1][x-1] != '.')){
        ile_kier2++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][j-x] == 'p' || szachownica[i][j-x] == 'h' || szachownica[i][j-x] == 's' || szachownica[i][j-x] == 'g' || szachownica[i][j-x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][j-x] == '.'){
                licznik++;
                j--;
            }
        }
    }
    return licznik-ile_kier2;
}

int hetman(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    int ile_kier = 0;
    if(!(szachownica[x+1][y] != '.')){
        ile_kier++;
        for(int j = x; j<8; j++){
            if(szachownica[y][j] == 'p' || szachownica[y][j] == 'h' || szachownica[y][j] == 's' || szachownica[y][j] == 'g' || szachownica[y][j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[y][j] == '.') licznik++;
        }
    }
    if(!(szachownica[x-1][y] != '.')){
        ile_kier++;
        for(int j = x; j>=0; j--){
            if(szachownica[y][j] == 'p' || szachownica[y][j] == 'h' || szachownica[y][j] == 's' || szachownica[y][j] == 'g' || szachownica[y][j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[y][j] == '.') licznik++;
        }
    }
    if(!(szachownica[x][y-1] != '.')){
        ile_kier++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][x] == 'p' || szachownica[i][x] == 'h' || szachownica[i][x] == 's' || szachownica[i][x] == 'g' || szachownica[i][x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x] == '.') licznik++;
        }
    }
    if(!(szachownica[x][y+1] != '.')){
        ile_kier++;
        for(int i = y; i<8; i++){
            if(szachownica[i][x] == 'p' || szachownica[i][x] == 'h' || szachownica[i][x] == 's' || szachownica[i][x] == 'g' || szachownica[i][x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x] == '.') licznik++;
        }
    }
    int j = 0;
    int ile_kier2 = 0;
    if(!(szachownica[y+1][x+1] != '.')){
        ile_kier2++;
        for(int i = y; i<8; i++){
            if(szachownica[i][x+j] == 'p' || szachownica[i][x+j] == 'h' || szachownica[i][x+j] == 's' || szachownica[i][x+j] == 'g' || szachownica[i][x+j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x+j] == '.'){
                licznik++;
                j++;
            }
        }
    }
    j = 7;
    if(!(szachownica[y+1][x-1] != '.')){
        ile_kier2++;
        for(int i = y; i<8; i++){
            if(szachownica[i][j-x] == 'p' || szachownica[i][j-x] == 'h' || szachownica[i][j-x] == 's' || szachownica[i][j-x] == 'g' || szachownica[i][j-x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][j-x] == '.'){
                licznik++;
                j--;
            }
        }
    }
    j = 0;
    if(!(szachownica[y-1][x+1] != '.')){
        ile_kier2++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][x+j] == 'p' || szachownica[i][x+j] == 'h' || szachownica[i][x+j] == 's' || szachownica[i][x+j] == 'g' || szachownica[i][x+j] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][x+j] == '.'){
                licznik++;
                j++;
            }
        }
    }
    j = 7;
    if(!(szachownica[y-1][x-1] != '.')){
        ile_kier2++;
        for(int i = y; i>=0; i--){
            if(szachownica[i][j-x] == 'p' || szachownica[i][j-x] == 'h' || szachownica[i][j-x] == 's' || szachownica[i][j-x] == 'g' || szachownica[i][j-x] == 'w'){
                licznik++;
                break;
            }
            if(szachownica[i][j-x] == '.'){
                licznik++;
                j--;
            }
        }
    }
    return licznik-ile_kier-ile_kier2-2;
}

int krol(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    if(szachownica[y][x-1] == '.'){
            licznik+=1;
        }
    if(szachownica[y][x+1] == '.'){
            licznik+=1;
        }
    if(szachownica[y-1][x] == '.'){
            licznik+=1;
        }
    if(szachownica[y+1][x] == '.'){
            licznik+=1;
        }
    if(szachownica[y-1][x-1] == '.'){
            licznik+=1;
        }
    if(szachownica[y+1][x+1] == '.'){
            licznik+=1;
        }
    if(szachownica[y-1][x+1] == '.'){
            licznik+=1;
        }
    if(szachownica[y+1][x-1] == '.'){
            licznik+=1;
        }
    return licznik;
}

int skoczek(int szachownica[RZEDY][KOLUMNY], int y, int x){
    int licznik = 0;
    if(szachownica[y-2][x-1] == '.'){
        licznik+=1;
    }
    if(szachownica[y-2][x+1] == '.'){
        licznik+=1;
    }
    if(szachownica[y-1][x+2] == '.'){
        licznik+=1;
    }
    if(szachownica[y-1][x-2] == '.'){
        licznik+=1;
    }
    if(szachownica[y+1][x-2] == '.'){
        licznik+=1;
    }
    if(szachownica[y+1][x+2] == '.'){
        licznik+=1;
    }
    if(szachownica[y+2][x+1] == '.'){
        licznik+=1;
    }
    if(szachownica[y+2][x-1] == '.'){
        licznik+=1;
    }
    return licznik;
}

int main()
{
    int szachownica[8][9];
    for(int i = 0; i<8;i++){
        for(int j = 0; j<9; j++){
            szachownica[i][j] = 0;
        }
    }
    for(int i = 0; i<8; i++){
        for(int j = 0; j<9; j++){
            szachownica[i][j] = getchar();
        }
    }
    int ruchy = 0;
    int ruch;
    for(int i = 0; i<8; i++){
        for(int j = 0; j<8; j++){
            char c = szachownica[i][j];
            switch(c){
                case 'P':
                    ruch = pionek(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
                case 'H':
                    ruch = hetman(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
                case 'G':
                    ruch = goniec(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
                case 'W':
                    ruch = wieza(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
                case 'K':
                    ruch = krol(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
                case 'S':
                    ruch = skoczek(szachownica, i, j);
                    if(ruch<0) break;
                    ruchy+=ruch;
                    break;
            }
        }
    }
    printf("%d", ruchy);
}
