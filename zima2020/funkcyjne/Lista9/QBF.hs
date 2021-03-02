module QBF where
type Var = String
data Formula = 
    Var Var -- zmienne zdaniowe
    | Bot -- spójnik fałszu (⊥)
    | Not Formula -- negacja (¬ϕ)
    | And Formula Formula -- koniunkcja (ϕ ∧ ψ)
    | All Var Formula -- kwantyfikacja uniwersalna (∀p.ϕ)

type Env = Var -> Bool
eval :: Env -> Formula -> Bool

eval envor (Var x) = envor x
eval envor Bot = False
eval envor (Not x) = not (eval envor x)
eval envor (And x y) = (eval envor x) && (eval envor y)
eval envor (All x form) = eval (\arg -> if arg == x then True else envor arg) form && eval (\arg -> if arg == x then False else envor arg) form

isTrue :: Formula -> Bool
isTrue form = eval (\x -> error "Zmienna wolna") form

formula = All "p" (Not (All "q" (Not (And (Not (And (Var "p") (Var "q"))) (Not (And (Not (Var "p")) (Not (Var "q"))))))))