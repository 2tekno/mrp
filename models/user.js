var sql = require('mssql');
var config = require('../config/database');
var async = require('async');
var logger = require('winston'); 
var enums = require('../config/enums');

exports.changepassword = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
    var userID = req.params.id  
	var Password = input.Password.replace(/(')/g, "''");
    var ChangePasswordWhenLogin = 0;

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
					
      request.query("UPDATE users SET "+
                    "Password='"+Password+"'"+
                    ",ChangePasswordWhenLogin='"+ChangePasswordWhenLogin+"'"+
   					" WHERE UserID='"+userID+"'", function(err, rows) {


         if (err) logger.error("Error updating the users table: %s ", err);
		 else {
			  res.contentType('application/json');
			  var data = JSON.stringify('/login');
			  res.header('Content-Length', data.length);
			  res.end(data);
		  }
	  });
	});
};


exports.form_security = function(req, res){
    var input = JSON.parse(JSON.stringify(req.body));
    var userID = req.user.UserID;
    var formName = input.formName;
    console.log('form_security userID==' + userID);
    console.log('form_security formName==' + formName);
    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query("select FieldName,AccessLevel from vwFormAccessLevel WHERE userID = '"+userID +"' AND Form='"+ formName + "'", function(err, fieldList) {
          if(err) logger.error("Error Selecting from vwFormAccessLevel table: %s ", err);
          res.send(JSON.stringify(fieldList));
        });
    });
};


exports.renderNewUser = function(req, res) {
    var accessLevelArray = enums.accessLevelArray;
    var enumYesNo = enums.enumYesNo;

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString2 = "SELECT distinct A.UPGID,A.GroupName,RoleID = ISNULL(B.RoleID,0) FROM UsersPermissionGroup A LEFT JOIN UserGroupSecurity B ON B.UPGID = A.UPGID AND B.UserID='0'";

        request.query(sqlString2, function(err, permissions) {
           if(err) logger.error("Error Selecting from user permissions table: %s ", err);
               
            res.render('add_user', {
                permissions: permissions,
                accessLevelArray: accessLevelArray,
                user: req.user,
                enumYesNo: enumYesNo,
                ChangePasswordWhenLogin: 1
            });
      });
  });
}


exports.renderUser = function(req, res) {
    var userID = req.params.id  
    var accessLevelArray = enums.accessLevelArray;
    var enumYesNo = enums.enumYesNo;

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString = "SELECT * FROM users WHERE UserID='"+userID+"'";
      var sqlString2 = "SELECT distinct A.UPGID,A.GroupName,RoleID = ISNULL(B.RoleID,0) FROM UsersPermissionGroup A LEFT JOIN UserGroupSecurity B ON B.UPGID = A.UPGID AND B.UserID='"+userID+"'";

      request.query(sqlString, function(err,result) {
        if(err) logger.error("Error Selecting from User table: %s ", err);
        request.query(sqlString2, function(err, permissions) {
           if(err) logger.error("Error Selecting from user permissions table: %s ", err);
               
            res.render('edit_user', {
                data: result[0],
                permissions: permissions,
                accessLevelArray: accessLevelArray,
                user: req.user,
                enumYesNo: enumYesNo
               
            });
      });
      });
  });
}

exports.user_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));

	console.log('*****user_validate == ' +JSON.stringify(req.body));

	var UserName = input.UserName.replace(/(')/g, "''");
	var Email = input.Email.replace(/(')/g, "''");

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM Users WHERE UserName = '" + UserName  + "'", function(err, data) {
			if(err) logger.error("Error Selecting from users table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};

exports.save_edit = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
    var userID = req.params.id  
    var UserName = input.UserName.replace(/(')/g, "''");
	var Password = input.Password.replace(/(')/g, "''");
	var Email = input.Email.replace(/(')/g, "''");
    var FName = input.FName.replace(/(')/g, "''");
    var LName = input.LName.replace(/(')/g, "''");
    var Inactive = input.Inactive == '1' ? 1 : 0;
    var IsAdmin = input.IsAdmin == '1' ? 1 : 0;
    var ChangePasswordWhenLogin = input.ChangePasswordWhenLogin == '1' ? 1 : 0;

    console.log('input.IsAdmin == ' + input.IsAdmin);
    console.log('IsAdmin == ' + IsAdmin);

    var secLevelArray = [];
    if (input.secLevelArray != null) {  secLevelArray = JSON.parse(input.secLevelArray);  }
    
    console.log('secLevelArray == ' + JSON.stringify(secLevelArray));
    
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
					
      request.query("UPDATE users SET "+
                    " UserName='"+UserName+"'"+
                    ",Password='"+Password+"'"+
                    ",FName='"+FName+"'"+
                    ",LName='"+LName+"'"+
                    ",Email='"+Email+"'"+
                    ",Inactive='"+Inactive+"'"+
                    ",IsAdmin='"+IsAdmin+"'"+
                    ",ChangePasswordWhenLogin='"+ChangePasswordWhenLogin+"'"+
   					" WHERE UserID='"+userID+"'", function(err, rows) {

         save_permissions(userID,secLevelArray);

         if (err) logger.error("Error updating the users table: %s ", err);
		 else {
			  res.contentType('application/json');
			  var data = JSON.stringify('/all_users');
			  res.header('Content-Length', data.length);
			  res.end(data);
		  }
	  });
	});
};


function save_permissions(userID,secLevelArray) {
    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        var qtyRec;
        async.each(secLevelArray, function(obj, callback) {
            var UPGID = obj.UPGID;
            var RoleID = obj.RoleID;
            console.log('save_permissions  *** userID == ' + userID);
            console.log('save_permissions  *** UPGID == ' + UPGID);

            request.query("SELECT Qty = count(*) FROM UserGroupSecurity WHERE UserID='"+userID+"' AND UPGID='"+UPGID+"'", function(err, data) {
                if(err) logger.error("Error Selecting from UserGroupSecurity table: %s ", err);
                qtyRec = data[0].Qty;
                console.log('qtyRec == ' + qtyRec);
                if( qtyRec == "0" ) {
                    request.query("INSERT INTO UserGroupSecurity (UserID,UPGID,RoleID) VALUES ('" +
                    userID +"','"+ UPGID +"','"+ RoleID +"') ", function(err, rows) {
                        if (err) logger.error("Error inserting in UserGroupSecurity table: %s ", err);
                    })  
                    callback();
                } else {
                    request.query("UPDATE UserGroupSecurity SET "+
                        "RoleID="+RoleID+" WHERE UserID='"+userID+"' AND UPGID='"+UPGID+"'", function(err, rows) {
                            if (err) logger.error("Error updating of UserGroupSecurity table: %s ", err);
                    })
                    callback();
                }
            });
            
        }, function(err) {
            if( err ) {
              console.log('process failed');
            } else {
              console.log('data processed successfully');
            }
        });
    });
};

exports.save_new = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	var userID = req.user.UserID;
	//console.log(input);

    var UserName = input.UserName.replace(/(')/g, "''");
    var FName = input.FName.replace(/(')/g, "''");
    var LName = input.LName.replace(/(')/g, "''");
	var Password = input.Password.replace(/(')/g, "''");
	var Email = input.Email.replace(/(')/g, "''");
	var Inactive = input.Inactive == '1' ? 1 : 0;
    var IsAdmin = input.IsAdmin == '1' ? 1 : 0;
    var ChangePasswordWhenLogin = input.ChangePasswordWhenLogin == '1' ? 1 : 0;
    
    
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
					
	  request.query("INSERT INTO users (UserName,Password,Email,Inactive,FName,LName,ChangePasswordWhenLogin,IsAdmin) values ('"+
                    UserName+"','"+
                    Password+"','"+
                    Email+"','"+
                    Inactive+"','"+
                    FName+"','"+
                    LName+"','"+
                    ChangePasswordWhenLogin+"','"+
					IsAdmin+
					"'); SELECT SCOPE_IDENTITY() AS ID", function(err, rows) {

		 if (err) logger.error("Error inserting into users table: %s ", err);
		 else {
			  res.contentType('application/json');
			  var data = JSON.stringify('/all_users');
			  res.header('Content-Length', data.length);
			  res.end(data);
		  }
	  });
	});
};


exports.user_permission_update = function(req, res){

    var input = JSON.parse(JSON.stringify(req.body));
    var UserID = input.userID || 0;
    var secLevelArray = [];
    if (input.secLevelArray != null) {  secLevelArray = JSON.parse(input.secLevelArray);  }
    
	console.log('UserID == ' + UserID);

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        var qtyRec;

        async.each(secLevelArray, function(obj, callback) {
            var UPGID = obj.UPGID;
            var RoleID = obj.RoleID;
            //console.log('UPGID == ' + UPGID);
            request.query("SELECT Qty = count(*) FROM UserGroupSecurity WHERE UserID='"+UserID+"' AND UPGID='"+UPGID+"'", function(err, data) {
                if(err) logger.error("Error Selecting from UserGroupSecurity table: %s ", err);
                qtyRec = data[0].Qty;
                console.log('qtyRec == ' + qtyRec);
                if( qtyRec == "0" ) {
                    request.query("INSERT INTO UserGroupSecurity (UserID,UPGID,RoleID) VALUES ('" +
                        UserID +"','"+ UPGID +"','"+ RoleID +"') ", function(err, rows) {
                        if (err) logger.error("Error inserting in UserGroupSecurity table: %s ", err);
                    })  
                    callback();
                } else {
                    request.query("UPDATE UserGroupSecurity SET "+
                        "RoleID="+RoleID+" WHERE UserID='"+UserID+"' AND UPGID='"+UPGID+"'", function(err, rows) {
                            if (err) logger.error("Error updating of UserGroupSecurity table: %s ", err);
                    })
                    callback();
                }
            });
            
        }, function(err) {
            if( err ) {
              console.log('A file failed to process');
            } else {
              console.log('All files have been processed successfully');
            }
        });

        res.send('OK');
    });

};

exports.all_users_data = function(req, res){
    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query('SELECT * FROM vwUsers', function(err, data) {
        
            if(err) console.log("Error Selecting : %s ", err);
            res.send(data);
        });
    });
};

exports.user_permission_groups_data = function(req, res){
    var userID = req.params.id;
    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query('SELECT distinct A.UPGID,A.GroupName,RoleID = ISNULL(B.RoleID,0) FROM UsersPermissionGroup A LEFT JOIN UserGroupSecurity B ON B.UPGID = A.UPGID AND B.UserID='+userID, function(err, data) {
        
            if(err) console.log("Error Selecting : %s ", err);
            res.send(data);
        });
    });
};


exports.getUserByID = function(userId, done) {
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString = "SELECT * FROM vwUsers WHERE UserID = '" +userId + "'";

      request.query(sqlString, function(err,result) {
          if (err) return done(err);
          if (result.length==1) {
              //console.log(' result.UserName:  ' + result[0].UserName);
              var user = {
                  UserName: result[0].UserName,
                  Email: result[0].Email,
                  UserID : result[0].UserID,
                  Password : result[0].Password,
                  IsAdmin : result[0].IsAdmin,
                  FName: result[0].FName,
                  LName: result[0].LName,
                  Inactive : result[0].Inactive,
                  ChangePasswordWhenLogin: result[0].ChangePasswordWhenLogin
              };
              return done(null, user);
          }   
          else {return done(null, null);}     
      });
  });
}


exports.getUserByName = function(name, Password, done) {
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString = "SELECT * FROM users WHERE UserName = '" +name + "'";

      request.query(sqlString, function(err,result) {
          if (err) return done(err);
          if (result.length==1) {
              //console.log(' result.length:  ' + result.length);
              //console.log(' Password:  ' + result[0].Password);
              var user = {
                  UserName: result[0].UserName,
                  Email: result[0].Email,
                  UserID : result[0].UserID,
                  Password : result[0].Password,
                  IsAdmin : result[0].IsAdmin,
                  FName: result[0].FName,
                  LName: result[0].LName,
                  Inactive : result[0].Inactive,
                  ChangePasswordWhenLogin: result[0].ChangePasswordWhenLogin
              };
              return done(null, user);
          }  
          else {return done(null, null);}    
      });
  });
}
