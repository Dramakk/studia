module NestedQBF where 
import Data.Void

data Formula v
    = Var v
    | Bot
    | Not (Formula v)
    | And (Formula v) (Formula v)
    | All (Formula (Inc v))

data Inc v = Z | S v
type Env v = v -> Bool

eval :: Env v -> Formula v -> Bool
eval envor (Var x) = envor x
eval envor Bot = False
eval envor (Not x) = not (eval envor x)
eval envor (And x y) = (eval envor x) && (eval envor y)
eval envor (All form) = eval (\arg -> case arg of
                                    Z -> True
                                    S x -> envor x) form && 
                        eval (\arg -> case arg of
                                    Z -> False
                                    S x -> envor x) form

isTrue :: Formula Void -> Bool
isTrue = eval absurd