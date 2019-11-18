#ifndef WIELOMIANY_HPP_INCLUDED
#define WIELOMIANY_HPP_INCLUDED
using namespace std;
class wielomian
{
    private:
        int stopien; // stopień wielomianu
        double *wspolczynniki; // współczynniki wielomianu
    public:
        wielomian (int st=0, double wsp=1.0); // konstruktor tworzący jednomian
        wielomian (int st, const double wsp[]); // konstruktor tworzący wielomian
        wielomian (initializer_list<double> wsp); // lista współczynników
        wielomian (const wielomian &w); // konstruktor kopijący
        wielomian (wielomian &&w); // konstruktor przenoszący
        wielomian& operator = (const wielomian &w); // przypisanie kopijące
        wielomian& operator = (wielomian &&w); // przypisanie przenoszące
        ~wielomian (); // destruktor
        int get_stopien();
        friend wielomian operator + (const wielomian &u, const wielomian &v);
        friend wielomian operator - (const wielomian &u, const wielomian &v);
        friend wielomian operator * (const wielomian &u, const wielomian &v);
        friend wielomian operator * (const wielomian &u, double c);
        wielomian& operator += (const wielomian &v);
        wielomian& operator -= (const wielomian &v);
        wielomian& operator *= (const wielomian &v);
        wielomian& operator *= (double c);
        //double& operator[](int i);
        double set_wsp(int i, double w);
        double operator () (double x) const; // obliczenie wartości wielomianu dla x
        double operator [] (int i) const; // odczytanie i-tego współczynnika
        double operator[](pair<int, double> i) const;
        friend istream& operator >> (istream &we, wielomian &w);
        friend ostream& operator << (ostream &wy, const wielomian &w);
        //funkcje pomocnicze
        friend int stopien_dodawanie(const wielomian& w1, const wielomian& w2);
        friend int stopien_odejmowanie(const wielomian& w1, const wielomian& w2);
};

#endif // WIELOMIANY_HPP_INCLUDED
