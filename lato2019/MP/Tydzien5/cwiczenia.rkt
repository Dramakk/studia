#lang racket

(define (var? t)
  (symbol? t))

(define (neg? t)
  (and (list? t)
       (= 2 (length t))
       (eq? 'neg (car t))))

(define (conj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'conj (car t))))

(define (disj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'disj (car t))))

(define (prop? f)
  (or (var? f)
      (and (neg? f)
           (prop? (neg-subf f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-right f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-right f)))))
(define (neg t)
      (list 'neg t))
(define (neg-subf t)
  (second t))
(define (disj p q)
  (list 'disj p q))
(define (conj p q)
  (list 'conj p q))
(define (disj-left t)
  (second t))
(define (disj-right t)
  (third t))
(define (conj-left t)
  (second t))
(define (conj-right t)
  (third t))
(define (free-vars t)
  (define (is-inside a xs)
    (if (null? xs)
        #f
        (if (eq? a (car xs))
            #t
            (is-inside a (cdr xs)))))
  (define (how-many f acc)
    (if (null? f)
        acc
        (if (list? f)
        (cond [(eq? 'neg (car f)) (append acc (how-many (neg-subf f) '()))]
              [(eq? (car f) 'disj) (append acc (list (how-many (disj-left f) '()))
                                                (list (how-many (disj-right f) '())))]
              [(eq? (car f) 'conj) (append acc (list (how-many (conj-left f) '()))
                                                (list (how-many (conj-right f) '())))]
              [else null])
        (append acc f))))
            
  (if (prop? t)
      (flatten (how-many t '()))
      null))
(define (free-vars2 f)
  (if (var? f)
      (list f)
      (cond   [(eq? 'neg (car f)) (append (free-vars2 (neg-subf f)))]
              [(eq? (car f) 'disj) (append (free-vars2 (disj-left f))
                                              (free-vars2 (disj-right f)))]
              [(eq? (car f) 'conj) (append (free-vars2 (conj-left f))
                                              (free-vars2 (conj-right f)))]
              [else null])))
(define x (neg 'a))
(define z (neg 'b))
(define xz (disj x z))
(define y (neg 'c))
(define u (neg 'd))
(define asda (conj (disj x z) (disj y u)))
(free-vars asda)
(free-vars2 asda)
;;ćwiczenie 3
(define (gen-vals xs )
  (if (null? xs )
      (list null)
      (let*
          ((vss (gen-vals (cdr xs ) ) )
           (x (car xs ) )
           (vst (map (lambda (vs) (cons (list x true ) vs ) ) vss ) )
           (vsf (map (lambda (vs) (cons (list x false ) vs ) ) vss ) ) )
        (append vst vsf ) ) ) )
(define (eval-formula f val)
  (define (find f l)
    (if (null? l)
        null
        (if (eq? (car l) f)
            (car (cdr (car l)))
            (find f (cdr l)))))
  (cond [(var? f) (find f val)]
        [(neg? f) (not (find f val))]
        [(conj? f) (and (eval-formula (conj-right f) val) (eval-formula (conj-left f) val))]
        [(disj? f) (and (eval-formula (disj-right f) val) (eval-formula (disj-left f) val))]
        [else (error "XD")]))
(gen-vals (free-vars asda))
(eval-formula asda (car (gen-vals (free-vars asda))))
;;falsifable-eval trzeba zrobić sobie rekurenjce po wartościowaniach, jak znajdujemy #f to koniec wpp jeżeli już nie będzie wartościowań do sprawdzenia to false
;;ćwiczenie 4
(define (nnf? f)
  (or (var? f)
      (and (neg? f)
           (var? (neg-subf f)))
      (and (disj? f)
           (nnf? (disj-left f))
           (nnf? (disj-right f)))
      (and (conj? f)
           (nnf? (conj-left f))
           (nnf? (conj-right f)))))
(define (convert-to-nnf f)
  (if (nnf? f)
      f
      (cond [(var? f) f]
            [(conj? f) (conj (convert-to-nnf (conj-left f)) (convert-to-nnf (conj-right f)))]
            [(disj? f) (disj (convert-to-nnf (disj-left f)) (convert-to-nnf (disj-right f)))]
            [(neg? f) (let ([x (neg-subf f)])
                        (cond [(var? x) (neg x)]
                              [(neg? x) (convert-to-nnf (neg-subf x))]
                              [(conj? x) (disj (convert-to-nnf (neg (conj-left x))) (convert-to-nnf (neg (conj-right x))))]
                              [(disj? x) (conj (convert-to-nnf (neg (disj-left x))) (convert-to-nnf (neg (disj-right x))))]))]
            [else null])))
(define (convert-to-nnf2 f)
  (if (nnf? f)
      f
      (cond [(var? f) f]
            [(conj? f) (conj (convert-to-nnf (conj-left f)) (convert-to-nnf (conj-right f)))]
            [(disj? f) (disj (convert-to-nnf (disj-left f)) (convert-to-nnf (disj-right f)))]
            [(neg? f) convert-neg-to-nnf (neg-subf f)]
            [else null])))
(define (convert-neg-to-nnf f)
  (cond [(var? f) (neg f)]
        [(conj? f) (disj (convert-neg-to-nnf (conj-left x)) (convert-neg-to-nnf (conj-right x)))]
        [(disj f) (conj (convert-neg-to-nnf (disj-left x)) (convert-neg-to-nnf (disj-right x)))]
        [(neg? f) (convert-to-nnf (neg-subf f))]))
;;ćwiczenie 6
;;reprezentacja jako lista klauzul
(define (create-clause . xs)
  (cons 'clause xs))
(define (get-literals clause)
  (cdr clause))
(define (convert-to-CNF prop)
  (cond [(lit? prop) (list (create-clause prop))]
        [(conj? prop) (append-cl (convert-to-CNF (conj-left prop)) ;;append-cl odpakowuje klauzule i je łączy
                                     (convert-to-CNF (conj-right prop)))]
        [(disj? prop) (merge-clauses (convert-to-CNF (disj-left prop))
                                     (convert-to-CNF (conj-right prop)))]))
(define (merge-clauses cl-1 cl-2)
  (define (merge-lit-clause lit clause)
    (if (null? clause)
        null
        (cons (create-clause (list (car clause) lit)) (merge-lit-clause lit (cdr clause)))))
  (let ([lit1 (get-literals cl-1)]
        [lit2 (get-literals cl-2)])
    (if (null? cl-1)
        null
        (append (merge-lit-clause (cdr cl-1) (merge-clauses (cdr cl-1) cl-2))))))
        