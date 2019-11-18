#include <iostream>
#include "funkcje.hpp"
#include <climits>
using namespace std;
using namespace obliczenia;
int main()
{
    wymierna a = wymierna(18333, 99900);
    wymierna b = wymierna(123456, 999999);
    wymierna c = wymierna(5, 11);
    wymierna d = wymierna(311, 900);
    wymierna e = wymierna(1, 3);
    wymierna f = wymierna(1, 6);
    wymierna x = wymierna((INT_MAX/2), 2);
    wymierna z = wymierna(2*(INT_MAX/3), 2);
    e = e/f;
    cout << a << endl << b << endl << c << endl << d << endl << e << endl << f << endl;
    return 0;
}
