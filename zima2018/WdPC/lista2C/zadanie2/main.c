#include <stdio.h>
#include <stdlib.h>

int main()
{
    int a, b;
    scanf("%d%d", &a, &b);
    //float sk1, sk2;// double
    for(float y = -b+0.5; y<=b-0.5; y++){
        for(float x = -a+0.5; x<=a-0.5; x++){
            float sk1 = (x*x)/(a*a);
            float sk2 = (y*y)/(b*b);
            if((sk1 + sk2) <= 1.0){
                printf("#");
            }
            else{
                printf(" ");
            }
        }
        printf("\n");
    }
    return 0;
}
