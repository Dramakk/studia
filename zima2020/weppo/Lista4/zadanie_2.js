//Napisałem dwie wersje i nie wiem o którą chodziło dokładnie w zadaniu, dlatego zostawiam tak
function Foo() {
    var Qux = function () {
        console.log("Jestem prywatna!");
    }
    Foo.prototype.Bar = function () {
        console.log("Hej");
        Qux();
    }
}

var Foo2 = (function () {
    var quxSymbol = Symbol('Qux');
    function Foo2() {
        this[quxSymbol] = function() {
            console.log("Jestem prywatna! 2");
        };
    }
    Foo2.prototype.Bar = function () {
        console.log("Hej");
        this[quxSymbol]();
    };
    return Foo2;
}());
var foo1 = new Foo();
foo1.Bar();

var foo2 = new Foo2();
foo2.Bar();
