using System;

namespace Slownik{
  public class Slownik<K,V>{
    SlownikItem<K,V> next;
    public Slownik(){
      this.next = null;
    }
    SlownikItem<K,V> isHere(K key){
      if(this.next == null) return null;
      SlownikItem<K,V> oldNext = this.next;
      while(oldNext != null){
        if(oldNext.getKey().Equals(key)){
          return oldNext;
        }
        oldNext = oldNext.getNext();
      }
      return null;
    }
    public void add(K key, V val){
        SlownikItem<K,V> newNext = new SlownikItem<K,V>();
        newNext.setVal(val);
        newNext.setKey(key);
        SlownikItem<K,V> oldNext = this.next;
        SlownikItem<K,V> prev = this.next;
        if(this.next == null) this.next = newNext;
        else{
          while(oldNext != null){
            if(oldNext.getKey().Equals(key)){
              oldNext.setVal(val);
              return;
            }
            prev = oldNext;
            oldNext = oldNext.getNext();
          }
          prev.setNext(newNext);
        }
    }
    public V find(K key){
      SlownikItem<K,V> isFound = this.isHere(key);
      if(isFound != null){
        return isFound.getVal();
      }
      return default(V);
    }
    public void remove(K key){
      SlownikItem<K,V> oldNext = this.next;
      if(this.next.getKey().Equals(key)){
        this.next = this.next.getNext();
      }
      else{
        while(oldNext.getNext() != null){
          if(oldNext.getNext().getKey().Equals(key)){
            oldNext.setNext(oldNext.getNext().getNext());
            return;
          }
          oldNext = oldNext.getNext();
        }
      }
    }
  }
  public class SlownikItem<K,V>{
    K key;
    V val;
    SlownikItem<K,V> next;
    public SlownikItem(){
      this.val = default(V);
      this.next = null;
    }
    public void setNext(SlownikItem<K,V> next){
      this.next = next;
    }
    public void setVal(V val){
      this.val = val;
    }
    public void setKey(K key){
      this.key = key;
    }
    public SlownikItem<K,V> getNext(){
      return this.next;
    }
    public V getVal(){
      return this.val;
    }
    public K getKey(){
      return this.key;
    }
  }
}
