#lang racket
(require racklog)

(define %rev1
	(%rel (xs ys zs x)
	[(null null)]
	[((cons x xs) ys)
	(%append zs (list x) ys)
	(%rev1 zs xs)]))
(%which (x) (%rev1 '(1 2 3 4) x))
