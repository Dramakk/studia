#include <stdio.h>
#include <stdlib.h>

int czyPrzecinaja(double x1, double y1, double x2, double y2){
    double czy = (x1-x2)/(y2 - x2 - y1 + x1);
    if((czy > 0) && (czy < 1)){
        return 1;
    }
    else{
        return 0;
    }
}

int main()
{
    printf("%d", czyPrzecinaja(0, 3, 3, 1));
}
