#include <stdio.h>
#include <stdlib.h>

int main()
{
    int pary[5000] = {0};
    int c;
    int d = 0;
    while((c = getchar()) != EOF){
        if(c == '{' || c == '(' || c == '['){
            pary[d] = c;
            d++;
        }
        if(c == '}'){
            if(pary[d-1] == '{'){
                d--;
            }
            else{
                break;
            }
        }
        if(c == ')'){
            if(pary[d-1] == '('){
                d--;
            }
            else{
                break;
            }
        }
        if(c == ']'){
            if(pary[d-1] == '['){
                d--;
            }
            else{
                break;
            }
        }
    }
    if(d == 0){
        printf("Poprawnie!");
    }
    else{
        printf("Niepoprawnie!");
    }
}
