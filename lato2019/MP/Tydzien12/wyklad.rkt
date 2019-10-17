#lang typed/racket
;zacznijmy!
(: dist (-> Real Real Real)) ;jak zmienimy wynik na typ Any
;a później spróbujemy np. dodać, to dostaniemy błąd :C
;bo typy sprawdzane są przed uruchomieniem
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
  (: improve (-> Real Real))
  (define (improve approx)
    (average (/ x approx) approx))
  (: good-enough? (-> Real Boolean))
  (define (good-enough? approx)
    (< (dist x (square approx)) 0.0001))
  (: iter (-> Real Real))
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else (iter (improve approx))]))
  (iter 1.0))

(: increment (-> Integer Integer))
(define (increment x)
  (+ x 1))
;definiujemy typ liczb wymiernych
(define-type Rat (Pairof Integer Integer))
(: make-rat (-> Integer Integer Rat))
(define (make-rat n d)
  (let ((c (gcd n d)))
    (cons (quotient n c) (quotient d c))))
(: rat-numer (-> Rat Integer))
(define (rat-numer l) (car l))

(: rat-denom (-> Rat Integer))
(define (rat-denom l) (cdr l))

#|(: rat? (-> Any Boolean))
(define (rat? x)
  (and (pair? x) (integer? (car x)) (integer? (cdr x))))|#
(define-predicate rat? Rat)
(: print-rat (-> Rat Void))
(define (print-rat r)
  (display (rat-numer r))
  (display "/")
  (display (rat-denom r)))
  
(: integer->rational (-> Integer Rat))
(define (integer->rational n)
  (make-rat n 1))

(: to-rat (-> (U Integer Rat) Rat))
(define (to-rat n)
  (cond [(integer? n) (integer->rational n)]
        [(rat? n) n]))
;dzielenie typu Rat Rat Rat
;koniec liczb wymiernych
;teraz zabawy z listami
(: length (-> (Listof Any) Number))
(define (length xs)
  (if (null? xs)
      0
      (+ 1 (length (cdr xs)))))

(: append (All (a) (-> (Listof a) (Listof a) (Listof a)))) ;Dla każdego a, bierze listę a, listę a i zwraca listę a
(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))
;trzecia godzina
;drzewa binarne
#|(define-type Leaf 'leaf)
(define-type (Node a b) (List 'node a b b))
(define-type (Tree a) (U Leaf (Node a (Tree a))))

(define-predicate leaf? Leaf)
(define-predicate node? (Node Any Any))
(define-predicate tree? (Tree Any))

(define leaf 'leaf)
(: make-node (All (a b) (-> a b b (Node a b))))
(define (make-node v l r)
  (list 'node v l r))

(: node-left (All (a b) (-> (Node a b) b)))
(define (node-left x)
  (caddr x))
(: node-right (All (a b) (-> (Node a b) b)))
(define (node-right x)
  (cadddr x))
(: node-val (All (a b) (-> (Node a b) a)))
(define (node-val x)
  (second x))
(: example-tree (Tree Integer))
(define example-tree (make-node 2 (make-node 1 leaf leaf) leaf))

(: find-bst (-> Integer (Tree Integer) Boolean))
(define (find-bst x t)
  (cond [(leaf? t) false]
        [(= x (node-val t)) true]
        [(< x (node-val t)) (find-bst x (node-left t))]
        [else (find-bst x (node-right t))]))

(: insert-bst (-> Integer (Tree Integer) (Tree Integer)))
(define (insert-bst x t)
  (cond [(leaf? t) (make-node x leaf leaf)]
        [(< x (node-val t))
         (make-node (node-val t)
                    (insert-bst x (node-left t)) (node-right t))]
        [else
         (< x (node-val t))
         (make-node (node-val t)
                    (node-left t)
                    (insert-bst x (node-right t)))]))
|#
;typy a pattern matching
(struct leaf () #:transparent)
#|(struct node ([v : Integer]
              [l : (U node leaf)]
              [r : (U node leaf)]) #:transparent) stara wersja, typ wartości na sztywno, drzewa tylko intów|#
(struct (a b) node ([v : a]
                    [l : b]
                    [r : b]) #:transparent)

#|(define-type Tree (U node leaf))
(define-predicate tree? Tree)

(: find-bst (-> Integer Tree Boolean))
(define (find-bst v t)
  (match t
    [(leaf) false]
    [(node w l r)
     (cond [(= w v) true]
           [(< v w) (find-bst v l)]
           [else (find-bst v r)])])) stara wersja, ze sztywnym typem|#

(define-type Tree (U (node a (Tree a)) leaf))
(define-predicate tree? (Tree Any))
(: find-bst (-> Integer (Tree Integer) Boolean))
(define (find-bst v t)
  (match t
    [(leaf) false]
    [(node w l r)
     (cond [(= w v) true]
           [(< v w) (find-bst v l)]
           [else (find-bst v r)])]))