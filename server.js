
var express = require('express');
var session  = require('express-session');
var cookieParser = require('cookie-parser');

var http = require('http');
var path = require('path');
var pug = require('pug');

var bodyParser = require('body-parser');
var app = express();
var morgan = require('morgan');

var passport = require('passport');
var flash    = require('connect-flash');


require('./config/passport')(passport); // pass passport for configuration


app.use(morgan('dev')); // log every request to the console
app.use(cookieParser()); // read cookies (needed for auth)
app.use(bodyParser.urlencoded({
	extended: true
}));
app.use(bodyParser.json());
//app.use(express.favicon());

// all environments
app.set('port', process.env.PORT || 4300);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');
app.use(express.static(path.join(__dirname, 'public')));

var config = require('./config/config.json');

//console.log( ' !!! secret == ' + config.secret);

var sessionConfig = {
  secret: config.secret,
  resave: false,
  saveUninitialized: true,
  cookie: {  secure: false   }
};
app.use(session(sessionConfig));


app.use(passport.initialize());
app.use(passport.session()); // persistent login sessions
app.use(flash()); // use connect-flash for flash messages stored in session


var logger = require("./app/logger");
logger.debug("Overriding 'Express' logger");

//require('./app/routes.js')(app);
require('./app/routes.js')(app, passport); 

app.get('*', function(req, res){
 res.status(404).render('404_error', {title: "Sorry, page not found"});
});



http.createServer(app).listen(app.get('port'), function(){
  console.log('TFRI App server listening on port ' + app.get('port'));
});
