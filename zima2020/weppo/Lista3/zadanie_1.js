var testObject = {
    testField : 0,
    get bar() {
        return testObject.testField;
    },
    set bar(i) {
        testObject.testField = i;
    },
    testMethod : function (){
        return "Jestem funkcją";
    }
};
testObject.secondTestMethod = function () {
    return "Jestem drugą funckją!"
};

testObject.testField2 = 2;
Object.defineProperty(testObject, 'testFieldd', {
    get : function() {
        return testObject.testField2;
    },
    set : function(i) {
        testObject.testField2 = i;
    }
});

testObject.testFieldd = 4;
console.log(testObject);