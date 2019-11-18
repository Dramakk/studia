#lang racket
(require rackunit)
(require rackunit/text-ui)
;; procedury pomocnicze
(define (tagged-tuple? tag len x)
  (and (list? x)
       (=   len (length x))
       (eq? tag (car x))))

(define (tagged-list? tag x)
  (and (pair? x)
       (eq? tag (car x))
       (list? (cdr x))))

;; reprezentacja formuł w CNFie
;; zmienne
(define (var? x)
  (symbol? x))

(define (var x)
  x)

(define (var-name x)
  x)

(define (var<? x y)
  (symbol<? x y))

;; literały
(define (lit pol var)
  (list 'lit pol var))

(define (pos x)
  (lit true (var x)))

(define (neg x)
  (lit false (var x)))

(define (lit? x)
  (and (tagged-tuple? 'lit 3 x)
       (boolean? (second x))
       (var? (third x))))

(define (lit-pol l)
  (second l))

(define (lit-var l)
  (third l))

;; klauzule
(define (clause? c)
  (and (tagged-list? 'clause c)
       (andmap lit? (cdr c))))

(define (clause . lits)
  (cons 'clause lits))

(define (clause-lits c)
  (cdr c))

(define (cnf? f)
  (and (tagged-list? 'cnf f)
       (andmap clause? (cdr f))))

(define (cnf . clauses)
  (cons 'cnf clauses))

(define (cnf-clauses f)
  (cdr f))

;; definicja rezolucyjnych drzew wyprowadzenia
(define (axiom? p)
  (tagged-tuple? 'axiom 2 p))

(define (axiom c)
  (list 'axiom c))

(define (axiom-clause a)
  (second a))

(define (res? p)
  (tagged-tuple? 'resolve 4 p))

(define (res x pf-pos pf-neg)
  (list 'resolve x pf-pos pf-neg))

(define (res-var p)
  (second p))
(define (res-proof-pos p)
  (third p))
(define (res-proof-neg p)
  (fourth p))

(define (proof? p)
  (or (and (axiom? p)
           (clause? (axiom-clause p)))
      (and (res? p)
           (var? (res-var p))
           (proof? (res-proof-pos p))
           (proof? (res-proof-neg p)))))
(define (proof-result pf prop-cnf)
  (define (make-resolvent var c1 c2)
    (if (or (eq? c1 #f) (eq? c2 #f))
        #f ;;coś poszło nie tak w dowodzie, propaguje #f wyżej
        (let ([pos (find-lit var (clause-lits c1))]
              [neg (find-lit var (clause-lits c2))])
          (if (and (eq? (lit-pol neg) #f) (eq? (lit-pol pos) #t))
              (cons 'clause (remove-duplicates (append (filter (lambda (x) (not (equal? x pos))) (clause-lits c1))
                                                       (filter (lambda (x) (not (equal? x neg))) (clause-lits c2))) equal?))
              #f))))
  (define (find-lit var cl)
    (if (null? cl)
        null
        (let* ([first (car cl)])
          (if (eq? var (lit-var first))
              first
              (find-lit var (cdr cl))))))
  (define (find-clause cl prop-list)
    (if (null? prop-list)
        #f ;;pusta lista klauzul
        (if (equal? cl (car prop-list))
            (car prop-list)
            (find-clause cl (cdr prop-list)))))
  ;;ciało funkcji proof result
  (if (or (null? pf) (null? prop-cnf))
      #f ;;brak dowodu lub zbioru klauzul do sprawdzenia
      (cond [(axiom? pf) (find-clause (axiom-clause pf) (cnf-clauses prop-cnf))]
            [(res? pf)
             (let ([pos (res-proof-pos pf)]
                   [neg (res-proof-neg pf)])
               (make-resolvent (res-var pf) (proof-result pos prop-cnf) (proof-result neg prop-cnf)))]
            [else null])))

(define (check-proof? pf prop)
  (let ((c (proof-result pf prop)))
    (and (clause? c)
         (null? (clause-lits c)))))
;; XXX: Zestaw testów do zadania pierwszego
(define proof-result-tests
  (test-suite
   "Testy procedury proof-result"
   (test-case "Przykładowy dowód z zadania"
              (let ((d '(resolve q
                                 (resolve p (axiom (clause (lit #t p ) (lit #t q ) ) )
                                          (axiom (clause (lit #f p ) (lit #t q ) ) ) )
                                 (resolve r (axiom (clause  (lit #f q ) (lit #t r ) ) )
                                          (axiom (clause (lit #f q ) (lit #f r ) ) ) ) ))
                    (cnf-cl '(cnf (clause (lit #f p ) (lit #t q ) )
                                  (clause (lit #t p ) (lit #t q ) )
                                  (clause (lit #f q ) (lit #t r ) )
                                  (clause (lit #f q ) (lit #f r ) ) )))
                (check-equal? (proof-result d cnf-cl) (clause))))
   (test-case "Dowód ze złą strukturą"
              (let ((d '(resolve r
                                 (resolve p
                                          (resolve q
                                                   (axiom (clause (lit #f p) (lit #t q)))
                                                   (axiom (clause (lit #f q) (lit #t r))))
                                          (axiom (clause (lit #t p)))
                                          )
                                 (axiom (clause (lit #f r)))))
                    (cnf-cl '(cnf (clause (lit #f p) (lit #t q))
                                  (clause (lit #f q) (lit #t r))
                                  (clause (lit #t p))
                                  (clause (lit #f r)))))
                (check-equal? (proof-result d cnf-cl) #f)))
   (test-case "Poprzedni dowód z poprawioną strukturą"
              (let ((d '(resolve r
                                 (resolve p
                                          (axiom (clause (lit #t p)))
                                          (resolve q
                                                   (axiom (clause (lit #f p) (lit #t q)))
                                                   (axiom (clause (lit #f q) (lit #t r))))
                                          )
                                 (axiom (clause (lit #f r)))))
                    (cnf-cl '(cnf (clause (lit #f p) (lit #t q))
                                  (clause (lit #f q) (lit #t r))
                                  (clause (lit #t p))
                                  (clause (lit #f r)))))
                (check-equal? (proof-result d cnf-cl) (clause))))
   (test-case "Dowód korzystający z klauzul spoza zbioru"
              (let ((d '(resolve q (axiom (clause (lit #t q)))
                                 (axiom (clause (lit #f p)))))
                    (cnf-cl '(cnf (clause (lit #f q))
                                  (clause (lit #t q)))))
                (check-equal? (proof-result d cnf-cl) #f)))
   (test-case "Dowód dla zbioru z jedną klauzulą" ;;Zbiór nie jest sprzeczny
              (let ((d '(resolve q (axiom (clause (lit #t q) (lit #f q)))
                                 (axiom (clause (lit #t q) (lit #f q)))))
                    (cnf-cl '(cnf (clause (lit #t q) (lit #f q))
                                  )))
                (check-equal? (proof-result d cnf-cl) #f)))
   (test-case "Dowód dla axiom" ;;Zbiór sprzeczny
              (let ((d '(resolve q
                                 (axiom (clause (lit #t q)))
                                 (axiom (clause (lit #f q)))))
                    (cnf-cl '(cnf (clause (lit #t q))
                                  (clause (lit #f q)))))
                (check-equal? (proof-result d cnf-cl) (clause))))
   (test-case "Wyprowadzenie klauzuli"
              (check-equal? (proof-result '(resolve p (axiom (clause (lit #t p) (lit #t q)))
                                                     (axiom (clause (lit #f p) (lit #t q))))
                                           '(cnf (clause (lit #t p) (lit #t q))
                                                 (clause (lit #f p) (lit #t q)))) '(clause (lit #t q))))))
(run-tests proof-result-tests)
;; Wewnętrzna reprezentacja klauzul
(define (sorted? ord? xs)
  (or (null? xs)
      (null? (cdr xs))
      (and (ord? (car xs)
                 (cadr xs))
           (sorted? ord? (cdr xs)))))

(define (sorted-varlist? xs)
  (and (andmap var? xs)
       (sorted? var<? xs)))

(define (res-clause pos neg pf)
  (list 'res-clause pos neg pf))

(define (res-clause-pos rc)
  (second rc))
(define (res-clause-neg rc)
  (third rc))
(define (res-clause-proof rc)
  (fourth rc))

(define (res-clause? p)
  (and (tagged-tuple? 'res-clause 4 p)
       (sorted-varlist? (second p))
       (sorted-varlist? (third  p))
       (proof? (fourth p))))

;; implementacja zbiorów / kolejek klauzul do przetworzenia

(define clause-set-empty
  '(stop () ()))

(define (clause-set-add rc rc-set)
  (define (eq-cl? sc)
    (and (equal? (res-clause-pos rc)
                 (res-clause-pos sc))
         (equal? (res-clause-neg rc)
                 (res-clause-neg sc))))
  (define (add-to-stopped sset)
    (let ((procd  (cadr  sset))
          (toproc (caddr sset)))
      (cond
        [(null? procd) (list 'stop (list rc) '())]
        [(or (memf eq-cl? procd)
             (memf eq-cl? toproc))
         sset]
        [else (list 'stop procd (cons rc toproc))])))
  (define (add-to-running rset)
    (let ((pd  (second rset))
          (tp  (third  rset))
          (cc  (fourth rset))
          (rst (fifth  rset)))
      (if (or (memf eq-cl? pd)
              (memf eq-cl? tp)
              (eq-cl? cc)
              (memf eq-cl? rst))
          rset
          (list 'run pd tp cc (cons rc rst)))))
  (if (eq? 'stop (car rc-set))
      (add-to-stopped rc-set)
      (add-to-running rc-set)))

(define (clause-set-done? rc-set)
  (and (eq? 'stop (car rc-set))
       (null? (caddr rc-set))))

(define (clause-set-next-pair rc-set)
  (define (aux rset)
    (let* ((pd  (second rset))
           (tp  (third  rset))
           (nc  (car tp))
           (rtp (cdr tp))
           (cc  (fourth rset))
           (rst (fifth  rset))
           (ns  (if (null? rtp)
                    (list 'stop (cons cc (cons nc pd)) rst)
                    (list 'run  (cons nc pd) rtp cc rst))))
      (cons cc (cons nc ns))))
  (if (eq? 'stop (car rc-set))
      (let ((pd (second rc-set))
            (tp (third  rc-set)))
        (aux (list 'run '() pd (car tp) (cdr tp))))
      (aux rc-set)))

(define (clause-set-done->clause-list rc-set)
  (and (clause-set-done? rc-set)
       (cadr rc-set)))

;; konwersja z reprezentacji wejściowej na wewnętrzną

(define (clause->res-clause cl)
  (let ((pos (filter-map (lambda (l) (and (lit-pol l) (lit-var l)))
                         (clause-lits cl)))
        (neg (filter-map (lambda (l) (and (not (lit-pol l)) (lit-var l)))
                         (clause-lits cl)))
        (pf  (axiom cl)))
    (res-clause (sort pos var<?) (sort neg var<?) pf)))

;; tu zdefiniuj procedury pomocnicze, jeśli potrzebujesz
(define (insert xs n ord?)
  (cond
    ((null? n) (list xs))
    ((null? xs) (list n))
    ((ord? n (car xs)) (cons n xs))
    (else (cons (car xs) (insert (cdr xs) n ord?)))))
(define (insert-sort xs ord?)
  (cond
    ((null? xs) null)
    (else (insert (insert-sort (cdr xs) ord?) (car xs) ord?))))
(define (find-lit-2 pos negs)
  (define (aux var lits)
    (if (null? lits)
        #f
        (if (equal? var (car lits))
            var
            (aux var (cdr lits)))))
  (if (null? pos)
      #f
      (let ([first (car pos)])
        (if (aux first negs)
            first
            (find-lit-2 (cdr pos) negs)))))
(define (rc-trivial? rc)
  (let ([pos (res-clause-pos rc)]
        [neg (res-clause-neg rc)])
    (cond [(and (null? pos) (null? neg)) #f]
          [(eq? (not (find-lit-2 pos neg)) #f) #t]
          [else #f])))

(define (rc-resolve rc1 rc2)
  (let* ([pos-rc1 (res-clause-pos rc1)]
         [neg-rc1 (res-clause-neg rc1)]
         [pos-rc2 (res-clause-pos rc2)]
         [neg-rc2 (res-clause-neg rc2)]
         [lit-rc1 (find-lit-2 pos-rc1 neg-rc2)]
         [lit-rc2 (find-lit-2 pos-rc2 neg-rc1)])
    (cond [(and (eq? lit-rc1 #f) (eq? lit-rc2 #f)) #f]
          [(eq? lit-rc1 #f) (let* ([resolv-pos (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc2))) pos-rc1)
                                                                    (filter (lambda (x) (not (equal? x lit-rc2))) pos-rc2)) var<?)]
                                   [resolv-neg (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc2))) neg-rc1)
                                                                    (filter (lambda (x) (not (equal? x lit-rc2))) neg-rc2)) var<?)]
                                   [resolv-cpos (res-clause-proof rc2)]
                                   [resolv-cneg (res-clause-proof rc1)]
                                   [resolv-pf (res lit-rc2 resolv-cpos resolv-cneg)])
                              (res-clause resolv-pos resolv-neg resolv-pf))]
          [(eq? lit-rc2 #f) (let* ([resolv-pos (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc1))) pos-rc1)
                                                                    (filter (lambda (x) (not (equal? x lit-rc1))) pos-rc2)) var<?)]
                                   [resolv-neg (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc1))) neg-rc1)
                                                                    (filter (lambda (x) (not (equal? x lit-rc1))) neg-rc2)) var<?)]
                                   [resolv-cpos (res-clause-proof rc1)]
                                   [resolv-cneg (res-clause-proof rc2)]
                                   [resolv-pf (res lit-rc1 resolv-cpos resolv-cneg)])
                              (res-clause resolv-pos resolv-neg resolv-pf))]
          [(and (not (eq? lit-rc1 #f)) (not (eq? lit-rc2 #f))) (let* ([resolv-pos (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc1))) pos-rc1)
                                                                                                       (filter (lambda (x) (not (equal? x lit-rc1))) pos-rc2)) var<?)]
                                                                      [resolv-neg (insert-sort (append (filter (lambda (x) (not (equal? x lit-rc1))) neg-rc1)
                                                                                                       (filter (lambda (x) (not (equal? x lit-rc1))) neg-rc2)) var<?)]
                                                                      [resolv-cpos (res-clause-proof rc1)]
                                                                      [resolv-cneg (res-clause-proof rc2)]
                                                                      [resolv-pf (res lit-rc1 resolv-cpos resolv-cneg)])
                                                                 (res-clause resolv-pos resolv-neg resolv-pf))]
          [else #f]))
  )

(define (fixed-point op start)
  (let ((new (op start)))
    (if (eq? new false)
        start
        (fixed-point op new))))

(define (cnf->clause-set f)
  (define (aux cl rc-set)
    (clause-set-add (clause->res-clause cl) rc-set))
  (foldl aux clause-set-empty (cnf-clauses f)))

(define (get-empty-proof rc-set)
  (define (rc-empty? c)
    (and (null? (res-clause-pos c))
         (null? (res-clause-neg c))))
  (let* ((rcs (clause-set-done->clause-list rc-set))
         (empty-or-false (findf rc-empty? rcs)))
    (and empty-or-false
         (res-clause-proof empty-or-false))))

(define (improve rc-set)
  (if (clause-set-done? rc-set)
      false
      (let* ((triple (clause-set-next-pair rc-set))
             (c1     (car  triple))
             (c2     (cadr triple))
             (rc-set (cddr triple))
             (c-or-f (rc-resolve c1 c2)))
        (if (and c-or-f (not (rc-trivial? c-or-f)))
            (clause-set-add c-or-f rc-set)
            rc-set))))

(define (prove cnf-form)
  (let* ((clauses (cnf->clause-set cnf-form))
         (sat-clauses (fixed-point improve clauses))
         (pf-or-false (get-empty-proof sat-clauses)))
    (if (eq? pf-or-false false)
        'sat
        (list 'unsat pf-or-false))))
;; XXX: Zestaw testów do zadania drugiego
(define find-lit-2-tests
  (test-suite "Testy procedury pomocniczej znajdującej literały do rezolucji"
              (test-case "Zwykła sytuacja"
                         (let* ([ress (clause->res-clause '(clause (lit #f p) (lit #t q) (lit #f q) (lit #t r)))]
                                [pos (res-clause-pos ress)]
                                [neg (res-clause-neg ress)])
                           (check-equal? (find-lit-2 pos neg)
                                         'q)))
              (test-case "Brak możliwej rezolucji"
                         (let* ([ress (clause->res-clause '(clause (lit #f p) (lit #t q)))]
                                [pos (res-clause-pos ress)]
                                [neg (res-clause-neg ress)])
                           (check-equal? (find-lit-2 pos neg)
                                         #f)))))
(define rc-trivial-tests
  (test-suite "Testy rc-trivial"
              (test-case "Klauzula pusta"
                         (let ([x (res-clause '() '() '())])
                           (check-equal? (rc-trivial? x) #f)))
              (test-case "Klauzula p v ~p"
                         (let ([x (clause->res-clause '(clause (lit #t p) (lit #f p)))])
                           (check-equal? (rc-trivial? x) #t)))))
(define rc-resolve-tests
  (test-suite "Testy rc-trivial"
              (test-case "Dwie klauzule"
                         (let ([x (res-clause '(q) '(p) '())]
                               [y (res-clause '(p) '(q) '())])
                           (check-equal? (rc-resolve x y) (res-clause '(p) '(p) '(resolve q () ())))))
              (test-case "Dwie identyczne klauzule"
                         (let ([x (res-clause '(q) '(p) '())]
                               [y (res-clause '(q) '(p) '())])
                           (check-equal? (rc-resolve x y) #f)))
              (test-case "Kluzula pusta i niepusta"
                         (let ([x (res-clause '() '() '())]
                               [y (res-clause '(p) '(q) '())])
                           (check-equal? (rc-resolve x y) #f)))
              (test-case "Wiele zmiennych"
                         (let ([x (res-clause '(p q r) '(a b) '())]
                               [y (res-clause '(c d) '(p q) '())])
                           (check-equal? (rc-resolve x y) (res-clause '(c d q r) '(a b q) '(resolve p () ())))))))
(define prove-tests
  (test-suite "Testowanie poprawności generowanych dowodów z pomocą check-proof?"
              (test-case "Zbiór z zadania"
                         (let ((cnf-cl '(cnf (clause (lit #f p ) (lit #t q ) )
                                             (clause (lit #t p ) (lit #t q ) )
                                             (clause (lit #f q ) (lit #t r ) )
                                             (clause (lit #f q ) (lit #f r ) ) )))
                           (check-equal? (check-proof? (cadr (prove cnf-cl)) cnf-cl) #t)))
              (test-case "Zbiór z WB"
                         (let ((cnf-cl '(cnf (clause (lit #f p) (lit #t q))
                                             (clause (lit #f q) (lit #t r))
                                             (clause (lit #t p))
                                             (clause (lit #f r)))))
                           (check-equal? (check-proof? (cadr (prove cnf-cl)) cnf-cl) #t)))
              (test-case "Zbiór zawierający dwa literały"
                         (let ((cnf-cl '(cnf (clause (lit #t p))
                                             (clause (lit #f p)))))
                           (check-equal? (check-proof? (cadr (prove cnf-cl)) cnf-cl) #t)))
              (test-case "Dowód dla zbioru pustego"
                         (let ((cnf-cl (cnf)))
                           (check-equal? (prove cnf-cl) 'sat)))))
(run-tests find-lit-2-tests)
(run-tests rc-trivial-tests)
(run-tests rc-resolve-tests)
(run-tests prove-tests)