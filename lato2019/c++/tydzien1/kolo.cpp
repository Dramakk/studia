#include <iostream>
#include <iomanip>
#include <math.h>
using namespace std;

void promienKola(double pole){
    if(pole < 0){
        cerr << "Nie istnieje figura o polu ujemnym";
        return;
    }
    else{
        cout << setprecision(3) << sqrt((pole/M_PI));
    }
    return;
}

int main()
{
    string poleS;
    double pole;
    clog << "Podaj pole figury: ";
    cin >> poleS;
    try{
        pole = stod(poleS);
    }
    catch(logic_error){
        cerr << "Błędne argumenty. (logic_error)";
        return -1;
    }
    promienKola(pole);
    return 0;
}
