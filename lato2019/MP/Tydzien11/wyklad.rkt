#lang racket
(require quickcheck)
(define test (list 6 5 0 4 9 1 2 3))
(define (sorted? l)
  (cond   [(null? l) #t]
          [(null? (cdr l)) #t]
          [else (and (<= (car l) (cadr l))
                     (sorted? (cdr l)))]))

(define sorts1/c (-> (listof integer?) (listof integer?))) 
(define sorts2/c (-> (listof integer?) (and/c (listof integer?)
                                              sorted?)))

(define/contract sort2-id sorts2/c (lambda (xs) xs))

;wersja 3
(define (contains? l1 l2)
  (andmap (lambda (x) (member x l2)) l1))

(define (contains/c l)
  (lambda (l2) (contains? l l2)))
;kontrakty zależne
(define sorts3/c
  (->i ([l (listof integer?)])
       [result (l) (and/c (listof integer?)
                          sorted?
                          (contains/c l))]))

(define/contract sort3-id sorts3/c (lambda (xs) xs))
(define/contract sort3 sorts3/c (lambda (xs) (sort xs <)))
(define/contract sort3-weird sorts3/c (lambda (xs) (list 1)))
(define/contract sort3-add sorts3/c
  (lambda (xs) (cons (- (apply min (cons 0 xs)) 1) (sort xs <)))) ;nie wyłapie, bo spradzamy tylko czy wejście zawiera się w wyjściu

;wersja 4
(define (contained/c l)
  (lambda (l2) (contains? l2 l)))

(define sorts4/c
  (->i ([l (listof integer?)])
       [result (l) (and/c (listof integer?)
                          sorted?
                          (contains/c l)
                          (contained/c l))]))
(define/contract sort4-id sorts4/c (lambda (xs) xs))
(define/contract sort4 sorts4/c (lambda (xs) (sort xs <)))
(define/contract sort4-weird sorts4/c (lambda (xs) (list 1)))
(define/contract sort4-add sorts4/c
  (lambda (xs) (cons (- (apply min (cons 0 xs)) 1) (sort xs <))))
;dalej nie działa, bo co z duplikatami XD
(define/contract sort4-duplicate sorts4/c
  (lambda (xs) (if (null? xs) null
                   (cons (apply min xs) (sort xs <)))))
;sortowanie to tak naprawdę permutacja wejścia
(define (permutation? l1 l2)
  (cond [(and (null? l1) (null? l2)) #t]
        [(null? l1) #f]
        [(null? l2) #f]
        [(not (member (car l1) l2)) #f]
        [else (permutation? (cdr l1) (remove (car l1) l2))]))

(define (permutation/c l)
  (lambda (l2) (permutation? l l2)))
(define sorts5/c
  (->i ([l (listof integer?)])
       [result (l) (and/c (listof integer?)
                          sorted?
                          (permutation/c l))]))

(define/contract sort5-add sorts5/c
  (lambda (xs) (cons (- (apply min (cons 0 xs)) 1) (sort xs <))))
(define/contract sort5-duplicate sorts5/c
  (lambda (xs) (if (null? xs) null
                   (cons (apply min xs) (sort xs <)))))

;;DRUGA GODZINA
#| Z testowaniem jednostkowym jest problem, bo sami musimy wymyślić testy, ktróre mogą być niepełne
Jak na to zaradzić?
Np. wprowadzić losowe testy!, zaimplementować dwie implementacje tego samego algorytmu i sprawdzić je wzajemnie,
|#
(define (close-enough? x y)
  (< (abs (- x y)) 0.0000001))
(define (square x) (* x x))

(quickcheck
 (property ([x arbitrary-integer]
            [y arbitrary-integer])
           (eq? (+ x y) (+ y x))))

(quickcheck
 (property ([x arbitrary-integer]
            [y arbitrary-integer]
            [z arbitrary-integer])
           (eq? (+ x (+ y z)) (+ (+ x y) z))))

(define (close-enough-complex? x y)
  (< (magnitude (- x y)) 0.0000001))
#|(quickcheck
 (property ([x arbitrary-real]
            [y arbitrary-real])
           (close-enough-complex? (sqrt (* x y)) (* (sqrt x) (sqrt y)))))|#
;inne generatory
(quickcheck
 (property ([x (choose-real 0 1000)]
            [y (choose-real 0 1000)])
           (close-enough? (sqrt (* x y)) (* (sqrt x) (sqrt y)))))
;implikacje warunków (?)
(quickcheck
 (property ([x arbitrary-real]
            [y arbitrary-real])
           (==> (positive? x)
                (==> (positive? y)
           (close-enough-complex? (sqrt (* x y)) (* (sqrt x) (sqrt y)))))))

;WYBIŁA TRZECIA GODZINA!
;abstrakcja jednostek
;lecimy słownik
;sygnatury
;^ i @ to konwencja
;(define-signature dict^
;  (dict? dict-empty? empty-dict dict-insert dict-remove dict-lookup))

;sygnatura z kontraktami
#|(define-signature dict^
  ((contracted
    [dict? (-> any/c boolean?)]
    [dict-empty? (-> dict? boolean?)]
    [empty-dict (and/c dict? dict-empty?)]
    [dict-insert (-> dict? string? any/c dict?)]
    [dict-remove (-> dict? string? dict?)]
    [dict-lookup (-> dict? string? (or/c (cons/c string? any/c)
                                         #f))])))|#

;bardziej skomplikowane kontrakty
(define-signature dict^
  ((contracted
    [dict? (-> any/c boolean?)]
    [dict-empty? (-> dict? boolean?)]
    [empty-dict (and/c dict? dict-empty?)]
    [dict-insert (-> dict? string? any/c dict?)]
    [dict-remove (->i ([d dict?] [k string?])
                      [result (k) (and/c
                                    dict?
                                    (lambda (r) (eq? #f (dict-lookup r k))))])]
    [dict-lookup (->i ([d dict?] [k string?])
                      [result (or/c
                               (cons/c string? any/c) #f)
                              #:post)])])))

(define-unit dict-list@
  (import)
  (export dict^)

  (define (dict? d)
    (and (list? d)
         (eq? (length d) 2)
         (eq? (car d) 'dict-list)))
  ;nasza procedura wewnętrzna
  (define (dict-list d)
    (cadr d))
  (define (dict-cons l) (list 'dict-list l))
  
  (define (dict-empty? d)
    (eq? (dict-list d) '()))
  (define empty-dict (dict-cons '()))
  (define (dict-lookup d k)
    (assoc k (dict-list d)))
  (define (dict-remove d k)
    (dict-cons (remf (lambda (p) (eq? (car p) k)) (dict-list d))))
  (define (dict-insert d k v)
    (dict-cons (cons (cons k v) (dict-list (dict-remove d k)))))
  )

(define-values/invoke-unit/infer dict-list@)

(define dx1 (dict-insert empty-dict "x" 1))
(define dx2 (dict-insert dx1 "x" 2))
(define dx1y2 (dict-insert dx1 "y" 2))

(define (list->dict l)
  (cond [(null? l) empty-dict]
        [else (dict-insert (list->dict (cdr l)) (caar l) (cdar l))]))

(define arbitrary-dict-list
  (arbitrary-list (arbitrary-pair arbitrary-string arbitrary-integer)))

(quickcheck
 (property
  ([l arbitrary-dict-list]
   [k arbitrary-string]
   [v arbitrary-integer])
  (let* ([d (list->dict l)]
         [di (dict-insert d k v)]
         [dl (dict-lookup di k)])
    (and (pair? dl)
         (eq? (car dl) k)
         (eq? (cdr dl) v)))))