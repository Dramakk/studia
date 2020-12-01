function fibIter() {
    let curr = 0;
    let prev = 0;
    let nextVal = 1;
    return {
        next: function () {
            prev = curr;
            curr = nextVal;
            nextVal = prev + curr;
            return {
                value: curr,
                done: false
            }
        }
    }
}

function* fibGen() {
    let curr = 0;
    let prev = 0;
    let nextVal = 1;
    while (true) {
        prev = curr;
        curr = nextVal;
        nextVal = prev + curr;
        yield curr;
    }
}

function* take(it, top) {
    let howMany = 0;
    let iter = it;
    while (howMany < top) {
        howMany++
        yield iter.next().value;
    }
}
// zwróć dokładnie 10 wartości z potencjalnie
// "nieskończonego" iteratora/generatora
for (let num of take(fibIter(), 10)) {
    console.log(num);
}