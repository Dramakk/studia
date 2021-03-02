{-# LANGUAGE FlexibleContexts, FlexibleInstances, FunctionalDependencies, ScopedTypeVariables #-}
class Monad m => TwoPlayerGame m s a b | m -> s a b where
    moveA :: s -> m a
    moveB :: s -> m b

data Score = AWins | Draw | BWins

data Field = Circle | X | Empty deriving Show
data Player = A | B
type Board = [Field]
type AMove = [Int] -- lista możliwych pozycji do zajęcia
type BMove = [Int]

rotate :: Board -> Board
rotate (p11:p12:p13:p21:p22:p23:p31:p32:p33:[]) = p13:p23:p33:p12:p22:p32:p11:p21:p31:[]

checkWin :: Board -> AMove -> BMove -> Maybe Score
checkWin board [] [] = Just Draw
checkWin (Circle:Circle:Circle:rest) _ _ = Just AWins 
checkWin (_:_:_:Circle:Circle:Circle:rest) _ _ = Just AWins 
checkWin (_:_:_:_:_:_:Circle:Circle:Circle:[]) _ _ = Just AWins 
checkWin (X:X:X:rest) _ _ = Just BWins 
checkWin (_:_:_:X:X:X:rest) _ _ = Just BWins 
checkWin (_:_:_:_:_:_:X:X:X:[]) _ _ = Just BWins 
checkWin (Circle:_:_:_:Circle:_:_:_:Circle:[]) _ _ = Just AWins
checkWin (X:_:_:_:X:_:_:_:X:[]) _ _ = Just BWins
checkWin _ _ _ = Nothing

change :: Int -> Field -> Board -> Board
change index f b = let (firstHalf, secondHalf) = splitAt (index-1) b in
                        firstHalf++(f:(tail secondHalf))

deleteA :: Int -> AMove -> AMove
deleteA index moves = let (firstHalf, secondHalf) = splitAt (index-1) moves in
                        firstHalf++(tail secondHalf)

deleteB :: Int -> BMove -> BMove
deleteB index moves = let (firstHalf, secondHalf) = splitAt (index-1) moves in
                        firstHalf++(tail secondHalf)

game :: TwoPlayerGame m Board AMove BMove => m Score
game = let board = [Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty, Empty] in
          let moveA = [1..9] in
              let moveB = [1..9] in
                  play board Circle moveA moveB
                  where play :: Board -> Field -> AMove -> BMove -> m Score
                        play b Circle aM bM = do tmp <- (moveA b)
                                                 let nextAMove = (head tmp) in
                                                    if elem nextAMove aM then
                                                            let newBoard = change nextAMove Circle b in
                                                                    let newAMoves = deleteA nextAMove aM in
                                                                            case checkWin newBoard newAMoves bM of
                                                                                Just x -> return x
                                                                                Nothing -> play newBoard X newAMoves bM
                                                        else
                                                            return BWins
                        play b X aM bM = do tmp <- (moveB b)
                                            let nextBMove = (head tmp) in
                                                if elem nextBMove bM then
                                                        let newBoard = change nextBMove X b in
                                                            let newBMoves = deleteB nextBMove bM in
                                                                case checkWin newBoard aM newBMoves of
                                                                    Just x -> return x
                                                                    Nothing -> play newBoard Circle aM newBMoves
                                                    else
                                                        return AWins