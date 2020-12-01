function fib() {
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
//Tutaj nie można użyć for of
var _it = fib();
for (var _result; _result = _it.next(), !_result.done;) {
    console.log(_result.value);
}
//Tutaj można użyć for of
// var foo = {
//     [Symbol.iterator]: fib,
// }

// for (var f of foo)
//     console.log(f);

function* fib() {
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
//Tutaj można użyć for of
var _it = fib();
// for (var _result; _result = _it.next(), !_result.done;) {
//     console.log(_result.value);
// }
for (var f of foo)
    console.log(f);