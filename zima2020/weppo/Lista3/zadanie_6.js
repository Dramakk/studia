function createGenerator(iterLimit) {
    var _state = 0;
    return {
        next: function () {
            return {
                value: _state,
                done: _state++ >= iterLimit
            }
        }
    }
}

var foo = {
    [Symbol.iterator]: (() => { return createGenerator(5) })
}

for (var f of foo)
    console.log(f);

var foo1 = {
    [Symbol.iterator]: (() => { return createGenerator(10) })
}

for (var f of foo1)
    console.log(f);
var foo2 = {
    [Symbol.iterator]: (() => { return createGenerator(15) })
}

for (var f of foo2)
    console.log(f);