#lang racket
(require rackunit)
(require rackunit/text-ui)
;; definicja wyrażeń

(struct variable     (x)        #:transparent)
(struct const        (val)      #:transparent)
(struct op           (symb l r) #:transparent)
(struct let-expr     (x e1 e2)  #:transparent)
(struct if-expr      (b t e)    #:transparent)
(struct cons-expr    (l r)      #:transparent)
(struct car-expr     (p)        #:transparent)
(struct cdr-expr     (p)        #:transparent)
(struct pair?-expr   (p)        #:transparent)
(struct null-expr    ()         #:transparent)
(struct null?-expr   (e)        #:transparent)
(struct symbol-expr  (v)        #:transparent)
(struct symbol?-expr (e)        #:transparent)
(struct lambda-expr  (xs b)     #:transparent)
(struct app-expr     (f es)     #:transparent)
(struct apply-expr   (f e)      #:transparent)

(define (expr? e)
  (match e
    [(variable s)       (symbol? s)]
    [(const n)          (or (number? n)
                            (boolean? n))]
    [(op s l r)         (and (member s '(+ * - / > >= < <= = eq?))
                             (expr? l)
                             (expr? r))]
    [(let-expr x e1 e2) (and (symbol? x)
                             (expr? e1)
                             (expr? e2))]
    [(if-expr b t e)    (andmap expr? (list b t e))]
    [(cons-expr l r)    (andmap expr? (list l r))]
    [(car-expr p)       (expr? p)]
    [(cdr-expr p)       (expr? p)]
    [(pair?-expr p)     (expr? p)]
    [(null-expr)        true]
    [(null?-expr p)     (expr? p)]
    [(symbol-expr v)    (symbol? v)]
    [(symbol?-expr p)   (expr? p)]
    [(lambda-expr xs b) (and (list? xs)
                             (andmap symbol? xs)
                             (expr? b)
                             (not (check-duplicates xs)))]
    [(app-expr f es)    (and (expr? f)
                             (list? es)
                             (andmap expr? es))]
    [(apply-expr f e)   (and (expr? f)
                             (expr? e))]
    [_                  false]))

;; wartości zwracane przez interpreter

(struct val-symbol (s)   #:transparent)
;; definicja domknięcia do którego wylicza się (lambda-expr xs b)
(struct closure (args b env))

(define (my-value? v)
  (or (number? v)
      (boolean? v)
      (and (pair? v)
           (my-value? (car v))
           (my-value? (cdr v)))
      ; null-a reprezentujemy symbolem (a nie racketowym
      ; nullem) bez wyraźnej przyczyny
      (and (symbol? v) (eq? v 'null))
      (and (val-symbol? v) (symbol? (val-symbol-s v)))
      (and (closure? v)
           (list? (closure-args v))
           (andmap symbol? (closure-args v))
           (expr? (closure-b v))
           (env? (closure-env v)))))

;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
;; dwuelementowych list

(define (lookup x xs)
  (cond
    [(null? xs)
     (error x "unknown identifier :(")]
    [(eq? (caar xs) x) (cadar xs)]
    [else (lookup x (cdr xs))]))

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
              (eq? ,(lambda (x y) (eq? (val-symbol-s x)
                                       (val-symbol-s y))))
              )))

;; interfejs do obsługi środowisk

(define (env-empty) null)
(define env-lookup lookup)
(define (env-add x v env) (cons (list x v) env))

(define (env? e)
  (and (list? e)
       (andmap (lambda (xs) (and (list? xs)
                                 (= (length xs) 2)
                                 (symbol? (first xs)))) e)))

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
    [(lambda-expr xs b) (closure xs b env)]
    [(app-expr f es) (let ((vf (eval f env))
                           (arg-vals (map (lambda (x) (eval x env)) es)))
                       (match vf
                         [(closure args b e)
                          (let ((new-env (join args arg-vals e)))
                            (eval b new-env))]
                         [_ (error "application: not a function")]))]
    [(apply-expr f e) (let ((vf (eval f env))
                            (arg-vals (create-from-abstract e env)))
                        (match vf
                         [(closure args b e)
                          (let ((new-env (join args arg-vals e)))
                            (eval b new-env))]
                         [_ (error "application: not a function")]))]))

;funkcja pomocnicza tworząca środowisko wykonawcze funckji z wieloma argumentami
;kojarzymy wartości z listy argumentów z nazwami argumentów formalnych i dodajemy je do środowiska
(define (join xs ys env)
    (cond [(and (null? xs) (null? ys)) env]
          [(null? ys) (error "application: given less arguments than expected")]
          [(null? xs) (error "application: given too many arguments")]
          [else (join (cdr xs) (cdr ys) (env-add (car xs) (car ys) env))]))

;konwersja dla łatwiejszej pracy
;funkcja tworzy listę Racketową z listy w składni abstrakcyjnej naszego języka
(define (create-from-abstract xs env)
  (define (iter xs)
    (if (equal? xs 'null)
        null
        (cons (car xs) (iter (cdr xs)))))
  (iter (eval xs env)))

(define (run e)
  (eval e (env-empty)))

(define app-expr-tests
  (test-suite "Testy interpretacji app-expr"
              (test-case "Zwykła aplikacja"
                         (check-equal? (run (app-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y))) (list (const 10) (op '+ (const 1) (const 3))))) 14))
              (test-case "Zbyt mała liczba argumentów"
                         ;oczekujemy na błąd
                         (check-exn
                          exn:fail?
                          (lambda () (run (app-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y))) (list (op '+ (const 1) (const 3))))))))
              (test-case "Zbyt duża liczba argumentów"
                         ;oczekujemy na błąd
                         (check-exn
                          exn:fail?
                          (lambda () (run (app-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y))) (list (const 10) (const 12) (op '+ (const 1) (const 3))))))))
              (test-case "Zwykła aplikacja 2"
                         (check-equal? (run (app-expr (lambda-expr '(a b c d) (if-expr (op '= (variable 'a) (variable 'b))
                                                                                       (op '* (variable 'a) (variable 'b))
                                                                                       (op '+ (variable 'c) (variable 'd))))
                                                      (list (op '+ (const 2) (const 4)) (op '* (const 2) (const 3)) (const 1) (const 2)))) 36))))

(define lambda-expr-tests
  (test-suite "Testy interpretacji lambda-expr"
              (test-case "Test 1"
                         (check-match (run (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y))))
                                      (closure '(x y) _ '())))
              (test-case "Test 2"
                         (check-match (run (lambda-expr '(x) (op '+ (variable 'x) (const 2))))
                                      (closure '(x) _ '())))
              (test-case "Test 3"
                         (check-match (run (lambda-expr '(x y z) (op '+ (variable 'x) (op '+ (variable 'y) (variable 'z)))))
                                      (closure '(x y z) _ '())))
              (test-case "Test 4"
                         (check-match (run (lambda-expr '(a b c d) (if-expr (op '= (variable 'a) (variable 'b))
                                                                                       (op '* (variable 'a) (variable 'b))
                                                                                       (op '+ (variable 'c) (variable 'd)))))
                                       (closure '(a b c d) _ '())))))
                

(define apply-expr-tests
  (test-suite "Testy interpretacji apply-expr"
              (test-case "Zwykła aplikacja"
                         (check-equal? (run (apply-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y)))
                                                      (cons-expr (const 10) (cons-expr (op '+ (const 1) (const 3)) (null-expr))))) 14))
              (test-case "Zbyt mała liczba argumentów"
                         ;oczekujemy na błąd
                         (check-exn
                          exn:fail?
                          (lambda () (run (apply-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y)))
                                                    (cons-expr (op '+ (const 1) (const 3)) (null-expr)))))))
              (test-case "Zbyt duża liczba argumentów"
                         ;oczekujemy na błąd
                         (check-exn
                          exn:fail?
                          (lambda () (run (apply-expr (lambda-expr '(x y) (op '+ (variable 'x) (variable 'y)))
                                                    (cons-expr (const 10) (cons-expr (op '+ (const 1) (const 3)) (cons-expr (const 12) (null-expr)))))))))
              (test-case "Zwykła aplikacja 2"
                         (check-equal? (run (apply-expr (lambda-expr '(a b c d) (if-expr (op '= (variable 'a) (variable 'b))
                                                                                       (op '* (variable 'a) (variable 'b))
                                                                                       (op '+ (variable 'c) (variable 'd))))
                                                      (cons-expr (op '+ (const 2) (const 4)) (cons-expr (op '* (const 2) (const 3))
                                                                                                        (cons-expr (const 1) (cons-expr (const 2) (null-expr)))))))
                                                      36))))
(run-tests lambda-expr-tests)
(run-tests app-expr-tests)
(run-tests apply-expr-tests)
