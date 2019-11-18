#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>


#define FOR(a,b,c) for(int a = b; a <= c;a++)
#define N 1001
typedef double ld;
typedef long long ll;

#define swap(a,b)\
	({__typeof__ (a) _a = (a);\
		a = b;\
		b = _a;})

#define max(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a > _b ? _a : _b; })

#define min(a,b) \
   ({ __typeof__ (a) _a = (a); \
       __typeof__ (b) _b = (b); \
     _a < _b ? _a : _b; })

typedef struct
{
	ll x, y;
}point;

point minus(point a, point b)
{
	point res;
	res.x = a.x - b.x;
	res.y = a.y - b.y;
	return res;
}

ll cross1(point a, point b)
{
	return a.x * b.y - a.y * b.x;
}

ll cross2(point c, point a, point b)
{
	return cross1(minus(a, c), minus(b, c));
}

int sign(ll x)
{
	return x >= 0 ? x ? 1 : 0 : -1;
}

int inter1(ll a, ll b, ll c, ll d)
{
	if (a > b)swap(a, b);
	if (c > d)swap(c, d);

	return max(a, c) <= min(b, d) ? 1 : 0;
}

int check(point a, point b, point c, point d)
{
	if (cross2(c, a, d) == 0 && cross2(c, b, d) == 0)
	{
		return (inter1(a.x, b.x, c.x, d.x) == 1 && inter1(a.y, b.y, c.y, d.y) == 1) ? 1 : 0;
	}

	return (sign(cross2(a, b, c)) != sign(cross2(a, b, d)) &&
		sign(cross2(c, d, a)) != sign(cross2(c, d, b))) ? 1 : 0;
}

int n;

int grupa[N];
int roz[N];

typedef struct
{
	point a, b;
}segment;

segment segments[N];


int main(){
    int czyPrzecina[1000];
    for(int i = 0; i<1000; i++){
        czyPrzecina[i] = 0;
    }
    int n;
    scanf("%d", &n);
    for(int i = 0; i<n; i++){
        scanf(" %d%d%d%d%d%d%d%d", &segments[i][0].x, &segments[i][0].y, &segments[i][1].x, &segments[i][1].y, &segments[i][2].x, &segments[i][2].y, &segments[i][3].x, &segments[i][3].y);
    }
    for(int i = 0; i<n; i++){
        printf("%d %d %d %d %d %d %d %d\n", segments[i][0].x, segments[i][0].y, segments[i][1].x, segments[i][1].y, segments[i][2].x, segments[i][2].y, segments[i][3].x, segments[i][3].y);
    }
    struct pkt V1, V2;
    for(int i = 0; i<n; i++){
        for(int j = 0; j<n; j++){
            if(i == j) continue;
            for(int b = 0; b<3; b++){
                V1.x = (segments[i][3].x - segments[j][3].x);
                V1.y = (segments[i][3].y - segments[j][3].y);
                V2.x = (segments[j][3].x - segments[i][3].x);
                V2.y = (segments[j][3].y - segments[i][3].y);
                V1.x = V1.x + segments[i][b].x;
                V1.y = V1.y + segments[i][b].y;
                V2.x = V2.x + segments[j][b].x;
                V2.y = V2.y + segments[j][b].y;
                if(przecinaja(segments[i][b], V1, segments[j][0], segments[j][1])){
                    czyPrzecina[i] = 3;
                    continue;
                }
                if(przecinaja(segments[i][b], V1, segments[j][1], segments[j][2])){
                    czyPrzecina[i] = 3;
                    continue;
                }
                if(przecinaja(segments[i][b], V1, segments[j][0], segments[j][2])){
                    czyPrzecina[i] = 3;
                    continue;
                }
                if(przecinaja(segments[j][b], V2, segments[i][0], segments[i][1])){
                    czyPrzecina[j] = 3;
                    continue;
                }
                if(przecinaja(segments[j][b], V2, segments[i][1], segments[i][2])){
                    czyPrzecina[j] = 3;
                    continue;
                }
                if(przecinaja(segments[j][b], V2, segments[i][0], segments[i][2])){
                    czyPrzecina[j] = 3;
                    continue;
                }
            }

        }
    }
    for(int i = 0; i<n; i++){
        for(int j = 0; j<n; j++){
            if(i == j) continue;
            if(przecinaja(segments[i][0], segments[i][1], segments[j][0], segments[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][0], segments[i][1], segments[j][1], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][0], segments[i][1], segments[j][0], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][1], segments[i][2], segments[j][0], segments[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][1], segments[i][2], segments[j][1], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][1], segments[i][2], segments[j][0], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][0], segments[i][2], segments[j][0], segments[j][1])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][0], segments[i][2], segments[j][1], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            else if(przecinaja(segments[i][0], segments[i][2], segments[j][0], segments[j][2])){
                czyPrzecina[i] = 0;
                czyPrzecina[j] = 0;
                continue;
            }
            //else if((czyZawiera(segments[i][0], segments[i][1], segments[i][2], segments[j][0])) && (czyZawiera(segments[i][0], segments[i][1], segments[i][2], segments[j][1])) && (czyZawiera(segments[i][0], segments[i][1], segments[i][2], segments[j][2]))){
              //  czyPrzecina[i] = 0;
               // continue;
            //}
        }
    }
    for(int i = 0; i < n; i++){
        printf("%d ", czyPrzecina[i]);
    }
    return 0;
}
