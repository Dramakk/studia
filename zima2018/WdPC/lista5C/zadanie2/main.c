#include <stdio.h>
#include <stdlib.h>
int l[1000];
int l2[1000];
int l3[1000];

int main()
{
    int max = 1;
    int n;
    scanf("%d", &n);
    for(int i = 0; i<n; i++){
        scanf("%d", &l[i]);
    }
    max=max<<n;
    int maximum = 0;
    for(int i = 0; i<max; i++){
        int sum = 0;
        int x = 0;
        for(int j = 0; j<n; j++){
            if(i&(1<<j)){
                sum= sum + l[j];
                l2[x] = l[j];
                x++;
            }
        }
        if(sum == 0 && x>=maximum){
            for(int i = 0; i<x; i++){
                l3[i] = l2[i];
                maximum = x;
            }
        }
    }
    for(int i = 0; i<maximum; i++){
        printf("%d", l3[i]);
    }
    return 0;
}
