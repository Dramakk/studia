#lang racket
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
                                                                              [(par t) (string-append "<p>" (apply string-append t) "</p>")])) (list elems)))
                                      "</h" (number->string n) ">")]))
(define pars (par (list "Da" "wid")))
(define chapters (chapter "Title" pars))
(define (show-start-page)
  (text->html (tekst "Dawid" "Dawid Żywczak" chapters)))
(define (show-prime-divs n)
  "")
(provide show-start-page)
(provide show-prime-divs)