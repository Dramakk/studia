var http = require('http');
var express = require('express');
var app = express();

app.set('view engine', 'ejs');
app.set('views', './views');

app.use(express.urlencoded({ extended: true }));
app.get('/', (req, res) => {
    console.log("Got get request");
    res.render('getData.ejs', { name: '' , surname: '', zadania: [], errorMessage: ''});
});
app.get('/print', (req, res) => {
    res.redirect('/');
})
app.post('/print', (req, res) => {
    var name = req.body.name,
        surname = req.body.surname,
        zadanie = [];

    for(let i = 0; i<10; i++){
        var zadanieVal = req.body[String(i)];
        if(zadanieVal === ''){
            zadanieVal = '0';
        }
        zadanie.push(zadanieVal);
    }

    if(name === '' || surname === ''){
        res.render('getData.ejs', {name: name, surname: surname, zadania: zadanie, errorMessage: 'Podaj imię i nazwisko'});
    }
    else{
        res.render('print.ejs', {name: name, surname: surname, zadania: zadanie, errorMessage: ''});
    }
});
http.createServer(app).listen(3000);