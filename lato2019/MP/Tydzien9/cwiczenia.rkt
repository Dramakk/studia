#lang racket
(provide (all-defined-out))

;; definicja wyrażeń

(struct variable     (n)        #:transparent)
(struct const        (val)      #:transparent)
(struct op           (symb l r) #:transparent)
(struct let-expr     (e1 e2)  #:transparent)
(struct letrec-expr  (e1 e2)  #:transparent)
(struct if-expr      (b t e)    #:transparent)
(struct cons-expr    (l r)      #:transparent)
(struct car-expr     (p)        #:transparent)
(struct cdr-expr     (p)        #:transparent)
(struct pair?-expr   (p)        #:transparent)
(struct null-expr    ()         #:transparent)
(struct null?-expr   (e)        #:transparent)
(struct symbol-expr  (v)        #:transparent)
(struct symbol?-expr (e)        #:transparent)
(struct lambda-expr  (b)      #:transparent)
(struct app-expr     (f e)      #:transparent)
(struct set!-expr    (n v)      #:transparent)

;; wartości zwracane przez interpreter

(struct val-symbol (s)   #:transparent)
(struct closure (b e)  #:transparent) ; Racket nie jest transparentny w tym miejscu,
                         ; to my też nie będziemy XD
(struct blackhole ()) ; lepiej tzrymać się z daleka!

;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list

(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

(define (mlookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (mcar (mcar xs)) x)
     (match (mcar (mcdr (mcar xs)))
       [(blackhole) (error "Stuck in a black hole :(")]
       [x x])]
    [else (mlookup x (mcdr xs))]))

(define (mupdate! x v xs)
  (define (update! ys)
    (cond
      [(null? ys) (error x "unknown identifier :(")]
      [(eq? x (mcar (mcar ys)))
       (set-mcar! (mcdr (mcar ys)) v)]
      [else (update! (mcdr ys))]))
  (begin (update! xs) xs))

;; kilka operatorów do wykorzystania w interpreterze

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

;; interfejs do obsługi środowisk

(define (env-empty) null)
(define (env-lookup n xs)
  (cond
    [(null? xs)
     (error "unknown identifier :(")]
    [(= n 0)
     (match (mcar xs)
       [(blackhole) (error "Stuck in a black hole :(")]
       [x x])]
    [else (env-lookup (- n 1) (mcdr xs))]))

(define (env-add x v env)
  (mcons (mcons x (mcons v null)) env))
(define env-update! mupdate!)

;; interpretacja wyrażeń

(define (eval e env)
  (match e
    [(const n) n]
    [(op s l r)
     ((op-to-proc s) (eval l env)
                     (eval r env))]
    [(let-expr x e1 e2)
     (let ((v1 (eval e1 env)))
       (eval e2 (env-add x v1 env)))]
    [(letrec-expr x e1 e2)
     (let* ((new-env (env-add x (blackhole) env))
            (v1 (eval e1 new-env)))
       (eval e2 (env-update! x v1 new-env)))]
    [(variable x) (env-lookup x env)]
    [(if-expr b t e) (if (eval b env)
                         (eval t env)
                         (eval e env))]
    [(cons-expr l r)
     (let ((vl (eval l env))
           (vr (eval r env)))
       (cons vl vr))]
    [(car-expr p)      (car (eval p env))]
    [(cdr-expr p)      (cdr (eval p env))]
    [(pair?-expr p)    (pair? (eval p env))]
    [(null-expr)       'null]
    [(null?-expr e)    (eq? (eval e env) 'null)]
    [(symbol-expr v)   (val-symbol v)]
    [(lambda-expr x b) (closure x b env)]
    [(app-expr f e)    (let ((vf (eval f env))
                             (ve (eval e env)))
                         (match vf
                           [(closure x b c-env)
                            (eval b (env-add x ve c-env))]
                           [_ (error "application: not a function :(")]))]
    [(set!-expr x e)
     (env-update! x (eval e env) env)]
    ))

(define (run e)
  (eval e (env-empty)))

;; przykład

(define fact-in-expr
  (letrec-expr 'fact (lambda-expr 'n
     (if-expr (op '= (const 0) (variable 'n))
              (const 1)
              (op '* (variable 'n)
                  (app-expr (variable 'fact)
                            (op '- (variable 'n)
                                   (const 1))))))
     (app-expr (variable 'fact)
               (const 5))))

;(let (x 5) (lambda (z) (let (y 5) (+ x y z))))
(define example1
	(let-expr 'x (const 5)
		(lambda-expr 'x
			(let-expr 'y (const 5)
				(op '+ (variable 'x) (variable 'z))))))

(define example2
  (app-expr (lambda-expr 'x
                         (lambda-expr 'y
                                      (op '+ (variable 'x) (variable 'y)))) (const 10)))

;(print (eval example1 (env-empty)))
;;zadanie2
(define (reverse xs)
  (define (rev-app ys acc)
    (if (null? ys)
        acc
        (rev-app (cdr ys) (cons (car ys) acc))))
  (rev-app xs '()))

(define reverse-expr
  (letrec-expr 'rev-app
               (lambda-expr 'ys (lambda-expr 'acc (if-expr (null?-expr (variable 'ys))
                                                             (variable 'acc)
                                                             (app-expr (app-expr (variable 'rev-app) (cdr-expr (variable 'ys)))
                                                                       (cons-expr (car-expr (variable 'ys)) (variable 'acc))))))
               (lambda-expr 'xs (app-expr (app-expr (variable 'rev-app) (variable 'xs)) (null-expr)))))
(define list123-expr
   (cons-expr (const 1) (cons-expr (const 2) (cons-expr (const 3) (null-expr)))))
(define (reverse-test)
  (eval (app-expr reverse-expr list123-expr) (env-empty)))
                          
(print (reverse-test))
;map
(define map-expr
	(letrec-expr 'map
		(lambda-expr 'f (lambda-expr 'xs
		(if-expr (null?-expr (variable 'xs))
			(null-expr)
			(cons-expr
				(app-expr (variable 'f) (car-expr (variable 'xs)))
				(app-expr
(app-expr (variable 'map) (variable 'f))
	(cdr-expr (variable 'xs)))))))
		'map))
;z3
;map na środowisku żeby usunąć zmienne wolne
;z4
#|jednocześnie sprawdzamy równość strukturalną
;napotkamy na zmienne to generujemy sobie nazwy zmiennych
np (lambda (x) (+ x y))
   (lambda (y) (+ y z))
idąc zmieniamy sobie x i y na jakieś g1
i zapamiętujemy jak zamieniamy
ale tylko zmienne związane
wtedy (lambda (g1) (+ g1 y))
      (lambda (g1) (+ g1 z))
|#


;z5
#|środowisko może być po prostu listą wartości|#