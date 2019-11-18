//Dawid Żywczak 310111
//Zadanie 1 - lista 2
using System;

namespace IntStreamApp{
  class IntStream{
    int kolejna = 0;
    protected bool end = false;
    virtual public bool eos(){
      return this.end;
    }
    virtual public int next(){
      if(kolejna == Int32.MaxValue){
        this.end = true;
        return Int32.MaxValue;
      }
      else return this.kolejna++;
    }
    public void reset(){
      this.kolejna = 0;
      this.end = false;
    }
  }
  class PrimeStream: IntStream{
    int pierwsza = 1;
    override public int next(){
      bool czyPierwsza;
      while(true){
        if(this.pierwsza == Int32.MaxValue){
          this.end = true;
          return -1;
        }
        czyPierwsza = true;
        this.pierwsza+=1;
        for(int j = 2; j<=Math.Sqrt(this.pierwsza); j++){
          if(this.pierwsza % j == 0){
            czyPierwsza = false;
            break;
          }
        }
        if(czyPierwsza == true) return this.pierwsza;
      }
    }
  }
  class RandomStream : IntStream{
    Random losowe = new Random();
    override public bool eos(){
      return false;
    }
    override public int next(){
      return losowe.Next(0, Int32.MaxValue);
    }
  }
  class RandomWordStream{
    string alfabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    PrimeStream potokP = new PrimeStream();
    RandomStream potokR = new RandomStream();
    public string next(){
      string losowyS = "";
      int dlugosc = potokP.next();
      for(int i = 0; i<dlugosc; i++){
        int losowaL = potokR.next();
        losowyS = losowyS.Insert(i, alfabet[losowaL % alfabet.Length].ToString());
      }
      return losowyS;
    }
    public bool eos(){
      return false;
    }
  }
  class Program{
    static void Main(string[] args) {
         IntStream potok = new IntStream();
         PrimeStream potokP = new PrimeStream();
         RandomStream rand = new RandomStream();
         RandomWordStream randWord = new RandomWordStream();
         for(int i = 0; i < 10; i++){
           Console.WriteLine("{0} {1}",potok.next(), potok.eos());
         }
         Console.WriteLine("--------------------------------------");
         for(int i = 0; i < 10; i++){
           Console.WriteLine("{0} {1}",potokP.next(), potokP.eos());
         }
         Console.WriteLine("--------------------------------------");
         for(int i = 0; i < 10; i++){
           Console.WriteLine("{0} {1}",rand.next(), rand.eos());
         }
         Console.WriteLine("--------------------------------------");
         for(int i = 0; i < 10; i++){
           Console.WriteLine("{0} {1}",randWord.next(), randWord.eos());
         }
         Console.ReadKey();
      }
  }
}
