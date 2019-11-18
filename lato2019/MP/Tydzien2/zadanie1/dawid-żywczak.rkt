#lang racket
(define (dist x y)
  (abs (- x y)))
(define (cont-frac-it num den)
  (define (numerator k)
    (define (iter-num i a-1 a-2)
      (let*
          ([s1 (* (den i) a-1)]
           [s2 (* (num i) a-2)]
           [s (+ s1 s2)])
        (if (= i k)
            a-1
            (iter-num (+ i 1) s a-1))))
    (iter-num 1 0 1))
  (define (denominator k)
    (define (iter-den i b-1 b-2)
      (let*
          ([s1 (* (den i) b-1)]
           [s2 (* (num i) b-2)]
           [s (+ s1 s2)])
        (if (= i k)
            b-1
            (iter-den (+ i 1) s b-1))))
    (iter-den 1 1 0))
  (define (iter i)
    (let
      ([k (/ (numerator i) (denominator i))]
      [k+1 (/ (numerator (+ i 1)) (denominator (+ i 1)))])
      (if (< (dist k k+1) 0.000001)
          k
          (iter (+ i 1))))
      )
  (iter 1)
  )
(define (square x) (* x x))
(define (pi)
  (define (num x)
    (square (- (* 2 x) 1)))
  (define (den x) 6.0)
  (+ 3 (cont-frac-it num den)))
(define (atan-cf x)
  (define (num i)
    (if (= i 1)
        x
        (square (* (- i 1) x))))
  (define (den z)
    (- (* 2 z) 1))
  (cont-frac-it num den))
(pi)
(atan-cf 1.0)
(atan 1.0)
(atan-cf 100)
(atan 100)
(cont-frac-it (lambda (x) 1.0) (lambda (x) 1.0))