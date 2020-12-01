open Logic

type context = (string * formula) list
type goalDesc = context * formula

type proof = Leaf of theorem | NodeB of proof * proof * (theorem -> theorem -> theorem) | NodeU of proof * (theorem -> theorem) | Hole of goalDesc
type path = Top | 
            Unary of (theorem-> theorem) * path | 
            Left of (theorem -> theorem -> theorem) * path * proof |
            Right of proof * path * (theorem -> theorem -> theorem)
type goal = Goal of proof * path

let rec qed pf =
  match pf with
  | Leaf th -> th
  | NodeB (p1, p2, f) -> f (qed p1) (qed p2) 
  | NodeU (p1, f) -> f (qed p1)
  | Hole _ -> failwith "Not finished"

let rec numGoals pf =
  match pf with
  | Leaf _ -> 0
  | NodeB (p1, p2, _) -> numGoals p1 + numGoals p2
  | NodeU (p1, _) -> numGoals p1
  | Hole _ -> 1

let rec goals pf =
  match pf with
  | Leaf _ -> []
  | NodeB (p1, p2, _) -> (goals p1) @ (goals p2)
  | NodeU (p1, _) -> goals p1
  | Hole gD -> [gD]

let proof g f =
  Hole(g, f) 

let goal pf =
  match pf with
  | Goal (Hole(gD), _) -> gD
  | _ -> failwith "Wrong goal"


let go_left (Goal(pf, path)) =
  match path with 
  | Top                     -> failwith "left of Top"
  | Unary (_, _)            -> failwith "left of Unary"
  | Left (_,_,_)            -> failwith "left of Left"
  | Right (left, father, f) -> Goal(left, Left(f,father, pf))

let go_right (Goal(pf, path)) =
  match path with 
  | Top                     -> failwith "right of Top"
  | Unary (_, _)            -> failwith "right of Unary"
  | Left (f, father, right) -> Goal(right, Right(pf, father, f))
  | Right (_,_,_)           -> failwith "right of Right"

let go_up (Goal(pf, path)) = 
  match path with 
  | Top                     -> failwith "up of Top"
  | Unary (f, father)       -> Goal(NodeU (pf,f), father)
  | Left (f, father, right) -> Goal(NodeB (pf, right, f), father)
  | Right (left, father, f) -> Goal(NodeB (left, pf, f), father)

let go_down (Goal(pf, path)) = 
  match pf with
  | Leaf th             -> failwith "down of Leaf"
  | Hole gD             -> failwith "down of Hole"
  | NodeU (pf1, f)      -> Goal(pf1, Unary(f,path))
  | NodeB (pf1, pf2, f) -> Goal(pf1, Left(f, path, pf2))

let go_down_right (Goal(pf, path)) = 
  match pf with
  | Leaf th             -> failwith "down of Leaf"
  | Hole gD             -> failwith "down of Hole"
  | NodeU (pf1, f)      -> Goal(pf1, Unary(f,path))
  | NodeB (pf1, pf2, f) -> Goal(pf2, Right(pf1, path, f))

let rec forward (Goal(pf, path) as g) = 
  let rec go_up_up (Goal(pf0, path0) as gl) = (* idzie do góry aż path nie będzie top lub left *)
    match path0 with 
    | Left (f, father, right) -> go_right gl
    | Top                     -> forward gl
    | _                       -> go_up_up (go_up gl)
  in match pf with 
  | Leaf _ | Hole _   -> go_up_up g
  | NodeU (_,_)       -> go_down g
  | NodeB (_,_,_)     -> go_down g

let backward (Goal(pf, path) as g) = 
  let rec go_down_down (Goal(pf0, path0) as gl) = 
    match pf0 with 
    | NodeU (_,_) -> go_down_down (go_down gl)
    | NodeB (_,_,_) -> go_down_down (go_down_right gl)
    | _ -> gl
  in match path with
  | Top           -> go_down_down g
  | Unary (_, _)  -> go_up g
  | Left (_,_,_)  -> go_up g
  | Right (_,_,_) -> go_down_down (go_left g)

let next (Goal(pf, path) as gl) =
  let rec aux (Goal(pf, path) as nextGoal) = 
    match pf with
  | Hole _ -> nextGoal 
  | _      -> aux (forward nextGoal)
  in aux (forward gl)

let rec prev (Goal(pf, path) as gl) =
  let rec aux (Goal(pf, path) as nextGoal) = 
    match pf with
  | Hole _ -> nextGoal 
  | _      -> aux (backward nextGoal)
  in aux (backward gl)

let focus n pf =
  let find_first pf =
    let rec aux g = 
      match g with
      | Goal(Hole _, _) -> g
      | _ -> aux(forward g)
    in aux (Goal(pf, Top))
  in
  let rec aux n gl = 
    if n = 0 then gl else aux (n-1) (next gl)
  in aux n (find_first pf)

let rec unfocus (Goal(pf, path) as gl) =
  match path with
  | Top -> pf
  | _ -> unfocus (go_up gl)


let intro name (Goal(pf, path)) =
  match pf with
  | Hole(cont, Implication(f1, f2)) -> 
    let nhole = Hole((name, f1)::cont, f2) in Goal(nhole, Unary(imp_i f1, path))
  | _ -> failwith "Wrong intro"

let rec apply f (Goal(Hole(cont, form) as pf, path) as gl) =
  if f = form then gl else
  match f with
  | False -> let nhole = Hole(cont, False) in Goal(nhole, Unary(bot_e form, path))
  | Implication(f1, f2) -> let nhole = Hole(cont, f) in 
                   let nholer = Hole(cont, f1) in 
                   let Goal(nproof, npath) = (apply f2 gl) in
                   Goal(nhole, Left(imp_e, npath, nholer))
  | _ -> failwith "Wrong apply"

let apply_thm thm (Goal(Hole(cont, form), path) as gl) =
  let f = (consequence thm)in
  let Goal(Hole(cont0, form0), path0) = apply f gl in
    if f = form0 && List.for_all (fun f -> List.exists (fun (_, fc) -> f = fc) cont0) (assumptions thm) then
      unfocus (Goal (Leaf(thm), path0))
    else failwith "Wrong apply_thm/assm"

let apply_assm name (Goal(Hole(cont, form), path) as gl) =
  let f = List.assoc name cont in
  apply_thm (by_assumption f) gl

let pp_print_proof fmtr pf =
  let ngoals = numGoals pf
  and goals = goals pf
  in if ngoals = 0
  then Format.pp_print_string fmtr "No more subgoals"
  else begin
      Format.pp_open_vbox fmtr (-100);
      Format.pp_open_hbox fmtr ();
      Format.pp_print_string fmtr "There are";
      Format.pp_print_space fmtr ();
      Format.pp_print_int fmtr ngoals;
      Format.pp_print_space fmtr ();
      Format.pp_print_string fmtr "subgoals:";
      Format.pp_close_box fmtr ();
      Format.pp_print_cut fmtr ();
      goals |> List.iteri (fun n (_, f) ->
       Format.pp_print_cut fmtr ();
       Format.pp_open_hbox fmtr ();
       Format.pp_print_int fmtr (n + 1);
       Format.pp_print_string fmtr ":";
       Format.pp_print_space fmtr ();
       pp_print_formula fmtr f;
       Format.pp_close_box fmtr ());
      Format.pp_close_box fmtr ()
    end

let pp_print_goal fmtr gl =
  let (g, f) = goal gl
  in
  Format.pp_open_vbox fmtr (-100);
  g |> List.iter (fun (name, f) ->
      Format.pp_print_cut fmtr ();
      Format.pp_open_hbox fmtr ();
      Format.pp_print_string fmtr name;
      Format.pp_print_string fmtr ":";
      Format.pp_print_space fmtr ();
      pp_print_formula fmtr f;
      Format.pp_close_box fmtr ());
  Format.pp_print_cut fmtr ();
  Format.pp_print_string fmtr (String.make 40 '=');
  Format.pp_print_cut fmtr ();
  pp_print_formula fmtr f;
  Format.pp_close_box fmtr ()
