#lang racket
;;cw 2
(struct node (v l r) #:transparent)
(struct leaf () #:transparent)

;; predykat: czy dana wartość jest drzewem binarnym?

(define (tree? t)
  (match t
    [(leaf) true]
    ; wzorzec _ dopasowuje się do każdej wartości
    [(node _ l r) (and (tree? l) (tree? r))]
    ; inaczej niż w (cond ...), jeśli żaden wzorzec się nie dopasował, match kończy się błędem
    [_ false]))

;; przykładowe użycie dopasowania wzorca

(define (insert-bst v t)
  (match t
    [(leaf) (node v (leaf) (leaf))]
    [(node w l r)
     (if (< v w)
         (node w (insert-bst v l) r)
         (node w l (insert-bst v r)))]))
(define (paths t)
    (match t
      [(leaf) (list (list '*))]
      [(node v l r)
                     (map (lambda (path) (cons v path)) (append (paths l) (paths r)))]))
;;cw 3
(struct const (val) #:transparent)
(struct op (symb l r) #:transparent)

(define (expr? e)
  (match e
    [(const n) (number? n)]
    [(op s l r) (and (member s '(+ *))
                     (expr? l)
                     (expr? r))]
    [_ false]))

;; przykładowe wyrażenie

(define e1 (op '* (op '+ (const 2) (const 2))
                  (const 2)))

;; ewaluator wyrażeń arytmetycznych

(define (eval e)
  (match e
    [(const n) n]
    [(op '+ l r) (+ (eval l) (eval r))]
    [(op '* l r) (* (eval l) (eval r))]))

;; kompilator wyrażeń arytmetycznych do odwrotnej notacji polskiej

(define (to-rpn e)
  (match e
    [(const n) (list n)]
    [(op s l r) (append (to-rpn l)
                        (to-rpn r)
                        (list s))]))
;;przypisz do operatorów 1 i -1
;;cw 4
(struct tekst (title author chapters) #:transparent)
(struct chapter (title hs) #:transparent)
(struct par (text) #:transparent)
(define (document? t)
  (match t
    [(tekst t a ar) (and (string? t)
                         (string? a)
                         (list? ar)
                         (andmap chapter? ar))]
    [_ #f]))
(define (chapterr? ch)
  (match ch
    [(chapter t hs)
     (and (string? t)
          (list? hs)
          (andmap (lambda (h) (or (chapter? h)
                                  (par? h)))))]
    [_ #f]))
(define (parr? p)
  (match p
    [(par t) (and (list? t)
                  (>= (length t) 1)
                  (andmap string? t))]
    [_ #f]))
(define (text->html t)
  (string-append "<html><head><title>"
                 (tekst-title t)
                 "</title>"
                 "</head><body>"
                 (chapter->html (tekst-chapters t) 1)


                 "</body></html>"))
(define (chapter->html ch n)
  (match ch
    [(chapter t elems) (string-append "<h" (number->string n) ">"
                                      (apply string-append (map (lambda (x) (match x
                                                                              [(chapter a b) (chapter->html x (+ n 1))]
                                                                              [(par t) (string-append "<p>" (apply string-append t) "</p>")])) elems))
                                      "</h" (number->string n) ">")]))