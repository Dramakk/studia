var http = require('http');
var express = require('express');
var app = express();
var multer  = require('multer')
var upload = multer({ dest: './' })

app.set('view engine', 'ejs');
app.set('views', './');
app.engine('html', require('ejs').renderFile);

var storage = multer.diskStorage({
    destination: function (req, file, cb) {
      cb(null, './')
    },
    filename: function (req, file, cb) {
      cb(null, file.fieldname + ".pdf")
    }
  })
  
var upload = multer({ storage: storage })

app.use(express.urlencoded({ extended: true }));
app.get('/', (req, res) => {
    console.log("Got get request");
    res.render('./zadanie_1.html');
});
app.post('/', upload.single('zadanie_1'), (req, res, next) => {
    const file = req.file
    if (!file) {
      res.send("Proszę wybrać")
      return
    }
      res.send("Udało się!")
})
http.createServer(app).listen(3000);