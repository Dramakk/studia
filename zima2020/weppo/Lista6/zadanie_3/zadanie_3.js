var http = require('http');
var express = require('express');
var app = express();
var cookieParser = require('cookie-parser');

app.set('view engine', 'ejs');
app.set('views', './');
app.disable('etag');
app.use(cookieParser());
app.use(express.urlencoded({
    extended: true
}));
app.use(express.urlencoded({ extended: true }));

var session = require('express-session');
var FileStore = require('session-file-store')(session);
 
app.use(session({
    store: new FileStore,
    secret: 'zadanie_3',
    resave: true,
    saveUninitialized: true
  })
);

app.get('/', (req, res) => {
    console.log("Got get request");
    let cookieSupport = "Twoja przeglądarka wspiera ciastka"
    if(req.session.ile >= 0){
        req.session.ile++;
    }

    if (!req.cookies.support) {
        res.cookie('support', "Twoja przeglądarka wspiera ciastka");
    }
    else {
        if (req.cookies.support !== "Twoja przeglądarka wspiera ciastka"){
            cookieSupport = "Nie wspiera ciasteczek";
        }
    }
    cookieValue = req.cookies.ciasteczko;
    res.render("zadanie_3", { cookieValue: cookieValue, cookieSupport: cookieSupport, sessionValue: req.session.ile});
});

app.get('/createCookie', (req, res) => {
    console.log("Got get request");
    var cookieValue;
    if (!req.cookies.ciasteczko) {
        cookieValue = new Date().toString();
        res.cookie('ciasteczko', cookieValue);
    } else {
        cookieValue = req.cookies.ciasteczko;
    }
    res.redirect('/');
});

app.get('/deleteSession', (req, res) => {
    console.log("Got get request");
    delete req.session.ile
    res.redirect('/');
});

app.get('/createSession', (req, res) => {
    console.log("Got get request");
    req.session.ile = 0;
    res.redirect('/');
});

app.get('/deleteCookie', (req, res) => {
    console.log("Got get request");
    res.cookie('ciasteczko', '', {maxAge: -1});
    res.redirect('/');
});

http.createServer(app).listen(3000);