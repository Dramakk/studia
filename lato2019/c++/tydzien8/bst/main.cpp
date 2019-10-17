#include <iostream>
#include "bst.hpp"
#include <deque>
//adress sainitazer
//valgrind
using namespace std;
using namespace struktury;
int main()
{
    BST<int> t(5);
	t.dodaj(5);
	t.dodaj(4);
	t.dodaj(10);
	t.usun(5);
	cout << t << endl;
	int *x1, *x2, *x3, *x4;
	int y1 = 10;
	int y2 = -2;
	int y3 = 4;
	int y4 = 1;
	x1 = &y1;
	x2 = &y2;
	x3 = &y3;
	x4 = &y4;

	BST<int*> drzewo;
	drzewo.dodaj(x3);
	drzewo.dodaj(x4);
	drzewo.dodaj(x1);
	drzewo.dodaj(x2);
	cout << drzewo << endl;

	string akcja;
	BST<double> *tree = new BST<double>();
	cout << "Utworzone zostało drzewo BST wartości double.\n1. dodaj x - dodaj wartość do drzewa\n2. usun x - usuń wartość z drzewa\n3. znajdz x - znajdź";
	cout << " wartość w drzewie\n4. wyswietl - wyświetl zawartość drzewa w kolejności in-order\n5. koniec - zakończ program\n";
    while(true){
        cin >> akcja;
        if(akcja == "dodaj"){
            double x;
            cin >> x;
            tree->dodaj(x);
            cout << "Dodano wartość do drzewa\n";
        }
        if(akcja == "usun"){
            double x;
            cin >> x;
            bool a = tree->usun(x);
            if(a)
                cout << "Usunięto wartość z drzewa\n";
            else cout << "Brak takiej wartości w drzewie\n";
        }
        if(akcja == "znajdz"){
            double x;
            cin >> x;
            bool a = tree->znajdz(x);
            if(a) cout << "Wartość znajduje się w drzewie\n";
            else cout << "Brak tej wartości w drzewie\n";
        }
        if(akcja == "wyswietl"){
            cout << *tree << endl;
        }
        if(akcja == "koniec"){
            delete tree;
            return 0;
        }
    }
}
