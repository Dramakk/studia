#include<iostream>
#include <string>
#include "wielomiany.hpp"
using namespace std;
int stopien_dodawanie(const wielomian& w1, const wielomian& w2){
    int st = max(w1.stopien, w2.stopien);
    if(w1.stopien == w2.stopien){
        while((st >= 0) && ((w1.wspolczynniki[st] + w2.wspolczynniki[st]) == 0)){
            st--;
        }
    }
    return st;
}
int stopien_odejmowanie(const wielomian& w1, const wielomian& w2){
    int st = max(w1.stopien, w2.stopien);
    if(w1.stopien == w2.stopien){
        while((st >= 0) && ((w1.wspolczynniki[st] - w2.wspolczynniki[st] == 0))){
            st--;
        }
    }
    return st;
}
wielomian::wielomian(int st, double wsp){
    if(wsp == 0 && st != 0){
        throw invalid_argument("Próba stworzenia wielomianu z zerem przy najwyższej potędze\n");
    }
    stopien = st;
    wspolczynniki = new double[st+1];
    wspolczynniki[st] = wsp;
    for(int i = 0; i<st; i++){
        wspolczynniki[i] = 0;
    }
}

wielomian::wielomian(int st, const double wsp[]){
    if(wsp[st] == 0){
        throw invalid_argument("Próba stworzenia wielomianu z zerem przy najwyższej potędze\n");
    }
    stopien = st;
    wspolczynniki = new double[st+1];
    for(int i = 0; i<=st; i++){
        wspolczynniki[i] = wsp[i];
    }
}

wielomian::wielomian(initializer_list<double> wsp){
    if(*(wsp.end() - 1) == 0){
        throw invalid_argument("Próba stworzenia wielomianu z zerem przy najwyższej potędze\n");
    }
    stopien = wsp.size()-1;
    wspolczynniki = new double[stopien+1];
    int i = 0;
    for(auto iterator = wsp.begin(); iterator != wsp.end(); iterator++){
        wspolczynniki[i] = *iterator;
        i++;
    }
}

wielomian::wielomian(const wielomian& w){
    stopien = w.stopien;
    wspolczynniki = new double[stopien+1];
    for(int i = 0; i<=stopien; i++){
        wspolczynniki[i] = w.wspolczynniki[i];
    }
}

wielomian::wielomian(wielomian&& w){
    stopien = w.stopien;
    wspolczynniki = w.wspolczynniki;
    w.stopien = 0;
    w.wspolczynniki = new double[1];
    w.wspolczynniki[0] = 1.0;
}

wielomian& wielomian::operator=(const wielomian& w){
    stopien = w.stopien;
    wspolczynniki = new double[stopien+1];
    for (int i = 0; i <= stopien; i++)
		wspolczynniki[i] = w.wspolczynniki[i];
	return *this;
}

wielomian& wielomian::operator=(wielomian&& w){
    stopien = w.stopien;
    wspolczynniki = new double[stopien+1];
    for (int i = 0; i <= stopien; i++)
		wspolczynniki[i] = w.wspolczynniki[i];
    w.stopien = 0;
    w.wspolczynniki = new double[1];
    w.wspolczynniki[0] = 1.0;
	return *this;
}

wielomian::~wielomian(){
    delete[] wspolczynniki;
}

istream& operator>>(istream &we, wielomian& w){
    while(!(we >> w.stopien) || w.stopien <= 0){
        we.clear();
    }
    w.wspolczynniki = new double[w.stopien + 1];
    for (int i = 0; i <= w.stopien; i++)
		we >> w.wspolczynniki[i];
	return we;
}

ostream& operator<<(ostream &wy, const wielomian &w){
    if(w.stopien == 0){
        wy << w.wspolczynniki[0];
        return wy;
    }
	for (int i = w.stopien; i >= 0; i--){
	    if(w.wspolczynniki[i] != 0) wy << w.wspolczynniki[i] << "*x^" << i << " ";
	}
	return wy;
}

int wielomian::get_stopien(){
    return stopien;
}

wielomian operator+(const wielomian &w1, const wielomian &w2){
    int st = stopien_dodawanie(w1, w2);
    if(st < 0){
        return wielomian(0, 0.0);
    }
    double *wsp = new double[st+1];
    int i;
    for(i = 0; i<=w1.stopien && i<=w2.stopien && i<=st; i++){
        wsp[i] = w1.wspolczynniki[i] + w2.wspolczynniki[i];
    }
    if(w1.stopien > w2.stopien){
        for(;i<=w1.stopien && i<=st;i++){
            wsp[i] = w1.wspolczynniki[i];
        }
    }
    else if(w2.stopien > w1.stopien){
        for(;i<=w2.stopien && i<=st;i++){
            wsp[i] = w2.wspolczynniki[i];
        }
    }
    wielomian w(st, wsp);
    delete[] wsp;
    return w;
}

wielomian operator-(const wielomian &w1, const wielomian &w2)
{
	int st = stopien_odejmowanie(w1, w2);
    if(st < 0){
        return wielomian(0, 0.0);
    }
	double *wsp = new double[st+1];
	int i = 0;
    for(i = 0; i<=w1.stopien && i<=w2.stopien && i<=st; i++){
        wsp[i] = w1.wspolczynniki[i] - w2.wspolczynniki[i];
    }
    if(w1.stopien > w2.stopien){
        for(;i<=w1.stopien && i<=st;i++){
            wsp[i] = w1.wspolczynniki[i];
        }
    }
    else if(w2.stopien > w1.stopien){
        for(;i<=w2.stopien && i<=st;i++){
            wsp[i] = w2.wspolczynniki[i];
        }
    }
    wielomian w = wielomian(st, wsp);
    delete[] wsp;
	return w;
}

wielomian operator*(const wielomian &w1, const wielomian &w2){
	int st = w1.stopien + w2.stopien;
	double *wsp = new double[st+1];
	for (int i = 0; i <= st; i++)
		wsp[i] = 0;
	for (int i = 0; i <= w1.stopien; i++)
		for (int j = 0; j <= w2.stopien; j++)
			wsp[i + j] += w1.wspolczynniki[i] * w2.wspolczynniki[j];
	wielomian w(st, wsp);
	delete[] wsp;
	return w;
}

wielomian operator*(const wielomian& w, double c){
    wielomian u = w;
    if(c == 0){
        return wielomian(0, 0.0);
    }
    for (int i = 0; i <= w.stopien; i++)
		u.wspolczynniki[i] *= c;
    return u;
}

wielomian& wielomian::operator-=(const wielomian &w1){
    wielomian w = *this-w1;
    *this = w;
	return *this;
}

wielomian& wielomian::operator+=(const wielomian &w1){
    wielomian w = *this+w1;
    *this = w;
    return *this;
}

wielomian& wielomian::operator*=(const wielomian &w1){
    wielomian w = *this*w1;
    *this = w;
    return *this;
}

wielomian& wielomian::operator *= (double c){
    wielomian w = *this*c;
    *this = w;
    return *this;
}

double wielomian::operator[](int i) const{
	if (i > stopien || i < 0)
	{
		std::cerr << "Bledny indeks!\n";
		return -1;
	}
	return wspolczynniki[i];
}
//double& wielomian::operator[](int i){
//    if (i > this->stopien || i < 0)
//	{
//		throw  invalid_argument("Bledny indeks!\n");
//	}
//	else if(i == stopien){
//        throw invalid_argument("Próba stworzenia wielomianu z zerem przy najwyższej potędze\n");
//        return -1;
//	}
//	return wspolczynniki[i];
//}
double wielomian::set_wsp(int i, double w){
    if (i > this->stopien || i < 0)
	{
		cerr << "Bledny indeks!\n";
		return -1;
	}
	else if(i == stopien && w == 0){
        throw invalid_argument("Próba stworzenia wielomianu z zerem przy najwyższej potędze\n");
        return -1;
	}
	return wspolczynniki[i] = w;
}

double wielomian::operator () (double x) const{
    if (stopien == 0)
		return wspolczynniki[0];
	double wynik = x*wspolczynniki[stopien] + wspolczynniki[stopien - 1];
	for (int i = stopien-2; i >= 0; i--)
		wynik = wynik*x + wspolczynniki[i];
	return wynik;
};
