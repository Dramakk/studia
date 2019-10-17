#lang racket

(define/contract (suffixes xs)
  (parametric->/c [a] (-> a (listof (listof a))))
  (if (null? xs)
      (list null)
      (cons xs (suffixes (cdr xs)))))

(define/contract (sublists xs )
  (parametric->/c [a] (-> (listof a) (listof(listof a))))
  (if (null? xs)
      (list null)
      (append-map
       (lambda (ys) (list (cons (car xs) ys) ys))
       (sublists (cdr xs)))))
;ćw 4
(define/contract (c a)
  (parametric->/c [a b] (-> a b))
  (c a)) ;nie naruszy bo nigdy nie zwróci XD
;ćw 5
(define/contract (foldl-map f a xs )
  (parametric->/c [a b c] (-> (-> a b (cons/c c b)) b (listof a) (cons/c (listof c) b)))
  (define (it a xs ys )
    (if (null? xs )
        (cons (reverse ys ) a )
        (let [(p (f (car xs ) a ) ) ]
          (it (cdr p )
              (cdr xs )
              (cons ( car p ) ys ) ) ) ) )
  (it a xs null ) )
;ćw 6
;; definicja wyrażeń z let-wyrażeniami

(struct const    (val)      #:transparent)
(struct op       (symb l r) #:transparent)
(struct let-expr (x e1 e2)  #:transparent)
(struct variable (x)        #:transparent)

(define (expr? e)
  (match e
    [(variable s)       (symbol? s)]
    [(const n)          (number? n)]
    [(op s l r)         (and (member s '(+ *))
                             (expr? l)
                             (expr? r))]
    [(let-expr x e1 e2) (and (symbol? x)
                             (expr? e1)
                             (expr? e2))]
    [_                  false]))

(define expr/c
  (flat-rec-contract expr
                     (struct/c const number?)
                     (struct/c op symbol? expr expr)
                     (struct/c let-expr symbol? expr expr)
                     (struct/c variable symbol?)))
;; podstawienie wartości (= wyniku ewaluacji wyrażenia) jako stałej w wyrażeniu

(define/contract (subst x v e)
  (-> symbol? number? expr/c expr/c)
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

(define/contract (eval e)
  (-> expr/c number?)
  (match e
    [(const n)    n]
    [(op '+ l r)  (+ (eval l) (eval r))]
    [(op '* l r)  (* (eval l) (eval r))]
    [(let-expr x e1 e2)
     (eval (subst x (eval e1) e2))]
    [(variable n) (error n "cannot reference an identifier before its definition ;)")]))