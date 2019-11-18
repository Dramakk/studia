#lang racket
;temat inny od wszystkich innych
;programowanie logiczne
(require racklog)
;% zwyczajowo do programowania logicznego
;zdefiniowaliśmy sobie pewną bazę faktów
(define %ojciec
  (%rel ()
        [('andrzej 'błażej)]
        [('andrzej 'beata)]
        [('błażej 'czarek)]
        [('czarek 'damian)]))
;(%which () (%ojciec 'andrzej 'macieja)) w przypadku prawdy da nam listę pustą teraz, a w przypadku fałszu da nam #f
;(%which (x) (%ojciec x 'damian)) zwróci nam listę par ((x . czarek)) czyli, że Czarek jest ojcem Damiana
;działa aż znajdzie pierwszą pasującą odpowiedź
;używajać (%more) możemy dostać kolejne odpowiedzi
;(%which (x y z) (%ojciec x y) (%ojciec y z)) znajdź takie x y z, że x jest ojcem y i y jest ojcem z
(define %dziadek
  (%rel (x y z) ;tutaj wpisujemy wszystkie zmienne, których używamy
        [(x z) ;x jest w relacji z z wtedy gdy istnieje y t.że x jest ojcem y i y jest ojcem z
         (%ojciec x y) 
         (%ojciec y z)]))
(define %rodzenstwo
  (%rel (x y z)
        [(x y)
         (%ojciec z x)
         (%ojciec z y)]))


(define %przodek
  (%rel (x y z)
        [(x y) ;jest przodkiem jeśli jest ojcem
         (%ojciec x y)]
        [(x y) ;lub jest ojcem jakiegoś z który jest przodkiem y
         (%ojciec x z)
         (%przodek z y)]))
(define %jest-w-rodzinie
  (%rel (x)
        [('andrzej)]
        [(x)
         (%przodek 'andrzej x)]))

(define %jest-ojcem
  (%rel (x y)
        [(x)
         (%ojciec x (_))]))

(define %elem-pary
  (%rel (x) ;możemy sobie mieszać te logiczne zmienne z konstrukcjami z Racket
        [(x (cons x (_)))]
        [(x (cons (_) x))]))

(define %car
  (%rel (x)
        [(x (cons x (_)))])) ;(%which (x) (%car 1 x)) '((x 1 . _)) takiej pary, (1, coś)

(define %elem-listy
  (%rel (x xs) ;to w kwadratowych mówi, że para (x, (cons x cokolwiek)) jest w relacji
        [(x (cons x (_)))] ;x jest elementem listy jeśli jest w głowie
        [(x (cons (_) xs)) ;lub gdy jest w reszcie listy
         (%elem-listy x xs)]))
;poprośmy o listę w której jest 2 i 3
;(%which (x) (%elem-listy 2 x) (%elem-listy 3 x))

(define %swap
  (%rel (x y)
        [((cons x y) (cons y x))]))

#|(define %kwadrat
  (%rel (x)
        [(x (* x x))])) takie nie zadziała, bo nie można mnożyć na zmiennych logicznych|#
(define %kwadrat
  (%rel (x y)
        [(x y)
         (%is y (* x x))]))

(define %insert
  (%rel (x xs y ys zs)
        [(x xs (cons x xs))]
        [(x (cons y ys) (cons y zs))
         (%insert x ys zs)]))
;(%which (ys) (%insert 0 '(1 2 3 4) ys)) wypisze nam wszystkie listy ys które powstały przez włożenie 0 do '(1 2 3 4)

(define %app
  (%rel (x xs ys zs)
        [(null xs xs)]
        [((cons x xs) ys (cons x zs))
         (%app xs ys zs)]))
;(%which (xs ys) (%app xs ys '(1 2 3 4))) wypisze wszystkie możliwości jak będziemy używać (%more)
(define %insert-s
  (%rel (x xs y ys zs)
        [(x null (cons x null))]
        [(x (cons y ys) (cons x (cons y ys)))
         (%> y x)]
        [(x (cons y ys) (cons y zs))
         (%insert-s x ys zs)]))
;ten insert wkłada tak żeby było posortowane