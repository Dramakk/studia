#lang racket
(define (average x y)
  (/ (+ x y) 2))
(define (good-enough? x y)
  (< (abs (- x y)) 0.0000001))
(define (compose f g)
  (lambda (x)
    (f (g x))))
(define (repeated p n)
  (if (<= n 0)
      identity
      (compose p (repeated p (- n 1)))))
(define (average-damp f)
  (lambda (x) (average x (f x))))
(define (fixed-point f s)
  (define (iter k)
    (let ((new-k (f k)))
      (if (good-enough? k new-k)
          k
          (iter new-k))))
  (iter s))
(define (nth-root n x)
  (define (log-base-2-floor x)
    (floor (/ (log x) (log 2))))
  (cond [(< n 1) #f]
        [(and (< x 0) (= (modulo n 2) 0)) #f]
        [else
         (let
             ([f (lambda (y) (/ x (expt y (- n 1))))])
           (fixed-point ((repeated average-damp (log-base-2-floor n)) f) 1.0))])
  )
(nth-root 5 243)
(nth-root 3 -27)
(nth-root 4 16)
(nth-root 4 -16)
(nth-root 10 1024)