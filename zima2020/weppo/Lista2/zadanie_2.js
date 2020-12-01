const myObj = {a: 1, "test[]": 2};
//a
//Korzystając z notacji [] możemy używać znaków, które nie zadziałałyby z notacją .
console.log(myObj.a);
console.log(myObj['test[]']);
//b
myObj[1] = "abc"; //Wszystko działa, ale trzeba używać nawiasów do odwołania
console.log(myObj[1]);

const myObj2 = {test: 1};
myObj[myObj2] = 2; //Też działa, po raz kolejny trzeba używać nawiasów
console.log(myObj[myObj2]);

console.log(myObj);
//c
const arr = ['test1'];
//Gdy napis jest zawiera w sobie liczbę dostaniemy wartość z odpowiedniego indeksu
console.log(arr[0]);
console.log(arr['0']);
arr[myObj2] = "test_obiekt";
console.log(arr[myObj2]);
//Jeśli zapiszemy pod stringiem, dostajemy tablicę asocjacyjną
arr['test2'] = "test";

console.log(arr);
//Tablica się wydłuża lub skraca, warto zaznaczyć, że pola z nazwą nie są liczone do długości tablicy
arr.length = 2;
console.log(arr.length);
console.log(arr);