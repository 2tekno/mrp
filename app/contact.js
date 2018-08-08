var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 


exports.contact_delete_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));

	var ContactID = input.ContactID;

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwPeopleCount WHERE ContactID = " + ContactID, function(err, data) {
			if(err) logger.error("Error Selecting from Contact table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};

exports.contact_security = function(req, res){
	//var input = JSON.parse(JSON.stringify(req.body));
	//console.log('*****contact_security == ' +JSON.stringify(req.body));

	var userID = req.user.id;
	var fieldList = [];

	res.send(fieldList);

};

exports.contact_edit_validate = function(req, res){
	var contactID = req.params.id;
	var input = JSON.parse(JSON.stringify(req.body));

	var FName = input.FName.replace(/(')/g, "''");
	var LName = input.LName.replace(/(')/g, "''");

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM Contact WHERE FName='"+FName+"' AND LName='"+LName+"' AND ContactID !='"+contactID+"'", function(err, data) {
			if(err) logger.error("Error Selecting from contact table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};
exports.contact_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));

	console.log('*****contact_validate == ' +JSON.stringify(req.body));

	var FName = input.FName.replace(/(')/g, "''");
	var LName = input.LName.replace(/(')/g, "''");

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM Contact WHERE FName = '" + FName + "' AND LName = '" + LName + "'", function(err, data) {
			if(err) logger.error("Error Selecting from contact table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.contact_edit = function(req, res){
	var contactID = req.params.id;
	//var action = req.params.action || '';
	//logger.debug("action = " + action);	
	// var readonly = '';
	// if (action == 'view') {
	// 	readonly = 'readonly';
	// };
	
	
	
	sql.connect(config.connection, function(err) {
	  var request = new sql.Request();
	  request.query('SELECT *,Inact = ISNULL(Inactive, 0) FROM Contact WHERE ContactID = ' + contactID, function(err, contact) {
		  if(err) logger.error("Error Selecting from contact table: %s ", err);

		  request.query('SELECT * FROM Institution  ORDER BY InstitutionName' , function(err, institutions) {
			   if(err) logger.error("Error Selecting from Institution table: %s ", err);

			  request.query('SELECT * FROM vwContactInstitution WHERE ContactID = ' + contactID, function(err, contactInstitutions) {
				  if(err) logger.error("Error Selecting from vwContactInstitution table: %s ", err);


			  request.query('SELECT * FROM vwPeopleByProject WHERE ContactID = ' + contactID, function(err, contactProjects) {
				  if(err) logger.error("Error Selecting from vwPeopleByProject table: %s ", err);

			  request.query('SELECT * FROM vwPeople WHERE ContactID <> ' + contactID + ' ORDER BY LName, FName', function(err, contacts) {
				  if(err) logger.error("Error Selecting from vwPeopleByProject table: %s ", err);

			  request.query('SELECT * FROM vwContactAdminFor WHERE ContactAdminID = ' + contactID, function(err, adminAssistants) {
				  if(err) logger.error("Error Selecting from vwContactAdminFor table: %s ", err);

			  request.query('SELECT * FROM vwContactAdminFor WHERE ContactID = ' + contactID, function(err, assistantFor) {
				  if(err) logger.error("Error Selecting from vwContactAdminFor table: %s ", err);


			  request.query('select * from vwSalutation order by SortOrder', function(err, salutation) {
				  if(err) logger.error("Error Selecting from vwSalutation table: %s ", err);

			  request.query('select * from vwProvince order by SortOrder', function(err, province) {
				  if(err) logger.error("Error Selecting from vwProvince table: %s ", err);


			  request.query('SELECT * FROM vwPeopleByGroup WHERE ContactID = ' + contactID, function(err, contactGroups) {
				  if(err) logger.error("Error Selecting from vwPeopleByGroup table: %s ", err);

			  request.query('SELECT * FROM ContactPhone WHERE ContactID = ' + contactID, function(err, contactPhones) {
				  if(err) logger.error("Error Selecting from ContactPhone table: %s ", err);

			  request.query('SELECT * FROM ContactEmail WHERE ContactID = ' + contactID, function(err, contactEmails) {
				  if(err) logger.error("Error Selecting from ContactEmail table: %s ", err);
				  
			  request.query('SELECT * FROM PeopleGroup', function(err, groups) {
	
					  res.render('edit_contact', {
						  page_title: "Edit Contact",
						  contact: contact[0],
						  institutions: institutions,
						  contactInstitutions: contactInstitutions,
						  contactProjects: contactProjects,
						  contacts: contacts,
						  assistantFor: assistantFor,
						  adminAssistants: adminAssistants,
						  salutation: salutation,
						  province: province,
						  contactGroups: contactGroups,
						  contactPhones: contactPhones,
						  contactEmails: contactEmails,
						  groups: groups,
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
			  });
		  });
	  });
	});
};


exports.add_contact = function(req, res){

	sql.connect(config.connection, function(err) {
	  var request = new sql.Request();

		  request.query('SELECT * FROM Institution  ORDER BY InstitutionName' , function(err, institutions) {
			   if(err) logger.error("Error Selecting from Institution table: %s ", err);

			  request.query('SELECT * FROM vwContactInstitution WHERE ContactID = 0', function(err, contactInstitutions) {
				  if(err) logger.error("Error Selecting from vwContactInstitution table: %s ", err);

			  request.query('SELECT * FROM vwPeople  ORDER BY LName, FName' , function(err, contacts) {
				  if(err) logger.error("Error Selecting from vwPeopleByProject table: %s ", err);
				  
			  request.query('select * from vwSalutation order by SortOrder', function(err, salutation) {
				  if(err) logger.error("Error Selecting from vwSalutation table: %s ", err);

			  request.query('select * from vwProvince order by SortOrder', function(err, province) {
				  if(err) logger.error("Error Selecting from vwProvince table: %s ", err);

			  request.query('SELECT * FROM PeopleGroup', function(err, groups) {					
					  res.render('add_contact', {
						  page_title: "Add Contact",
						  institutions: institutions,
						  contactInstitutions: contactInstitutions,
						  contacts: contacts,
						  adminAssistants : [],
						  salutation: salutation,
						  province: province,
						  contactPhones: [],
						  contactEmails: [],
						  contactGroups: [],
						  groups: groups,
						  user: req.user						  
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
	var userID = req.user.UserID;
	//console.log(input);
	var FName = input.FName.replace(/(')/g, "''");
	var LName = input.LName.replace(/(')/g, "''");
	var Sal = input.Sal.replace(/(')/g, "''");
	var Address1 = input.Address1.replace(/(')/g, "''");
	var Address2 = input.Address2.replace(/(')/g, "''");
	var Address3 = input.Address3.replace(/(')/g, "''");
	var City = input.City.replace(/(')/g, "''");
	var Province = input.Province;
	var PostalCode = input.PostalCode;
	var Country = input.Country;
	var Notes = input.Notes.replace(/(')/g, "''");
	var JobTitle = input.JobTitle.replace(/(')/g, "''");
	var Inactive = 0;

	var editedContactInstitutions = [];
	if (input.editedContactInstitutions != null) {  editedContactInstitutions = JSON.parse(input.editedContactInstitutions);  }

	var editedAdminAssistants = [];
	if (input.editedAdminAssistants != null) {  editedAdminAssistants = JSON.parse(input.editedAdminAssistants);  }
	
	var editedContactPhones = [];
	if (input.editedContactPhones != null) {  editedContactPhones = JSON.parse(input.editedContactPhones);  }
	
	var editedContactEmails = [];
	if (input.editedContactEmails != null) {  editedContactEmails = JSON.parse(input.editedContactEmails);  }
	
	var editedContactGroups = [];
	if (input.editedContactGroups != null) {  editedContactGroups = JSON.parse(input.editedContactGroups);  }
	
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();


					
	  request.query("INSERT INTO contact (FName,LName,Sal,Address1,Address2,Address3,City,Province,PostalCode,Notes,JobTitle,Country,CreatedUserID,Inactive) values ('"+
					FName+"','"+
					LName+"','"+
					Sal+"','"+
					Address1+"','"+
					Address2+"','"+
					Address3+"','"+
					City+"','"+
					Province+"','"+
					PostalCode+"','"+
					Notes+"','"+
					JobTitle+"','"+
					Country+"','"+
					userID+"','"+
					Inactive+
					"'); SELECT SCOPE_IDENTITY() AS ID", function(err, rows) {
		var ContactID = JSON.stringify(rows[0].ID);


		for(var obj in editedContactGroups) {
			if(editedContactGroups[obj].hasOwnProperty('id')) {
				var id = editedContactGroups[obj]['id'];
				var selectedId = editedContactGroups[obj]['selectedId'];

				if (id == "-1") {
					request.query("INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID) VALUES ('" +
									ContactID +"','"+selectedId+"') ", function(err, rows) {
							if (err) logger.error("Error inserting in PeopleGroupContact table: %s ", err);
					})
				}
			}
		}

		
		for(var obj in editedContactInstitutions) {
			if(editedContactInstitutions[obj].hasOwnProperty('id')) {
				  var id = editedContactInstitutions[obj]['id'];
				  var selectedId = editedContactInstitutions[obj]['selectedId'];
				  var role = editedContactInstitutions[obj]['role'];
				  var primary = editedContactInstitutions[obj]['primary'];
				  if (primary==true) {primary=1} else {primary=0};

				  if (id == "-1") {
					  request.query("INSERT INTO ContactInstitution (ContactID,InstitutionID,Role,[Primary]) VALUES ('" +
									ContactID +"','"+selectedId+"','"+role +"','"+primary +"' )", function(err, rows) {
						   if (err) logger.error("Error inserting in ContactInstitution table: %s ", err);
					  })
				  } 
			}
		}


		for(var obj in editedAdminAssistants) {
			if(editedAdminAssistants[obj].hasOwnProperty('id')) {
				  var id = editedAdminAssistants[obj]['id'];
				  var selectedId = editedAdminAssistants[obj]['selectedId'];
				  if (id == "-1") {
					  request.query("INSERT INTO AdminAssistant (ContactAdminID,ContactID) VALUES ('" +
									ContactID +"','"+selectedId+"') ", function(err, rows) {
						   if (err) logger.error("Error inserting in AdminAssistant table: %s ", err);
					  })
				  } 
			}
		}


		
		
		  for(var obj in editedContactPhones) {
			  if(editedContactPhones[obj].hasOwnProperty('id')) {
					var id = editedContactPhones[obj]['id'];
					var value = editedContactPhones[obj]['value'];
					var primary = editedContactPhones[obj]['primary'];
					if (primary==true) {primary=1} else {primary=0};

					if (id == "-1") {
						request.query("INSERT INTO ContactPhone (ContactID,Phone,[Primary]) VALUES ('" +
									  ContactID +"','"+value+"','"+primary+"') ", function(err, rows) {
							 if (err) logger.error("Error inserting in ContactPhone table: %s ", err);
						})
					}
			  }
		  }

// --------- Emails ----------------------------

		  for(var obj in editedContactEmails) {
			  if(editedContactEmails[obj].hasOwnProperty('id')) {
					var id = editedContactEmails[obj]['id'];
					var value = editedContactEmails[obj]['value'];
					var primary = editedContactEmails[obj]['primary'];
					if (primary==true) {primary=1} else {primary=0};

					if (id == "-1") {
						request.query("INSERT INTO ContactEmail (ContactID,Email,[Primary]) VALUES ('" +
									  ContactID +"','"+value+"','"+primary+"') ", function(err, rows) {
							 if (err) logger.error("Error inserting in ContactEmail table: %s ", err);
						})
					}
			  }
		  }		
		
		

		 if (err) logger.error("Error inserting into contact table: %s ", err);
		 else {
			  res.contentType('application/json');
			  var data = JSON.stringify('/contacts');
			  res.header('Content-Length', data.length);
			  res.end(data);
		  }

	  });
	});
};

exports.save_edit = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	//console.log(input);

	var userID = req.user.UserID;
	console.log('userID ==' + userID);
	var ContactID = req.params.id;
	var FName = input.FName.replace(/(')/g, "''");
	var LName = input.LName;  //.replace(/(')/g, "''");
	var Sal = input.Sal.replace(/(')/g, "''");
	var Address1 = input.Address1.replace(/(')/g, "''");
	var Address2 = input.Address2.replace(/(')/g, "''");
	var Address3 = input.Address3.replace(/(')/g, "''");
	var City = input.City.replace(/(')/g, "''");
	var Province = input.Province;
	var PostalCode = input.PostalCode;
	var Country = input.Country;
	var Notes = input.Notes.replace(/(')/g, "''");
	var JobTitle = input.JobTitle.replace(/(')/g, "''");
	var Inactive = 0;
	if (input.Inactive!=undefined) {
		if (input.Inactive=='on') {
			Inactive=1;
		}
	}
	

	var editedContactInstitutions = [];
	if (input.editedContactInstitutions != null) {  editedContactInstitutions = JSON.parse(input.editedContactInstitutions);  }
	var deletedContactInstitutions = [];
	if (input.deletedContactInstitutions != null) { deletedContactInstitutions = JSON.parse(input.deletedContactInstitutions);  }


	var editedAdminAssistants = [];
	if (input.editedAdminAssistants != null) {  editedAdminAssistants = JSON.parse(input.editedAdminAssistants);  }
	var deletedAdminAssistants = [];
	if (input.deletedAdminAssistants != null) { deletedAdminAssistants = JSON.parse(input.deletedAdminAssistants);  }

	
	var editedContactPhones = [];
	if (input.editedContactPhones != null) {  editedContactPhones = JSON.parse(input.editedContactPhones);  }
	var deletedContactPhones = [];
	if (input.deletedContactPhones != null) { deletedContactPhones = JSON.parse(input.deletedContactPhones);  }
	
	var editedContactEmails = [];
	if (input.editedContactEmails != null) {  editedContactEmails = JSON.parse(input.editedContactEmails);  }
	var deletedContactEmails = [];
	if (input.deletedContactEmails != null) { deletedContactEmails = JSON.parse(input.deletedContactEmails);  }

	var editedContactGroups = [];
	if (input.editedContactGroups != null) {  editedContactGroups = JSON.parse(input.editedContactGroups);  }
	var deletedContactGroups = [];
	if (input.deletedContactGroups != null) { deletedContactGroups = JSON.parse(input.deletedContactGroups);  }
	
	
	console.log('**** ' + editedContactGroups);
	
	sql.connect(config.connection, function(err) {
	  var sqlString = "UPDATE contact set "+
						  "  FName='" +FName+
						  "',LName='"+LName+
						  "',Sal='"+Sal+
						  "',Address1='"+Address1+
						  "',Address2='"+Address2+
						  "',Address3='"+Address3+
						  "',City='"+City+
						  "',Province='"+Province+
						  "',PostalCode='"+PostalCode+
						  "',Country='"+Country+ 
						  "',Notes='"+Notes+ 
						  "',JobTitle='"+JobTitle+ 
						  "',UpdatedUserID='"+userID+ 
						  "',Inactive='"+Inactive+					  
						  "',Updated=getdate()"+
						  " WHERE ContactID = " + ContactID;

	  logger.debug(sqlString);

	  var request = new sql.Request();

	  request.query(sqlString, function(err, rows) {


				for(var obj in editedContactGroups) {
					  if(editedContactGroups[obj].hasOwnProperty('id')) {
							var id = editedContactGroups[obj]['id'];
							var selectedId = editedContactGroups[obj]['selectedId'];

							if (id == "-1") {
								request.query("INSERT INTO PeopleGroupContact (ContactID,PeopleGroupID) VALUES ('" +
											  ContactID +"','"+selectedId+"') ", function(err, rows) {
									 if (err) logger.error("Error inserting in PeopleGroupContact table: %s ", err);
								})
							} else {
								request.query("UPDATE PeopleGroupContact SET "+
								"PeopleGroupID='"+selectedId+"' WHERE PeopleGroupContactID='" +id+"'", function(err, rows) {
									 if (err) logger.error("Error updating of PeopleGroupContact table: %s ", err);
								})
							}
					  }
				  }

				  for(var obj in deletedContactGroups) {
					  if(deletedContactGroups[obj].hasOwnProperty('id')) {
							var id = deletedContactGroups[obj]['id'];
							request.query("DELETE PeopleGroupContact WHERE PeopleGroupContactID='"+id+"'", function(err, rows) {
								 if (err) logger.error("Error deleting from PeopleGroupContact table: %s ", err);
							})
					  }
				  }
	  
				//console.log("!!!  editedContactInstitutions:  " + JSON.stringify(editedContactInstitutions));

				for(var obj in editedContactInstitutions) {
					if(editedContactInstitutions[obj].hasOwnProperty('id')) {
						var id = editedContactInstitutions[obj]['id'];
						var selectedId = editedContactInstitutions[obj]['selectedId'];
						var role = editedContactInstitutions[obj]['role'];
						var primary = editedContactInstitutions[obj]['primary'];
						if (primary==true) {primary=1} else {primary=0};
						
						//console.log('primary == ' + primary);

						if (id == "-1") {
							request.query("INSERT INTO ContactInstitution (ContactID,InstitutionID,Role,[Primary]) VALUES ('" +
											ContactID +"','"+selectedId+"','"+role +"','"+primary +"') ", function(err, rows) {
									if (err) logger.error("Error inserting in ContactInstitution table: %s ", err);
							})
						} else {
							request.query("UPDATE ContactInstitution SET "+
							"InstitutionID='"+selectedId+"',Role='"+role +"',[Primary]='"+primary +"' WHERE ContactInstitutionID='" +id+"'", function(err, rows) {
									if (err) logger.error("Error updating of ContactInstitution table: %s ", err);
							})
						}
					}
				}

				for(var obj in deletedContactInstitutions) {
					if(deletedContactInstitutions[obj].hasOwnProperty('id')) {
						var id = deletedContactInstitutions[obj]['id'];
						request.query("DELETE ContactInstitution WHERE ContactInstitutionID='"+id+"'", function(err, rows) {
								if (err) logger.error("Error deleting from ContactInstitution table: %s ", err);
						})
					}
				}


// --------- AdminAssistants ----------------------------

				for(var obj in editedAdminAssistants) {
					if(editedAdminAssistants[obj].hasOwnProperty('id')) {
						var id = editedAdminAssistants[obj]['id'];
						var selectedId = editedAdminAssistants[obj]['selectedId'];

						if (id == "-1") {
							request.query("INSERT INTO AdminAssistant (ContactAdminID,ContactID) VALUES ('" +
											ContactID +"','"+selectedId+"') ", function(err, rows) {
									if (err) logger.error("Error inserting in AdminAssistant table: %s ", err);
							})
						} else {
							request.query("UPDATE AdminAssistant SET "+
							"ContactID='"+selectedId+"' WHERE AdminAssistantID='" +id+"'", function(err, rows) {
									if (err) logger.error("Error updating of AdminAssistant table: %s ", err);
							})
						}
					}
				}

				for(var obj in deletedAdminAssistants) {
					if(deletedAdminAssistants[obj].hasOwnProperty('id')) {
						var id = deletedAdminAssistants[obj]['id'];
						request.query("DELETE AdminAssistant WHERE AdminAssistantID='"+id+"'", function(err, rows) {
								if (err) logger.error("Error deleting from AdminAssistant table: %s ", err);
						})
					}
				}

// ---------------------------------------------


// --------- Phones ----------------------------

				for(var obj in editedContactPhones) {
					if(editedContactPhones[obj].hasOwnProperty('id')) {
						var id = editedContactPhones[obj]['id'];
						var value = editedContactPhones[obj]['value'];
						var primary = editedContactPhones[obj]['primary'];
						if (primary==true) {primary=1} else {primary=0};

						if (id == "-1") {
							request.query("INSERT INTO ContactPhone (ContactID,Phone,[Primary]) VALUES ('" +
											ContactID +"','"+value+"','"+primary+ "') ", function(err, rows) {
									if (err) logger.error("Error inserting in ContactPhone table: %s ", err);
							})
						} else {
							request.query("UPDATE ContactPhone SET [Primary]='"+primary+"'," +
							"Phone='"+value+"' WHERE ContactPhoneID='" +id+"'", function(err, rows) {
									if (err) logger.error("Error updating of ContactPhone table: %s ", err);
							})
						}
					}
				}

				for(var obj in deletedContactPhones) {
					if(deletedContactPhones[obj].hasOwnProperty('id')) {
						var id = deletedContactPhones[obj]['id'];
						request.query("DELETE ContactPhone WHERE ContactPhoneID='"+id+"'", function(err, rows) {
								if (err) logger.error("Error deleting from ContactPhone table: %s ", err);
						})
					}
				}

// ---------------------------------------------

// --------- Emails ----------------------------

				for(var obj in editedContactEmails) {
					if(editedContactEmails[obj].hasOwnProperty('id')) {
						var id = editedContactEmails[obj]['id'];
						var value = editedContactEmails[obj]['value'];
						var primary = editedContactEmails[obj]['primary'];
						if (primary==true) {primary=1} else {primary=0};

						if (id == "-1") {
							request.query("INSERT INTO ContactEmail (ContactID,Email,[Primary]) VALUES ('" +
											ContactID +"','"+value+"','"+primary+ "') ", function(err, rows) {
									if (err) logger.error("Error inserting in ContactEmail table: %s ", err);
							})
						} else {
							request.query("UPDATE ContactEmail SET [Primary]='"+primary+"'," +
							"Email='"+value+"' WHERE ContactEmailID='" +id+"'", function(err, rows) {
									if (err) logger.error("Error updating of ContactEmail table: %s ", err);
							})
						}
					}
				}

				for(var obj in deletedContactEmails) {
					if(deletedContactEmails[obj].hasOwnProperty('id')) {
						var id = deletedContactEmails[obj]['id'];
						request.query("DELETE ContactEmail WHERE ContactEmailID='"+id+"'", function(err, rows) {
								if (err) logger.error("Error deleting from ContactEmail table: %s ", err);
						})
					}
				}

// ---------------------------------------------

			if (err) logger.error("Error updating of contact table: %s ", err);
			else {
			  res.contentType('application/json');
			  var data = JSON.stringify('/contacts');
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
	  request.query("DELETE FROM contact WHERE ContactID = " + id , function(err, recordset) {

		  if(err) logger.error("Error deleting from contact table: %s ", err);

		  res.redirect('/contacts');
		});
	  });
};



exports.NotFilteredContacts = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("SELECT * FROM vwPeople ORDER BY LName, FName", function(err, data) {
		  res.send(data);
		});
  });
}



exports.getAllContacts = function (req, res, next){
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
	request.query("SELECT * FROM vwPeople ORDER BY LName, FName", function(err, rows) {

		if (err || !rows.length) {  return next(error);  }
		req.contacts = rows;
		return next();
	});
	});
};


exports.contacts = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwPeople ORDER BY LName, FName", function(err, recordset) {

		if(err) logger.error("Error selecting from contact table: %s ", err);
		  res.send(recordset);
		});
  });
}