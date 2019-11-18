#ifndef KOLEJKA_HPP_INCLUDED
#define KOLEJKA_HPP_INCLUDED
#include<iostream>
#include<string>
using namespace std;
class Kolejka{
private:
    string *kol;
    int pocz;
    int ile;
    int pojemnosc;
public:
    void wloz(string value);
    string wyciagnij();
    string sprawdz();
    int rozmiar();
    Kolejka& operator=(const Kolejka& obiekt);
    Kolejka& operator=(Kolejka&& obiekt);
    Kolejka();
	Kolejka(int poj);
	Kolejka(int poj, initializer_list<string> lista);
	Kolejka(const Kolejka &obiekt);
	Kolejka(Kolejka &&obiekt);
	~Kolejka();
};
#endif // KOLEJKA_HPP_INCLUDED
