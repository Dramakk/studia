const magicNumbers = function () {
    let result = [];

    for(let i = 1; i <= 100000; i++){
        let digits = i.toString().split(''),
            flag = true,
            sum = 0;

        digits.forEach(element => {
            let digit = parseInt(element);

            if(i !== 0 && i % digit !== 0){
                flag = false;
                return;
            }
            sum+=digit;
        });
        
        if(flag && i % sum === 0){
            result.push(i);
        }
    }

    return result;
}

console.log(magicNumbers());