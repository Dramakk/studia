#include "bst.hpp"
#include <iostream>
using namespace struktury;
using namespace std;
template<typename T, class C>
struktury::BST<T, C>::BST(){
	this->root = nullptr;
}

template<typename T, class C>
struktury::BST<T, C>::BST(T wart){
	node *newT = new node(wart);
	this->root = newT;
}

template<typename T, class C>
struktury::BST<T, C>::BST(initializer_list<T> list) : BST(){
	for (auto i : list)
		this->dodaj(i);
}

template<typename T, class C>
struktury::BST<T, C>::BST(const BST &obiekt){
	if (obiekt.root == nullptr){
		this->root = nullptr;
		return;
	}
	else
		this->root = (this->root->kopiuj(obiekt.root));
}


template<typename T, class C>
void* struktury::BST<T, C>::node::kopiuj(const node *obiekt){
	node *newT = new node(obiekt->wart);
	if (obiekt->lewe == nullptr && obiekt->prawe == nullptr){
		newT->lewe = newT->prawe = nullptr;
		return newT;
	}

	if (obiekt->lewe != nullptr)
		newT->lewe = (this->kopiuj(obiekt->lewe));
	else
		newT->lewe = nullptr;
	if (obiekt->prawe != nullptr)
		newT->prawe = (this->kopiuj(obiekt->prawe));
	else
		newT->prawe = nullptr;
	return newT;
}

template<typename T, class C>
struktury::BST<T, C>::BST(BST &&obiekt){
	this->root = obiekt.root;
	obiekt.root = nullptr;
}


template<typename T, class C>
BST<T, C>& struktury::BST<T,C>::operator=(const BST &obiekt){
	if (obiekt.root == nullptr){
		this->root = nullptr;
		return *this;
	}
	else
		this->root = (this->root->kopiuj(obiekt.root));
	return *this;
}


template<typename T, class C>
BST<T, C>& struktury::BST<T, C>::operator=(BST &&obiekt){
	this->root = obiekt.root;
	obiekt.root = nullptr;
	return *this;
}



template<typename T, class C>
struktury::BST<T, C>::~BST(){
	this->root->destruct();
}


template<typename T, class C>
void struktury::BST<T, C>::node::destruct(){
	if (this == nullptr)
		return;
	if (this->lewe == nullptr && this->prawe == nullptr){
		delete this;
		return;
	}
	this->lewe->destruct();
	this->prawe->destruct();
	delete this;
}



template<typename T, class C>
void struktury::BST<T, C>::dodaj(T wart){
	if (this->czyPuste()){
		node *newT = new node(wart);
		this->root = newT;
		return;
	}
	this->root->dodaj(wart);
}


template<typename T, class C>
bool struktury::BST<T, C>::usun(T wart){
	if (!this->znajdz(wart))
		return false;
	node *start = this->root;
    C compare;
    greaterEqual<T> ge;
	if (compare(start->wart, wart) && ge(start->wart, wart)){
		if (start->lewe == nullptr && start->prawe == nullptr){
			delete this->root;
			this->root = nullptr;
		}
		else if (start->prawe == nullptr){
			node *temp = start;
			start = start->lewe;
			delete temp;
			root = start;
		}
		else if (start->lewe == nullptr){
			node *temp = start;
			start = start->prawe;
			delete temp;
			root = start;
		}
		else{
			node *help = start->prawe;
			if (help->lewe == nullptr){
				start->wart = help->wart;
				start->prawe = start->prawe->prawe;
			}
			else{
				while (help->lewe->lewe != nullptr)
					help = help->lewe;
				start->wart = help->lewe->wart;
				help->lewe = help->lewe->prawe;
			}
		}
		return true;
	}
	return this->root->usun(wart);
}

template<typename T, class C>
bool struktury::BST<T, C>::znajdz(T wart){
	return this->root->znajdz(wart);
}

template<typename T, class C>
bool struktury::BST<T, C>::czyPuste(){
	return this->root == nullptr;
}

template<typename T, class C>
ostream& struktury::BST<T,C>::node::print(ostream &output){
	if (this == nullptr)
		return output;
	if (this->lewe == nullptr && this->prawe == nullptr){
		output << this->wart << " ";
		return output;
	}
	this->lewe->print(output);
	output << this->wart << " ";
	this->prawe->print(output);
	return output;
}

template<typename T, class C>
struktury::BST<T, C>::node::node(T wart){
	this->wart = wart;
	this->lewe = nullptr;
	this->prawe = nullptr;
}

template<typename T, class C>
struktury::BST<T, C>::node::node(const node &obiekt){
	this->wart = obiekt.wart;
	this->lewe = obiekt.lewe;
	this->prawe = obiekt.prawe;
}

template<typename T, class C>
struktury::BST<T, C>::node::~node(){
	this->lewe = this->prawe = nullptr;
}

template<typename T, class C>
void struktury::BST<T, C>::node::dodaj(T wart){
	C compare;
	if (!compare(this->wart, wart)){
		if (this->lewe == nullptr){
			node *newT = new node(wart);
			this->lewe = newT;
			return;
		}
		this->lewe->dodaj(wart);
	}
	else{
		if (this->prawe == nullptr){
			node *newT = new node(wart);
			this->prawe = newT;
			return;
		}
		this->prawe->dodaj(wart);
	}
}

template<typename T, class C>
bool struktury::BST<T, C>::node::usun(T wart){
	if (this == nullptr)
		return false;
	if (this->lewe == nullptr && this->prawe == nullptr)
		return false;
	C compare;
    greaterEqual<T> ge;
	if (this->lewe != nullptr && compare(this->lewe->wart, wart) && ge(this->lewe->wart, wart)){
		if (this->lewe->lewe == nullptr && this->lewe->prawe == nullptr){
			delete this->lewe;
			this->lewe = nullptr;
		}
		else if (this->lewe->prawe == nullptr){
			node *temp = this->lewe;
			this->lewe = this->lewe->lewe;
			delete temp;
		}
		else if (this->lewe->lewe == nullptr){
			node *temp = this->lewe;
			this->lewe = this->lewe->prawe;
			delete temp;
		}
		else{
			node *help = this->lewe->prawe;
			if (help->lewe == nullptr){
				this->lewe->wart = help->wart;
				this->lewe->prawe = this->lewe->prawe->prawe;
			}
			else{
				while (help->lewe->lewe != nullptr)
					help = help->lewe;
				this->lewe->wart = help->lewe->wart;
				help->lewe = help->lewe->prawe;
			}
		}
		return true;
	}
	else if (this->prawe != nullptr && compare(this->prawe->wart, wart) && ge(this->prawe->wart, wart)){
		if (this->prawe->lewe == nullptr && this->prawe->prawe == nullptr){
			delete this->prawe;
			this->prawe = nullptr;
		}
		else if (this->prawe->prawe == nullptr){
			node *temp = this->prawe;
			this->prawe = this->prawe->lewe;
			delete temp;
		}
		else if (this->prawe->lewe == nullptr){
			node *temp = this->prawe;
			this->prawe = this->prawe->prawe;
			delete temp;
		}
		else{
			node *help = this->prawe->prawe;
			if (help->lewe == nullptr){
				this->prawe->wart = help->wart;
				this->prawe->prawe = this->prawe->prawe->prawe;
			}
			else{
				while (help->lewe->lewe != nullptr)
					help = help->lewe;
				this->prawe->wart = help->lewe->wart;
				help->lewe = help->lewe->prawe;
			}
		}
		return true;
	}
	else if (compare(this->wart, wart))
		return this->prawe->usun(wart);
	else
		return this->lewe->usun(wart);
}

template<typename T, class C>
bool struktury::BST<T, C>::node::znajdz(T wart){
	C compare;
    greaterEqual<T> ge;
	if (compare(this->wart, wart) && ge(this->wart, wart))
		return true;
	else if (compare(this->wart, wart))
		if (this->prawe == nullptr)
			return false;
		else
			return this->prawe->znajdz(wart);
	else
		if (this->lewe == nullptr)
			return false;
		else
			return this->lewe->znajdz(wart);
}
