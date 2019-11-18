#include <iostream>
#include "wyrazenia.hpp"


int main()
{
    wyrazenie *w1 = new podziel(new pomnoz(new odejmij(new zmienna("x"), new liczba(1.0)), new zmienna("x")), new liczba(2));
	wyrazenie *w2 = new podziel(new dodaj(new liczba(3), new liczba(5)), new dodaj(new pomnoz(new liczba(2), new zmienna("x")), new liczba(7)));
	wyrazenie *w3 = new odejmij(new dodaj(new liczba(2), new pomnoz(new zmienna("x"), new liczba(7))), new dodaj(new pomnoz(new zmienna("y"), new liczba(3)), new liczba(5)));
	wyrazenie *w4 = new podziel(new cos(new pomnoz(new dodaj(new zmienna("x"), new liczba(1)), new zmienna("x"))), new poteguj(new e(), new poteguj(new zmienna("x"), new liczba(2))));
	std::cout << w1->opis() << std::endl << w2->opis() << std::endl << w3->opis() << std::endl << w4->opis() << std::endl;
    for (double i = 0; i < 1.01; i += 0.01){
        zmienna::set("x", i);
		zmienna::set("y", 1 + i);
		std::cout << "i = " << i << std::endl;
		std::cout << "w1 = " << w1->oblicz() << std::endl;
		std::cout << "w2 = " << w2->oblicz() << std::endl;
		std::cout << "w3 = " << w3->oblicz() << std::endl;
		std::cout << "w4 = " << w4->oblicz() << std::endl;
	}
    return 0;
}
