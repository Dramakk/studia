(><) :: [a] -> [b] -> [(a,b)]
(><) [] _ = []
(><) _ [] = []

(><) list1 list2 =
    [(list1 !! (fst x), list2 !! (snd x)) | x <- (f list1 list2)] where
        f :: [a] -> [b] -> [(Int, Int)]
        f xs ys = [x | n <- takeWhile (\n -> not (null (drop (n-1) xs))) [1..], x <- prod (take n xs) (take n ys), (fst x) + (snd x) == n-1] where
            prod :: [a] -> [b] -> [(Int, Int)]
            prod xs ys = [(x, y) | x <- [0..(length xs) - 1], y <- [0..(length ys) - 1]]

