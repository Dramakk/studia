#include <stdio.h>
#include <sys/stat.h>
#include <string.h>
int main(int argc, char *argv[]) {
    // Otwieramy nasz plik wykonywalny
    FILE *fmain = fopen(argv[0],"rb");
    // Tworzymy tymczasowy plik
    char tmpname[strlen(argv[0])+5];
    strcpy(tmpname,argv[0]);
    strcat(tmpname,".tmp");
    FILE *ftmp = fopen(tmpname,"wb+");
    chmod(tmpname,0777);
    // Kopiujemy bajt po bajcie
    int ch;
    while ((ch = fgetc(fmain)) != EOF) fputc(ch, ftmp);
    fseek(ftmp, -2*sizeof(int), SEEK_END);
    int flaga = getw(ftmp);
    if(flaga == -83){
        int x = getw(ftmp);
        x++;
        fseek(ftmp, -sizeof(int), SEEK_END);
        putw(x, ftmp);
        printf("%d\n", x);
    }
    else{
        putw(-83, ftmp);
        putw(1, ftmp);
        printf("1\n");
    }
    fclose(fmain);
    fclose(ftmp);
    rename(tmpname,argv[0]);
}
