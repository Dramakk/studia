#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define RADIUS 10

struct pkt{
    double x;
    double y;
    double a;
};

void drawCircle(double a, struct pkt G, struct pkt M){
    double w;
    for(int y = -2*RADIUS; y<(2*RADIUS); y++){
        for(int x = -2*RADIUS; x<2*RADIUS; x++){
            if((int)G.x == 0 && G.y >= 0){
                if(x == 0 && (y<= 0 && y<RADIUS)){
                    printf("G");
                    continue;
                }
            }
            if((int)G.x == 0 && G.y < 0){
                if(x == 0 && (y<= 0 && y>-RADIUS)){
                    printf("G");
                    continue;
                }
            }
             if((int)M.x == 0 && M.y >= 0){
                if(x == 0 && (y>= 0 && y<RADIUS)){
                    printf("M");
                    continue;
                }
            }
            if((int)M.x == 0 && M.y < 0){
                if(x == 0 && (y<= 0 && y>-RADIUS)){
                    printf("M");
                    continue;
                }
            }
            if((x >= 0 && x < G.x) && (y >= 0 && y < G.y)){
                w = G.a*x;
                if(round(y) == round(w)){
                    printf("G");
                    continue;
                }
            }
             if((x >= 0 && x < G.x) && (y > G.y && y <= 0)){
                w = G.a*x;
                if(round(y) == round(w)){
                    printf("G");
                    continue;
                }
            }
             if((x > G.x && x < 0) && (y >= 0 && y < G.y)){
                w = G.a*x;
                if(round(y) == round(w)){
                    printf("G");
                    continue;
                }
            }
             if((x > G.x && x < 0) && (y > G.y && y <= 0)){
                w = G.a*x;
                if(round(y) == round(w)){
                    printf("G");
                    continue;
                }
            }
             if((x >= 0 && x < M.x) && (y >= 0 && y < M.y)){
                w = M.a*x;
                if(round(y) == round(w)){
                    printf("M");
                    continue;
                }
            }
             if((x >= 0 && x < M.x) && (y > M.y && y <= 0)){
                w = M.a*x;
                if(round(y) == round(w)){
                    printf("M");
                    continue;
                }
            }
             if((x > M.x && x < 0) && (y >= 0 && y < M.y)){
                w = M.a*x;
                if(round(y) == round(w)){
                    printf("M");
                    continue;
                }
            }
             if((x > M.x && x < 0) && (y > M.y && y <= 0)){
                w = M.a*x;
                if(round(y) == round(w)){
                    printf("M");
                    continue;
                }
            }
            if((y*y + x*x) < RADIUS*RADIUS){
                printf(".");
            }
            else{
                printf(" ");
            }
        }
        printf("\n");
    }
}
struct pkt setValues(struct pkt A, double Rad){
    double y = RADIUS*cos(Rad);
    double x = RADIUS*sin(Rad);
    double a = y/x;
    A.x = x;
    A.y = y;
    A.a = a;
    return A;
}

int main(){
    int circle[2*RADIUS][2*RADIUS] = {0};
    const double HOUR = (2*M_PI)/12;
    const double MINUTES = (2*M_PI)/60;
    double g, m;
    scanf("%lf:%lf", &g, &m);
    double gRad = -HOUR*g + M_PI;
    double mRad = -MINUTES*m - M_PI;
    struct pkt G, M;
    G = setValues(G, gRad);
    M = setValues(M, mRad);
    double a = G.y/G.x;
    drawCircle(a, G, M);
}
