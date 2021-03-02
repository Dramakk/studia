var http = require('http');
var express = require('express');
var app = express();

app.set('view engine', 'ejs');
app.set('views', './');

app.use(express.urlencoded({ extended: true }));
app.get('/', (req, res) => {
    console.log("Got get request");
    res.render('zadanie_2.ejs');
});
http.createServer(app).listen(3000);