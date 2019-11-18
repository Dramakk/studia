#lang typed/racket
#|(: prefixses2 (All (a) (-> (Listof a) (Listof (Listof a)))))
(define (prefixses2 xs)
  (map reverse (foldl (lambda (x a) (append xs (cons x (car a)) (list null) xs)))|#
#|(: suffixes (All (a) (-> (Listof a) (Listof (Listof a)))))
(define (suffixes xs)
  (if (null? xs)
      (list null)
      (cons xs (suffixes (cdr xs)))))
(: prefixses (All (a) (-> (Listof a) (Listof (Listof a)))))
(define (prefixses xs)
    (map reverse (suffixes (reverse xs))))|#
(: dist (-> Real Real Real))
(define (dist x y)
  (abs (- x y)))

(: average (-> Real Real Real))
(define (average x y)
  (/ (+ x y) 2))

(: square (-> Real Real))
(define (square x)
  (* x x))

(: sqrt (-> Real Real))
(define (sqrt x)
  ;; lokalne definicje
  ;; poprawienie przybliżenia pierwiastka z x
  (: improve (-> Real Real))
  (define (improve approx)
    (average (/ x approx) approx))
  ;; nazwy predykatów zwyczajowo kończymy znakiem zapytania
  (: good-enough? (-> Real Boolean))
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  ;; główna procedura znajdująca rozwiązanie
  (: iter (-> Real Real))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))
(struct vector2 ([x : Real ] [y : Real ]) #:transparent )
(struct vector3 ([x : Real ] [y : Real ] [z : Real ]) #:transparent )
(: vector-length (-> (U vector2 vector3) Real))
(define (vector-length v)
  (match v
    [(vector2 x y) (sqrt (+ (* x x) (* y y)))]
    [(vector3 x y z) (sqrt (+ (* x x) (* y y) (* z z)))]))
;ćw 3 obgadane
;ćw 4
#|(struct leaf () #:transparent)
(struct (a b) node ([v : a] [t : (Listof b)]) #:transparent)
(define-type (Tree a) (U leaf (node a (Tree a))))
(: preorder (All (a) (-> (Tree a) (Listof a))))
(define (preorder t)
  (: iter (-> (Tree a) (Listof a) (Listof a)))
  (define (iter t acc)
    (match t
      [(node v t) (apply (lambda (x) (iter x (cons v acc))) t)]
      [(leaf) null]))
  (iter t '())) nie działa |#

;ćw 5
;; definicja wyrażeń z let-wyrażeniami
(define-type Expr (U const op let-expr variable))
(struct const    ([val : Real])      #:transparent)
(struct op       ([symb : (U '+ '*)] [l : Expr] [r : Expr]) #:transparent)
(struct let-expr ([x : Symbol] [e1 : Expr] [e2 : Expr])  #:transparent)
(struct variable ([x : Symbol])        #:transparent)
(define-predicate expr? Expr)
#|(define (expr? e)
  (match e
    [(variable s)       (symbol? s)]
    [(const n)          (number? n)]
    [(op s l r)         (and (member s '(+ *))
                             (expr? l)
                             (expr? r))]
    [(let-expr x e1 e2) (and (symbol? x)
                             (expr? e1)
                             (expr? e2))]
    [_                  false]))|#

;; podstawienie wartości (= wyniku ewaluacji wyrażenia) jako stałej w wyrażeniu
(: subst (-> Symbol Real Expr Expr))
(define (subst x v e)
  (match e
    [(op s l r)   (op s (subst x v l)
                        (subst x v r))]
    [(const n)    (const n)]
    [(variable y) (if (eq? x y)
                      (const v)
                      (variable y))]
    [(let-expr y e1 e2)
     (if (eq? x y)
         (let-expr y
                   (subst x v e1)
                   e2)
         (let-expr y
                   (subst x v e1)
                   (subst x v e2)))]))

;; (gorliwa) ewaluacja wyrażenia w modelu podstawieniowym
(: eval (-> Expr Real))
(define (eval e)
  (match e
    [(const n)    n]
    [(op '+ l r)  (+ (eval l) (eval r))]
    [(op '* l r)  (* (eval l) (eval r))]
    [(let-expr x e1 e2)
     (eval (subst x (eval e1) e2))]
    [(variable n) (error n "cannot reference an identifier before its definition ;)")]))
(: p1 Expr)
(define p1 (op '+ (const 2) (const 3)))
