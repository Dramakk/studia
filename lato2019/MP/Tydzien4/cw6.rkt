(define (from-to n m)
  (if (> n m)
      '()
      (cons n (from-to (+ n 1) m))))
(define (concat-map f xs)
  (if (null? xs)
      null
      (append (f (car xs))
              (concat-map f (cdr xs)))))
(define (queens board-size)
  ;; Return the representation of a board with 0 queens inserted
  (define (empty-board)
    null)
  ;; Return the representation of a board with a new queen at
  ;; (row , col) added to the partial representation `rest '
  (define ( adjoin-position row col rest )
    (cons (cons row col) rest))
  ;; Return true if the queen in k-th column does not attack any of
  ;; the others
  (define (safe? k positions)
    (define (all xs)
      (if (null? xs)
          #t
          (and (car xs) (all (cdr xs)))))
    (let ([row (car (car positions))]
          [col (cdr (car positions))]
          [rest (cdr positions)])
      (all (map (lambda (pos2)
                  (let ([row2 (car pos2)]
                        [col2 (cdr pos2)])
                    (not (or (= row row2)
                             (= (abs (- row row2)) (- col col2))))))
                             rest))))
          
  ;; Return a list of all possible solutions for k first columns
(define (queen-cols k)
  (if (= k 0)
      (list (empty-board))
      (filter
        (lambda (positions) (safe? k positions) )
        (concat-map
          (lambda (rest-of-queens)
             (map (lambda (new-row)
                      (adjoin-position new-row k rest-of-queens ) )
                   (from-to 1 board-size)))
          (queen-cols (- k 1))))))
(queen-cols board-size))