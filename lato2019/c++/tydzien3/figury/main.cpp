#include <iostream>
#include "figury.h"
using namespace std;

int main()
{
    //punkt
    //konstrukotry
    try{
        punkt a = punkt(-4, 4);
        punkt b = punkt(12, 2);
        punkt c = punkt(a);
        punkt d = b;
        cout << a << "| " << b << "| " << c << "| " << d << endl;
        cout << "--------------------------------" << endl;
    }
    catch(...){
        clog<<"Wystąpił błąd przy tworzeniu punktów\n";
    }
    //przesuń, obróć, odległość
    try{
        punkt a = punkt();
        punkt b = punkt(1, 3);
        punkt c = punkt(0, 3);
        cout << "Odległość między (0, 0) a (0, 3): " << odleglosc(a, c) << endl;
        b.przesun(1, 3);
        cout << "Przesunięcie o (1, 3) " << b << endl;
        b.obroc(0, 0, -180);
        cout << "Po obrocie o -180 stopni względem (0, 0) " << b << endl;
        cout << "--------------------------------" << endl;
    }
    catch(...){
        clog<<"Wystąpił błąd przy testowaniu funkcji przesuń i obróć\n";
    }
    //odcinek
    //konstruktory
    try{
        punkt a = punkt();
        punkt b = punkt(1, 3);
        punkt c = punkt(2, 3);
        punkt d = b;
        odcinek A = odcinek(a, b);
        odcinek B = odcinek(A);
        odcinek C = A;
        odcinek D = odcinek(d, c);
        cout << A << B << C << D;
        cout << "--------------------------------" << endl;
    }
    catch(...){
        clog<<"Wystąpił błąd przy tworzeniu odcinków\n";
    }
    //przsun, obróc, dlugosc, naOdcinku, przecinaja, rowolegle, prostopadle, srodek
    try{
        punkt a = punkt(-4, 4);
        punkt b = punkt(-12, 2);
        punkt e = punkt(1, 2);
        punkt f = punkt(7, 8);
        punkt g = punkt(2, 9);
        punkt h = punkt(4, 6);
        punkt i = punkt(5, 4.5);
        odcinek A = odcinek(a, b);
        odcinek B = odcinek(a, b);
        odcinek C = odcinek(e, f);
        odcinek D = odcinek(g, h);
        odcinek E = odcinek(g, i);
        cout << "Przed obrotem i przesunięciem:\n" << "A: " << A << "B: " << B << "C: " << C << "D: " << D << "E: " << E;
        A.obroc(0, 0, 0.349);
        //cout << "Po przesunięciu o (2, 3): " << endl << A;
        cout << "Po obrocie o 20 stopni względem (0, 0) " << endl << A;
        B.obroc(1, 1, 0.349);
        cout << "Po obrocie o 20 stopni względem (1, 1) " << endl << B;
        //cout << "Czy punkt (2, 3) leży na odcinku A: " << A.naOdcinku(c) << endl;
        cout << "Punkt przecięcia C z D: " << C.przecinaja(D) << endl;
        cout << "--------------------------------" << endl;
    }
    catch(...){
        clog<<"Wystąpił błąd przy testowaniu funkcjonalności związanych z odcinkami\n";
    }
    try{
        punkt e = punkt(1, 2);
        punkt f = punkt(7, 8);
        punkt g = punkt(2, 9);
        punkt i = punkt(5, 4.5);
        punkt h = punkt(4, 6);
        odcinek D = odcinek(e, f);
        odcinek E = odcinek(g, i);
        cout << "\nPunkt przecięcia E z D: " << D.przecinaja(E) << endl;
    }
    catch(...){
        clog << "Błąd";
    }
    //trójkąt
    try{
        punkt a = punkt(0, 0);
        punkt b = punkt(20, 0);
        punkt c = punkt(10, 30);
        punkt d = punkt(10, 15);
        punkt e = punkt(30, 15);
        trojkat A = trojkat(a, b, c);;
        cout << "Czy punkt (10, 15) jest zawarty w A: " << A.czyZawarty(d) << endl;
        cout << "Czy punkt (30, 15) jest zawarty w A: " << A.czyZawarty(e) << endl;
        cout << "--------------------------------";
    }
    catch(...){
        clog<<"Wystąpił błąd przy testowaniu funkcjonalności związanych z odcinkami\n";
    }
    return 0;
}
