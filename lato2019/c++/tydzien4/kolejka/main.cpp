#include <iostream>
#include "kolejka.hpp"
using namespace std;

int main()
{
    try{
        initializer_list<string> lista({"aa", "bb", "cc", "dd"});
        Kolejka *k = new Kolejka(4, lista);
        Kolejka *kk;
        kk = move(k);
        cout<< kk->sprawdz() << endl;
        delete k;
    }
    catch(...){
        clog<<"Błąd przy dynamicznym tworzeniu kolejki";
    }
    int pojemnosc = 0;
    Kolejka* k;
    while(pojemnosc<1){
        cout<<"Podaj pojemność kolejki: ";
        cin>>pojemnosc;
    }
    k = new Kolejka(pojemnosc);
    cout << "1. Dodaj element do kolejki;\n2. Sprawdź ile jest elemetów w kolejce;\n3. Sprawdź pierwszy element w kolejce\n4. Wyciągnij element z kolejki\n5. Zakończ program" << endl;
    int opcja;
    string wartosc;
    while(true){
        while(!opcja || opcja>6 || opcja<0){
            cout<<"Wybierz opcje: ";
            cin>>opcja;
        }
        switch(opcja){
            case 1:
                try{
                    cout<<"Podaj co chcesz umieścić w kolejce: ";
                    cin>>wartosc;
                    k->wloz(wartosc);
                }
                catch(invalid_argument){
                    cerr<<"Brak miejsca w kolejce na następny element\n";
                }
                opcja = 0;
                break;
            case 2:
                cout<<"Aktualnie w kolejce jest: "<<k->rozmiar() <<" elementów\n";
                opcja = 0;
                break;
            case 3:
                wartosc = k->sprawdz();
                cout<<"Pierwszy element w kolejce: " << wartosc << endl;
                opcja = 0;
                break;
            case 4:
                try{
                    wartosc = k->wyciagnij();
                    cout<<"Wyciągnięto z kolejki: " << wartosc << endl;
                }
                catch(invalid_argument){
                    cerr<<"Brak elementów w kolejce\n";
                }
                opcja = 0;
                break;
            case 5:
                cout<<"Koniec programu";
                delete k;
                return 0;
        }
    }
    return 0;
}
