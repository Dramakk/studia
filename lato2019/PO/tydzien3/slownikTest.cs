using System;
using Slownik;

namespace Test{
  class Program{
    static void Main(string[] args){
      Slownik<int,int> s = new Slownik<int,int>();
      for(int i = 0; i<10; i++){
        s.add(i, i+10);
      }
      for(int i = 0; i<10; i++){
        Console.WriteLine("{0}", s.find(i));
      }
      for(int i = 0; i<10; i++){
        s.remove(i);
      }
      s.add(1,2);
      Console.WriteLine("{0}", s.find(1));
      Console.WriteLine("{0}", s.find(2));
    }
  }
}
