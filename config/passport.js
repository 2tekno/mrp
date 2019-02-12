var LocalStrategy   = require('passport-local').Strategy;
// var GoogleStrategy  = require('passport-google-oauth20').Strategy;
// var FacebookStrategy = require('passport-facebook').Strategy;
var bcrypt = require('bcrypt-nodejs');
var users = require('../models/user');
var config = require('../config/config.json')[process.env.NODE_ENV || 'development'];
var moment = require('moment');

var trialPeriodDays = 14;

function extractProfile (profile) {

  return {
    UserID: profile.id,
    UserName: profile.displayName,
	Email: profile.Email
  };
}

function getExpireDate(days) {

	// var rMax = moment(new Date()); 
	// rMax.add(days, 'days');
	// var tD = moment(new Date(rMax)).format('ll');
	var td = moment().add(trialPeriodDays,'days').format("YYYY-MM-DD HH:mm:ss");;
	console.log('moment == ' + td);
	return td;
  };

module.exports = function(passport) {

    // =========================================================================
    // passport session setup ==================================================
    // =========================================================================
    // required for persistent login sessions
    // passport needs ability to serialize and unserialize users out of session

    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
		console.log('serializeUser ---> ' + JSON.stringify(user));	
		done(null, user.userID);		
    });

	

	passport.deserializeUser(function(id, done) {
		users.getUserByID(id, function(err, user){
			//console.log('deserializeUser ---> ' + JSON.stringify(user));	
			done(err, user);
		});
	});
	
	
	
    // =========================================================================
    // LOCAL LOGIN =============================================================
    // =========================================================================
    // we are using named strategies since we have one for login and one for signup
    // by default, if there was no name, it would just be called 'local'
    passport.use(
        'local-login',
			new LocalStrategy({
					usernameField : 'UserName',
					passwordField : 'Password',
					passReqToCallback : true}, 

			function(req, UserName, Password, done) { 
				console.log('local-login');	
				users.getUserByUserName(UserName, Password, function(err, user) {
					if (user) {
						console.log('local-login: User found.');	
						req.user = user; 
						
						if (user.active==0)
							return done(null, false, req.flash('loginMessage', 'Account is not active!')); 
						
						if (bcrypt.compareSync(Password.trim(),user.password.trim()))
							return done(null, user);
						return done(null, false, req.flash('loginMessage', 'Oops! Wrong password.')); 
					} else {
						console.log('local-login: No user found.');	
						return done(null, false, req.flash('loginMessage', 'No user found.'));
					}
				});
		}
	));

	
	passport.use(
        'local-signup',
			new LocalStrategy({
					usernameField: 'UserName',
					passwordField: 'Password',
					passReqToCallback: true}, 
			
		function(req, UserName, Password, done) { 	
				console.log('local-signup');	
				var company_name = req.body.company_name;
				console.log('company_name == ' + company_name);	
				
				 users.getUserByCompanyName(company_name, function(err, user) {
					if (user) {
						return done(null, false, req.flash('signupMessage', 'That company is already exists.'));
					} else {
						var newCompany = {
							UserName: UserName,
							Email: UserName,
							company_name: company_name,
							Password: bcrypt.hashSync(Password, null, null),
							ipAddress: 0,
							AccountType:'local',
							IsActive: 0,
							role: '',
							licType: 'trial',
							licExpire: getExpireDate(trialPeriodDays),
	 						};
						
						users.createCompany(newCompany, function(err, user) {
							return done(null, user);
						});
					}
				});
			}
	));

	// passport.use(
	// 		new GoogleStrategy({
	// 			  clientID: config.google.clientID,
	// 			  clientSecret: config.google.clientSecret,
	// 			  callbackURL: config.google.callbackURL,
	// 			  passReqToCallback: true},
	// 	  function(req, accessToken, refreshToken, profile, done) {
	// 			console.log('google profile email: ' + profile.emails[0].value);
	// 			var ip = req.headers['x-forwarded-for'] || 
	// 						req.connection.remoteAddress || 
	// 						req.socket.remoteAddress ||
	// 						req.connection.socket.remoteAddress;
	// 			users.getUserByEmail(profile.emails[0].value, function(err, user) {
	// 				if(err) {return done(err);}
	// 				if (user) {
	// 					console.log('google signup == That username already exists.');
	// 					return done(null, user);
	// 				} else {
	// 					var AccountType = 'google';
	// 					var role = 'applicant';
	// 					var IsActive = 1;
	// 					var licType = 'trial';
	// 					var licExpire = getExpireDate(trialPeriodDays);
	// 					users.createUser(ip, profile.emails[0].value, profile.emails[0].value,'',AccountType,IsActive,role,licType,licExpire, function(err, user) {
	// 						return done(null, user);
	// 					});
	// 				}
	// 			});
	// 	  }
	// ));
	

	// passport.use(
	// 	new FacebookStrategy({
	// 	  clientID: config.facebook.clientID,
	// 	  clientSecret: config.facebook.clientSecret,
	// 	  callbackURL: config.facebook.callbackURL,
	// 	  profileFields: ['id', 'emails', 'name'],
	// 	  passReqToCallback: true
	// 	},
	// 	function(req,accessToken, refreshToken, profile, done) {
	// 		console.log('req ' + req);
	// 		var ip = req.headers['x-forwarded-for'] || 
	// 						req.connection.remoteAddress || 
	// 						req.socket.remoteAddress ||
	// 						req.connection.socket.remoteAddress;
	// 		console.log('ip == ' + ip);
	// 		users.getUserByEmail(profile.emails[0].value, function(err, user) {
	// 			if(err) {return done(err);}
	// 			if (user) {
	// 				console.log('fb signup == That username already exists.');
	// 				return done(null, user);
	// 			} else {
	// 				var AccountType = 'fb';
	// 				var role = 'applicant';
	// 				var IsActive = 1;
	// 				var licType = 'trial';
	// 				var licExpire = getExpireDate(trialPeriodDays);
	// 				users.createUser(ip, profile.emails[0].value, profile.emails[0].value,'',AccountType,IsActive,role,licType,licExpire, function(err, user) {
	// 					return done(null, user);
	// 				});
	// 			}
	// 		});		
	// 	}
	// ));


	
};


function getIp () {
	var ip='';
	Object.keys(ifaces).forEach(function (ifname) {
		var alias = 0;
		
		ifaces[ifname].forEach(function (iface) {
			if ('IPv4' !== iface.family || iface.internal !== false) {
			// skip over internal (i.e. 127.0.0.1) and non-ipv4 addresses
			//console.log('not IPv4');
			return;
			}
		
			if (alias >= 1) {
			// this single interface has multiple ipv4 addresses
				console.log(ifname + ':' + alias, iface.address);
				ip += ' | ' + iface.address;
			} else {
			// this interface has only one ipv4 adress
				console.log(ifname, iface.address);
				ip = iface.address;
			}
			++alias;
		});
	});
	return ip;
}