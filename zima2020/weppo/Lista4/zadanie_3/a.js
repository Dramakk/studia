module.exports = { a };
let b = require('./b');
function a(n) {
    if (n > 0) {
        console.log(`a: ${n}`);
        b.b(n - 1);
    }
}