#include<iostream>
#include "wyrazenia.hpp"
#include <vector>
#include <string>
#include <cmath>
using namespace std;

const int liczba::priorytet = 10;
const int stala::priorytet = 10;
const int zmienna::priorytet = 10;

int wyrazenie::getLacznasc(){
	return 0;
}

int liczba::getPriorytet(){
	return priorytet;
}
int stala::getPriorytet(){
	return priorytet;
}
int zmienna::getPriorytet(){
	return priorytet;
}
int unarne::getPriorytet(){
	return priorytet;
}
int binarne::getPriorytet(){
	return priorytet;
}

liczba::liczba(double w){
    wartosc = w;
}

double liczba::oblicz(){
    return wartosc;
}

string liczba::opis(){
    string v = to_string(wartosc);
	v.erase(v.find_last_not_of('0') + 1);
	v.erase(v.find_last_not_of('.') + 1);
	return v;
}

double stala::oblicz(){
    return wartosc;
}

string stala::opis(){
    return nazwa;
}

vector<pair<string, double>> zmienna::variables;

void zmienna::usun(string &name){
	for(int i = 0; i < variables.size(); i++){
        string x = variables[i].first;
        if(name == x){
            variables.erase(variables.begin() + i);
            break;
        }
	}
}

zmienna::zmienna(string name) : var(name){
	usun(name);
	variables.push_back(make_pair(name, NAN));
}

zmienna::zmienna(string name, double value) : var(name){
	usun(name);
	variables.push_back(make_pair(name, value));
}

void zmienna::set(string name, double value){
	usun(name);
	variables.push_back(make_pair(name, value));
}

double zmienna::oblicz(){
	string variable = var;
	int i = 0;
	for(i = 0; i < variables.size(); i++){
        pair<string, double> x = variables[i];
        if(x.first == variable){
            if (variables[i].second == NAN)
                throw invalid_argument("Zmienna nie zadeklarowana\n");
            else return variables[i].second;
        }
	}
	if (i == variables.size())
		throw invalid_argument("Zmienna nie istnieje\n");
}

string zmienna::opis(){
	return var;
}
unarne::~unarne(){
    delete lewy;
}

binarne::~binarne(){
    delete prawy;
}

double sin::oblicz(){
	double arg = lewy->oblicz();
	return std::sin(arg);
}

string sin::opis(){
	return "sin(" + lewy->opis() + ")";
}

double cos::oblicz(){
	double arg = lewy->oblicz();
	return std::cos(arg);
}

string cos::opis(){
	return "cos(" + lewy->opis() + ")";
}

double exp::oblicz(){
	double arg = lewy->oblicz();
	return std::exp(arg);
}

string exp::opis(){
	return "e^(" + lewy->opis() + ")";
}

double ln::oblicz(){
	double arg = lewy->oblicz();
	return std::log(arg);
}

string ln::opis(){
	return "ln(" + lewy->opis() + ")";
}

double abs::oblicz(){
	double arg = lewy->oblicz();
	return std::fabs(arg);
}

string abs::opis(){
	return "|" + lewy->opis() + "|";
}

double opp::oblicz(){
	double arg = lewy->oblicz();
	return arg*(-1);
}

string opp::opis(){
	return "-(" + lewy->opis() + ")";
}

double inv::oblicz(){
	double arg = lewy->oblicz();
	if(arg == 0){
        throw invalid_argument("Próba dzielenia przez 0!\n");
	}
	return 1 / arg;
}

string inv::opis(){
	return "1 / (" + lewy->opis() + ")";
}

string binarne::opis()
{
	string result="";
	if (priorytet > lewy->getPriorytet())
		result += "(" + lewy->opis() + ")";
	else if (priorytet == lewy->getPriorytet() && getLacznasc() == 0)
		result += "(" + lewy->opis() + ")";
	else
		result += lewy->opis();

	result += " " + op + " ";

	if (priorytet > prawy->getPriorytet())
		result += "(" + prawy->opis() + ")";
	else if (priorytet == prawy->getPriorytet() && getLacznasc() == 1)
		result += "(" + prawy->opis() + ")";
	else
		result += prawy->opis();
	return result;
}

double dodaj::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	return leftvalue + rightvalue;
}


double odejmij::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	return leftvalue - rightvalue;
}


double pomnoz::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	return leftvalue * rightvalue;
}


double podziel::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	if (rightvalue == 0)
		throw invalid_argument("Dzielenie przez 0!\n");
	return leftvalue / rightvalue;
}


double modulo::oblicz(){
	double leftvalue = (lewy->oblicz());
	double rightvalue = (prawy->oblicz());
	return fmod(leftvalue, rightvalue);
}

double poteguj::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	return pow(leftvalue, rightvalue);
}

int poteguj::getLacznasc(){
	return 1;
}

double log::oblicz(){
	double leftvalue = lewy->oblicz();
	double rightvalue = prawy->oblicz();

	return std::log(rightvalue) / std::log(leftvalue);
}

string log::opis(){
	return (op + "(" + lewy->opis() + ")" + "^" + "(" + prawy->opis() + ")");
}
