#include <stdio.h>
#include <stdlib.h>

int liczby[1000000];
char operatoryT[100000];
int n;

void operatory(int poz, int sum){
    int temp = sum;
    if(poz == n-1){
        if(sum == 1) {
          printf("%i", liczby[0]);
          for (int i = 0; i < n-1; i++) {
            if(operatoryT[i] == '>'){
                printf(" >> %i", liczby[i+1]);
            }
            else if(operatoryT[i] == '<'){
                printf(" << %i", liczby[i+1]);
            }
            else printf(" %c %i", operatoryT[i], liczby[i+1]);
          }
          exit(0);
        }
        else if(sum > 1){
            printf("Nie można znaleźć takiego ustawienia operatorów!");
            exit(0);
        }
    }
    else{
        temp = sum & liczby[poz+1];
        operatoryT[poz] = '&';
        operatory(poz+1, temp);
        temp = sum | liczby[poz+1];
        operatoryT[poz] = '|';
        operatory(poz+1, temp);
        temp = sum ^ liczby[poz+1];
        operatoryT[poz] = '^';
        operatory(poz+1, temp);
        temp = sum >> liczby[poz+1];
        operatoryT[poz] = '>';
        operatory(poz+1, temp);
        temp = sum << liczby[poz+1];
        operatoryT[poz] = '<';
        operatory(poz+1, temp);
    }
    return;
}

int main()
{
    scanf("%d", &n);
    for(int i = 0; i<n; i++){
        scanf("%d", &liczby[i]);
    }
    operatory(0, liczby[0]);
}
