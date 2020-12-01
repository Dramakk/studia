module.exports = { b };
let a = require('./a');
function b(n) {
    if (n > 0) {
        console.log(`b: ${n}`);
        a.a(n - 1);
    }
}