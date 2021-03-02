divisible :: [Integer] -> [Integer]
divisible xs =
    case xs of
        (hd:tl) -> [x | x <- tl, mod x hd /= 0]
        [] -> []

primes :: [Integer]
primes = map head (iterate divisible [2..])