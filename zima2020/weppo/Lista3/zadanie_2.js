function memoize(fn) {
    var cache = {};
    return function (n) {
        if (n in cache) {
            return cache[n]
        } else {
            var result = fn(n);
            cache[n] = result;
            return result;
        }
    }
}

function fibRec(n){
    if(n === 0){
        return 0;
    }
    else if(n === 1){
        return 1;
    }

    return fibRec(n-1)+fibRec(n-2);
}

var memoFib = memoize(fibRec);
console.log(memoFib(45));
console.log(memoFib(45));

/* Pierwsze wywołanie nadal trwa bardzo długo, ale kiedy mamy wartości w kontekście, to po prostu
je pobieramy, co znacznie przyspiesza obliczanie */