#include <iostream>
#include <cmath>
#include "funkcje.hpp"
#include <climits>
#include <vector>
using namespace std;
using namespace obliczenia;
obliczenia::wyjatek_wymierny::wyjatek_wymierny(string m){
    msg = m;
}
obliczenia::wyjatek_wymierny::wyjatek_wymierny(const wyjatek_wymierny &obiekt){
	msg = obiekt.msg;
}
const char* obliczenia::wyjatek_wymierny::what() const throw(){
    return msg.c_str();
}
obliczenia::wyjatek_wymierny& obliczenia::wyjatek_wymierny::operator=(const wyjatek_wymierny &obiekt){
	msg = obiekt.msg;
	return *this;
}

int obliczenia::wymierna::nwd(int a, int b){
	int c;
	while(b != 0){
		c = a % b;
		a = b;
		b = c;
    	}
    	return a;
}

int obliczenia::wymierna::nww(int a, int b){
	long long int mult = (static_cast<long long int>(a)) * (static_cast<long long int>(b));
	mult /= nwd(a, b);
	if (mult > INT_MAX)
		throw przekroczenie_zakresu("Zbyt duża liczba\n");
	else{
		return (int)mult;
    }
}

bool obliczenia::czyOkresowy(int a){
	if (a == 1)
		return false;
	if ((a % 2 == 0) || (a % 5 == 0)){
		while ((a % 2 == 0) || (a % 5 == 0)){
			if (a % 2 == 0)
				a /= 2;
			else
				a /= 5;
		}
		if (a == 1)
			return false;
		else
			return true;
	}

	return true;
}

obliczenia::wymierna::wymierna(int l, int m){
	if(m == 0)
		throw dzielenie_przez_0("Zero w mianowniku!");
	else if(m < 0){
		l = l*(-1);
		m = m*(-1);
    }
	if(l != 0){
		int dzielnik;
		dzielnik = nwd(abs(l), m);
		l = l/dzielnik;
		m = m/dzielnik;
	}
	licznik = l;
	mianownik = m;
}

obliczenia::wymierna::wymierna(const wymierna &pattern){
	licznik = pattern.licznik;
	mianownik = pattern.mianownik;
}


obliczenia::wymierna& obliczenia::wymierna::operator=(const wymierna &pattern){
	licznik = pattern.licznik;
	mianownik = pattern.mianownik;
	return *this;
}

int obliczenia::wymierna::getNumerator() const{
    return licznik;
}


int obliczenia::wymierna::getDenominator() const{
	return mianownik;
}

obliczenia::wymierna::operator int(){
	return licznik / mianownik;
}


obliczenia::wymierna::operator double(){
	return static_cast<double>(licznik) / static_cast<double>(mianownik);
}

obliczenia::wymierna obliczenia::wymierna::operator-(){
    return wymierna((-1)*licznik, mianownik);
}

obliczenia::wymierna obliczenia::wymierna::operator!(){
	if (licznik == 0)
		throw dzielenie_przez_0("operator!(): Zero w mianowniku\n");
	wymierna w(mianownik, licznik);
	return w;
}

obliczenia::wymierna obliczenia::wymierna::operator+(wymierna second){
	int mult;
	try{
		mult = nww(mianownik, second.mianownik);
	}
	catch (przekroczenie_zakresu mess){
		throw przekroczenie_zakresu("Przekroczenie zakresu przy dodawaniu!");
	}
	int multfirst = mult / mianownik;
	int multsecond = mult / second.mianownik;
	if ((((static_cast<long long int>(licznik) * multfirst) + (static_cast<long long int>(second.licznik) * multsecond)) > INT_MAX) ||
	(((static_cast<long long int>(licznik) * multfirst) + (static_cast<long long int>(second.licznik) * multsecond)) < INT_MIN))
		throw przekroczenie_zakresu("operator+(wymierna&): Zbyt duża liczba!\n");
	int newnum = (licznik * multfirst) + (second.licznik * multsecond);
	return wymierna(newnum, mult);
}

obliczenia::wymierna obliczenia::wymierna::operator-(wymierna second){
	int mult;
	try{
		mult = nww(mianownik, second.mianownik);
	}
	catch (przekroczenie_zakresu mess){
		string messstr = "operator+(wymierna&): " + (string)mess.what();
		throw przekroczenie_zakresu(messstr);
	}

	int multfirst = mult / mianownik;
	int multsecond = mult / second.mianownik;

	if ((((static_cast<long long int>(licznik) * multfirst) - (static_cast<long long int>(second.licznik) * multsecond)) > INT_MAX) ||
	(((static_cast<long long int>(licznik) * multfirst) - (static_cast<long long int>(second.licznik) * multsecond)) < INT_MIN))
		throw przekroczenie_zakresu("operator-(wymierna&): Zbyt duża liczba!\n");
	int newnum = (licznik * multfirst) - (second.licznik * multsecond);
	return wymierna(newnum, mult);
}


obliczenia::wymierna obliczenia::wymierna::operator*(wymierna second){
	if (((static_cast<long long int>(licznik) * static_cast<long long int>(second.licznik)) > INT_MAX) ||
	(static_cast<long long int>(licznik) * static_cast<long long int>(second.licznik) < INT_MIN) ||
	(static_cast<long long int>(mianownik) * static_cast<long long int>(second.mianownik) > INT_MAX))
		throw przekroczenie_zakresu("operator*(wymierna&): Zbyt duża liczba!\n");

	return wymierna((licznik * second.licznik), (mianownik * second.mianownik));
}


obliczenia::wymierna obliczenia::wymierna::operator/(wymierna second){
	if (((static_cast<long long int>(licznik) * static_cast<long long int>(second.mianownik)) > INT_MAX) ||     //zakresy...
	(static_cast<long long int>(licznik) * static_cast<long long int>(second.mianownik) < INT_MIN) ||
	(static_cast<long long int>(mianownik) * static_cast<long long int>(second.licznik) > INT_MAX) ||
	(static_cast<long long int>(mianownik) * static_cast<long long int>(second.licznik) < INT_MIN))
		throw przekroczenie_zakresu("operator/(wymierna&): Zbyt duża liczba!\n");
	else if ((mianownik * second.licznik) == 0)
		throw dzielenie_przez_0("operator/(wymierna&): Zero w mianowniku!\n");

	int newnum = licznik * second.mianownik;
	int newden = mianownik * second.licznik;
	return wymierna(newnum, newden);
}

ostream& obliczenia::operator<<(ostream &output, const obliczenia::wymierna &w){
	if (!obliczenia::czyOkresowy(w.mianownik)){
		string wynik = to_string((w.licznik) / (w.mianownik*1.0));
		wynik.erase(wynik.find_last_not_of('0') + 1, string::npos);
		wynik.erase(wynik.find_last_not_of('.') + 1, string::npos);
		return output << wynik;
	}
	else
		return output << obliczenia::makeCycle(w.licznik, w.mianownik);
}

//algorytm stąd http://codepad.org/hKboFPd2
string obliczenia::makeCycle(int a, int b){
	vector<int> mods;
	vector<char> nums;
	string wynik;
	if(a < 0){
        wynik+='-';
	}
	int calk = a / b;
	mods.push_back(a = abs(a) % b);
    wynik += to_string(calk)+'.';
	while (true){
		if (a < b)
			a *= 10;
		nums.push_back(a / b + '0');

		for (unsigned int i = 0; i < mods.size(); i++){ //pierwszy wyraz
			for (unsigned int j = 1; j <= mods.size() / 2; j++){ //ile ich jest
				if (i + j + j - 1 < mods.size()){         //sprawdzam, czy nie wyskocze poza tablice sprawdzajac okres. warunek sprawdza, czy ostatnia cyfra drugiej czesci nie jest poza tablica
					int k = mods.size() - 2 * j; //idea k to pominiêcie operacji zrobionych poprzednio
					for (int p = k; ; p++){
						if (mods[p] != mods[p + j])
							break;
						if (p == k + j - 1){
							for (unsigned int h = 0; h < nums.size() - j; h++){
								if (h == k)   //bo "najnowsze" modulo wygeneruje jakby kolejna liczbe po przecinku, nie generuje tej "wpisywanej" w danym kroku
									wynik += '(';
								wynik += nums[h];
							}
							wynik += ')';
							return wynik;
						}
					}
				}
			}
		}
		mods.push_back(a = a % b);
	}
}
