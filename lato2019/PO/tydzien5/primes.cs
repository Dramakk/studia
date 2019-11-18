using System;
using Primes;

class Program{
    static void Main(string[] args){
        PrimeCollection pc = new PrimeCollection();
        foreach(int p in pc)
				System.Console.WriteLine(p);
    }
}
