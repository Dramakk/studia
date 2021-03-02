import Data.Char

data StreamTrans i o a = 
    Return a
    | ReadS (Maybe i -> StreamTrans i o a)
    | WriteS o (StreamTrans i o a)

stoLower :: StreamTrans Char Char ()
stoLower = ReadS (\x ->
                    case x of
                        Just a -> WriteS (toLower a) stoLower
                        Nothing -> Return ())

listTrans :: StreamTrans i o a -> [i] -> ([o], a)
-- listTrans transform list =
--    aux transform list []
--     where 
--         aux :: StreamTrans i o a -> [i] -> [o] -> ([o], a)
--         aux (Return val) list acc = (acc, val)
--         aux (ReadS fun) [] acc = aux (fun Nothing) [] acc
--         aux (ReadS fun) (hd:tl) acc = aux (fun (Just hd)) tl acc
--         aux (WriteS x cont) list acc = aux cont list (acc++[x])
listTrans (Return val) list =
    ([], val)
listTrans (ReadS fun) [] =
    listTrans (fun Nothing) []
listTrans (ReadS fun) (hd:tl) = 
    listTrans (fun (Just hd)) tl
listTrans (WriteS x cont) list =
    let (rest, val) = listTrans cont list in 
        (x:rest, val)