import Data.Char

echo :: IO ()
echo = do x <- getChar
          if x == '\EOT' then
             return ()
          else
              do putChar (toLower x)
                 echo