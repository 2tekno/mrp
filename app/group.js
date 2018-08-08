var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 


exports.group_owner_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
    var userID = req.user.UserID;
	var PeopleGroupID = input.ID;
    console.log('*****group_owner_validate: userID == ' +userID);
    console.log('*****group_owner_validate: PeopleGroupID == ' +PeopleGroupID);

    var isAdmin = req.user.IsAdmin || false;

	sql.connect(config.connection, function(err) {
          var request = new sql.Request();
          var sqlline = "SELECT Qty = count(*) FROM PeopleGroupOwner WHERE PeopleGroupID="+PeopleGroupID+" AND UserID="+userID;
          console.log(sqlline);

		  request.query(sqlline, function(err, data) {
			if(err) logger.error("Error Selecting from PeopleGroupOwner table: %s ", err);
            if (isAdmin) {
                res.send('1');
            } else {
                res.send(JSON.stringify(data));
            }
            
		  });
	});
};

exports.group_delete_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));

	console.log('*****contact_validate == ' +JSON.stringify(req.body));

	var PeopleGroupID = input.ID;

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwPeopleGroupCount WHERE PeopleGroupID = " + PeopleGroupID, function(err, data) {
			if(err) logger.error("Error Selecting from PeopleGroup table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.all_groups_data = function(req, res) {
  sql.connect(config.connection, function(err) {
    var request = new sql.Request();
    request.query("select * from PeopleGroup ORDER BY GroupName", function(err, data) {

     if(err) logger.error("Error selecting from PeopleGroup table: %s ", err);
     res.send(data);
    });
  });
}




exports.renderAddNewGroup = function(req, res){

    var groupContacts = [];
    var groupProjects = [];

    sql.connect(config.connection, function(err) {

      var request = new sql.Request();

      request.query('SELECT * FROM vwPeople  ORDER BY LName, FName' , function(err, contacts) {
          if(err) logger.error("Error Selecting from vwPeopleByProject table: %s ", err);
          
      request.query('SELECT * FROM vwRenewedProject ORDER BY ProjectNumberTitle', function(err, projects) {
          if(err) logger.error("Error Selecting from vwProject table: %s ", err);

          
      request.query('SELECT * FROM PeopleGroupOwner WHERE PeopleGroupID=' + 0, function(err, groupOwners) {
        if(err) logger.error("Error Selecting from PeopleGroupOwner table: %s ", err);

      request.query('SELECT * FROM vwUsers', function(err, users) {
        if(err) logger.error("Error Selecting from Users table: %s ", err);

              res.render('add_group', {
                  page_title: "Add Group",
                  contacts: contacts,
                  groupContacts: groupContacts,
                  projects: projects,
                  groupProjects: groupProjects,
                  users: users,
                  groupOwners: groupOwners,                  
                  user: req.user
              });
      });
      });
    });
    });
    });
};

exports.renderEditGroup = function(req, res){
    var PeopleGroupID = req.params.id;

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();

      request.query('SELECT * FROM PeopleGroup WHERE PeopleGroupID = ' + PeopleGroupID, function(err, group) {
          if(err) logger.error("Error Selecting from PeopleGroup table: %s ", err);

      request.query('SELECT * FROM vwPeople  ORDER BY LName, FName' , function(err, contacts) {
          if(err) logger.error("Error Selecting from vwPeople table: %s ", err);
          
      request.query('SELECT * FROM vwRenewedProject ORDER BY ProjectNumberTitle', function(err, projects) {
          if(err) logger.error("Error Selecting from vwProject table: %s ", err);

      request.query('SELECT * FROM PeopleGroupContact WHERE PeopleGroupID=' + PeopleGroupID, function(err, groupContacts) {
          if(err) logger.error("Error Selecting from PeopleGroupContact table: %s ", err);

      request.query('SELECT * FROM PeopleGroupOwner WHERE PeopleGroupID=' + PeopleGroupID, function(err, groupOwners) {
          if(err) logger.error("Error Selecting from PeopleGroupOwner table: %s ", err);

      request.query('SELECT * FROM vwUsers', function(err, users) {
          if(err) logger.error("Error Selecting from Users table: %s ", err);
  
      request.query('SELECT * FROM PeopleGroupProject WHERE PeopleGroupID=' + PeopleGroupID, function(err, groupProjects) {
          if(err) logger.error("Error Selecting from PeopleGroupProject table: %s ", err);

                      res.render('edit_group', {
                          page_title: "Edit Group",
                          group: group[0],
                          projects: projects,
                          contacts: contacts,
                          groupContacts: groupContacts,
                          groupProjects: groupProjects,
                          users: users,
                          groupOwners: groupOwners,
                          user: req.user        });
      });
      });
      });
      });
      });
      });
      });
      });
};




exports.save_new = function(req, res){
    var input = JSON.parse(JSON.stringify(req.body));
    var GroupName = input.GroupName.replace(/(')/g, "''");
    var Notes = input.Notes.replace(/(')/g, "''");

    var editedGroupContacts = [];
    if (input.editedGroupContacts != null) {  editedGroupContacts = JSON.parse(input.editedGroupContacts);  }

    var editedGroupProjects = [];
    if (input.editedGroupProjects != null) {  editedGroupProjects = JSON.parse(input.editedGroupProjects);  }

    var editedGroupOwners = [];
    if (input.editedGroupOwners != null) {  editedGroupOwners = JSON.parse(input.editedGroupOwners);  }

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();

      request.query("INSERT INTO PeopleGroup (GroupName,Notes) values ('"+GroupName+"','"+Notes+"'); SELECT SCOPE_IDENTITY() AS ID", function(err, rows) {
        var PeopleGroupID = JSON.stringify(rows[0].ID);



        for(var obj in editedGroupOwners) {
            if(editedGroupOwners[obj].hasOwnProperty('id')) {
                  var id = editedGroupOwners[obj]['id'];
                  var selectedId = editedGroupOwners[obj]['selectedId'];

                  if (id == "-1") {
                      request.query("INSERT INTO PeopleGroupOwner (PeopleGroupID,UserID) VALUES ('" +
                                    PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                           if (err) logger.error("Error inserting in PeopleGroupOwner table: %s ", err);
                      })
                  }
            }
        }

        for(var obj in editedGroupContacts) {
            if(editedGroupContacts[obj].hasOwnProperty('id')) {
                  var id = editedGroupContacts[obj]['id'];
                  var selectedId = editedGroupContacts[obj]['selectedId'];
                  if (id == "-1") {
                      request.query("INSERT INTO PeopleGroupContact (PeopleGroupID,ContactID) VALUES ('" +
                                    PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                           if (err) logger.error("Error inserting in PeopleGroupContact table: %s ", err);
                      })
                  } 
            }
        }


        for(var obj in editedGroupProjects) {
            if(editedGroupProjects[obj].hasOwnProperty('id')) {
                  var id = editedGroupProjects[obj]['id'];
                  var selectedId = editedGroupProjects[obj]['selectedId'];
                  if (id == "-1") {
                      request.query("INSERT INTO PeopleGroupProject (PeopleGroupID,ProjectID) VALUES ('" +
                                    PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                           if (err) logger.error("Error inserting in PeopleGroupProject table: %s ", err);
                      })
                  } 
            }
        }


         if (err) logger.error("Error inserting into PeopleGroup table: %s ", err);
         else {
              res.contentType('application/json');
              var data = JSON.stringify('/groups');
              res.header('Content-Length', data.length);
              res.end(data);
          }

      });
    });
};




exports.save_edit = function(req, res){
    var input = JSON.parse(JSON.stringify(req.body));
    var PeopleGroupID = req.params.id;
    var GroupName = input.GroupName.replace(/(')/g, "''");
    var Notes = input.Notes.replace(/(')/g, "''");
    
    var editedGroupContacts = [];
    if (input.editedGroupContacts != null) {  editedGroupContacts = JSON.parse(input.editedGroupContacts);  }
    var deletedGroupContacts = [];
    if (input.deletedGroupContacts != null) { deletedGroupContacts = JSON.parse(input.deletedGroupContacts);  }

    var editedGroupProjects = [];
    if (input.editedGroupProjects != null) {  editedGroupProjects = JSON.parse(input.editedGroupProjects);  }
    var deletedGroupProjects = [];
    if (input.deletedGroupProjects != null) { deletedGroupProjects = JSON.parse(input.deletedGroupProjects);  }


    var editedGroupOwners = [];
    if (input.editedGroupOwners != null) {  editedGroupOwners = JSON.parse(input.editedGroupOwners);  }
    var deletedGroupOwners = [];
    if (input.deletedGroupOwners != null) { deletedGroupOwners = JSON.parse(input.deletedGroupOwners);  }



    sql.connect(config.connection, function(err) {
        var sqlString = "UPDATE PeopleGroup set "+"  GroupName='" +GroupName+"',Notes='"+Notes+"' WHERE PeopleGroupID = " + PeopleGroupID;

        var request = new sql.Request();

        request.query(sqlString, function(err, rows) {



            for(var obj in editedGroupOwners) {
                if(editedGroupOwners[obj].hasOwnProperty('id')) {
                      var id = editedGroupOwners[obj]['id'];
                      var selectedId = editedGroupOwners[obj]['selectedId'];

                      if (id == "-1") {
                          request.query("INSERT INTO PeopleGroupOwner (PeopleGroupID,UserID) VALUES ('" +
                                        PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                               if (err) logger.error("Error inserting in PeopleGroupOwner table: %s ", err);
                          })
                      } else {
                          request.query("UPDATE PeopleGroupOwner SET "+
                          "UserID='"+selectedId+"' WHERE PeopleGroupOwnerID='" +id+"'", function(err, rows) {
                               if (err) logger.error("Error updating of PeopleGroupOwner table: %s ", err);
                          })
                      }
                }
            }

            for(var obj in deletedGroupOwners) {
                if(deletedGroupOwners[obj].hasOwnProperty('id')) {
                      var id = deletedGroupOwners[obj]['id'];
                      request.query("DELETE PeopleGroupOwner WHERE PeopleGroupOwnerID='"+id+"'", function(err, rows) {
                           if (err) logger.error("Error deleting from PeopleGroupOwner table: %s ", err);
                      })
                }
            }

//---------------------------------------------------------            
                  for(var obj in editedGroupContacts) {
                      if(editedGroupContacts[obj].hasOwnProperty('id')) {
                            var id = editedGroupContacts[obj]['id'];
                            var selectedId = editedGroupContacts[obj]['selectedId'];

                            if (id == "-1") {
                                request.query("INSERT INTO PeopleGroupContact (PeopleGroupID,ContactID) VALUES ('" +
                                              PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                                     if (err) logger.error("Error inserting in PeopleGroupContact table: %s ", err);
                                })
                            } else {
                                request.query("UPDATE PeopleGroupContact SET "+
                                "ContactID='"+selectedId+"' WHERE PeopleGroupContactID='" +id+"'", function(err, rows) {
                                     if (err) logger.error("Error updating of PeopleGroupContact table: %s ", err);
                                })
                            }
                      }
                  }

                  for(var obj in deletedGroupContacts) {
                      if(deletedGroupContacts[obj].hasOwnProperty('id')) {
                            var id = deletedGroupContacts[obj]['id'];
                            request.query("DELETE PeopleGroupContact WHERE PeopleGroupContactID='"+id+"'", function(err, rows) {
                                 if (err) logger.error("Error deleting from PeopleGroupContact table: %s ", err);
                            })
                      }
                  }


  // --------- group projects ----------------------------

                  for(var obj in editedGroupProjects) {
                      if(editedGroupProjects[obj].hasOwnProperty('id')) {
                            var id = editedGroupProjects[obj]['id'];
                            var selectedId = editedGroupProjects[obj]['selectedId'];

                            if (id == "-1") {
                                request.query("INSERT INTO PeopleGroupProject (PeopleGroupID,ProjectID) VALUES ('" +
                                              PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
                                     if (err) logger.error("Error inserting in PeopleGroupProject table: %s ", err);
                                })
                            } else {
                                request.query("UPDATE PeopleGroupProject SET "+
                                "ProjectID='"+selectedId+"' WHERE PeopleGroupProjectID='" +id+"'", function(err, rows) {
                                     if (err) logger.error("Error updating of PeopleGroupProject table: %s ", err);
                                })
                            }
                      }
                  }

                  for(var obj in deletedGroupProjects) {
                      if(deletedGroupProjects[obj].hasOwnProperty('id')) {
                            var id = deletedGroupProjects[obj]['id'];
                            request.query("DELETE PeopleGroupProject WHERE PeopleGroupProjectID='"+id+"'", function(err, rows) {
                                 if (err) logger.error("Error deleting from PeopleGroupProject table: %s ", err);
                            })
                      }
                  }

  // ---------------------------------------------



              if (err) logger.error("Error updating of PeopleGroup table: %s ", err);
              else {
                    res.contentType('application/json');
                    var data = JSON.stringify('/groups');
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
      request.query("DELETE FROM PeopleGroup WHERE PeopleGroupID = " + id , function(err, rs) {
      request.query("DELETE FROM PeopleGroupContact WHERE PeopleGroupID = " + id , function(err, rs) {  
      request.query("DELETE FROM PeopleGroupProject WHERE PeopleGroupID = " + id , function(err, rs) {    

          if(err) logger.error("Error deleting from PeopleGroup table: %s ", err);
          else    res.redirect('/groups');
      });
      });
      });
    });
};
