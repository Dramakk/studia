using System;
using List;

namespace Test{
  class Program{
    static void Main(string[] args){
      Lista<int> l = new Lista<int>();
      Console.WriteLine("{0}", l.Empty());
      for(int i = 0; i < 100; i++){
        l.addFirst(i);
      }
      for(int i = 0; i < 100; i++){
        l.addLast(i);
      }
      for(int i = 0; i < 50; i++){
        Console.WriteLine("{0}",l.getLast());
      }
      for(int i = 0; i < 150; i++){
        Console.WriteLine("{0}",l.getFirst());
      }
     	l.addFirst(10);
	    Console.WriteLine("{0}", l.getLast());
      Console.WriteLine("{0}", l.Empty());
    }
  }
}
