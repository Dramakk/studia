#include <stdio.h>
#include <stdlib.h>

int charToBin(int c, int i){
    if((c & (1 << i))){
        return 1;
    }
    else{
        return 0;
    }
    return 0;
}

int main()
{
    int c;
    int licznik = 0, maks_licznik = 0, bit = 0;
    while((c = getchar()) != EOF){
        for(int j = 7; j>=0; j--){
            if(charToBin(c, j) == 1){
                if(bit == 0){
                    licznik++;
                    if(licznik>maks_licznik){
                        maks_licznik = licznik;
                    }
                    bit = 1;
                }
                else{
                    licznik = 1;
                }
            }
            else{
                if(bit == 1){
                    licznik++;
                    if(licznik>maks_licznik){
                        maks_licznik = licznik;
                    }
                    bit = 0;
                }
                else{
                    licznik = 1;
                }
            }
        }
    }
    printf("\n%d", maks_licznik);
    return 0;
}
