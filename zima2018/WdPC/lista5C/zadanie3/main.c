#include <stdio.h>
#include <stdlib.h>

struct pkt {
    int x;
    int y;
};

int minimum(int a, int b){
    if(a > b){
        return b;
    }
    else if( a == b){
        return a;
    }
    else return a;
}

int maximum(int a, int b){
    if(a > b){
        return a;
    }
    else if( a == b){
        return a;
    }
    else return b;
}

long wektorowy(struct pkt X, struct pkt Y, struct pkt Z)
{
	long x1 = Z.x - X.x;
	long y1 = Z.y - X.y;
    long x2 = Y.x - X.x;
    long y2 = Y.y - X.y;
	return x1*y2 - x2*y1;
}

int sprawdz(struct pkt X, struct pkt Y, struct pkt Z)
{
	return minimum(X.x, Y.x) <= Z.x && Z.x <= maximum(X.x, Y.x)
		&& minimum(X.y, Y.y) <= Z.y && Z.y <= maximum(X.y, Y.y);
}

int przecinaja(struct pkt A, struct pkt B, struct pkt C, struct pkt D)
{
    long    w1 = wektorowy(C, D, A);
	long	w2 = wektorowy(C, D, B);
	long	w3 = wektorowy(A, B, C);
	long	w4 = wektorowy(A, B, D);

	if(((w1>0 && w2<0) || (w1<0 && w2>0)) && ((w3>0 && w4<0) || (w3<0 && w4>0))){
            return 1;
	}

	if(w1 == 0 && sprawdz(C, D, A)) return 1;
	if(w2 == 0 && sprawdz(C, D, B)) return 1;
	if(w3 == 0 && sprawdz(A, B, C)) return 1;
	if(w4 == 0 && sprawdz(A, B, D)) return 1;

	return 0;
}

int main(){
    struct pkt odcinki[1000][4] = {0};
    int czyPrzecina[1000];
    for(int i = 0; i<1000; i++){
        czyPrzecina[i] = 1;
    }
    int n;
    scanf("%d", &n);
    for(int i = 0; i<n; i++){
        scanf(" %d%d%d%d%d%d%d%d", &odcinki[i][0].x, &odcinki[i][0].y, &odcinki[i][1].x, &odcinki[i][1].y, &odcinki[i][2].x, &odcinki[i][2].y, &odcinki[i][3].x, &odcinki[i][3].y);
    }
    for(int i = 0; i<n; i++){
        printf("%d %d %d %d %d %d %d %d\n", odcinki[i][0].x, odcinki[i][0].y, odcinki[i][1].x, odcinki[i][1].y, odcinki[i][2].x, odcinki[i][2].y, odcinki[i][3].x, odcinki[i][3].y);
    }
    for(int i = 0; i<n; i++){
        for(int j = 0; j<n; j++){
            if(i == j) continue;
            if(przecinaja(odcinki[i][0], odcinki[i][1], odcinki[j][0], odcinki[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][0], odcinki[i][1], odcinki[j][1], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][0], odcinki[i][1], odcinki[j][0], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][1], odcinki[i][2], odcinki[j][0], odcinki[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][1], odcinki[i][2], odcinki[j][1], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][1], odcinki[i][2], odcinki[j][0], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][0], odcinki[i][2], odcinki[j][0], odcinki[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][0], odcinki[i][2], odcinki[j][1], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            if(przecinaja(odcinki[i][0], odcinki[i][2], odcinki[j][0], odcinki[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
        }

    }
    for(int i = 0; i < n; i++){
        printf("%d ", czyPrzecina[i]);
    }
    return 0;
}
