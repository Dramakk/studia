#ifndef PLIKI_HPP_INCLUDED
#define PLIKI_HPP_INCLUDED
#include <iostream>
#include <fstream>

std::istream& clearline(std::istream &input);

class ignore
{
private:
	int x;
public:
	ignore(int x) : x(x) {}
	friend std::istream& operator>>(std::istream &input, const ignore &manip);
};


std::ostream& comma(std::ostream &output);
std::ostream& colon(std::ostream &output);

class index
{
private:
	int x;
	int w;
public:
	index(int x, int w = 0) : x(x), w(w) {}
	friend std::ostream& operator<<(std::ostream &output, const index &manip);
};


namespace strumienie
{
	class wejscie
	{
	private:
		std::ifstream plik;
	public:
		wejscie(const std::string &sciezka);
		~wejscie();
		friend wejscie &operator>>(wejscie &input, int &num){
            num = static_cast<int>(input.plik.get());
            if(input.plik.fail()){
                throw std::ios_base::failure("Bład podczas czytania z pliku");
            }
            return input;
        }
	};

	class wyjscie
	{
	private:
		std::ofstream plik;
	public:
		wyjscie(const std::string &sciezka);
		~wyjscie();
		friend wyjscie &operator<<(wyjscie &file, const int &num){
            file.plik << static_cast<char>(num + 1);
            return file;
        }
	};
}
#endif // PLIKI_HPP_INCLUDED
