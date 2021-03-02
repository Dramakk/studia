permi, perms :: [a] -> [[a]]
insert :: a -> [a] -> [[a]]

insert x [] = [[x]]
insert x list = (x:list):map (\el -> (head list):el) (insert x (tail list))

permi (hd:tl) = concatMap (insert hd) (permi tl)
permi [] = [[]]

---
select :: [a] -> [(a,[a])]
select [] = []
select (hd:tl) = (hd, tl):[(x, hd:xs)|(x, xs) <- select tl]

perms [] = [[]]
perms l = [a:r2| (a, l) <- select l, r2 <-perms l]