(*Dawid Żywczak, Zadanie 2, lista 2*)
let cycle lst n = 
  let rec iter head tail = 
      if n = List.length tail
      then tail @ head
      else iter (head::[List.hd tail]) (List.tl tail)
      in
  iter [] lst;;