#ifndef WIELOMIANY_HPP_INCLUDED
#define WIELOMIANY_HPP_INCLUDED
#include <vector>
using namespace std;

class wyrazenie{
    public:
        wyrazenie() = default;
        virtual double oblicz() = 0;
        virtual string opis() = 0;
        virtual int getLacznasc();
        virtual int getPriorytet() = 0;
        virtual ~wyrazenie() = default;
        //1 prawostronnie lączne
        //0 lewostronnie lączne
};

class liczba : public wyrazenie{
    private:
        static const int priorytet;
        double wartosc;
    public:
        liczba(double w);
        double oblicz() override;
        string opis() override;
        int getPriorytet() override;
};


class stala : public wyrazenie{
    protected:
        const string nazwa;
        const double wartosc;
        static const int priorytet;
    public:
        stala(string nazwa, double wartosc) : nazwa(nazwa), wartosc(wartosc) {};
        double oblicz() override;
        string opis() override;
        int getPriorytet() override;
};

class pi : public stala{
	public:
		pi() : stala("pi", 3.14) {}
};


class e : public stala{
	public:
		e() : stala("e", 2.71) {}
};

class fi : public stala{
	public:
        fi() : stala("fi", 1.618) {}
};

class zmienna : public wyrazenie{
	private:
		static vector<pair<string, double>> variables;
		static void usun(string &name);
		static const int priorytet;
		string var;
	public:
		zmienna(string name);
		zmienna(string name, double value);
		static void set(string name, double value);
		double oblicz() override;
		string opis() override;
		int getPriorytet() override;
};

class unarne : public wyrazenie{
    protected:
        wyrazenie *lewy;
    private:
        const int priorytet;
    public:
        unarne(wyrazenie* l) : lewy(l), priorytet(9){};
        ~unarne();
        int getPriorytet() override;
};

class sin : public unarne{
	public:
		sin(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};

class cos : public unarne{
	public:
		cos(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};

class exp : public unarne{
	public:
		exp(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};


class ln : public unarne{
	public:
		ln(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};

class abs : public unarne{
	public:
		abs(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};

class opp : public unarne{
	public:
		opp(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};


class inv : public unarne{
	public:
		inv(wyrazenie *w) : unarne(w) { }
		double oblicz() override;
		string opis() override;
};

class binarne : public unarne{
	protected:
		wyrazenie *prawy;
		const string op;
		const int priorytet;
	public:
		binarne(wyrazenie *l, wyrazenie *r, string o, int prio) : unarne(l), prawy(r), op(o), priorytet(prio) { }
		~binarne();
		int getPriorytet() override;
		string opis() override;
};

class dodaj : public binarne{
	public:
		dodaj(wyrazenie *l, wyrazenie *r) : binarne(l, r, "+", 6) { }
		double oblicz() override;
};

class odejmij : public binarne{
	public:
		odejmij(wyrazenie *l, wyrazenie *r) : binarne(l, r, "-", 6) { }
		double oblicz() override;
};

class pomnoz : public binarne{
	public:
		pomnoz(wyrazenie *l, wyrazenie *r) : binarne(l, r, "*", 7) { }
		double oblicz() override;
	};

class podziel : public binarne{
	public:
		podziel(wyrazenie *l, wyrazenie *r) : binarne(l, r, "/", 7) { }
		double oblicz() override;
	};

class modulo : public binarne{
	public:
		modulo(wyrazenie *l, wyrazenie *r) : binarne(l, r, "%", 7) { }
		double oblicz() override;
};

class poteguj : public binarne{
	public:
		poteguj(wyrazenie *l, wyrazenie *r) : binarne(l, r, "^", 8) { }
		double oblicz() override;
		int getLacznasc() override;
};

class log : public binarne{
	public:
		log(wyrazenie *l, wyrazenie *r) : binarne(l, r, "log", 9) { }
		double oblicz() override;
		string opis() override;
};
#endif // WIELOMIANY_HPP_INCLUDED
