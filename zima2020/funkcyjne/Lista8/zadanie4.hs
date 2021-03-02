sublists :: [a] -> [[a]]

sublists [] = [[]]
sublists (hd:tl) = let test = (sublists tl) in
    test++[hd:x | x <- test]