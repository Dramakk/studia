#lang racket
(define (compose f g)
  (lambda (x)
    (f (g x))))
(define (square x)
  (* x x))
(define (inc x)
  (+ x 1))
(define (repeated p n)
  (if (<= n 0)
      identity
      (compose p (repeated p (- n 1)))))

(define (sum val next start end)
  (if (> start end)
      0
      (+ (val start)
         (sum val next (next start) end))))
;;zadanie 4
(define (next x)
  (+ x 2))
(define (val x)
  (/ (* x (+ x 2)) (* (+ x 1) (+ x 1))))
(define (product val next start end)
  (if (> start end)
      1.0
      (* (val start)
         (product val next (next start) end))))
;;zad 4 iteracyjnie
(define (product-it val next start end)
  (define (product-iter i result)
    (if (> i end)
        result
        (product-iter (next i)
                      (* result (val i))))
     )
  (product-iter start 1))
;;zadanie 5
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
                (accumulate combiner null-value
                            term (next a) next b))))
;;zadanie 6 rekurencja
(define (cont-frac num den k)
  (define (rec i)
    (if (> i k)
      0
      (/ (num i) (+ (den i) (rec (+ i 1))))))
  (rec 1))
;;zadanie 6 iteracja
(define (cont-frac-it num den k)
  (define (iter i sum)
    (if (= i 0)
        sum
        (iter (- i 1) (/ (num i) (+ (den i) sum)))))
   (iter k 0))
;;zadanie 7
(define (pi)
  (define (num x)
    (square (- (* 2 x) 1)))
  (define (den x) 6.0)
  (+ 3 (cont-frac-it num den 30)))
;;zadanie 8
(define (atan-cf x k)
  (define (num i)
    (if (= i 1)
        x
        (square (* (- i 1) x))))
  (define (den z)
    (- (* 2 z) 1))
  (cont-frac-it num den k))
;;zadanie 9
(define (repeated-build k n d b)
  (define ( build n d b )
     (/ n (+ d b )))
  ((repeated (lambda (x) (build n d x)) k) b))
(* 4 (accumulate * 1 val 2.0 next 4000))
( cont-frac ( lambda ( i ) 1.0) ( lambda ( i ) 1.0) 100 )
( cont-frac-it ( lambda ( i ) 1.0) ( lambda ( i ) 1.0) 100 )