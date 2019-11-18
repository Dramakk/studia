#include<iostream>
#include<fstream>
#include<string>
#include "pliki.hpp"
std::istream& clearline(std::istream &input)
{
	while (input.peek() != EOF && input.get() != '\n');
	return input;
}


std::istream& operator>>(std::istream &input, const ignore &manip)
{
	char a;
		for(int i=0; i<=manip.x; i++)
		{
			input.get(a);
			if (a == '\n' || input.eof())
				return input;
		}
    return input;
}



std::ostream& comma(std::ostream &output)
{
    output << ", ";
	return output;
}


std::ostream& colon(std::ostream &output)
{
    output << ": ";
	return output;
}


std::ostream &operator<<(std::ostream &output, const index &manip) {
	output << "[";
	output.width(manip.w);
	output << std::right << manip.x << "]";
	return output;
}

strumienie::wejscie::wejscie(const std::string &sciezka)
{
	plik.open(sciezka, std::ifstream::in);
	if (plik.fail()) {
		throw std::ios_base::failure("Error on opening file");
	}
}

strumienie::wejscie::~wejscie()
{
		plik.close();
}

strumienie::wyjscie::wyjscie(const std::string &sciezka)
{
	plik.open(sciezka, std::ofstream::out);
	if (plik.fail()) {
		throw std::ios_base::failure("Error on opening file");
	}
}

strumienie::wyjscie::~wyjscie()
{
		plik.close();
}
