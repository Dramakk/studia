#lang racket

(define (run-concurrent . thunks)
  (define threads (map thread thunks))
  (for-each thread-wait threads))

;(run-concurrent (lambda () (begin (sleep 0.5) (display 'a))) (lambda () (begin (sleep 0.1) (display 'b))))

(define (random-sleep)
  (sleep (/ (random) 100)))

(define (with-random-sleep proc)
  (lambda args
    (random-sleep)
    (apply proc args)))

(define (make-serializer)
  (define sem (make-semaphore 1))
  (lambda (proc)
    (lambda args
      (semaphore-wait sem)
      (define ret (apply proc args))
      (semaphore-post sem)
      ret)))

(define (make-account balance)
  (define (withdraw amount)
    (random-sleep)
    (if (>= balance amount)
        (begin (set! balance ((with-random-sleep -) balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (random-sleep)
    (set! balance ((with-random-sleep +) balance amount))
    balance)
  (define protected (make-serializer))
  (define (dispatch m)
    (cond [(eq? m 'withdraw) (protected withdraw)]
          [(eq? m 'deposit) (protected deposit)]
          [(eq? m 'balance) balance]
          [else (error "Unknown request - make-account" m)]))
  dispatch)


(define (make-account-with-serializer balance)
  (define (withdraw amount)
    (random-sleep)
    (if (>= balance amount)
        (begin (set! balance ((with-random-sleep -) balance amount))
               balance)
        "Insufficient funds"))
  (define (deposit amount)
    (random-sleep)
    (set! balance ((with-random-sleep +) balance amount))
    balance)
  (define account-serializer (make-serializer))
  (define (dispatch m)
    (cond [(eq? m 'withdraw) withdraw]
          [(eq? m 'deposit) deposit]
          [(eq? m 'balance) balance]
          [(eq? m 'serializer) account-serializer]
          [else (error "Unknown request - make-account" m)]))
  dispatch)

(define (serialized-deposit account amount)
  (let ([s (account 'serializer)]
        [d (account 'deposit)])
    ((s d) amount)))
(define (serialized-withdraw account amount)
  (let ([s (account 'serializer)]
        [w (account 'withdraw)])
    ((s w) amount)))

(define wsacc1 (make-account-with-serializer 100))
(define wsacc2 (make-account-with-serializer 90))
(define wsacc3 (make-account-with-serializer 80))
;defincja exchange, której nie przepisałem XD
(define (serialized-exchange account1 account2)
  (let ([serializer1 (account1 'serializer)]
        [serializer2 (account2 'seriazlier)])
    ((serializer1 (serializer2 exchange)) account1 account2)))
