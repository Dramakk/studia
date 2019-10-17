#ifndef OBLICZENIA
#define OBLICZENIA
#include <iostream>
#include <exception>
using namespace std;

namespace obliczenia{
	class wyjatek_wymierny;
	class dzielenie_przez_0;
	class przekroczenie_zakresu;
	class wymierna;


	class wyjatek_wymierny : public exception{
        private:
            string msg;
        public:
            wyjatek_wymierny(string m);
            wyjatek_wymierny(const wyjatek_wymierny &obiekt);
            wyjatek_wymierny& operator=(const wyjatek_wymierny &obiekt);
            virtual ~wyjatek_wymierny() throw() = default;
            virtual const char* what() const throw() override;
	};
	class dzielenie_przez_0 : public wyjatek_wymierny{
        using wyjatek_wymierny::wyjatek_wymierny;
	};

	class przekroczenie_zakresu : public wyjatek_wymierny{
        using wyjatek_wymierny::wyjatek_wymierny;
	};

	class wymierna
	{
	public:
		wymierna(int l = 0, int m = 1);
		wymierna(const wymierna &pattern);
		wymierna& operator=(const wymierna &pattern);
		int getNumerator() const;
		int getDenominator() const;
		explicit operator int();
		explicit operator double();

		wymierna operator-();
		wymierna operator!();
		friend ostream& operator<<(ostream &output, const wymierna &w);
		wymierna operator+(wymierna second);
		wymierna operator-(wymierna second);
		wymierna operator*(wymierna second);
		wymierna operator/(wymierna second);
	private:
		int licznik;
		int mianownik;
		friend bool czyOkresowy(int a);
		friend string makeCycle(int a, int b);
		int nwd(int a, int b);
		int nww(int a, int b);
		int mod(int a, int b);
	};
	bool czyOkresowy(int a);
	string makeCycle(int a, int b);
}


#endif
