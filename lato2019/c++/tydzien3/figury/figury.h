#ifndef FIGURY_HPP_INCLUDED
#define FIGURY_HPP_INCLUDED
class punkt;
class odcinek;
class trojkat;

double odleglosc(punkt x, punkt y);
bool rownolegle(odcinek x, odcinek y);
bool prostopadle(odcinek x, odcinek y);
bool oddzielne(trojkat x, trojkat y);
bool zawarte(trojkat x, trojkat y);
double wspolczynnik(punkt a, punkt b); //pomocnicza wspołczynnik kierunkowy prostej
int kierunek(punkt a, punkt b, punkt c); //pomocnicza
bool czyPrzecinaja(odcinek l1, odcinek l2); //pomocnicza
class punkt{
private:
    double x;
    double y;
public:
    friend odcinek;
	friend trojkat;
    punkt();
    punkt(double x,  double y);
    punkt(const punkt &obiekt);
    punkt& operator=(const punkt &obiekt);
    bool operator==(const punkt& porownanie);
    void przesun(double x, double y);
	void obroc(double x, double y, double alpha);

	friend double wspolczynnik(punkt a, punkt b);
	friend double factor(punkt a, punkt b);
	friend double odleglosc(punkt a, punkt b);
	friend bool prostopadle(odcinek x, odcinek y);
	friend std::ostream& operator<<(std::ostream& os, const punkt& obiekt);
	friend int kierunek(punkt a, punkt b, punkt c);
    friend bool czyPrzecinaja(odcinek l1, odcinek l2);
};
class odcinek{
private:
    punkt a;
    punkt b;
public:
    odcinek(const punkt& a, const punkt& b);
	odcinek(const odcinek &obiekt);
	odcinek& operator=(const odcinek &obiekt);
	bool operator==(const odcinek &obiekt);
	void przesun(double x, double y);
	void obroc(double x, double y, double alpha); //obrot wokol punktu (x,y) o kat alpha
	double dlugosc();
	bool naOdcinku(const punkt& a);
	punkt srodek();
	punkt przecinaja(const odcinek& przecinajaca);

	friend bool rownolegle(odcinek x, odcinek y);
	friend bool prostopadle(odcinek x, odcinek y);
	friend std::ostream& operator<<(std::ostream& os, const odcinek& obiekt);
	friend int kierunek(punkt a, punkt b, punkt c);
    friend bool czyPrzecinaja(odcinek l1, odcinek l2);
};
class trojkat{
private:
    punkt a;
    punkt b;
    punkt c;
public:
    trojkat(punkt a, punkt b, punkt c);
    trojkat(const trojkat &obiekt);
    trojkat& operator=(const trojkat &obiekt);
    bool operator==(const trojkat &obiekt);
    double obwod();
    double pole();
    bool czyZawarty(punkt x);
    void obroc(double x, double y, double alpha); //obrot wokol punktu (x,y) o kat alpha
    void przesun(double x, double y);
    punkt srodek();
    friend bool oddzielne(trojkat x, trojkat y);
    friend bool zawarte(trojkat x, trojkat y);
    friend std::ostream& operator<<(std::ostream& os, const trojkat& obiekt);
    friend int kierunek(punkt a, punkt b, punkt c);
    friend bool czyPrzecinaja(odcinek l1, odcinek l2);
};
#endif // FIGURY_HPP_INCLUDED
