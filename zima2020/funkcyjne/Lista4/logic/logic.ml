type formula = False | Var of string | Implication of (formula * formula );;

let rec string_of_formula f =
  match f with
  | False -> "⊥ "
  | Var a -> a
  | Implication (Implication (_, _) as l, r) -> "(" ^ string_of_formula l ^ ") -> " ^ string_of_formula r
  | Implication (a, b) -> (string_of_formula a) ^ "->" ^ (string_of_formula b)

let pp_print_formula fmtr f =
  Format.pp_print_string fmtr (string_of_formula f)

type theorem = Ax of (formula list * formula) | ImpI of (theorem * (formula list * formula)) 
              | ImpE of (theorem * theorem * (formula list * formula)) | FalseE of (theorem * (formula list * formula))

let assumptions thm =
  match thm with
  | Ax (assumptions, conseq) -> assumptions
  | ImpI (theorem, (assumptions, conseq)) -> assumptions
  | ImpE ((theorem, theorem1, (assumptions, conseq))) -> assumptions
  | FalseE (theorem, (assumptions, conseq)) -> assumptions

let consequence thm =
  match thm with
  | Ax (assumptions, conseq) -> conseq
  | ImpI (theorem, (assumptions, conseq)) -> conseq
  | ImpE ((theorem, theorem1, (assumptions, conseq))) -> conseq
  | FalseE (theorem, (assumptions, conseq)) -> conseq

let pp_print_theorem fmtr thm =
  let open Format in
  pp_open_hvbox fmtr 2;
  begin match assumptions thm with
  | [] -> ()
  | f :: fs ->
    pp_print_formula fmtr f;
    fs |> List.iter (fun f ->
      pp_print_string fmtr ",";
      pp_print_space fmtr ();
      pp_print_formula fmtr f);
    pp_print_space fmtr ()
  end;
  pp_open_hbox fmtr ();
  pp_print_string fmtr "⊢";
  pp_print_space fmtr ();
  pp_print_formula fmtr (consequence thm);
  pp_close_box fmtr ();
  pp_close_box fmtr ()

let by_assumption f =
  Ax ([f], f)

let imp_i f thm =
  ImpI (thm, (List.filter (fun x -> f <> x) (assumptions thm), Implication (f, consequence thm)))

let imp_e th1 th2 =
  match consequence th1 with
  | Implication (fi, psi) -> if fi = consequence th2 then 
    ImpE (th1, th2, (List.append (assumptions th1) (assumptions th2), psi))
    else failwith "Wrong theorem!"
  | _ -> failwith "Wrong theorem!"
  
let bot_e f thm =
  match consequence thm with
  | False -> FalseE (thm, (assumptions thm, f))
  | _ -> failwith "Wrong theorem!"
