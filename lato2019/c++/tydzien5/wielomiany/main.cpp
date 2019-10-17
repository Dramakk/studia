#include <iostream>
#include <string>
#include "wielomiany.hpp"
using namespace std;

int main()
{
    try{
        double tab1[] = {1, 3, 0};
        wielomian w1(2, tab1);
    }
    catch(...){
        cout<<"Błąd przy tworzeniu wielomianu!\n";
    }
    try{
        initializer_list<double> lista{15, 5, 1, 4, 0};
        wielomian w2(lista);
	}
	catch(...){
        cout<<"Błąd przy tworzeniu wielomianu! (lista)\n";
    }
    try{
        wielomian w2 = wielomian(0,0.0);
        cout<< w2 << endl;
	}
	catch(...){
        cout<<"Błąd przy tworzeniu wielomianu!\n";
    }
    cout << "Operacje arytmetyczne:\n";
    cout << "Testy z tablicy:\n";
    double uTab[] = {1.0, 1.0, 1.0};
    double vTab[] = {0.0, 0.0, 0.0, 1.0};
    wielomian u = wielomian(2, uTab);
    wielomian v = wielomian(3, vTab);
    cout<<u+v << endl;
    cout<<u*v<< endl;
    cout<<"--------------" << endl;
	double tab1[] = {1, 3, 4.5};
	wielomian w1(2, tab1);
	initializer_list<double> lista{15, 5, 1, 4, 3};
	wielomian w2(lista);
	cout << "w1+w2: " << w1 + w2 << endl;
	cout << "w1-w2: " << w1 - w2 << endl;
	double tab2[] = {1, 2, 3.2};
	double tab3[] = {1, 2.3};
	wielomian w3(2, tab2);
	wielomian w4(1, tab3);
	cout << "w3*w4: " << w3*w4 << endl;
	cout << "w3*2.5: " << w3*2.5 << endl;
	w3 += w4;
	cout << "w3+=w4: " << w3 << endl;
	w3 *= w4;
	cout << "w3*=w4: " << w3 << endl;
	w3 *= 2.5;
	cout << "w3*=2.5: " << w3 << endl;
	cout << "wartosc w3 w punkcie 1: " << w3(1) << endl;
	cout << "wspolczynnik w3 przy x^2: " << w3[2] << endl;
	pair<int, double> i = {2, -14};
	//cout << "zamieniam wspolczynnik w3 przy x^2 na -14: " << w3[i] << endl;
	cout << "faktycznie? " << w3[2] << endl;
    return 0;
}
