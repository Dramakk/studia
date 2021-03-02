int :: (String -> a) -> String -> Integer -> a
int cont =
    (\str number -> (cont (str++(show number))))

str :: (String -> a) -> String -> String -> a
str cont =
    (\str1 str2 -> (cont (str1++str2)))

lit :: String -> (String -> a) -> (String -> a)
lit str cont =
    (\strCont -> cont (strCont++str))

(^^) f1 f2 = 
    (\x -> f1 (f2 x))

sprintf formatString =
    formatString id ""

tmp n = sprintf (lit "Ala ma " Main.^^ int Main.^^ lit " kot" Main.^^ str Main.^^ lit ".") n (if n == 1 then "a" else if 1 < n && n < 5 then "y" else "ów")