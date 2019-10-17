#lang racket
(require rackunit)
(require rackunit/text-ui)
;;scalanie posortowanych list
(define (merge l1 l2)
  (cond [(null? l1) l2]
        [(null? l2) l1]
        [(< (car l1) (car l2))
         (cons (car l1) (merge (cdr l1) l2))]
        [else (cons (car l2) (merge l1 (cdr l2)))]))
;;podział listy na dwie (prawie) równe części
(define (split l)
  (define (split-it h lista i)
    (let ([head (car lista)]
          [rest (cdr lista)]
          [half (floor (/ (length l) 2))]
          [next (+ i 1)])
    (cond [(< i half) (split-it (append h (list head)) rest next)]
          [else (cons h (list lista))])))
  (if (or (null? l) (not (list? l)))
      null
      (split-it '() l 0)))
;;merge sort
(define (merge-sort xs)
  (if (not (list? xs))
      null
      (if (null? xs)
          xs
          (if (null? (cdr xs))
              xs
              (let* ([halves (split xs)]
                     [h1 (car halves)]
                     [h2 (car (cdr halves))])
                (merge
                 (merge-sort h1)
                 (merge-sort h2)))))))
;;testy
(define merge-proced-test
  (test-suite
   "Tests for merge procedure"
   (test-case "More than one occurance"
              (check-equal? (merge (list 1 6 8 9 10) (list 1 2 3)) (list 1 1 2 3 6 8 9 10)))
   (test-case "Normal situation 1."
              (check-equal? (merge (list 1 2 3) (list 10 11 12)) (list 1 2 3 10 11 12)))
   (test-case "Normal situation 2."
              (check-equal? (merge (list 10 11 12) (list 2 3 4)) (list 2 3 4 10 11 12)))
   (test-case "Two null lists"
              (check-equal? (merge null null) null))
   (test-case "One null list 1."
              (check-equal? (merge null (list 1 2 3)) (list 1 2 3)))
   (test-case "One null list 1."
              (check-equal? (merge (list 1 2 3) null) (list 1 2 3)))
   (test-case "Same lists"
              (check-equal? (merge (list 1 2 3) (list 1 2 3)) (list 1 1 2 2 3 3)))))
(define split-proced-test
  (test-suite
   "Tests for split procedure"
   (test-case "Odd number of elements"
              (check-equal? (split (list 1 6 8 9 10)) (list (list 1 6) (list 8 9 10))))
   (test-case "Even number of elements"
              (check-equal? (split (list 1 2 3 4)) (list (list 1 2) (list 3 4))))
   (test-case "Split of null"
              (check-equal? (split null) null))
   (test-case "Split of non list"
              (check-equal? (split (cons 1 2)) null))))
(define merge-sort-proced-test
  (test-suite
   "Tests for merge-sort procedure"
   (test-case "Null list"
              (check-equal? (merge-sort null) null))
   (test-case "Not a list"
              (check-equal? (merge-sort (lambda (x) x)) null))
   (test-case "Multiple occurances"
              (check-equal? (merge-sort (list 1 2 1 1 8 7 1 2 10 2)) (list 1 1 1 1 2 2 2 7 8 10)))
   (test-case "Reverse order of list"
              (check-equal? (merge-sort (list 4 3 2 1)) (list 1 2 3 4)))))
(define (run-all-tests)
  (run-tests merge-proced-test)
  (run-tests split-proced-test)
  (run-tests merge-sort-proced-test))