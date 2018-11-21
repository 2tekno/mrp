var uuid = require("uuid");
var mysql = require('mysql');
var dbconfig = require('../config/database');
var bcrypt = require('bcrypt-nodejs');
var nodemailer = require("nodemailer");
var config = require('../config/config.json')[process.env.NODE_ENV || 'development'];

var connection;
handleDisconnect();



let transporter = nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
        user: "2tekno@gmail.com",
        pass: "E%355840"
    },
    tls: {
      rejectUnauthorized: false
  }
});



exports.createUser = function(ip,UserName,Email,Password,AccountType,IsActive,role,licType,licExpire, done) {
      console.log('createUser');	
      var userID = uuid.v4();
      
      var user = {
        userID      : userID,
        userName 	: UserName,
        firstName   : '',
        lastName 	: '',
        active      : IsActive,
        password 	: Password,
        email 		: Email,
        ipAddress	: ip,
        role        : role,
        accountType : AccountType,
        licType     : licType,
        licExpire   : licExpire,
      };

      

    var insertQuery = "INSERT INTO user set ? ";
    // var insertProfile = "INSERT INTO applicant set ? ";
    var insertToEmailVerificationQuery = "INSERT INTO email_verification set ? ";
		connection.query(insertQuery, [user], function(err, result) {
      //connection.query(insertProfile, [profile], function(err, result) {
        if (err) { console.log(err);  return done(null,null) } 
        else {
          if (IsActive==0) {
                var generatedHash = bcrypt.hashSync(Email, null, null);
                var host = config.host;
                var verUrl = host+'verifyaccount?id='+generatedHash+'&email='+Email;
                //var bccmails=["2tekno@gmail.com"];
                let mailOptions = {
                  from: '"MRP Manager" <support@mrpmanager.com>',
                  to: Email,
                  subject: 'Please confirm your Email account',
                  html: 'Thanks for joining MRP Manager!<br><br> Please confirm that your email is correct to continue. Click the link below to get started:<br><br><a href="'+verUrl+'">Click here to verify</a>'+
                  '<br><br>We are so excited to have you! <br><br>Sincerely,<br>The MRP Manager Team'
                }

                var verObj = {
                  userID: userID,
                  email: Email,
                  verification_code: generatedHash,
                  was_used: 0,
                };

                transporter.sendMail(mailOptions, (error, info) => {
                  connection.query(insertToEmailVerificationQuery, [verObj], function(err, result) { 
                    if (error) { return console.log('transporter.sendMail == ' + error);  }
                    console.log('Message sent: %s', info.messageId);

                  });

                });        
            }
          
            return done(null, user);
        }
       //})
    
    })
}

exports.verifyaccount= function(req, res) {
  console.log('id == ' + req.query.id);
  console.log('email == ' + req.query.email);

  var email = req.query.email;
  var verCode = req.query.id;

  connection.query("SELECT * FROM email_verification WHERE was_used=0 AND email='"+email+"' AND verification_code='"+verCode+"'", function (err, rows) {
    if (err) return done(err)
    if (rows.length==1) {
        var userID = rows[0].userID;
        var updateObj = { active: 1 };
        var updateObj2 = { was_used: 1 };
        var updateQuery = "UPDATE user set ? WHERE userID = ?";
        var updateQuery2 = "UPDATE email_verification set ? WHERE userID = ?";
        var deleteQuery = "DELETE FROM email_verification WHERE userID = ?";
        connection.query(updateQuery, [updateObj,userID], function(err, result) {
            if (err) {console.log(err);  }
            else { 
              connection.query(updateQuery2, [updateObj2,userID], function(err, result) {
                connection.query(deleteQuery, [userID], function(err, result) {
                  res.status(201).redirect('/local_login'); 
                })
              })
            
            }
        })
    }
    else {res.status(201).redirect('/local_signup'); } 
  })

}


exports.getAllUsers = function(done) {
    connection.query('SELECT * FROM user', function (err, rows) {
    if (err) return done(err)
    done(null, rows)
  })
}

exports.getUserByID = function(userId, done) {
   connection.query('SELECT * FROM user WHERE userID = ?', userId, function (err, rows) {
    if (err) return done(err)
    if (rows.length==1) {
        var user = {
          userID : rows[0].userID,
          userName: rows[0].userName,
          email: rows[0].email,
          role : rows[0].role,
          active : rows[0].active,
        };
        return done(null, user);
      }
      else {return done(null, null);} 
    })
}

exports.getUser = function(userId) {
   connection.query('SELECT * FROM user WHERE userID = ?', userId, function (err, rows) {
    if (err) return done(err)
    var user = {
      userID : rows[0].userID,
      userName: rows[0].userName,
      email: rows[0].email,
      role : rows[0].role,
      active : rows[0].active,
    };
      return user;
    })
}

exports.getUserByEmail = function(email, done) {
	console.log('getUserByEmail looking for: ' + email);
	
   connection.query('SELECT * FROM user WHERE Email = ?', email, function (err, rows) {
    if (err) return done(err)
	  if (rows.length==1) {
          var user = {
            userID : rows[0].userID,
            userName: rows[0].userName,
            email: rows[0].email,
            password : rows[0].password,
            role : rows[0].role,
            active : rows[0].active,
          };
          return done(null, user);
    }
    else {return done(null, null);} 
  })
}

exports.getUserByUserName = function(UserName, Password, done) {
	console.log('getUserByUserName looking for: ' + UserName);
	
   connection.query('SELECT * FROM user WHERE userName = ?', UserName, function (err, rows) {
    if (err) return done(err)
	  if (rows.length==1) {
          var user = {
            userID : rows[0].userID,
            userName: rows[0].userName,
            email: rows[0].email,
            password : rows[0].password,
            role : rows[0].role,
            active : rows[0].active,
          };
          return done(null, user);
    }
    else {return done(null, null);} 
  })
}


function handleDisconnect() {
  connection = mysql.createConnection(dbconfig.connection); // Recreate the connection, since
                                                  // the old one cannot be reused.

  connection.connect(function(err) {              // The server is either down
    if(err) {                                     // or restarting (takes a while sometimes).
      console.log('error when connecting to db:', err);
      setTimeout(handleDisconnect, 2000); // We introduce a delay before attempting to reconnect,
    }                                     // to avoid a hot loop, and to allow our node script to
  });                                     // process asynchronous requests in the meantime.
                                          // If you're also serving http, display a 503 error.
  connection.on('error', function(err) {
    console.log('db error', err);
    if(err.code === 'PROTOCOL_CONNECTION_LOST') { // Connection to the MySQL server is usually
      handleDisconnect();                         // lost due to either server restart, or a
    } else {                                      // connnection idle timeout (the wait_timeout
      throw err;                                  // server variable configures this)
    }
  });
}