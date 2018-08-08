var LocalStrategy   = require('passport-local').Strategy;
var bcrypt = require('bcrypt-nodejs');
var sql = require('mssql');
var config = require('../config/database');

var users = require('../models/user');

module.exports = function(passport) {


    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
        //console.log('serializeUser == ' + JSON.stringify(user));
        done(null, user.UserID);
    });

    // used to deserialize the user
    passport.deserializeUser(function(id, done) {
        users.getUserByID(id, function(err, user){
            //console.log('deserializeUser ---> ' + JSON.stringify(user));	
			done(err, user);
		});
    });

  

    passport.use(
        'local',
        new LocalStrategy({
            usernameField : 'UserName',
            passwordField : 'Password',
            passReqToCallback : true // allows us to pass back the entire request to the callback
        },
        function(req, UserName, Password, done) { // callback with email and password from our form
           		
            users.getUserByName(UserName, Password, function(err, user) {
                if(err)  return done(err);
                //console.log('ZZZuser == ' + JSON.stringify(user));
                if (user) {
                    req.user = user;  //refresh the session value
                    //console.log(' Password:  ' + req.user.Password);
                    //if (!bcrypt.compareSync(Password, user.Password))

                    if (user.Inactive=='1')
                        return done(null, false, req.flash('loginMessage', 'This login is disabled. Please contact the system administrator.')); 

                    if (user.ChangePasswordWhenLogin=='1') {
                        req.session.returnTo = '/users/changepassword';
                        return done(null, user);
                    }
                        

                    if (Password.trim() === user.Password.trim())
                        return done(null, user);
                    
                    return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.')); 
                        
                }
                else {
                    console.log('No user found.');
                    return done(null, false, req.flash('loginMessage', 'No user found.'));
                }   
                
            });

            
            
        })
    );
};
