#include <iostream>
#include <string>
#include <math.h>
#include <iomanip>
using namespace std;

void poleTrojkata(double x, double y, double z){
    if((x <= 0 || y <= 0 || z <= 0) || ((x+y) <= z || (x+z) <= y ||
(z+y) <= x)){
            cerr << "Nieprawidłowe boki trójkąta.";
            return;
    }
    else{
        double obw = (x+y+z)/2;
        double pole = sqrt(obw*(obw-x)*(obw-y)*(obw-z));
        cout << setprecision(3) <<  pole << endl;
        return;
    }
    return;
}

int main()
{
    string x, y, z;
    double a, b, c;
    clog << "Podaj trzy boki trójkąta: \n";
    cin >> x;
    cin >> y;
    cin >> z;
    try{
        a = stod(x);
        b = stod(y);
        c = stod(z);
    }
    catch(logic_error){
        cerr << "Błędne argumenty (logic_error)";
        return -1;
    }
    poleTrojkata(a, b, c);
    return 0;
}
