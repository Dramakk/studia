#include <iostream>
#include "figury.h"
#include <cmath>
using namespace std;
double odleglosc(punkt a, punkt b){
	double odl = (b.x - a.x)*(b.x - a.x) + (b.y - a.y)*(b.y - a.y);
	if (odl < 0)
		odl *= -1;
	return sqrt(odl);
}
double wspolczynnik(punkt a, punkt b){
	if (b.x - a.x == 0)
		return INFINITY;
	return ((b.y - a.y) / (b.x - a.x));
}
bool rownolegle(odcinek x, odcinek y){
    double wsp1 = wspolczynnik(x.a, x.b);
    double wsp2 = wspolczynnik(y.a, y.b);
    if(wsp1 == wsp2) return 1;
    return 0;
}
bool prostopadle(odcinek x, odcinek y){
	double ax = wspolczynnik(x.a, x.b);
	double ay = wspolczynnik(y.a, y.b);

	if (ax == INFINITY && y.b.y - y.a.y == 0)
		return 1;
	else if (ay == INFINITY && x.b.y - x.a.y == 0)
		return 1;

	else if ((ax*ay) == -1)
		return 1;
	else
		return 0;
}
bool oddzielne(trojkat x, trojkat y){
	if (x.czyZawarty(y.a) == 1 || x.czyZawarty(y.b) == 1 || x.czyZawarty(y.c) == 1)
		return 0;
	else if (y.czyZawarty(x.a) == 1 || y.czyZawarty(x.b) == 1 || y.czyZawarty(x.c) == 1)
		return 0;
	else
		return 1;
}
bool zawarte(trojkat x, trojkat y){
	if (y.czyZawarty(x.a) == 1 && y.czyZawarty(x.b) == 1 && y.czyZawarty(x.c) == 1)
		return 1;
	else
		return 0;
}
//algorytm przecinania się odcinków zaczerpnięty z https://www.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
int kierunek(punkt a, punkt b, punkt c) {
   int val = (b.y-a.y)*(c.x-b.x)-(b.x-a.x)*(c.y-b.y);
   if (val == 0)
      return 0;
   else if(val < 0)
      return 2;
      return 1;
}
bool czyPrzecinaja(odcinek l1, odcinek l2){
   int dir1 = kierunek(l1.a, l1.b, l2.a);
   int dir2 = kierunek(l1.a, l1.b, l2.b);
   int dir3 = kierunek(l2.a, l2.b, l1.a);
   int dir4 = kierunek(l2.a, l2.b, l1.b);
   if(dir1 != dir2 && dir3 != dir4)
      return true;
   if(dir1==0 && l1.naOdcinku(l2.a))
      return true;
   if(dir2==0 && l1.naOdcinku(l2.b))
      return true;
   if(dir3==0 && l2.naOdcinku(l1.a))
      return true;
   if(dir4==0 && l2.naOdcinku(l1.b))
      return true;
   return false;
}
//punkt
punkt::punkt(){
    this->x = 0;
    this->y = 0;
}

punkt::punkt(double x, double y){
    this->x = x;
    this->y = y;
}

punkt::punkt(const punkt &obiekt){
    this->x = obiekt.x;
    this->y = obiekt.y;
}

punkt& punkt::operator=(const punkt &obiekt){
    if(this->x == obiekt.x && this->y == obiekt.y){
        return *this;
    }
    this->x = obiekt.x;
    this->y = obiekt.y;
    return *this;
}
bool punkt::operator==(const punkt& porowanie){
    return ((this->x == porowanie.x) && (this->y == porowanie.y));
}
void punkt::przesun(double x, double y){
    this->x += x;
    this->y += y;
}
void punkt::obroc(double x, double y, double alpha){
    double cosin = cos(alpha);
    double sinus = sin(alpha);
    double x1 = (((this->x - x) * cosin) - ((this->y - y) * sinus) + x);
	double y1 = (((this->x - x) * sinus) + ((this->y - y) * cosin) + y);
	this->x = x1;
    this->y = y1;
}
ostream& operator<<(ostream& os, const punkt& punkt){
    os << punkt.x << ", " << punkt.y;
    return os;
}
//odcinek
odcinek::odcinek(const punkt& a, const punkt& b){
    if (a.x==b.x && a.y==b.y)
        throw invalid_argument("Nie można utworzyć odcinka o długości 0");
    this->a = a;
    this->b = b;
}
odcinek::odcinek(const odcinek &obiekt)
{
	this->a = obiekt.a;
	this->b = obiekt.b;
}
odcinek& odcinek::operator=(const odcinek &obiekt){
    if(this->a == obiekt.a && this->b == obiekt.b){
        return *this;
    }
    this->a = obiekt.a;
    this->b = obiekt.b;
    return *this;
}
bool odcinek::operator==(const odcinek &obiekt){
    return ((this->a == obiekt.a) && (this->b == obiekt.b));
};
void odcinek::przesun(double x, double y){
    this->a.przesun(x, y);
    this->b.przesun(x, y);
};
void odcinek::obroc(double x, double y, double alpha){
    this->a.obroc(x, y, alpha);
    this->b.obroc(x, y, alpha);
};
double odcinek::dlugosc(){
	return odleglosc(a, b);
}
bool odcinek::naOdcinku(const punkt& a){
    if(this->a == a || this->b == a) return 1;
    double wsp = wspolczynnik(this->a, this->b);
    double reszta = this->a.y - (wsp * this->a.x);
    if(wsp == INFINITY){
        if((this->a.x == a.x) && ((this->a.y <= a.y) && (this->b.y >= a.y) || (this->b.y <= a.y) && (this->a.y >= a.y))) //or ponieważ nie mamy zagwarantowanej "kolejności" punktów w odcinku;
            return 1;
    }
    if((wsp*a.x + reszta) == a.y) return 1;
    else return 0;
};
punkt odcinek::srodek(){
    double x = (this->a.x + this->b.x)/2;
    double y = (this->a.y + this->b.y)/2;
    punkt s = punkt(x, y);
    return s;
};

punkt odcinek::przecinaja(const odcinek& przecinajaca){
    double athis = wspolczynnik(this->a, this->b);
	double acompared = wspolczynnik(przecinajaca.a, przecinajaca.b);
	double bthis = (-1)*(athis*this->a.x) + this->a.y;
	double bcompared = (-1)*(acompared*przecinajaca.a.x) + przecinajaca.a.y;
	double x, y;
	punkt point = punkt(0, 0);
    if (athis == acompared)
		throw invalid_argument("Odcinki są równoległe\n");
    if(!czyPrzecinaja(*this, przecinajaca))
        throw invalid_argument("Odcinki się nie przecinają\n");
	else if (athis == INFINITY)
	{
        x = this->a.x;
        y = acompared*x + bcompared;
	}
	else if(acompared == INFINITY){
        x = przecinajaca.a.x;
        y = athis*x + bthis;
	}
	else{
        x = (bcompared - bthis) / (athis - acompared);
        y = (athis*x) + bthis;
        point.x = x;
        point.y = y;
	}
	return point;

};
ostream& operator<<(ostream& os, const odcinek& obiekt){
    os << "Punkt A: " << obiekt.a << " punkt B: " << obiekt.b << endl;
    return os;
}
//trójkąty
trojkat::trojkat(punkt a, punkt b, punkt c){
    if (((a.x*b.y + a.y*c.x + b.x*c.y) - (b.y*c.x) - (a.x*c.y) - (a.y*b.x)) == 0)
        throw string("Punkty współliniowe, nie można utworzyć trójkąta!");
    this->a = a;
    this->b = b;
    this->c = c;
}
trojkat::trojkat(const trojkat &obiekt){
	this->a = obiekt.a;
	this->b = obiekt.b;
	this->c = obiekt.c;
}

bool trojkat::operator==(const trojkat &obiekt){
	if ((this->a == obiekt.a) && (this->b == obiekt.b) && (this->c == obiekt.c))
		return 1;
	else
		return 0;
}

trojkat& trojkat::operator=(const trojkat &obiekt){
	if (*this == obiekt)
		return *this;
	this->a = obiekt.a;
	this->b = obiekt.b;
	this->c = obiekt.c;

	return *this;
}

void trojkat::przesun(double x, double y){
	this->a.przesun(x, y);
	this->b.przesun(x, y);
	this->c.przesun(x, y);
}


void trojkat::obroc(double x, double y, double alpha){
	this->a.obroc(x, y, alpha);
	this->b.obroc(x, y, alpha);
	this->c.obroc(x, y, alpha);
}
double trojkat::obwod(){
	odcinek a = odcinek(this->a, this->b);
	odcinek b = odcinek(this->b, this->c);
	odcinek c = odcinek(this->a, this->c);

	return (a.dlugosc() + b.dlugosc() + c.dlugosc());
}
double trojkat::pole(){
	odcinek A = odcinek(this->a, this->b);
	odcinek B = odcinek(this->b, this->c);
	odcinek C = odcinek(this->a, this->c);

	double a = A.dlugosc();
	double b = B.dlugosc();
	double c = C.dlugosc();
	double p = this->obwod() / 2;

	return sqrt((p* (p - a)*(p - b)*(p - c)));
}
punkt trojkat::srodek(){
    //wyznaczenie boków
	odcinek ab = odcinek(this->a, this->b);
	odcinek bc = odcinek(this->b, this->c);
    //wyznaczenie srodków boków
	punkt srodekab = ab.srodek();
	punkt srodekbc = bc.srodek();
    //utworzenie odcinków CśrodekAB i AśrodekBC
	odcinek srodekabc = odcinek(srodekab, this->c);
	odcinek srodekbca = odcinek(srodekbc, this->a);
    //zwracamy punkt przecięcia dwóch środkowych
	return srodekabc.przecinaja(srodekbca);

}
bool trojkat::czyZawarty(punkt x){
    //algorytm zaczerpnięty z https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
    double dX = x.x-this->c.x;
    double dY = x.y-this->c.y;
    double dX21 = this->c.x-this->b.x;
    double dY12 = this->b.y-this->c.y;
    double D = dY12*(this->a.x-this->c.x) + dX21*(this->a.y-this->c.y);
    double s = dY12*dX + dX21*dY;
    double t = (this->c.y-this->a.y)*dX + (this->a.x-this->c.x)*dY;
    if (D<0) return s<=0 && t<=0 && s+t>=D;
    return s>=0 && t>=0 && s+t<=D;
}
ostream& operator<<(ostream& os, const trojkat& obiekt){
    os << "Punkt A: " << obiekt.a << " punkt B: " << obiekt.b << " punkt C: " << obiekt.c << endl;
    return os;
}
