var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 


exports.institution_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
    var name = input.name.replace(/(')/g, "''");
    var acronym = input.acronym || '';
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
		  request.query("SELECT Qty = count(*) FROM institution WHERE InstitutionName='"+name+"'", function(err, data) {
			if(err) logger.error("Error Selecting from institution table: %s ", err);
			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.institution_edit_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
    var name = input.name.replace(/(')/g, "''");
    var acronym = input.acronym || '';
    var institutionID = input.institutionID;
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
          request.query("SELECT Qty = count(*) FROM institution WHERE InstitutionName='"+name+"' AND InstitutionID!='"+institutionID+"'", function(err, data) {
			if(err) logger.error("Error Selecting from institution table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.institution_delete_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	var InstitutionID = input.InstitutionID;
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
		  request.query("SELECT Qty = count(*) FROM vwInstitutionCount WHERE ParentInstitutionID = " + InstitutionID, function(err, data) {
			if(err) logger.error("Error Selecting from Institution table: %s ", err);
			res.send(JSON.stringify(data[0]));
		  });
	});
};

exports.institution_security = function(req, res){
	//var input = JSON.parse(JSON.stringify(req.body));
	//console.log('*****contact_security == ' +JSON.stringify(req.body));
	var userID = req.user.id;
	var fieldList = [];
	res.send(fieldList);
};



exports.institutionByContact = function(req, res) {
	var id = req.params.id;
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("SELECT DISTINCT InstitutionID,InstitutionName FROM vwPeopleByInstitution WHERE ContactID="+id, function(err, data) {
          res.send(data);
		});
  });

}


exports.add_new = function(req, res){

   var institutionCommReps = [];

      sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query('select * from vwProvince order by SortOrder', function(err, province) {
          if(err) logger.error("Error Selecting from vwProvince table: %s ", err);

        request.query('SELECT * FROM vwInstitutionDropDown order by InstitutionName', function(err, institutions) {
        request.query('select * from vwPeople ORDER BY LName, FName', function(err, contacts) {
        
          res.render('add_institution', 
                      {page_title: "Add Institution",
                       province: province,
                       institutions: institutions,
                       institutionCommReps: institutionCommReps,
                       contacts: contacts,
                       user: req.user
        });
        });
        });
        });
      });
};


exports.save_new = function(req, res){
    var userID = req.user.UserID;
    var input = JSON.parse(JSON.stringify(req.body));
    var InstitutionName = input.InstitutionName.replace(/(')/g, "''");
    var Address1 = input.Address1;
    var Address2 = input.Address2;
    var Address3 = input.Address3;
    var City = input.City;
    var Province = input.Province;
    var PostalCode = input.PostalCode;
    var Country = input.Country;
    var ParentInstitution = input.ParentInstitution || 0;
    var Notes = input.Notes.replace(/(')/g, "''");
    var Dept = input.Dept;
	var Acronym = input.Acronym;

    var MOUStartDate = input.MOUStartDate;
    var MOUEndDate = input.MOUEndDate;
    var MOUExtendedOnDate = input.MOUExtendedOnDate;

    var editedInstitutionCommReps = [];
    if (input.editedInstitutionCommReps != null) {  editedInstitutionCommReps = JSON.parse(input.editedInstitutionCommReps);  }



    sql.connect(config.connection, function(err) {
  		var request = new sql.Request();

      var sqlString = "INSERT INTO institution (InstitutionName,ParentInstitutionID,Address1,Address2,Address3,City,Province,PostalCode,Notes,Country,Acronym,CreatedUserID,MOUStartDate,MOUEndDate,MOUExtendedOnDate,Dept) values ('" +
                          InstitutionName+"','"+
                          ParentInstitution+"','"+
                          Address1+"','"+
                          Address2+"','"+
                          Address3+"','"+
                          City+"','"+
                          Province+"','"+
                          PostalCode+"','"+
                          Notes+"','"+
                          Country+"','"+
                          Acronym+"','"+
                          userID+"','"+
                          MOUStartDate+"','"+
                          MOUEndDate+"','"+
                          MOUExtendedOnDate+"','"+
                          Dept+
                          "'); SELECT SCOPE_IDENTITY() AS ID";
console.log(sqlString);

      request.query(sqlString, function(err, rows) {

        if (err) logger.error("Error inserting into institution table: %s ", err);

        var institutionID = JSON.stringify(rows[0].ID);

        if (editedInstitutionCommReps != null) {
           logger.debug("editedInstitutionCommReps:  " + JSON.stringify(editedInstitutionCommReps));

            for(var obj in editedInstitutionCommReps) {
                if(editedInstitutionCommReps[obj].hasOwnProperty('id')) {
                      var id = editedInstitutionCommReps[obj]['id'];
                      var selectedId = editedInstitutionCommReps[obj]['selectedId'];
                      if (id == "-1") {
                          request.query("INSERT INTO InstitutionCommRep (InstitutionID,ContactID) VALUES ('" +
                                        institutionID +"','"+selectedId+"') ", function(err, rows) {
                               if (err) logger.error("Error inserting in InstitutionCommRep table: %s ", err);
                          })
                      }
                }
            }
        }


        if (err) logger.error("Error inserting into institution table: %s ", err);
        else {
            res.contentType('application/json');
            var data = JSON.stringify('/institutions');
            res.header('Content-Length', data.length);
            res.end(data);
        }


      });
    });
};

exports.edit = function(req, res){
    var id = req.params.id;
    var action = req.params.action || '';
	//logger.debug("action = " + action);
    
	var readonly = '';
	if (action == 'view') {
		readonly = 'readonly';
	};
	
	
    console.log("InstitutionID = " + id);

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      request.query('SELECT * FROM vwinstitution WHERE InstitutionID = ' + id, function(err, recordset) {
          if(err) logger.error("Error Selecting FROM institution table: %s ", err);

      request.query('SELECT * FROM vwProvince order by SortOrder', function(err, province) {
      request.query('SELECT * FROM institution WHERE ParentInstitutionID = ' + id + ' order by InstitutionName', function(err, childInstitutions) {
      request.query('SELECT * FROM vwInstitutionDropDown order by InstitutionName', function(err, institutions) {
      request.query('SELECT * FROM vwPeople ORDER BY LName, FName', function(err, contacts) {
      request.query('SELECT * FROM InstitutionCommRep WHERE InstitutionID = ' + id, function(err, institutionCommReps) {
      request.query('SELECT * FROM vwPeopleByInstitution WHERE InstitutionID = ' + id, function(err, peopleByInstitution) {  
	  request.query('select * from vwProjectByInstitutionProvince WHERE InstitutionID = ' + id, function(err, projectByInstitution) {  
        request.query('select * from vwInstCoFundersByProject WHERE InstitutionID = ' + id, function(err, projectByInsCoFunders) {
	  

          res.render('edit_institution', {page_title: "Edit Institution", 
                                          ContactID: id, 
                                          data: recordset[0],
                                          province: province,
                                          childInstitutions: childInstitutions,
                                          institutions: institutions,
                                          contacts: contacts,
                                          institutionCommReps: institutionCommReps,
                                          peopleByInstitution: peopleByInstitution,
                                          projectByInstitution: projectByInstitution,
                                          projectByInsCoFunders: projectByInsCoFunders,
                                          readonly: readonly,
                                          user: req.user					
	  });
      });
    });
      });
	  });
      });
      });
      });
      });
      });
      });
  };

exports.save_edit = function(req, res){
    var input = JSON.parse(JSON.stringify(req.body));
    var userID = req.user.UserID;
    var InstitutionID = req.params.id;
    var InstitutionName = input.InstitutionName.replace(/(')/g, "''");
    var Address1 = input.Address1;
    var Address2 = input.Address2;
    var Address3 = input.Address3;
    var City = input.City;
    var Province = input.Province;
    var PostalCode = input.PostalCode;
    var Country = input.Country;
    var ParentInstitution = input.ParentInstitution || 0;
    var Notes = input.Notes.replace(/(')/g, "''");
    var Dept = input.Dept;
	var Acronym = input.Acronym;

    var MOUStartDate = input.MOUStartDate;
    var MOUEndDate = input.MOUEndDate;
    var MOUExtendedOnDate = input.MOUExtendedOnDate;


    var editedInstitutionCommReps = [];
    if (input.editedInstitutionCommReps != null) {  editedInstitutionCommReps = JSON.parse(input.editedInstitutionCommReps);  }

    var deletedInstitutionCommReps = [];
    if (input.deletedInstitutionCommReps != null) { deletedInstitutionCommReps = JSON.parse(input.deletedInstitutionCommReps);  }


    var sqlString="UPDATE institution set "+
                  "  InstitutionName='" +InstitutionName+ 
                  "',ParentInstitutionID='"+ParentInstitution+
                  "',Address1='"+Address1+
                  "',Address2='"+Address2+
                  "',Address3='"+Address3+
                  "',City='"+City+
                  "',Province='"+Province+
                  "',PostalCode='"+PostalCode+
                  "',Country='"+Country+
                  "',Notes='"+Notes+
                  "',Dept='"+Dept+
                  "',UpdatedUserID='"+userID+ 
                  "',Acronym='"+Acronym+
                  "',MOUStartDate='"+MOUStartDate+
                  "',MOUEndDate='"+MOUEndDate+
                  "',MOUExtendedOnDate='"+MOUExtendedOnDate+
                  "',Updated=getdate()"+
                  " WHERE InstitutionID = "+InstitutionID;

    logger.debug(sqlString);
    
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();

      request.query(sqlString, function(err, rows) {

         if (err) logger.error("Error Updating institution table: %s ", err);


//----------- Comm Reps list ----------------------------------

            if (editedInstitutionCommReps != null) {
               //logger.debug("editedInstitutionCommReps:  " + JSON.stringify(editedInstitutionCommReps));

                for(var obj in editedInstitutionCommReps) {
                    if(editedInstitutionCommReps[obj].hasOwnProperty('id')) {
                          var id = editedInstitutionCommReps[obj]['id'];
                          var selectedId = editedInstitutionCommReps[obj]['selectedId'];
                          if (id == "-1") {
                              request.query("INSERT INTO InstitutionCommRep (InstitutionID,ContactID) VALUES ('" +
                                            InstitutionID +"','"+selectedId+"') ", function(err, rows) {
                                   if (err) logger.error("Error inserting in InstitutionCommRep table: %s ", err);
                              })
                          } else {
                              request.query("UPDATE InstitutionCommRep SET "+
                              "ContactID='"+selectedId+"' WHERE InstitutionCommRepID='" + id+"'", function(err, rows) {
                                   if (err) logger.error("Error updating of InstitutionCommRep table: %s ", err);
                              })
                          }
                    }
                }
            }

            if (deletedInstitutionCommReps != null) {
               logger.debug("deletedInstitutionCommReps:  " + JSON.stringify(deletedInstitutionCommReps));
                for(var obj in deletedInstitutionCommReps) {
                    if(deletedInstitutionCommReps[obj].hasOwnProperty('id')) {
                          var id = deletedInstitutionCommReps[obj]['id'];
                          request.query("DELETE InstitutionCommRep WHERE InstitutionCommRepID='"+id+"'", function(err, rows) {
                               if (err) logger.error("Error deleting from InstitutionCommRep table: %s ", err);
                          })
                    }
                }
            }


         if (err) logger.error("Error Updating institution table: %s ", err);
         else {
            res.contentType('application/json');
            var data = JSON.stringify('/institutions');
            res.header('Content-Length', data.length);
            res.end(data);
        }
        });
      });
};

exports.delete = function(req, res){
    var id = req.params.id;

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      request.query("DELETE FROM institution WHERE InstitutionID = " + id , function(err, recordset) {

          if(err) logger.error("Error deleting from institution table: %s ", err);

          res.redirect('/institutions');
        });
      });
};

exports.getAllInstitutions = function(req, res,next) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwInstitution order by InstitutionName", function(err, recordset) {
      if (err || !recordset.length) { return next(error);  }
       req.institutions = recordset;
       return next();
		});
  });
};


exports.institutions = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwInstitution order by InstitutionName", function(err, recordset) {

     if(err) logger.error("Error selecting from institution table: %s ", err);
 		 res.render('Institution', { page_title: 'Institution', data: recordset  }  );

		});
  });
}


exports.NotFilteredInstitutions = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwInstitution order by InstitutionName", function(err, data) {
          res.send(data);
		});
  });
}

