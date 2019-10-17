using System;

namespace List{
  public class Lista<T>{
    ListItem<T> first;
    ListItem<T> last;
    int howMany;
    public Lista(){
      this.first = new ListItem<T>();
      this.last = first;
      this.howMany = 0;
    }
    public bool Empty(){
      if(this.howMany == 0) return true;
      return false;
    }
    public void addFirst(T val){
      if(this.howMany == 0){
        this.first = new ListItem<T>();
        this.last = first;
      }
      if(this.first.getPrev() == null && this.first.getNext() == null){
        this.first.setVal(val);
        this.first.setPrev(this.last);
      }
      else{
        ListItem<T> newFirst = new ListItem<T>();
        newFirst.setVal(val);
        newFirst.setPrev(this.first);
        this.first.setNext(newFirst);
        this.first = newFirst;
      }
      this.addHowMany();
    }
    public T getFirst(){
      if(this.Empty()){
        return default(T);
      }
      ListItem<T> prev = this.first.getPrev();
      T x = this.first.getVal();
      if(prev != null) prev.setNext(null);
      this.first = prev;
      this.subHowMany();
      return x;
    }
    public void addLast(T val){
      if(this.howMany == 0){
        this.first = new ListItem<T>();
        this.last = first;
      }
      if(this.last.getPrev() == null && this.last.getNext() == null){
        this.last.setVal(val);
        this.last.setNext(this.first);
      }
      else{
        ListItem<T> newLast = new ListItem<T>();
        newLast.setVal(val);
        newLast.setNext(this.last);
        this.last.setPrev(newLast);
        this.last = newLast;
      }
      this.addHowMany();
    }
    public T getLast(){
      if(this.Empty()){
        return default(T);
      }
      ListItem<T> next = this.last.getNext();
      T x = this.last.getVal();
      if(next != null) next.setPrev(null);
      this.last = next;
      this.subHowMany();
      return x;
    }
    private void addHowMany(){
      this.howMany = this.howMany + 1;
    }
    private void subHowMany(){
      if(howMany > 0) this.howMany = this.howMany - 1;
    }
  }
  public class ListItem<T>{
    T val;
    ListItem<T> next;
    ListItem<T> prev;
    public ListItem(){
      this.val = default(T);
      this.next = null;
      this.prev = null;
    }
    public void setNext(ListItem<T> next){
      this.next = next;
    }
    public void setPrev(ListItem<T> prev){
      this.prev = prev;
    }
    public void setVal(T val){
      this.val = val;
    }
    public ListItem<T> getNext(){
      return this.next;
    }
    public ListItem<T> getPrev(){
      return this.prev;
    }
    public T getVal(){
      return this.val;
    }
  }
}
