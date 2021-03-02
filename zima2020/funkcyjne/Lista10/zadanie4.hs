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
                        
runIOStreamTrans :: StreamTrans Char Char a -> IO a
runIOStreamTrans (WriteS a cont) =
    do putChar a
       runIOStreamTrans cont

runIOStreamTrans (ReadS cont) =
    do x <- getChar
       if x == '\EOT' then
           runIOStreamTrans (cont Nothing)
       else
           runIOStreamTrans (cont (Just x))

runIOStreamTrans (Return val) =
    pure val
