let fs = require('fs');
let fsPromises = require('fs').promises;
let util = require('util');

fs.readFile('test_6.txt', function (err, data) {
    if (err) throw err;
    console.log('Done loading file!');
});

//Sposób 1.
function fspromise(path, enc) {
    return new Promise((res, rej) => {
        fs.readFile(path, enc, (err, data) => {
            if (err)
                rej(err);
            res(data);
        });
    });
}
fspromise('test_6.txt', 'utf-8')
    .then(data => {
        console.log(`Done loading file promise!`);
    })
    .catch(err => {
        console.log(`err: ${err}`);
    })
//Sposób 2.
let readFile = util.promisify(fs.readFile)

readFile('test_6.txt')
    .then(data => {
        console.log("Done loading file using promisify");
    })
    .catch(err => {
        console.log(err)
    })
//Sposób 3.
fs.promises.readFile('test_6.txt')
    .then(data => {
        console.log("Done loading file fs.promises!");
    })
    .catch(err => {
        console.log(`err: ${err}`);
    })