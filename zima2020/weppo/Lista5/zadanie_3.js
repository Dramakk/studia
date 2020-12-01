var http = require('http');
var server =
    http.createServer(
        (req, res) => {
            res.setHeader('Content-Disposition', 'attachment; filename="test.html"')
            res.end(`<html><head><title>Test</title></head><body><h1>Testowy nagłówek</h1></body></html>`);
        });
server.listen(3000);
console.log('started');