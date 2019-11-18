#include <iostream>
#include <vector>
#include <algorithm>
#include <memory>
#include "pliki.hpp"
using namespace strumienie;
int main() {
	std::vector<std::pair<std::string, int>> data;

	for(int i=0; i < 3; ++i){
		std::string temp;
		std::cin >> temp;
		data.emplace_back(std::make_pair(temp, i));
	}

	std::sort(data.begin(), data.end());

	for(const auto &el: data){
		std::cout << index(el.second, 2) << " " << el.first << std::endl;
	}

	int num = 580;
	std::cout << index(num, 20) << std::endl;


	//std::string input;
	//std::cin >> clearline >> input;
	//std::cin >> ignore(5) >>input;
	//std::cout << input;

	std::string path = "test.txt";
	wyjscie *fileOut = new wyjscie(path);
	*fileOut << 'a';
	*fileOut << 'b';
	*fileOut << 'c';
	*fileOut << 'd';
	delete fileOut;
	wejscie *fileIn = new wejscie(path);

	try {
		int n;
		while(true){
			*fileIn >> n;
			std::cout << static_cast<char>(n);
		}
		std::cout << std::endl;
	}catch (std::ios_base::failure &e) {}

	delete fileIn;
}
