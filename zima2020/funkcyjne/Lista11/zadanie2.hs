import Control.Monad
class Monad m => Random m where
    random :: m Int

remove :: [a] -> Int -> [a]
remove [] n = []
remove (hd:tail) 0 = tail
remove (hd:tail) n = 
    hd : remove tail (n - 1)


shuffle :: Random m => [a] -> m [a]
shuffle [] = pure []
shuffle list = 
    do index <- random
       let modIndex = index `mod` length list in
        do rest <- shuffle (remove list modIndex)
           return ((list !! modIndex):rest)

newtype RS a = RS {unRS :: Int -> (Int, a)}

instance Functor RS where
    fmap = liftM

instance Applicative RS where
    pure = return
    (<*>) = ap

instance Monad RS where
    return x = RS (\y -> (y, x))
    RS a >>= f = RS (\x -> let (worldAfterChange, returnValue) = a x in
                           let RS fun = (f returnValue) in
                               fun worldAfterChange)

instance Random RS where
    random = RS (\x -> let bi = 16807 * (x `mod` 127773) - 2836 * (x `div` 127773) in
                    if bi > 0 then
                        (bi, bi)
                    else
                        (bi+2147483647, bi+2147483647))

withSeed :: RS a -> Int -> a
withSeed (RS a) n = snd (a n)