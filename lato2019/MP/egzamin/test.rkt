#lang racket
(require racklog)
(define (flatten lst)
  (cond ((null? lst) '())
        ((list? lst)
         (append (flatten (car lst)) (flatten (cdr lst))))
        (else (list lst))))
(define (foldrr p nullv xs)
  (if (null? xs)
      nullv
      (p (car xs) (foldrr p nullv (cdr xs)))))
(define (foldll p nullv xs)
  (if (null? xs)
      nullv
      (foldll p (p (car xs) nullv) (cdr xs))))
(define (mreverse xs)
  (define (iter curr next)
    (if (null? next)
        curr
        (let ([new-next (mcdr next)]
              [new-curr next])
          (set-mcdr! next curr)
          (iter new-curr new-next))))
    (iter null xs))
;ewaluator
(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

(define (op-to-proc x)
  (lookup x `(
              (+ ,+)
              (* ,*)
              (- ,-)
              (/ ,/)
              (> ,>)
              (>= ,>=)
              (< ,<)
              (<= ,<=)
              (= ,=)
              (% ,modulo)
              (!= ,(lambda (x y) (not (= x y)))) 
              (&& ,(lambda (x y) (and x y)))
              (|| ,(lambda (x y) (or x y)))
              (eq? ,(lambda (x y) (eq? (val-symbol-s x)
                                       (val-symbol-s y))))
              )))

(struct blackhole () #:transparent)
(struct val-symbol (s) #:transparent)
(struct closure (x b env) #:transparent)

(struct variable (n) #:transparent)
(struct const (val) #:transparent)
(struct op (symb l r) #:transparent)
(struct let-expr (x e1 e2) #:transparent)
(struct if-expr (i t e) #:transparent)
(struct lambda-expr (x b) #:transparent)
(struct app-expr (f e) #:transparent)
(struct letrec-expr (x e1 e2)  #:transparent)
(struct letrec-mutual (x e1 y e2 e3) #:transparent)

(define empty-env null)

(define (env-add x v env) (mcons (mcons x (mcons v null)) env))

(define (env-update x v xs)
  (define (update! ys)
    (cond
      [(null? ys) (error x "unknown identifier :(")]
      [(eq? x (mcar (mcar ys)))
       (set-mcar! (mcdr (mcar ys)) v)]
      [else (update! (mcdr ys))]))
  (begin (update! xs) xs))

(define (env-lookup x env)
  (if (null? env)
      (error "Coś poszło nie tak")
      (if (equal? (mcar (mcar env)) x)
          (match (mcar (mcdr (mcar env)))
            [(blackhole) (error "Wrong hole")]
            [x x])
          (env-lookup x (mcdr env)))))
(define (eval e env)
  (match e
    [(const n) n]
    [(variable n) (env-lookup n env)]
    [(op o l r) ((op-to-proc o) (eval l env) (eval r env))]
    [(let-expr x e1 e2) (let ([v (eval e1 env)])
                        (eval e2 (env-add x v env)))]
    [(if-expr i t e) (if (eval i env)
                         (eval t env)
                         (eval e env))]
    [(lambda-expr x b) (closure x b env)]
    [(app-expr f e) (let ([vf (eval f env)]
                          [ve (eval e env)])
                      (match vf
                        [(closure x b c-env) (eval b (env-add x ve c-env))]
                        [_ (error "Pszykro")]))]
    [(letrec-expr x e1 e2) (let* ([n-env (env-add x (blackhole) env)]
                                  [v1 (eval e1 n-env)])
                             (eval e2 (env-update x v1 n-env)))]
    [(letrec-mutual x e1 y e2 e3) (let* ([n-env (env-add x (blackhole) (env-add y (blackhole) env))]
                                         [v1 (eval e1 n-env)]
                                         [v2 (eval e2 n-env)])
                                    (eval e3 (env-update x v1 (env-update y v2 n-env))))]))
(define (run e)
  (eval e empty-env))

(define p1
  (let-expr 'x (lambda-expr 'y (op '+ (variable 'y) (const 1)))
            (app-expr (variable 'x) (const 10))))

(define exp (letrec-mutual
  'odd  (lambda-expr 'x  (if-expr (op '= (variable 'x) (const 0)) (const #f) (app-expr (variable 'even) (op '- (variable 'x) (const 1)))))
  'even (lambda-expr 'x  (if-expr (op '= (variable 'x) (const 0)) (const #t) (app-expr (variable  'odd) (op '- (variable 'x) (const 1)))))
  
(app-expr (variable 'even) (const 13))))

(define (mrev xs)
  (define (loop x y)
    (if (null? x)
        y
        (let ((temp (mcdr x)))
          (set-mcdr! x y)
          (loop temp x))))
  (loop xs '()))
(define (make)
  (let ([a (mcons null null)]
        [b (mcons 1 null)]
        [c (mcons 2 3)]
        [d (mcons null null)])
    (set-mcar! a c)
    (set-mcdr! a b)
    (set-mcdr! b d)
    (set-mcar! d c)
    (set-mcdr! d b)
    a))

;zadanie 7 egzamin poprawkowy
(define (set-singleton x)
  (set x))
(struct s-expr (s) #:transparent)
(struct eadd (e1 e2) #:transparent)
(struct emult (e1 e2) #:transparent)
(struct e<=n (e n) #:transparent)
(define (expr? e)
  (or (s-expr? e) (eadd? e) (emult? e) (e<=n? e)))
(define (eval2 e)
  (match e
    [(s-expr s) (set s)]
    [(eadd e1 e2) (set-union (eval2 e1) (eval2 e2))]
    [(emult e1 e2) (flatten (set-map (eval2 e1) (lambda (x) (set-map (eval2 e2) (lambda (y) (set-union (set x) (set y)))))))]))
;racklog
(define %sorted
  (%rel (x y zs)
   [(null)]
   [((cons x null))]
   [((cons x (cons y zs)))
    (%<= x y)
    (%sorted (cons y zs))]))
(define %select
  (%rel (x y xs ys)
        [(x (cons x xs) xs)]
        [(y (cons x xs) (cons x ys))
         (%select y xs ys)]))
(define %permutation
  (%rel (x xs zs ys)
        [(null null)]
        [((cons x xs) ys)
         (%permutation xs zs)
         (%select x ys zs)]))
(define %permutation-sort
  (%rel (L S)
        [(L S)
         (%permutation L S)
         (%sorted S)]))
(define %rev-app
  (%rel (y zs x ys xs)
       [(null y y)]
       [((cons x xs) ys zs)
        (%rev-app xs (cons x ys) zs)]))
(define %rev
  (%rel (xs ys)
        [(xs ys)
         (%rev-app xs null ys)]))
;kontrakt zależny
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
       (< (dist x (square result)) 0.0001))
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

;merge in racklog
(define %merge
  (%rel (xs x y ys zs)
        [(null xs xs)]
        [(xs null xs)]
        [((cons x xs) (cons y ys) (cons x zs))
         (%<= x y)
         (%merge xs (cons y ys) zs)]
        [((cons x xs) (cons y ys) (cons y zs))
         (%> x y)
         (%merge (cons x xs) ys zs)]))
(define %split
  (%rel (x y xs ys zs)
        [(null null null)]
        [((cons x null) (cons x null) null)]
        [((cons x (cons y zs)) (cons x xs) (cons y ys))
         (%split zs xs ys)]))
(define %merge-sort
  (%rel (x xs y ys L1 L2 SL1 SL2)
        [(null null)]
        [((cons x null) (cons x null))]
        [((cons x (cons y xs)) ys)
         (%split (cons x (cons y xs)) L1 L2)
         (%merge-sort L1 SL1)
         (%merge-sort L2 SL2)
         (%merge SL1 SL2 ys)]))

;kontrakt dla append
(define/contract (append2 xs ys)
  (parametric->/c [a b] (-> (listof a) (listof b) (listof (or/c a b))))
  (if (null? xs)
      ys
      (cons (car xs) (append2 (cdr xs) ys))))