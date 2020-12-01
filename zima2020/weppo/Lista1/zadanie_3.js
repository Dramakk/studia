const primeNumbers = function () {
    let result = [];

    for(let i = 2; i <= 100000; i++){
        let flag = true;

        for(let j = 2; j*j<i; j++){
            if(i % j === 0){
                flag = false;
                break;
            }
        }

        if(flag){
            result.push(i);
        }
    }

    return result;
}

console.log(primeNumbers());