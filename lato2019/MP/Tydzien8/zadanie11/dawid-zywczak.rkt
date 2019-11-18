#lang racket
(module reprezentacja-wyklad racket
  (provide (all-defined-out))
  (struct variable (x)         #:transparent)
  (struct const    (val)       #:transparent)
  (struct op       (symb l r)  #:transparent)
  (struct let-expr (x e1 e2)   #:transparent)
  (struct if-expr  (b t e)     #:transparent)

  (define (expr? e)
    (match e
      [(variable s)       (symbol? s)]
      [(const n)          (or (number? n)
                              (boolean? n))]
      [(op s l r)         (and (member s '(+ *))
                               (expr? l)
                               (expr? r))]
      [(let-expr x e1 e2) (and (symbol? x)
                               (expr? e1)
                               (expr? e2))]
      [(if-expr b t e)    (andmap expr? (list b t e))]
      [_                  false]))

  ;; definicja instrukcji w języku WHILE

  (struct skip      ()       #:transparent) ; skip
  (struct comp      (s1 s2)  #:transparent) ; s1; s2
  (struct assign    (x e)    #:transparent) ; x := e
  (struct while     (b s)    #:transparent) ; while (b) s
  (struct if-stm    (b t e)  #:transparent) ; if (b) t else e
  (struct var-block (x e s)  #:transparent) ; var x := e in s

  (define (stm? e)
    (match e
      [(skip) true]
      [(comp s1 s2)   (and (stm? s1) (stm? s2))]
      [(assign x e)   (and (symbol? x) (expr? e))]
      [(while b s)    (and (expr? b) (stm? s))]
      [(if-stm b t e) (and (expr? b) (stm? t) (stm? e))]
      [_ false]))
  
  ;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
  ;; dwuelementowych list

  (define (lookup x xs)
    (cond
      [(null? xs)
       (error x "unknown identifier :(")]
      [(eq? (caar xs) x) (cadar xs)]
      [else (lookup x (cdr xs))]))

  ;; aktualizacja środowiska dla danej zmiennej (koniecznie już
  ;; istniejącej w środowisku!)

  (define (update x v xs)
    (cond
      [(null? xs)
       (error x "unknown identifier :(")]
      [(eq? (caar xs) x)
       (cons (list (caar xs) v) (cdr xs))]
      [else
       (cons (car xs) (update x v (cdr xs)))]))

  ;; kilka operatorów do wykorzystania w interpreterze

  (define (op-to-proc x)
    (lookup x `((+ ,+)
                (* ,*)
                (- ,-)
                (/ ,/)
                (%, modulo)
                (> ,>)
                (>= ,>=)
                (< ,<)
                (<= ,<=)
                (= ,=)
                (!= ,(lambda (x y) (not (= x y)))) 
                (&& ,(lambda (x y) (and x y)))
                (|| ,(lambda (x y) (or x y)))
                )))

  ;; interfejs do obsługi środowisk

  (define (env-empty) null)
  (define env-lookup lookup)
  (define (env-add x v env) (cons (list x v) env))
  (define env-update update)
  (define env-discard cdr)
  (define (env-from-assoc-list xs) xs)

  ;; ewaluacja wyrażeń ze środowiskiem

  (define (eval e env)
    (match e
      [(const n) n]
      [(op s l r) ((op-to-proc s) (eval l env)
                                  (eval r env))]
      [(let-expr x e1 e2)
       (let ((v1 (eval e1 env)))
         (eval e2 (env-add x v1 env)))]
      [(variable x) (env-lookup x env)]
      [(if-expr b t e) (if (eval b env)
                           (eval t env)
                           (eval e env))]))

  ;; interpretacja programów w języku WHILE, gdzie środowisko m to stan
  ;; pamięci. Interpreter to procedura, która dostaje program i początkowy
  ;; stan pamięci, a której wynikiem jest końcowy stan pamięci. Pamięć to
  ;; aktualne środowisko zawierające wartości zmiennych

  (define (interp p m)
    (match p
      [(skip) m]
      [(comp s1 s2) (interp s2 (interp s1 m))]
      [(assign x e)
       (env-update x (eval e m) m)]
      [(while b s)
       (if (eval b m)
           (interp p (interp s m))
           m)]
      [(var-block x e s)
       (env-discard
        (interp s (env-add x (eval e m) m)))]
      [(if-stm b t e) (if (eval b m)
                          (interp t m)
                          (interp e m))]))

  ;; silnia zmiennej i

  (define fact-in-WHILE
    (var-block 'x (const 0)                                           ; var x := 0 in
               (comp (assign 'x (const 1))                                    ;   x := 1
                     (comp (while (op '> (variable 'i) (const 0))                   ;   while (i > 0)
                                  (comp (assign 'x (op '* (variable 'x) (variable 'i))) ;     x := x * i
                                        (assign 'i (op '- (variable 'i) (const 1)))))   ;     i := i - 1
                           (assign 'i (variable 'x))))))                            ;   i := x

  (define (factorial n)
    (env-lookup 'i (interp fact-in-WHILE
                           (env-from-assoc-list `((i ,n))))))

  ;; najmniejsza liczba pierwsza nie mniejsza niż i

  (define find-prime-in-WHILE
    (var-block 'c (variable 'i)                                         ; var c := i in
               (var-block 'continue (const true)                                   ; var continue := true in
                          (comp
                           (while (variable 'continue)                                        ; while (continue)
                                  (var-block 'is-prime (const true)                                 ;   var is-prime := true in
                                             (var-block 'x (const 2)                                           ;   var x := 2 in
                                                        (comp
                                                         (while (op '&& (variable 'is-prime)                             ;   while (is-prime &&
                                                                    (op '< (variable 'x) (variable 'c)))             ;            x < c)
                                                                (comp (if-stm (op '= (op '% (variable 'c) (variable 'x))     ;     if (c % x =
                                                                                  (const 0))                              ;                 0)
                                                                              (assign 'is-prime (const false))               ;       is-prime := false
                                                                              (skip))                                        ;     else skip
                                                                      (assign 'x (op '+ (variable 'x) (const 1)))))          ;     x := x + 1 
                                                         (if-stm (variable 'is-prime)                                    ;   if (is-prime)
                                                                 (assign 'continue (const false))                        ;     continue := false
                                                                 (comp (assign 'continue (const true))                   ;   else continue := true
                                                                       (assign 'c (op '+ (variable 'c) (const 1))))))))) ;        c := c + 1
                           (assign 'i (variable 'c))))))                                      ; i := c

  (define (find-prime-using-WHILE n)
    (env-lookup 'i (interp find-prime-in-WHILE
                           (env-from-assoc-list `((i ,n) (is-prime ,true))))))
  (define fib-in-WHILE
    (comp
     (assign 'res (const 0))
     (var-block 'aux (const 1)
                (while (op '!= (variable 'n) (const 0))
                       (comp  (assign 'n (op '- (variable 'n) (const 1)))
                              (comp (assign 'aux (op'+ (variable 'aux) (variable 'res)))
                                    (assign 'res (op'- (variable 'aux) (variable 'res)))))))))
                           
  (define (fib-using-WHILE n)
    (env-lookup 'res (interp fib-in-WHILE
                             (env-from-assoc-list `((n ,n) (res 42))))))
  (define (gen-var s i)
    (string->symbol
     (string-append s (number->string i))))
  (define (range start stop)
    (if (>= start stop)
        null
        (cons start (range (+ start 1) stop))))
  (define (comp* . xs)
  (cond [(null? xs ) (skip) ]
        [else (comp (car xs) (apply comp* (cdr xs)))]))
  (define (incr-all-WHILE n)
    (apply comp* (map (lambda (i)
                       (assign (gen-var "x" i) (op '+ (variable (gen-var "x" i)) (const 1)))) (range 1 (+ n 1)))))
  (define (incr-all-in-WHILE n)
    (interp (incr-all-WHILE n) (env-from-assoc-list (map (lambda (i) (list (gen-var "x" i) i)) (range 1 (+ n 1)))))))

(module reprezentacja-zoptymalizowana racket
  (provide (all-defined-out))

  ;; definicja wyrażeń z let-wyrażeniami i if-wyrażeniami

  (struct variable (x)         #:transparent)
  (struct const    (val)       #:transparent)
  (struct op       (symb l r)  #:transparent)
  (struct let-expr (x e1 e2)   #:transparent)
  (struct if-expr  (b t e)     #:transparent)

  (define (expr? e)
    (match e
      [(variable s)       (symbol? s)]
      [(const n)          (or (number? n)
                              (boolean? n))]
      [(op s l r)         (and (member s '(+ *))
                               (expr? l)
                               (expr? r))]
      [(let-expr x e1 e2) (and (symbol? x)
                               (expr? e1)
                               (expr? e2))]
      [(if-expr b t e)    (andmap expr? (list b t e))]
      [_                  false]))

  ;; definicja instrukcji w języku WHILE

  (struct skip      ()       #:transparent) ; skip
  (struct comp      (s1 s2)  #:transparent) ; s1; s2
  (struct assign    (x e)    #:transparent) ; x := e
  (struct while     (b s)    #:transparent) ; while (b) s
  (struct if-stm    (b t e)  #:transparent) ; if (b) t else e
  (struct var-block (x e s)  #:transparent) ; var x := e in s

  (define (stm? e)
    (match e
      [(skip) true]
      [(comp s1 s2)   (and (stm? s1) (stm? s2))]
      [(assign x e)   (and (symbol? x) (expr? e))]
      [(while b s)    (and (expr? b) (stm? s))]
      [(if-stm b t e) (and (expr? b) (stm? t) (stm? e))]
      [_ false]))
  
  ;; wyszukiwanie wartości dla klucza na liście asocjacyjnej
  ;; dwuelementowych list

  (define (lookup x xs)
    (cond
      [(null? xs)
       (error x "unknown identifier :(")]
      [(eq? (caar xs) x) (cadar xs)]
      [else (lookup x (cdr xs))]))

  ;; aktualizacja środowiska dla danej zmiennej (koniecznie już
  ;; istniejącej w środowisku!)

  (define (update x v xs)
    (cond
      [(null? xs)
       (error x "unknown identifier :(")]
      [(eq? (caar xs) x)
       (cons (list (caar xs) v) (cdr xs))]
      [else
       (cons (car xs) (update x v (cdr xs)))]))

  ;; kilka operatorów do wykorzystania w interpreterze

  (define (op-to-proc x)
    (lookup x `((+ ,+)
                (* ,*)
                (- ,-)
                (/ ,/)
                (%, modulo)
                (> ,>)
                (>= ,>=)
                (< ,<)
                (<= ,<=)
                (= ,=)
                (!= ,(lambda (x y) (not (= x y)))) 
                (&& ,(lambda (x y) (and x y)))
                (|| ,(lambda (x y) (or x y)))
                )))

  ;; interfejs do obsługi środowisk
  (define (menv-update x v xs)
    (define (iter x v ys)
      (cond
        [(null? ys)
         (error x "unknown identifier :(")]
        [(eq? (mcar (mcar ys)) x)
         (set-mcdr! (mcar ys) v)]
        [else
         (iter x v (mcdr ys))]))
    (begin (iter x v xs)
           xs))
  (define (menv-lookup x xs)
    (cond
      [(null? xs)
       (error x "unknown identifier :(")]
      [(eq? (mcar (mcar xs)) x) (mcdr (mcar xs))]
      [else (env-lookup x (mcdr xs))]))

  (define (env-empty) null)
  ;Modyfikuję jedynie procedury dotyczące środowiska, lookup nie dotykam, ponieważ może być używany gdzieś indziej (rzeczywiście jest)
  (define env-lookup menv-lookup)
  (define (env-add x v env) (mcons (mcons x v) env))
  ;Modyfikuję jedynie procedury dotyczące środowiska, update nie dotykam, ponieważ może być używany gdzieś indziej (choć tutaj akurat nie jest)
  (define env-update menv-update)
  (define env-discard mcdr)
  ;Budujemy środowisko w postaci listy mutowalnej złożonej z mutowalnych par
  (define (env-from-assoc-list xs)
    (foldr mcons null (map (lambda (x) (mcons (car x) (car (cdr x)))) xs)))
  ;; ewaluacja wyrażeń ze środowiskiem

  (define (eval e env)
    (match e
      [(const n) n]
      [(op s l r) ((op-to-proc s) (eval l env)
                                  (eval r env))]
      [(let-expr x e1 e2)
       (let ((v1 (eval e1 env)))
         (eval e2 (env-add x v1 env)))]
      [(variable x) (env-lookup x env)]
      [(if-expr b t e) (if (eval b env)
                           (eval t env)
                           (eval e env))]))

  ;; interpretacja programów w języku WHILE, gdzie środowisko m to stan
  ;; pamięci. Interpreter to procedura, która dostaje program i początkowy
  ;; stan pamięci, a której wynikiem jest końcowy stan pamięci. Pamięć to
  ;; aktualne środowisko zawierające wartości zmiennych

  (define (interp p m)
    (match p
      [(skip) m]
      [(comp s1 s2) (interp s2 (interp s1 m))]
      [(assign x e)
       (env-update x (eval e m) m)]
      [(while b s)
       (if (eval b m)
           (interp p (interp s m))
           m)]
      [(var-block x e s)
       (env-discard
        (interp s (env-add x (eval e m) m)))]
      [(if-stm b t e) (if (eval b m)
                          (interp t m)
                          (interp e m))]))

  ;; silnia zmiennej i

  (define fact-in-WHILE
    (var-block 'x (const 0)                                           ; var x := 0 in
               (comp (assign 'x (const 1))                                    ;   x := 1
                     (comp (while (op '> (variable 'i) (const 0))                   ;   while (i > 0)
                                  (comp (assign 'x (op '* (variable 'x) (variable 'i))) ;     x := x * i
                                        (assign 'i (op '- (variable 'i) (const 1)))))   ;     i := i - 1
                           (assign 'i (variable 'x))))))                            ;   i := x

  (define (factorial n)
    (env-lookup 'i (interp fact-in-WHILE
                           (env-from-assoc-list `((i ,n))))))

  ;; najmniejsza liczba pierwsza nie mniejsza niż i

  (define find-prime-in-WHILE
    (var-block 'c (variable 'i)                                         ; var c := i in
               (var-block 'continue (const true)                                   ; var continue := true in
                          (comp
                           (while (variable 'continue)                                        ; while (continue)
                                  (var-block 'is-prime (const true)                                 ;   var is-prime := true in
                                             (var-block 'x (const 2)                                           ;   var x := 2 in
                                                        (comp
                                                         (while (op '&& (variable 'is-prime)                             ;   while (is-prime &&
                                                                    (op '< (variable 'x) (variable 'c)))             ;            x < c)
                                                                (comp (if-stm (op '= (op '% (variable 'c) (variable 'x))     ;     if (c % x =
                                                                                  (const 0))                              ;                 0)
                                                                              (assign 'is-prime (const false))               ;       is-prime := false
                                                                              (skip))                                        ;     else skip
                                                                      (assign 'x (op '+ (variable 'x) (const 1)))))          ;     x := x + 1 
                                                         (if-stm (variable 'is-prime)                                    ;   if (is-prime)
                                                                 (assign 'continue (const false))                        ;     continue := false
                                                                 (comp (assign 'continue (const true))                   ;   else continue := true
                                                                       (assign 'c (op '+ (variable 'c) (const 1))))))))) ;        c := c + 1
                           (assign 'i (variable 'c))))))                                      ; i := c

  (define (find-prime-using-WHILE n)
    (env-lookup 'i (interp find-prime-in-WHILE
                           (env-from-assoc-list `((i ,n) (is-prime ,true))))))
  (define fib-in-WHILE
    (comp
     (assign 'res (const 0))
     (var-block 'aux (const 1)
                (while (op '!= (variable 'n) (const 0))
                       (comp  (assign 'n (op '- (variable 'n) (const 1)))
                              (comp (assign 'aux (op'+ (variable 'aux) (variable 'res)))
                                    (assign 'res (op'- (variable 'aux) (variable 'res)))))))))
                           
  (define (fib-using-WHILE n)
    (env-lookup 'res (interp fib-in-WHILE
                             (env-from-assoc-list `((n ,n) (res 42))))))
  
  (define (gen-var s i)
    (string->symbol
     (string-append s (number->string i))))
  (define (range start stop)
    (if (>= start stop)
        null
        (cons start (range (+ start 1) stop))))
  (define (comp* . xs)
  (cond [(null? xs ) (skip) ]
        [else (comp (car xs) (apply comp* (cdr xs)))]))
  (define (incr-all-WHILE n)
    (apply comp* (map (lambda (i)
                       (assign (gen-var "x" i) (op '+ (variable (gen-var "x" i)) (const 1)))) (range 1 (+ n 1)))))
  (define (incr-all-in-WHILE n)
    (interp (incr-all-WHILE n) (env-from-assoc-list (map (lambda (i) (list (gen-var "x" i) i)) (range 1 (+ n 1)))))))
(require (prefix-in w: 'reprezentacja-wyklad))
(require (prefix-in o: 'reprezentacja-zoptymalizowana))
(define (find-prime-native n)
  (define (is-prime c isp x)
    (if (and isp (< x c))
      (if (= (modulo c x) 0)
          (is-prime c false (+ x 1))
          (is-prime c isp   (+ x 1)))
      isp))
  (if (is-prime n true 2)
      n
      (find-prime-native (+ n 1))))

;; testujemy, żeby dowiedzieć się, jak dużo wydajności tracimy przez
;; uruchamianie programu w naszym interpreterze

(define (test)
  (begin
    (display "Wait for find-prime proc test...\n")
    (flush-output (current-output-port))
    (test-prime)
    (display "Wait for factorial proc test...\n")
    (flush-output (current-output-port))
    (test-factorial)
    (display "Wait for incr-all proc test...\n")
    (flush-output (current-output-port))
    (test-incr-all)
    (display "Wait for Fibonacci proc test...\n")
    (flush-output (current-output-port))
    (test-fib)))

(define (test-prime)
  (let-values
      (((r1 cpu1 real1 gc1) (time-apply w:find-prime-using-WHILE (list 1111111)))
       ((r2 cpu2 real2 gc2) (time-apply find-prime-native      (list 1111111)))
       ((r3 cpu3 real3 gc3) (time-apply o:find-prime-using-WHILE (list 1111111))))
    (begin
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu1)  (display ", ")
      (display real1) (display ", ")
      (display gc1)   (display "\n")
      (display "native time (cpu, real, gc): ")
      (display cpu2)  (display ", ")
      (display real2) (display ", ")
      (display gc2)   (display "\n")
      (display "optimized time (cpu, real, gc): ")
      (display cpu3)  (display ", ")
      (display real3) (display ", ")
      (display gc3)   (display "\n"))))

(define (test-fib)
  (let-values
      (((r1 cpu1 real1 gc1) (time-apply w:fib-using-WHILE (list 100000)))
       ((r2 cpu2 real2 gc2) (time-apply o:fib-using-WHILE (list 100000))))
    (begin
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu1)  (display ", ")
      (display real1) (display ", ")
      (display gc1)   (display "\n")
      (display "optimized time (cpu, real, gc): ")
      (display cpu2)  (display ", ")
      (display real2) (display ", ")
      (display gc2)   (display "\n"))))

(define (factorial-native n)
  (define (iter i n)
    (if (= 0 n)
        i
        (iter (* i n) (- n 1))))
  (iter 1 n))

(define (test-factorial)
  (let-values
      (((r1 cpu1 real1 gc1) (time-apply w:factorial (list 10000)))
       ((r2 cpu2 real2 gc2) (time-apply factorial-native     (list 10000)))
       ((r3 cpu3 real3 gc3) (time-apply o:factorial (list 10000))))
    (begin
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu1)  (display ", ")
      (display real1) (display ", ")
      (display gc1)   (display "\n")
      (display "native time (cpu, real, gc): ")
      (display cpu2)  (display ", ")
      (display real2) (display ", ")
      (display gc2)   (display "\n")
      (display "optimized time (cpu, real, gc): ")
      (display cpu3)  (display ", ")
      (display real3) (display ", ")
      (display gc3)   (display "\n"))))

(define (incr-all n)
  (map (lambda (x) (cons (car x) (cons (+ (car (cdr x)) 1) null))) (map (lambda (i) (list (o:gen-var "x" i) i)) (o:range 1 (+ n 1)))))

(define (test-incr-all)
  (let-values
      (((r1 cpu1 real1 gc1) (time-apply w:incr-all-in-WHILE (list 1000)))
       ((r2 cpu2 real2 gc2) (time-apply incr-all     (list 1000)))
       ((r3 cpu3 real3 gc3) (time-apply o:incr-all-in-WHILE (list 1000)))
       ((r4 cpu4 real4 gc4) (time-apply w:incr-all-in-WHILE (list 10000)))
       ((r5 cpu5 real5 gc5) (time-apply incr-all     (list 10000)))
       ((r6 cpu6 real6 gc6) (time-apply o:incr-all-in-WHILE (list 10000))))
    (begin
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu1)  (display ", ")
      (display real1) (display ", ")
      (display gc1)   (display "\n")
      (display "WHILE  time (cpu, real, gc): ")
      (display cpu4)  (display ", ")
      (display real4) (display ", ")
      (display gc4)   (display "\n")
      (display "native time (cpu, real, gc): ")
      (display cpu2)  (display ", ")
      (display real2) (display ", ")
      (display gc2)   (display "\n")
      (display "native time (cpu, real, gc): ")
      (display cpu5)  (display ", ")
      (display real5) (display ", ")
      (display gc5)   (display "\n")
      (display "optimized time (cpu, real, gc): ")
      (display cpu3)  (display ", ")
      (display real3) (display ", ")
      (display gc3)   (display "\n")
      (display "optimized time (cpu, real, gc): ")
      (display cpu6)  (display ", ")
      (display real6) (display ", ")
      (display gc6)   (display "\n"))))
(test)
#| Według mnie optymalizacja ta jest jak najbardziej warta implementowania na stałe. Nie wymagała ona dużego nakładu pracy, a w przypadku programów wymagających wielu instrukcji przypisania
(takich jak np. incr-all) stanowczo poprawiła wydajność naszego interpretera, co widać w testach. W przypadku procedury szukającej liczbę pierwszą nasza optymalizacja
niewiele zmieniła, lecz to nie znaczy, że nie poprawiła nic, dlatego nawet w tym przypadku uważam iż optymalizacja była warta wykonania. 
Nawet w przypadku programu, wydaje się prostego, obliczającego n!, nasza optymalizacja dała efekt. W przypadku obliczania liczb Fibonacciego również uzyskaliśmy wzrost wydajności. Nieduży, bo w przykładowym wyniku 
jest on na poziomie ~1,3%, ale tak jak pisałem wcześniej - z uwagi na to, że optymalizacja nie wymagała dużego nakładu pracy, jest to wynik dla mnie zadowalający i jeszcze raz powtórzę, według mnie była ona warta implementowania.
Przykładowe wyniki testów:
Wait for find-prime proc test...
WHILE  time (cpu, real, gc): 3980, 3974, 53
native time (cpu, real, gc): 54, 53, 0
optimized time (cpu, real, gc): 3904, 3900, 47
Wait for factorial proc test...
WHILE  time (cpu, real, gc): 77, 77, 3
native time (cpu, real, gc): 52, 52, 1
optimized time (cpu, real, gc): 74, 74, 3
Wait for incr-all proc test...
WHILE  time (cpu, real, gc): 48, 48, 6
WHILE  time (cpu, real, gc): 4363, 4356, 535
native time (cpu, real, gc): 1, 2, 0
native time (cpu, real, gc): 8, 8, 0
optimized time (cpu, real, gc): 29, 28, 0
optimized time (cpu, real, gc): 3429, 3422, 334
Wait for Fibonacci proc test...
WHILE  time (cpu, real, gc): 828, 828, 11
optimized time (cpu, real, gc): 817, 815, 10
|#
