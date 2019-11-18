#lang racket
(require rackunit)
(require rackunit/text-ui)

(struct variable () #:transparent) ;;zgodnie z przypisem - zmienna jest tylko jedna zatem ich nie odróżniamy
(struct const (l) #:transparent)
(struct op (sym left right) #:transparent)
(struct deriv (expr) #:transparent) ;;operator pochodnej w składni abstrakcyjnej

(define (expr? e)
  (match e
    [(variable) #t]
    [(const l) (number? l)]
    [(op s l r) (and (symbol? s)
                     (expr? l)
                     (expr? r))]
    [(deriv e) (expr? e)]
    [_ #f]))

(define (abstract-deriv e) ;;operacja różniczkowania na składni abstrakcyjnej
  (match e
    [(variable) (const 1)]
    [(const l) (const 0)]
    [(op s l r) (cond [(equal? s '+) (op '+ (abstract-deriv l) (abstract-deriv r))]
                      [(equal? s '*) (op '+ (op '* (abstract-deriv l) r) (op '* l (abstract-deriv r)))])]
    [(deriv e) (deriv (abstract-deriv e))]
    [_ (error "Wystąpiła operacja niezdefiniowana")]))

(define (eval expr val) ;;ewaluacja wyrażenia w składni abstrakcyjnej z zadaną wartością zmiennej
  (match expr
    [(variable) val]
    [(const l) l]
    [(op s l r) (cond [(equal? s '+) (+ (eval l val) (eval r val))]
                      [(equal? s '*) (* (eval l val) (eval r val))])]
    [(deriv e) (eval (abstract-deriv e) val)]
    [_ (error "Wystąpiła operacja niezdefiniowana")]))

(define abstract-deriv-tests
  (test-suite "Testy porcedury abstract-deriv"
              (test-case "Pochodna stałej"
                         (check-equal? (abstract-deriv (const 1)) (const 0)))
              (test-case "Pochodna zmiennej"
                         (check-equal? (abstract-deriv (variable)) (const 1)))
              (test-case "Podwójna pochodna zmiennej"
                         (check-equal? (abstract-deriv (deriv (variable))) (deriv (const 1))))
              (test-case "Pochodna z zadania"
                         (check-equal? (abstract-deriv (op '+ (op '* (variable) (variable)) (variable)))  (op
                                                                                                           '+
                                                                                                           (op '+ (op '* (const 1) (variable)) (op '* (variable) (const 1)))
                                                                                                           (const 1))))
              ))
(define eval-tests
  (test-suite "Testy porcedury eval"
              (test-case "Pochodna stałej"
                         (check-equal? (eval (deriv (const 1)) 1) 0))
              (test-case "Pochodna zmiennej"
                         (check-equal? (eval (deriv (variable)) 1) 1))
              (test-case "Podwójna pochodna zmiennej"
                         (check-equal? (eval (deriv (deriv (variable))) 1) 0))
              (test-case "Równanie z zadania"
                         (check-equal? (eval (op '+ (op '* (const 2) (variable)) (deriv (op '+ (op '* (variable) (variable)) (variable)))) 3)  13))
              ))
(run-tests abstract-deriv-tests)
(run-tests eval-tests)