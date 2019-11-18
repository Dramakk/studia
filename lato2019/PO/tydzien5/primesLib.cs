
using System;
using System.Collections;
namespace Primes{
  public class Prime: IEnumerator
  {
    private int current_val;
    public int nextPrime(int current_val)
    {
      if (current_val < 2)
      return 2;

      for (int i = current_val + 1; i <= int.MaxValue; i++){
        if (current_val == int.MaxValue) return 0;
        bool czyPierwsza = true;
        for (int j = 2; j <= Math.Sqrt(i); j++){
          if (i % j == 0){
            czyPierwsza = false;
            break;
          }
        }
        if (czyPierwsza)
        return i;
      }
      return 0;
    }

    public Prime(){
      this.current_val = int.MaxValue - 10000;
    }
    public bool MoveNext(){
      this.current_val = nextPrime(current_val);
      return current_val != 0;
    }
    public object Current{
      get{
        return this.current_val;
      }
    }
    public void Reset(){
      this.current_val = 1;
    }
  }

  public class PrimeCollection : IEnumerable{
    public IEnumerator GetEnumerator(){
      return new Prime();
    }
  }
}
