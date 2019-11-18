#lang racket

;; sygnatura: grafy
(define-signature graph^
  ((contracted
    [graph        (-> list? (listof edge?) graph?)]
    [graph?       (-> any/c boolean?)]
    [graph-nodes  (-> graph? list?)]
    [graph-edges  (-> graph? (listof edge?))]
    [edge         (-> any/c any/c edge?)]
    [edge?        (-> any/c boolean?)]
    [edge-start   (-> edge? any/c)]
    [edge-end     (-> edge? any/c)]
    [has-node?    (-> graph? any/c boolean?)]
    [outnodes     (-> graph? any/c list?)]
    [remove-node  (-> graph? any/c graph?)]
    )))

;; prosta implementacja grafów
(define-unit simple-graph@
  (import)
  (export graph^)

  (define (graph? g)
    (and (list? g)
         (eq? (length g) 3)
         (eq? (car g) 'graph)))

  (define (edge? e)
    (and (list? e)
         (eq? (length e) 3)
         (eq? (car e) 'edge)))

  (define (graph-nodes g) (cadr g))

  (define (graph-edges g) (caddr g))

  (define (graph n e) (list 'graph n e))

  (define (edge n1 n2) (list 'edge n1 n2))

  (define (edge-start e) (cadr e))

  (define (edge-end e) (caddr e))

  (define (has-node? g n) (not (not (member n (graph-nodes g)))))
  
  (define (outnodes g n)
    (filter-map
     (lambda (e)
       (and (eq? (edge-start e) n)
            (edge-end e)))
     (graph-edges g)))

  (define (remove-node g n)
    (graph
     (remove n (graph-nodes g))
     (filter
      (lambda (e)
        (not (eq? (edge-start e) n)))
      (graph-edges g)))))

;; sygnatura dla struktury danych
(define-signature bag^
  ((contracted
    [bag?       (-> any/c boolean?)]
    [empty-bag  (and/c bag? bag-empty?)]
    [bag-empty? (-> bag? boolean?)]
    [bag-insert (-> bag? any/c (and/c bag? (not/c bag-empty?)))]
    [bag-peek   (-> (and/c bag? (not/c bag-empty?)) any/c)]
    [bag-remove (-> (and/c bag? (not/c bag-empty?)) bag?)])))

;; struktura danych - stos
(define-unit bag-stack@
  (import)
  (export bag^)
  (define (bag? b)
    (list? b))
  (define empty-bag null)
  (define (bag-empty? b)
    (null? b))
  (define (bag-insert b v)
    (cons v b))
  (define (bag-peek b)
    (car b))
  (define (bag-remove b)
    (cdr b)))


;; struktura danych - kolejka FIFO
;; do zaimplementowania przez studentów
(define-unit bag-fifo@
  (import)
  (export bag^)
  (define (bag? b)
    (and (list? b)
         (list? (first b))
         (list? (second b))))
  (define empty-bag (list null null))
  (define (bag-empty? b)
    (and (null? (first b))
         (null? (second b))))
  (define (bag-insert b v)
    (list (cons v (first b)) (second b)))
  (define (bag-peek b)
    (if (null? (second b))
        (car (reverse (first b)))
        (car (second b))))
  (define (bag-remove b)
    (if (null? (second b))
        (list null (cdr (reverse (first b))))
        (list (first b) (cdr (second b)))))
)

;; sygnatura dla przeszukiwania grafu
(define-signature graph-search^
  (search))

;; implementacja przeszukiwania grafu
;; uzależniona od implementacji grafu i struktury danych
(define-unit/contract graph-search@
  (import bag^ graph^)
  (export (graph-search^
           [search (-> graph? any/c (listof any/c))]))
  (define (search g n)
    (define (it g b l)
      (cond
        [(bag-empty? b) (reverse l)]
        [(has-node? g (bag-peek b))
         (it (remove-node g (bag-peek b))
             (foldl
              (lambda (n1 b1) (bag-insert b1 n1))
              (bag-remove b)
              (outnodes g (bag-peek b)))
             (cons (bag-peek b) l))]
        [else (it g (bag-remove b) l)]))
    (it g (bag-insert empty-bag n) '()))
  )

;; otwarcie komponentu grafu
(define-values/invoke-unit/infer simple-graph@)

;; graf testowy
(define test-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4))))
(define my-graph
  (graph
   (list 1 2 3 4 8 9 11)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 4)
         (edge 3 4)
         (edge 4 8)
         (edge 8 11)
         (edge 11 9))))
(define my-cycle-graph
  (graph
   (list 1 2 3 4)
   (list (edge 1 3)
         (edge 1 2)
         (edge 2 3)
         (edge 3 4)
         (edge 4 1))))
(define my-graph2
  (graph
   (list 1 2 3 10 11 12)
   (list (edge 1 2)
         (edge 1 3)
         (edge 2 3)
         (edge 3 1)
         (edge 10 11)
         (edge 11 12)
         (edge 11 10)
         (edge 12 10))))
;; otwarcie komponentu stosu
(define-values/invoke-unit/infer bag-stack@)
;; opcja 2: otwarcie komponentu kolejki
;(define-values/invoke-unit/infer bag-fifo@)

;; testy w Quickchecku
(require quickcheck)
;procedury pomocnicze
(define (adder b l)
  (if (null? l)
      b
      (adder (bag-insert b (car l)) (cdr l))))
(define (get-last l)
  (if (null? (cdr l))
      (car l)
      (get-last (cdr l))))
(define (create-list-from-bag b)
  (if (bag-empty? b)
      null
      (cons (bag-peek b) (create-list-from-bag (bag-remove b)))))
;; test przykładowy: jeśli do pustej struktury dodamy element
;; i od razu go usuniemy, wynikowa struktura jest pusta
(quickcheck
 (property ([s arbitrary-symbol])
           (bag-empty? (bag-remove (bag-insert empty-bag s)))))
;Stos, (bag-remove (bag-insert b v)) == b
#|(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)]
            [n arbitrary-integer])
           ;pomijamy listę pustą, bo założenie jest, że na stosie musi być jakiś element
           (if (not (null? l))
               (equal? (bag-remove (bag-insert (adder empty-bag l) n)) (adder empty-bag l))
               #t)))|#
;Stos, ostatni element włożony, jest pierwszym wyjętym
#|(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)])
           ;pomijamy listę pustą, bo założenie jest, że na stosie musi być jakiś element
           (if (not (null? l))
               (equal? (bag-peek (adder empty-bag l)) (get-last l))
               #t)))|#
;Stos, jeżeli wyjmiemy wszystkie elementy ze stosu stworzonej z listy L to otrzymamy tą listę w odwróconej kolejności
#|(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)])
           ;pomijamy listę pustą, bo założenie jest, że na stosie musi być jakiś element
           (if (not (null? l))
               (equal? (create-list-from-bag (adder empty-bag l)) (reverse l))
               #t)))|#
;Kolejka FIFO, pierwszy element włożony do kolejki, jest pierwszym wyjętym
#|(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)])
           ;pomijamy listę pustą, bo założenie jest, że w kolejce musi być jakiś element
           (if (not (null? l))
               (equal? (bag-peek (adder empty-bag l)) (car l))
               #t)))|#
;Kolejka FIFO, jeżeli wyjmiemy wszystkie elementy z kolejki stworzonej z listy L to otrzymamy tą listę
#|(quickcheck
 (property ([l (arbitrary-list arbitrary-integer)])
           ;pomijamy listę pustą, bo założenie jest, że na stosie musi być jakiś element
           (if (not (null? l))
               (equal? (create-list-from-bag (adder empty-bag l)) l)
               #t)))|#
;; jeśli jakaś własność dotyczy tylko stosu lub tylko kolejki,
;; wykomentuj ją i opisz to w komentarzu powyżej własności

;; otwarcie komponentu przeszukiwania
(define-values/invoke-unit/infer graph-search@)

;; uruchomienie przeszukiwania na przykładowym grafie
(search test-graph 1)
(search my-graph 1)
(search my-cycle-graph 4)
(search my-graph2 1)
(search my-graph2 12)