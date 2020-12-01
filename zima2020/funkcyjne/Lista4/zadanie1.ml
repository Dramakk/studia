(*Dawid Żywczak, Zadanie 1, lista 4*)

type 'a btree = Leaf | Node of 'a btree * 'a * 'a btree;;
let t1 = Node(Node(Leaf, "abc", Leaf), "def", Node(Leaf, "ghi", Leaf));;

let rec balanced (tree: 'a btree) =
  match tree with
  | Leaf -> (true, 1)
  | Node (left, _ , right) -> 
    let bLeft, bLeftCount = (balanced left) in 
        let bRight, bRightCount = (balanced right) 
          in if (abs (bLeftCount - bRightCount) <= 1) && bLeft && bRight 
          then (true, bLeftCount + bRightCount + 1) 
          else (false, bLeftCount + bRightCount + 1);;

let halve list =
  let rec aux acc list counter = 
    match counter with
      | [] | [_] -> (List.rev acc), list 
      | hd::tail -> aux (List.hd list::acc) (List.tl list) (List.tl tail)   
    in aux [] list list;;

let rec buildTree list = 
  match list with
  | [] -> Leaf
  | [a] -> Node (Leaf, a, Leaf)
  | head::tail -> let left, right = halve tail in Node (buildTree left, head, buildTree right);;