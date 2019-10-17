#lang typed/racket

;; definicja wyrażeń z let-wyrażeniami i if-wyrażeniami
(define-type Value (U Real Boolean))
(define-type Expr (U const op let-expr variable if-expr))
(define-type Env (Listof (List Symbol Value)));przy List mamy zadaną długośc i musimy zdefiniować typ każdego elementu
(define-predicate value? Value)
(define-predicate expr? Expr)
(struct variable ([x : Symbol])        #:transparent)
(struct const    ([val : Value])      #:transparent)
(struct op       ([symb : Symbol] [l : Expr] [r : Expr]) #:transparent)
(struct let-expr ([x : Symbol] [e1 : Expr] [e2 : Expr])  #:transparent)
(struct if-expr  ([b : Expr] [t : Expr] [e : Expr])    #:transparent)
  
;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list
(: lookup (All (a b) (-> a (Listof (List a b)) b)))
(define (lookup x xs)
  (cond
    [(null? xs)
     (error "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

;; kilka operatorów do wykorzystania w interpreterze
(: op-to-proc (-> Symbol (-> Value Value Value)))
;wyciągnąć listę : op-list (Listof (List Symbol (-> Real Real Value))
; i zrobić konwersję na Value Value Value
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
              )))

;; interfejs do obsługi środowisk
(define (env-empty) null)
(define env-lookup lookup)
(define (env-add x v env) (cons (list x v) env))

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
    [(variable x) (env-lookup x env)]
    [(if-expr b t e) (if (eval b env)
                         (eval t env)
                         (eval e env))]))

(define (run e)
  (eval e (env-empty)))

;; przykładowe wyrażenie

(define ex1
  (op '+ (const 1)
         (let-expr 'x (const 3)
                   (if-expr (op '< (variable 'x) (const 4))
                            (op '+ (const 4) (variable 'x))
                            (const true)))))
                            