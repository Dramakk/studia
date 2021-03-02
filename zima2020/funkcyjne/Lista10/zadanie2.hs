{-# LANGUAGE GADTs #-}
-- type Format a b = (String -> a) -> String -> b
data Format a b where
    Int     :: Format a (Integer -> a)
    Str     :: Format a (String -> a)
    Lit     :: String -> Format a a
    (:^:)   :: Format a b -> Format c a -> Format c b
-- Int ^ Str Format a (Int -> Str -> a)
-- Chcemy mieć (String a) -> String -> Int -> String -> a
-- Format a b -> (String -> a) -> String -> b
-- Format c a -> (String -> c) -> String -> a
-- Format c b -> (String -> c) -> String -> b
-- Jak podstawimy to dostaniemy
-- Format (String -> b) (Integer -> (String -> b)) ^ Format b (String -> b) == Format b (Integer -> String -> b)
-- Format       a                 c                ^ Format b       a       == Format b          c                

ksprintf :: Format a b -> (String -> a) -> b
ksprintf Int cont =
    (\x -> (cont (show x)))
ksprintf Str cont =
    (\x -> (cont x))
ksprintf (Lit s) cont =
    (cont s)
ksprintf (f1 :^: f2) cont =
    ksprintf f1 (\x -> ksprintf f2 (\c -> cont (x++c)))

sprintf formatString =
    ksprintf formatString id

kprintf :: Format a b -> (IO () -> a) -> b

kprintf Int cont =
    (\x -> (cont (putStr (show x))))
kprintf Str cont =
    (\x -> (cont (putStr x)))
kprintf (Lit s) cont =
    (cont (putStr s))
kprintf (f1 :^: f2) cont =
    kprintf f1 (\x -> kprintf f2 (\x2 -> cont (x>>x2)))

printf formatString =
    kprintf formatString id
