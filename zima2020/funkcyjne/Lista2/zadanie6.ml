(*Dawid Żywczak, Zadanie 6, lista 2*)
type 'a clist = { clist : 'z. ('a -> 'z -> 'z) -> 'z -> 'z }
let cnil = { clist = (fun f elem -> elem) };;
let ccons c cl = {clist = fun f z -> f c (cl.clist f z) };; 
let cmap (g: 'a -> 'b) cl = {clist = fun f elem -> cl.clist (fun x -> f (g x)) elem};;
let cappend xs ys = {
    clist = fun g elem -> xs.clist g (ys.clist g elem)
};;
let clist_to_list cl = cl.clist (fun x y -> x::y) [];;
let rec clist_of_list xs =
  match xs with
  | [] -> cnil
  | head::tail -> ccons head (clist_of_list tail);;
let prod xs ys = {clist = fun f x -> xs.clist (fun a -> ys.clist (fun b -> f (a,b))) x};;