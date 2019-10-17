#lang racket
(require racket/contract)

(define/contract foo number? 42)

(define/contract (dist x y)
  (-> number? number? number?)
  (abs (- x y)))

(define/contract (average x y)
  (-> number? number? number?)
  (/ (+ x y) 2))

(define/contract (square x)
  (-> number? number?)
  (* x x))
(define/contract (sqrt x)
  (->i ([x positive?])
       [result (x) positive?]
       #:post (x result)
       (<= (dist (square result) x) 0.0001))
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))
;cwiczenie 2
(define/contract (filter p? xs)
  (parametric->/c [a] (->i ([p? (-> a boolean?)]
                            [xs (listof a)])
                           [result (p? xs) (and/c
                                               (lambda (l) (andmap p? l))
                                               (listof a)
                                               ;tutaj funkcja sprawdzająca czy jest podlistą
                                               )]))
  (if (null? xs)
      null
      (if (p? (car xs))
          (cons (car xs)
                (filter p? (cdr xs)))
          (filter p? (cdr xs)))))
;cwiczenie 3
(define-signature monoid^
  ((contracted
    [elem? (-> any/c boolean?) ]
    [neutral elem?]
    [oper (-> elem? elem? elem?)])))

(define-unit monoid-num@
  (import)
  (export monoid^)
  (define (elem? x)
    (integer? x))
  (define neutral 0)
  (define (oper x y)
    (+ x y)))

(define-unit monoid-list@
  (import)
  (export monoid^)
  (define (elem? x)
    (list? x))
  (define neutral null)
  (define (oper x y)
    (append x y)))
(require quickcheck)
(define-values/invoke-unit/infer monoid-num@)
(quickcheck
 (property
  ([v arbitrary-integer])
  (= (oper v neutral) (oper neutral v))))
;ćwiczenie 5
(define-signature set^
  ((contracted
    [set? (-> any/c boolean?)]
    [member? (-> integer? set? boolean?)]
    [empty-set set?]
    [singleton (-> integer? set?)]
    [sum (-> set? set? set?)]
    [join (-> set? set? set?)])))
(define-unit set-list@
  (import)
  (export set^)
  (define (set? x)
    (and (list? x)
         (andmap integer? x)))
  (define (member? x s)
    (define (iter s)
      (if (null? s)
          #f
          (if (= x (car s))
              #t
              (iter (cdr s)))))
    (iter s))
  (define empty-set null)
  (define (singleton x)
    (list x))
  (define (sum x y)
    (remove-duplicates (append x y)))
  (define (join x y)
    (filter (lambda (e) (member? e x)) y)))
(define-values/invoke-unit/infer set-list@)
(define set '(1 2 3 -1 -2))
(define set2 '(1 2 3))
(sum set set2)
;ćw 6
(define (implies a b)
  (or (not a) b))
;że singleton zawiera tylko element z którego został stworzony
(quickcheck
 (property ([x arbitrary-integer]
            [y arbitrary-integer])
           (equal? (member? y (singleton x))
                   (equal? x y))))
#|żeby działało jeszcze intlist->set jest potrzebne
(quickcheck
 (property ([x arbitrary-integer]
            [s1l arbitrary-list arbitrary-integer]
            [s2l arbitrary-list arbitrary-integer])
           (let ([s1 (intlist->set s1l)]
                 [s2 (intlist->set s2l)])
             (implies (belongs x (sum s1 s2))
                      (or (belongs x s1) (belongs x s2))))))|#