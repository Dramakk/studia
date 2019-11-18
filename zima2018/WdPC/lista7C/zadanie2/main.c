#include <stdio.h>
#include <stdlib.h>

int main()
{
    size_t maxMem = 0, prawa, pom, lewa, i = 1;
    size_t *memPointer;
    for(i=1; memPointer=malloc(i); i=i*2) free(memPointer);
    lewa = i/2;
    prawa = i;
    maxMem = lewa;
    while(malloc(maxMem)){
        pom = (maxMem+prawa)/2;
        if((memPointer=malloc(pom))!=NULL){
            maxMem = pom;
            prawa = pom;
            free(memPointer);
        }
        else{
            lewa = pom;
        }
    }
    printf("DONE! %lld", maxMem);
    return 0;
}
