#include "kolejka.hpp"
#include <iostream>
#include <string>
using namespace std;
Kolejka::Kolejka() : Kolejka(1) {};
Kolejka::Kolejka(int poj) : pojemnosc(poj), pocz(0), ile(0){
    kol = new string[poj];
}
Kolejka::Kolejka(int poj, initializer_list<string> lista) : Kolejka(poj){
	for(auto i = lista.begin(); i != lista.end(); ile++, i++)
	{
		if (ile >= pojemnosc)
			throw invalid_argument("Rozmiar kolejki przekroczony juz przy inicjalizacji!\n");

		kol[ile] = *i;
	}
}
Kolejka::Kolejka(const Kolejka &obiekt){
    pojemnosc = obiekt.pojemnosc;
	ile = obiekt.ile;
	pocz = obiekt.pocz;
	kol = new string[pojemnosc];
	for (int i = 0; i < pojemnosc; i++)
		kol[i] = obiekt.kol[i];
}
Kolejka::Kolejka(Kolejka &&obiekt){
    pojemnosc = obiekt.pojemnosc;
    ile = obiekt.ile;
    pocz = obiekt.pocz;
    kol = obiekt.kol;
    obiekt.kol = nullptr;
}
Kolejka::~Kolejka()
{
	delete[] kol;
}
Kolejka& Kolejka::operator=(const Kolejka &obiekt){
	pojemnosc = obiekt.pojemnosc;
	ile = obiekt.ile;
	pocz = obiekt.pocz;
	kol = new string[pojemnosc];
	for (int i = 0; i < pojemnosc; i++)
		kol[i] = obiekt.kol[i];
	return *this;
}
Kolejka& Kolejka::operator=(Kolejka &&obiekt){
	pojemnosc = obiekt.pojemnosc;
	ile = obiekt.ile;
	pocz = obiekt.pocz;
	kol = obiekt.kol;
	obiekt.kol = nullptr;
	return *this;
}
string Kolejka::sprawdz(){
	return kol[pocz];
}
string Kolejka::wyciagnij(){
    if(ile == 0){
        throw invalid_argument("Brak elementów w kolejce");
    }
    string slowo = sprawdz();
    pocz = (pocz+1) % pojemnosc;
    ile--;
    return slowo;
}
void Kolejka::wloz(string value){
    if(ile == pojemnosc){
        throw invalid_argument("Brak miejsca na kolejny element");
    }
    kol[(pocz+ile) % pojemnosc] = value;
    ile++;
}
int Kolejka::rozmiar(){
    return ile;
}
