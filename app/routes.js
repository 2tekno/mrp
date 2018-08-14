
var users = require('../models/user');
var orders = require('./orders');


module.exports = function(app, passport) {


  app.get('/orders/add', orders.renderAddNewOrder);

  app.get('/orders', function(req, res) {
    res.render('orders');
  });

  app.get('/allorders', orders.allorders);
  app.get('/allproducts', orders.allproducts);
  
  app.get('/allordersSS', orders.allordersSS);
  app.get('/allproductsSS', orders.allproductsSS);
  app.post('/orders/save_new', orders.save_new);


 app.get('/', function(req, res) {		
    console.log('req.user == ' + JSON.stringify(req.user));
    res.render('homepage',{page_title: "Home Page", user : req.user}); 
});



 
   // LOGIN ===============================
    // show the login form
    app.get('/login', function(req, res) {
      res.render('login', { message: req.flash('loginMessage'), user: req.user});
    });
      

    app.post('/login', passport.authenticate('local', {
          successReturnToOrRedirect : '/', // redirect to the secure profile section
          failureRedirect : '/login', // redirect back to the signup page if there is an error
          failureFlash : true // allow flash messages
      }),
      function(req, res) {
        console.log('req.session.returnTo = ' + req.session.returnTo);
        res.redirect(req.session.returnTo || '/');
        delete req.session.returnTo;
    });

    app.get('/logout', function(req, res) {
      req.logout();
      res.redirect('/');
      
    });
}

function isLoggedIn(req, res, next) {
	if (req.user) {
		return next();
	}
    else { 
        req.session.returnTo = req.path;  
        res.redirect('/login'); 
    }
}
