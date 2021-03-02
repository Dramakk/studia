primes' :: [Integer]
primes' = 2 : [x | x <- [3..], all (\checkDiv -> mod x checkDiv /= 0) (takeWhile (\y -> y^2 <= x) primes')]