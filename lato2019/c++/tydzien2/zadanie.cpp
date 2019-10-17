#include <iostream>
#include <vector>
#include <utility>
#include <string>
using namespace std;

string bin2rzym(int x){
    const vector<pair<int, string>> rzym = {
        {1000, "M"},
        {900, "CM"}, {500, "D"}, {400, "CD"}, {100, "C"},
        {90, "XC"}, {50, "L"}, {40, "XL"}, {10, "X"},
        {9, "IX"}, {5, "V"}, {4, "IV"}, {1, "I"}
    };
    string rzymska = "";
    int i = 0;
    while(x > 0){
        if(rzym[i].first > x){
            i++;
        }
        else{
            x-=rzym[i].first;
            rzymska+=rzym[i].second;
        }
    }
    return rzymska;
}

int main(int argc, const char *argv[]){
    vector<int> liczby_do_konwersji;
    for(int i = 1; i<argc; i++){
        int x;
        try{
            if(argv[i][0] == '\0'){
                clog << "Liczba pusta.\n";
            }
            else{
                bool poprawna = true;
                for(int j = 0; argv[i][j] != '\0'; j++){
                    if(argv[i][j] < '0' || argv[i][j] > '9'){
                        clog << "Liczba " << argv[i] <<" ma nieprawidłowy format.\n";
                        poprawna = false;
                        break;
                    }
                }
                if(poprawna){
                    x = stoi(argv[i]);
                    if(x < 1 || x > 3999) continue;
                    else liczby_do_konwersji.push_back(x);
                }
            }
        }
        catch(logic_error){
            clog << "Error, błędna liczba do konwersji: " << argv[i] << endl;
        }
    }
    for(int i = 0; i<liczby_do_konwersji.size(); i++){
        cout << "Liczba: " << liczby_do_konwersji[i] << endl;
        cout << "Rzymska reprezentacja: " << bin2rzym(liczby_do_konwersji[i]) << endl;
    }
}
