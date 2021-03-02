qsortBy::(a->a->Bool)->[a]->[a]
qsortBy p [] = []
qsortBy p (h:t)=qsortBy p ([x|x<-t,not (p h x)])++[h]++qsortBy p ([x|x<-t,p h x])