const fib = function (n){
    let prev = 0,
        curr = 0;
        next = 1;
    
    for(let i = 1; i<n; i++){
        prev = curr;
        curr = next;
        next = prev+curr;
    }

    return next;
}

const fibRec = function (n){
    if(n === 0){
        return 0;
    }
    else if(n === 1){
        return 1;
    }

    return fibRec(n-1)+fibRec(n-2);
}

for(let i = 10; i <= 46; i++){
    console.log("-------------------------------")
    console.time(i+"-ta liczba Fibonacciego iteracyjnie");
    console.log(fib(i));
    console.timeEnd(i+"-ta liczba Fibonacciego iteracyjnie");
    console.time(i+"-ta liczba Fibonacciego rekurencyjnie");
    console.log(fibRec(i));
    console.timeEnd(i+"-ta liczba Fibonacciego rekurencyjnie");
}

//Dla 45 liczby Fibonacciego w Chrome, uzyskałem czas gorszy o 3 sekundy, dla 46 było to około 4.5s (gorszy w stosunku do Node.js)