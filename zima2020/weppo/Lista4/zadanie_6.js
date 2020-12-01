//Musiałem napisać generowanie pliku bo nie posiadam pod ręką loga serweru HTTP
let contentToFile = '';
for (let i = 0; i < 10000; i++) {
    contentToFile += Math.floor(Math.random() * 24) + ":" + Math.floor(Math.random() * 60) + ":" + Math.floor(Math.random() * 60) + " " +
        "192.168.1." + Math.floor(Math.random() * 255)
        + " /TheApplication/WebResource.axd 200\n";
}
fs = require('fs');
fs.writeFile('test_6.txt', contentToFile, function (err) {
    if (err) throw err;
    console.log('Done generating file!');
});

readline = require('readline');
var lineReader = readline.createInterface({
    input: fs.createReadStream('test_6.txt')
});

var ipsTable = [];

lineReader.on('line', function (line) {
    let ip = line.split(" ")[1];
    let ipNumber = ip.split(".").join("");
    if (ipsTable[ipNumber] !== undefined) {
        ipsTable[ipNumber].count++;
    }
    else ipsTable[ipNumber] = {'ip': ip, 'count': 1};
});
lineReader.on('close', function () {
    function compare( a, b ) {
        if ( a.count > b.count ){
          return -1;
        }
        if ( a.count < b.count ){
          return 1;
        }
        return 0;
      }
      
    ipsTable.sort(compare);
    console.log(ipsTable.slice(0, 3));
})