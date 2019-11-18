#include <stdio.h>
#include <stdlib.h>

int maxS(int n, int a[])
{ int ms, i, s;
i=s=0; ms=a[0];
while (i<n){
 s=s+a[i];
 if (s>ms) ms=s;
 i++;
}
 return ms;
}

//zadanie 3
int gcd(int n, int m){
    int ilenp;
    if(n<m){
        int temp;
        temp = n;
        m = n;
        m = temp;
    }
    ilenp = n%2 + m%2;
    if(ilenp == 2){
        n = n - m;
    }
    if(!ilenp){
        n = n/2;
        m = m/2;
    }
    if(n%2 == 0){
        n = n/2;
    }
    int tmp;
    while(n != 0){
        tmp = m % n;
        m = n;
        n = tmp;
    }
    if(!ilenp) return m*2;
    return m;
}
//zadanie 5a
int fTrec(int n, int m){
    if(n == 0){
        return m;
    }
    else if(m == 0){
        return n;
    }
    else{
        return fTrec(n-1,m)+2*fTrec(n,m-1);
    }
}
//zadanie 6
int fibbonaci(int k, int r){
    int F[3] = {1, 1};
    for(int i = 2; i<=k; i++){
        F[2] = F[0]%r + F[1]%r;
        F[0] = F[1];
        F[1] = F[2];
    }
    return F[2]%r;
}
//zadanie 7
int pot(int n, int m){
    int np = n;
    int k =1;
    if(m == 0 || m == 1) return 1;
    if(n == 0 || n == 1) return 0;
    else{
        while(n<m){
            n = n*np;
            k++;
        }
        return k;
    }
}
struct elem{
    int val;
    struct elem *next;
};

void f(struct elem *lis){
    while(lis != NULL){
        if(lis->val > 0) printf("%d ", lis->val);
        lis = lis->next;
    }
}

void d(struct elem *lis, int val){
    struct elem *nowy;
    nowy = (struct elem *) malloc(sizeof(struct elem));
    nowy->val = val;
    nowy->next = NULL;
    while(lis->next != NULL){
        lis = lis->next;
    }
    lis->next = nowy;
}

void u(struct elem *lista){
    while(lista->next->next != NULL){
        lista = lista->next;
    }
    free(lista->next);
    lista->next = NULL;
}

void s(struct elem *lista1, struct elem *lista2){
    while(lista1->next != NULL){
        lista1 = lista1->next;
    }
    lista1->next = lista2;
}

void wypisz(struct elem *lista){
    if(lista->next == NULL){
        printf("%d ", lista->val);
    }
    else{
        wypisz(lista->next);
        printf("%d ", lista->val);
    }
}

struct elem * odwroc(struct elem *lista){
    struct elem *nastepny;
    struct elem *poprzedni;
    poprzedni = NULL;
    nastepny = NULL;
    while(lista != NULL){
        nastepny = lista->next;
        lista->next = poprzedni;
        poprzedni = lista;
        lista = nastepny;
    }
    return poprzedni;
}

int main()
{
    //zadanie 2
    /*int liczba;
    int i = 2;
    int ile;
    int silnie[100] = {1, 1};
    scanf("%d", &liczba);
    while(1){
        silnie[i] = silnie[i-1] * i;
        i++;
        if(silnie[i-1] >= liczba) break;
    }
    while(liczba > 0){
        ile = liczba/silnie[i-1];
        liczba = liczba - (ile*silnie[i-1]);
        printf("%d! * %d\n", i-1, ile);
        i--;
    }*/
    //printf("%d\n", fTiter(3,4));
    //printf("%d\n", fibbonaci(4, 3));
    //printf("%d", gcd(123241, 12343));
    //selection sort
    int array[10] = {10, 9,8, 7, 6, 5, 4, 3, 2, 1};
    /*for (int c = 0; c < 9; c++){
        int position;
        for (int d = c + 1; d < 10; d++){
          if (array[c] > array[d])
            position = d;
        }
        if (position != c){
          int swap = array[c];
          array[c] = array[position];
          array[position] = swap;
          printf("zamieniam!\n");
        }
    }
    for(int i = 0; i<10; i++){
        printf("%d", array[i]);
    }*/
    //bubble sort
    /*int size = 10;
    for (int i = 0; i<size-1; i++){
		for (int j=0; j<size-1-i; j++){
			if (array[j] > array[j+1]){
				int temp = array[j+1];
				array[j+1] = array[j];
				array[j] = temp;
            }
		}
    }
    for(int i = 0; i<10; i++){
        printf("%d", array[i]);
    }
    int w = 0, i, k = 6;
    int tab[7] = {1, 1, 1, 1, 1, 1, 1};
        for( i = 0; i<=k; i++)  w = w*2+tab[i];
        printf("\n%d", w);*/
    //sitoErastotenesa
//    int s[1000000];
//    for(int i = 2; i<1000000; i++){
//        s[i] = 1;
//    }
//    for(int i = 2; i<1000; i++){
//        if(s[i] == 1){
//            for(int j = i; i*j<1000000; j++){
//                int wynik = i*j;
//                s[wynik] = 0;
//            }
//        }
//    }
//    for(int i = 2; i<1000000; i++){
//        if(s[i] == 1){
//            printf("%d ", i);
//        }
//    }
    int a[5] = {1, 2, -3, -3, -7};
    //printf("%d", maxS(5, a));
    struct elem *x;
    x = (struct elem *)(malloc(sizeof(struct elem)));
    x->val = 5;
    x->next = NULL;
    struct elem *lis;
    lis = (struct elem *)(malloc(sizeof(struct elem)));
    lis->val = 2;
    lis->next = x;
    d(lis, 10);
    f(lis);
//    u(&lis);
//    struct elem d = {10, NULL};
//    f(&lis);
//    s(&lis, &d);
//    printf("\n");
//    f(&lis);
//    printf("\n");
    lis = odwroc(lis);
    f(lis);
}


