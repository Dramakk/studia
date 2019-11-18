#ifndef BST_HPP_INCLUDED
#define BST_HPP_INCLUDED
#include <iostream>
#include <type_traits>
#include <functional>
using namespace std;
namespace struktury{
	template <typename T, class C = less_equal<T>>
	class BST{
	protected:
		class node{
		public:
			T wart;
			node *lewe;
			node *prawe;
			node(T wart);
			node(const node &obiekt);
			~node();
			void dodaj(T wart);
			bool usun(T wart);
			bool znajdz(T wart);
			void destruct();
			void* kopiuj(const node *obiekt);
			ostream& print(ostream &output);
		};

		node *root;

	public:
		BST();
		BST(T wart);
		BST(initializer_list<T> list);
		BST(const BST &obiekt);
		BST(BST<T, C> &&obiekt);
		BST<T, C>& operator=(const BST &obiekt);
		BST<T, C>& operator=(BST &&obiekt);
		~BST();
		void dodaj(T wart);
		bool usun(T wart);
		bool znajdz(T wart);
		friend ostream& operator<<(ostream &output, const BST &obiekt){
			return obiekt.root->print(output);
		}
	protected:
		bool czyPuste();
	};

	template<typename T, class C>
	class BST<T*, C> : public BST<T, C>{
	public:
		using BST<T, C>::BST;
		void dodaj(T *wart){
			this->BST<T, C>::dodaj(*wart);
		}

		bool usun(T *wart){
			return this->BST<T, C>::usun(*wart);
		}

		bool znajdz(T *wart){
			return this->BST<T, C>::znajdz(*wart);
		}

		friend ostream& operator<<(ostream &output, const BST &obiekt){
			return obiekt.root->print(output);
		}
	};

	template<typename T>
	class BST<T*> : public BST<T*, less_equal<T>>{
	public:
		using BST<T*, less_equal<T>>::BST;
		friend ostream& operator<<(ostream &output, const BST &obiekt){
			return obiekt.root->print(output);
		}
	};
    	template<typename T>
	struct greaterEqual{
		bool operator()(const T& l, const T& r) const{
			return l >= r;
		}
	};

	template<>
	struct greaterEqual<const char*>{
		bool operator()(const char *l, const char *r) const{
			string lewe = l;
			string prawe = r;
			return lewe >= prawe;
		}
	};

	template<>
	struct greaterEqual<char*>{
		bool operator()(const char *l, const char *r) const{
			string lewe = l;
			string prawe = r;
			return lewe >= prawe;
		}
	};

	template<typename T>
	struct greaterEqual<T*>{
		bool operator()(*l, *r){
			return (*l) >= (*r);
		}
	};
}
#include "funkcje.cpp"
#endif // BST_HPP_INCLUDED
