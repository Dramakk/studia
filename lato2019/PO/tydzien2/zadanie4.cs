//Dawid Żywczak 310111
//Zadanie 4 - lista 2
using System;
using System.Collections.Generic;

namespace ListaLeniwa{
  class ListaLeniwa{
    protected int wielkosc = 0;
    protected List<int> lista = new List<int>();
    Random losowe = new Random();
    public int size(){
      return this.wielkosc;
    }
    virtual public int element(int x){
      if(x<0){
        Console.WriteLine("Nieprawidłowa ilość elementów");
        return -1;
      }
      else if(x > this.wielkosc){
        for(int i = 0; i<=x; i++){
          lista.Add(losowe.Next(0,Int32.MaxValue));
        }
        this.wielkosc = x;
        return lista[x];
      }
      else{
        return lista[x];
      }
    }
  }
  class Pierwsze:ListaLeniwa{
    int kolejnaPierwsza = 2;
    override public int element(int x){
      x = x-1;
      if(x<0){
        Console.WriteLine("Nieprawidłowa ilość elementów");
        return -1;
      }
      else if(x > this.wielkosc){
        int i = 0;
        while(i<=x){
          bool czyPierwsza = true;
          for(int j = 2; j<=Math.Sqrt(kolejnaPierwsza); j++){
            if(kolejnaPierwsza % j == 0){
              czyPierwsza = false;
              break;
            }
          }
          if(czyPierwsza){
            lista.Add(kolejnaPierwsza);
            i+=1;
          }
          kolejnaPierwsza++;
        }
        this.wielkosc = x+1;
        return lista[x];
      }
      else{
        return lista[x];
      }
    }
  }
  class Program{
    static void Main(string[] args) {
         ListaLeniwa lista = new ListaLeniwa();
         Pierwsze listaP = new Pierwsze();
         Console.WriteLine("{0}", lista.element(40));
         Console.WriteLine("{0}", lista.size());
         Console.WriteLine("{0}", lista.element(12));
         Console.WriteLine("{0}", lista.size());
         Console.WriteLine("{0}", listaP.element(10));
         Console.WriteLine("{0}", listaP.size());
         Console.WriteLine("{0}", listaP.element(9));
         Console.WriteLine("{0}", listaP.element(15));
         Console.WriteLine("{0}", listaP.size());
	       Console.ReadKey();
      }
  }
}
