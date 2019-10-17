#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define FILL(t, n, pattern)\
    const char *s = #pattern;\
    for(int i = 0; i<n; i++) t[i] = 0;\
    int dlugosc = strlen(s);\
    for(int ktoryBajt = 0; ktoryBajt<n*8; ktoryBajt++) t[ktoryBajt/8] = t[ktoryBajt/8] | ((s[ktoryBajt%dlugosc] - '0') << (7-ktoryBajt%8));\

int main()
{
    char t[10];
    FILL(t,10,0110000101100010);
    printf("%.10s",t);
}
