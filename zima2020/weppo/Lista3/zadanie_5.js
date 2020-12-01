function sum(...args) {
    let argsLength = args.length;
    let returnVal = 0;
    for(let i = 0; i < argsLength; i++){
        returnVal+=args[i];
    }

    return returnVal;
}
console.log(sum(1, 2, 3));
// 6
console.log(sum(1, 2, 3, 4, 5));
// 15