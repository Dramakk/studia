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