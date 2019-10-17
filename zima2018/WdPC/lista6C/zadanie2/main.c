#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int m, n;
char * plansza[10];

int ileZnakow = 0;
char * znaki[5];
char * wybraneZnaki[50];

int mink;

bool czyCala(char * plansza[10])
{
	char podstawowyKolor = plansza[0][0];

	for (int y=0; y<n; y++) {
		for (int x=0; x<m; x++) {
			if (plansza[y][x] != podstawowyKolor) return false;
		}
	}
	return true;
}

void wybierzZnak(int ruch)
{
	if (ruch+1 < mink) {
        char *temp[10];
		for (int y=0; y<n; y++) {
			temp[y] = (char *)malloc(m*sizeof(char));
		}

		for (int i=0; i<ileZnakow; i++) {
			wybraneZnaki[ruch] = znaki[i];

			for (int i=0; i<n; i++) {
				for (int j=0; j<m; j++) {
					for (int y=0; y<n; y++) {
						for (int x=0; x<m; x++) {
							temp[y][x] = plansza[y][x];
						}
					}
					for (int jakiKolor=0; jakiKolor<=ruch; jakiKolor++) {
						flood(temp, j, i, wybraneZnaki[jakiKolor]);
					}

					if (czyCala(temp)) {
						if (ruch+1 < mink) {
							mink = ruch+1;
						}
					} else {
						wybierzZnak(ruch+1);
					}
				}
			}
		}
	}
}

void flood(char * plansza[10], int x, int y, char nowy)
{
	char zmieniany = plansza[y][x];
	if (zmieniany != nowy) {
		plansza[y][x] = nowy;

		if (y-1 >= 0 && plansza[y-1][x] == zmieniany)
			flood(plansza, x, y-1, nowy);
		if (y+1 < n && plansza[y+1][x] == zmieniany)
			flood(plansza, x, y+1, nowy);
		if (x-1 >= 0 && plansza[y][x-1] == zmieniany)
			flood(plansza, x-1, y, nowy);
		if (x+1 < m && plansza[y][x+1] == zmieniany)
			flood(plansza, x+1, y, nowy);
	}
}

int main()
{
	scanf(" %d %d", &m, &n);
	mink = n*m;

	for (int i=0; i<n; i++) {
		plansza[i] = (char *)malloc(m*sizeof(char));
	}

	bool jakieZnaki[256] = {false};

	for (int y=0; y<n; y++) {
		for (int x=0; x<m; x++) {
			scanf(" %c", &plansza[y][x]);
			jakieZnaki[ plansza[y][x] ] = true;
		}
	}

	for (int i=0; i<256; i++) {
		if (jakieZnaki[i]) ileZnakow++;
	}

	int iterator = 0;
	for (int i=0; i<256; i++) {
		if (jakieZnaki[i]) znaki[iterator++] = i;
	}

	if(czyCala(plansza)) {
		printf("Nie trzeba nic robić\n");
	} else {
		wybierzZnak(0);
		printf("Wymaga %d ruchów.\n", mink);
	}

	return 0;
}
