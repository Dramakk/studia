data Tree a = Node (Tree a) a (Tree a) | Leaf deriving (Eq, Show)
data Set a = Fin (Tree a) | Cofin (Tree a) deriving (Eq, Show)

setFromList :: Ord a => [a] -> Set a
setEmpty, setFull :: Ord a => Set a
setUnion, setIntersection :: Ord a => Set a -> Set a -> Set a
setComplement :: Ord a => Set a -> Set a
setMember :: Ord a => a -> Set a -> Bool
setToList :: Ord a => Set a -> [a]
setToListAux :: Ord a => Tree a -> [a]
treeFromList :: Ord a => [a] -> Tree a
treeFromList [] = Leaf
treeFromList (hd:tl) = Node (treeFromList [x | x<-tl, x < hd]) hd (treeFromList [x | x<-tl, x > hd])

setEmpty = Fin Leaf
setFull = Cofin Leaf

setFromList [] = setEmpty
setFromList xs = Fin (treeFromList xs) 
    
    

setMember elem (Fin ftree) = 
    findInTree elem ftree where
        findInTree :: Ord a => a -> Tree a -> Bool
        findInTree elem Leaf = False
        findInTree elem (Node left nodeElem right)
            | nodeElem == elem = True
            | elem < nodeElem = findInTree elem left 
            | otherwise = findInTree elem right

setMember elem (Cofin ctree) =
    not (setMember elem (Fin ctree))

setToListAux Leaf = []
setToListAux (Node left elem right) = (setToListAux left) ++ [elem] ++ (setToListAux right)
setToList (Fin ttree) = setToListAux ttree
setToList (Cofin ttree) = setToListAux ttree 

setUnion (Fin tree1) (Fin tree2) =
    setFromList ((setToList (Fin tree1)) ++ (setToList (Fin tree2)))

setUnion (Fin tree1) (Cofin tree2) =
    let cofinSet = setToList (Cofin tree2) in
        let finSet = setToList (Fin tree1) in
            Cofin (treeFromList (filter (\x -> notElem x finSet) cofinSet))

setUnion (Cofin tree2) (Fin tree1) =
    setUnion (Fin tree1) (Cofin tree2)

setUnion (Cofin tree1) (Cofin tree2) = Cofin (treeFromList [x | x <- setToList (Cofin tree1), any (\y -> x == y) (setToList (Cofin tree2))])

setIntersection (Fin tree1) (Fin tree2) =
    let fin1 = setToList (Fin tree2) in
        let fin2 = setToList (Fin tree1) in
            setFromList (filter (\x -> elem x fin2) fin1)

setIntersection (Fin tree1) (Cofin tree2) =
    let cofinSet = setToList (Cofin tree2) in
        let finSet = setToList (Fin tree1) in
            setFromList (filter (\x -> notElem x cofinSet) finSet)

setIntersection (Cofin tree1) (Fin tree2) =
    setIntersection (Fin tree2) (Cofin tree1)

setIntersection (Cofin tree1) (Cofin tree2) =
    Cofin (treeFromList (setToList (Fin tree1) ++ setToList (Fin tree2)))

setComplement (Fin tree) = 
    Cofin tree
setComplement (Cofin tree) =
    Fin tree
