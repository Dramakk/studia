#lang racket

(define (quick-sort xs)
  (if (null? xs)
      null
      (let* ([pivot (car xs)]
             [tail (cdr xs)]
             [grt (filter (lambda (x) (>= x pivot)) tail)]
             [lsr (filter (lambda (x) (< x pivot)) tail)])
        (append (quick-sort lsr) (cons pivot (quick-sort grt))))))