
var users = require('../models/user');
var orders = require('./orders');
var products = require('./products');



module.exports = function(app, passport) {


  app.get('/orders/add', orders.renderAddNewOrder);
  app.get('/products/add', products.renderAddNewProduct);

  app.get('/orders', function(req, res) {
    res.render('orders');
  });

  app.get('/products', function(req, res) {
    res.render('products');
  });

  app.get('/allorders', orders.allorders);
  app.get('/allproducts', products.allproducts);
  
  app.get('/allordersSS', orders.allordersSS);
  app.get('/allproductsSS', products.allproductsSS);
  app.post('/orders/save_new', orders.save_new);


 app.get('/', function(req, res) {		
    console.log('req.user == ' + JSON.stringify(req.user));
    res.render('homepage',{page_title: "Home Page", user : req.user}); 
});



 
   // LOGIN ===============================
    // show the login form

    app.get('/logout', function (req, res){
      req.logout();
      res.clearCookie('connect.sid');
      res.render('layouts/header');
    });
    
  
    app.get('/local_login', function(req, res) {
      res.render('local_login', { message: req.flash('loginMessage'), user : req.user });
    });
  
    app.post('/local_login', passport.authenticate('local-login', {
          successReturnToOrRedirect : '/profile', 
          failureRedirect : '/local_login', 
          failureFlash : true 
        }),function(req, res) {
            res.redirect(req.session.returnTo || '/');
            delete req.session.returnTo;
    });
  
    app.get('/verification_email_sent', function (req, res){
    res.render('verification_email_sent');
    });
  
    app.get('/verifyaccount', users.verifyaccount);

  // SIGNUP ==============================
  app.get('/local_signup', function(req, res) {
		res.render('local_signup', { message: req.flash('signupMessage') });
	});

	app.post('/local_signup', passport.authenticate('local-signup', {
			successReturnToOrRedirect : '/verification_email_sent', 
			failureRedirect : '/local_signup', 
			failureFlash : true 
		})
	);

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
