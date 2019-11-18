#lang racket

(define (every-second-elem xd)
  (if (<= (length xd) 1)
      null
      (cons (cadr xd) (every-second-elem (cdr (cdr xd))))))

(define (reverse xs)
  (if (null? xs)
      null
      (append (reverse (cdr xs)) (list (car xs)))))

(define (interleave xs ys)
  (cond ((null? xs) ys)
        ((null? ys) xs)
        (else (cons (car xs) (cons (car ys) (interleave (cdr xs) (cdr ys)))))))

(define (max xs)
  (define (max-it xs c)
    (cond ((null? xs) c)
           ((> c (car xs)) (max-it (cdr xs) c))
           (else (max-it (cdr xs) (car xs)))))
  (max-it (cdr xs) (car xs)))

(define (merge xs ys)
  (cond ((null? xs) ys)
        ((null? ys) xs)
        (else (if (< (car xs) (car ys))
                  (cons (car xs) (merge (cdr xs) ys))
                  (cons (car ys) (merge xs (cdr ys)))))))

(define (split xs)
  (define (aux x acc n i)
    (if (>= i n)
        (list acc x)
        (aux (cdr x) (append acc (list (car x))) n (+ i 1))))
  (aux xs '() (/ (length xs) 2) 0))

(define (merge-sort xs)
  (if (<= (length xs) 1)
      xs
      (merge (merge-sort (car (split xs))) (merge-sort (cadr (split xs))))))

(define (sublists xs)
  (if (null? xs)
      (list null)
      (apply append (map (lambda (x) (list xs)) (sublists (cdr xs))))))