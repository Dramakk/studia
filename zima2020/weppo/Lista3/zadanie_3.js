function forEach(a, f) {
    let aLength = a.length;
    for(let i = 0; i<aLength; i++){
        f(a[i]);
    }
}

function map(a, f) {
    let aLength = a.length;
    for(let i = 0; i<aLength; i++){
        a[i] = f(a[i]);
    }
    return a;
}

function filter(a, f) {
    let returnArray = [];
    let aLength = a.length;
    for(let i = 0; i<aLength; i++){
        if (f(a[i])){
            returnArray.push(a[i]);
        }
    }
    return returnArray;
}
function tryForEach(a){
    console.log(a);
};
function tryFilter(a){
    return a < 3;
}
function tryMap(a){
    return a*2;
}
var a = [1, 2, 3, 4];
forEach(a, _ => { console.log(_); });
// [1,2,3,4]
console.log(filter(a, _ => _ < 3));
// [1,2]
console.log(map(a, _ => _ * 2));
// [2,4,6,8]
forEach(a, tryForEach);
console.log(filter(a, tryFilter));
console.log(map(a, tryMap));