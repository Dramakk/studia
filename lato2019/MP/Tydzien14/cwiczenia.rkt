#lang racket

(require racklog)

(define %rodzic ; (%rodzic x y) oznacza, że iks jest rodzicem igreka
  (%rel ()
        [('elżbieta2 'karol)]
        [('elżbieta2 'anna)]
        [('elżbieta2 'andrzej)]
        [('elżbieta2 'edward)]
        [('karol     'william)]
        [('karol     'harry)]
        [('anna      'piotr)]
        [('anna      'zara)]
        [('andrzej   'beatrycze)]
        [('andrzej   'eugenia)]
        [('edward    'james)]
        [('edward    'louise)]
        [('william   'george)]
        [('william   'charlotte)]
        [('william   'louis)]
        [('harry     'archie)]
        [('piotr     'savannah)]
        [('piotr     'isla)]
        [('zara      'mia)]
        [('zara      'lena)]))

(define %rok-urodzenia
  (%rel ()
        [('elżbieta2 1926)]
        [('karol     1948)]
        [('anna      1950)]
        [('andrzej   1960)]
        [('edward    1964)]
        [('william   1982)]
        [('harry     1984)]
        [('piotr     1977)]
        [('zara      1981)]
        [('beatrycze 1988)]
        [('euagenia  1990)]
        [('james     2007)]
        [('louise    2003)]
        [('george    2013)]
        [('charlotte 2015)]
        [('louis     2018)]
        [('archie    2019)]
        [('savannah  2010)]
        [('isla      2012)]
        [('mia       2014)]
        [('lena      2018)]))

(define %plec
  (%rel ()
        [('elżbieta2 'k)]
        [('karol     'm)]
        [('anna      'k)]
        [('andrzej   'm)]
        [('edward    'm)]
        [('william   'm)]
        [('harry     'm)]
        [('piotr     'm)]
        [('zara      'k)]
        [('beatrycze 'k)]
        [('euagenia  'k)]
        [('james     'm)]
        [('louise    'k)]
        [('george    'm)]
        [('charlotte 'k)]
        [('louis     'm)]
        [('archie    'm)]
        [('savannah  'k)]
        [('isla      'k)]
        [('mia       'k)]
        [('lena      'k)]))

(define %spadl-z-konia
  (%rel ()
        [('anna)]))
(define (collect which)
  (define (aux which acc)
	(if which
  	(aux (%more) (cons which acc))
  	(reverse acc))
  )
  (aux which '()))
(define %prababcia
  (%rel (x y z u)
        [(x y)
         (%plec x 'k)
         (%rodzic z y)
         (%rodzic u z)
         (%rodzic x u)]))
(define %praprababcia
  (%rel (x y z u)
        [(x y)
         (%rodzic z y)
         (%prababcia x z)]))
(define %bornin
  (%rel (x y)
        [(x y)
         (%prababcia 'elżbieta2 x)
         (%rok-urodzenia x y)]))

(define %wiekprawnucząt
  (%rel (x y z)
        [(x y)
         (%prababcia 'elżbieta2 x)
         (%rok-urodzenia x z)
         (%is y (- 2019 z))]))

(define %kuzyni
  (%rel (a x y z)
        [(y)
         (%rodzic x 'archie)
         (%rodzic a x)
         (%rodzic a z)
         (%rodzic z y)
         (%not (%= z x))]))
(define %rodzenstwo
  (%rel (a x y)
        [(x y)
         (%rodzic a x)
         (%rodzic a y)
         (%not (%= x y))]))
;wersja trudniejsza
(define %starsze-rodzenstwo
  (%rel (a b c x y r r1 r2)
        [(x y)
         (%rodzenstwo x y)
         (%plec x c)
         (%plec y c)
         (%rok-urodzenia x a)
         (%rok-urodzenia y b)
         (%< a b)]
        [(x y)
         (%rodzenstwo x y)
         (%plec x 'm)
         (%plec y 'k)
         (%rok-urodzenia y r)
         (%< r 2011)] ;ta linia w wersji trudniejszesz
        [(x y) ;w wersji trudniejszej
         (%rodzenstwo x y)
         (%plec x 'm)
         (%plec y 'k)
         (%rok-urodzenia y r1)
         (%>= r 2011)
         (%rok-urodzenia x r2)
         (%< r2 r1)]
        [(y x) ;w wersji trudniejszej
          (%rodzenstwo x y)
          (%plec x 'm)
          (%plec y 'k)
         (%rok-urodzenia y r1)
         (%>= r 2011)
         (%rok-urodzenia x r2)
         (%< r1 r2)]))
;ćw 3 moje starsze rodzeństwo i ich dzieci, mój rodzic i Ci którzy go wyprzedzają
;ćw 4
(define %revapp
  (%rel (x y xs ys zs)
        [(null y y)]
        [((cons x xs) ys zs)
         (%revapp xs (cons x ys) zs)]))
(define %rev
  (%rel (xs ys)
        [(xs ys)
         (%revapp xs null ys)]))
;ćw 6
(define %merge
  (%rel (A B Ra Rb M)
        [(A null A)]
        [(null B B)]
        [((cons A Ra) (cons B Rb) (cons A M))
         (%<= A B)
         (%merge Ra (cons B Rb) M)]
        [((cons A Ra) (cons B Rb) (cons B M))
         (%> A B)
         (%merge (cons A Ra) Rb M)]))
(define %split
  (%rel (A B R Ra Rb)
        [(null null null)]
        [((cons A null) (cons A null) null)]
        [((cons A (cons B R)) (cons A Ra) (cons B Rb))
         (%split R Ra Rb)]))
(define %mergesort
  (%rel (A B R S L1 L2 SL1 SL2)
        [(null null)]
        [((cons A null) (cons A null))]
        [((cons A (cons B R)) S)
         (%split (cons A (cons B R)) L1 L2)
         (%mergesort L1 SL1)
         (%mergesort L2 SL2)
         (%merge SL1 SL2 S)]))