var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 
var accounting = require("accounting");



exports.project_edit_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	console.log('*****project_edit_validate == ' +JSON.stringify(req.body));
    var ProjectTitle = input.ProjectTitle.replace(/(')/g, "''");
    var ProjectShortName = input.ProjectShortName.replace(/(')/g, "''");
    var ProjectNumber = input.ProjectNumber.replace(/(')/g, "''");
    var ProjectID = input.ProjectID.replace(/(')/g, "''");
    
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwProject WHERE (ProjectNumber='"+ProjectNumber+"' OR ProjectTitle='"+ProjectTitle+"' OR ProjectShortName='"+ProjectShortName+"') AND ProjectID!='"+ProjectID+"'", function(err, data) {
			if(err) logger.error("Error Selecting from vwProject table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};

exports.project_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	console.log('*****project_validate == ' +JSON.stringify(req.body));
    var ProjectTitle = input.ProjectTitle.replace(/(')/g, "''");
    var ProjectShortName = input.ProjectShortName.replace(/(')/g, "''");
    var ProjectNumber = input.ProjectNumber.replace(/(')/g, "''");
    
	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwProject WHERE ProjectNumber = '" + ProjectNumber + "' OR ProjectTitle='" + ProjectTitle + "' OR ProjectShortName='" + ProjectShortName + "'", function(err, data) {
			if(err) logger.error("Error Selecting from vwProject table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.subproject_delete_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));
	console.log('*****contact_validate == ' +JSON.stringify(req.body));
	var SubProjectID = input.SubProjectID;

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwSubProjectCount WHERE SubProjectID = " + SubProjectID, function(err, data) {
			if(err) logger.error("Error Selecting from Projects table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};


exports.project_delete_validate = function(req, res){
	var input = JSON.parse(JSON.stringify(req.body));

	console.log('*****contact_validate == ' +JSON.stringify(req.body));

	var ProjectID = input.ProjectID;

	sql.connect(config.connection, function(err) {
  		var request = new sql.Request();
	
		  request.query("SELECT Qty = count(*) FROM vwProjectCount WHERE ProjectID = " + ProjectID, function(err, data) {
			if(err) logger.error("Error Selecting from Projects table: %s ", err);

			res.send(JSON.stringify(data[0]));
		  });
	});
};



exports.renderEditProject = function(req, res){
    var projectID = req.params.id;
    var action = req.params.action || '';

	logger.debug("ProjectID = " + projectID);
	logger.debug("action = " + action);
    
	var readonly = '';
	if (action == 'view') {
		readonly = 'readonly';
	};
    
    

    var Years = [
      {"value" : "0" },
      {"value" : "1" },
      {"value" : "2" },
      {"value" : "3" },
      {"value" : "4" },
      {"value" : "5" }
    ];
    var Months = [
      {"value" : "0" },
      { "value" : "1" },
      { "value" : "2" },
      { "value" : "3" },
      { "value" : "4" },
      { "value" : "5" },
      { "value" : "6" },
      { "value" : "7" },
      { "value" : "8" },
      { "value" : "9" },
      { "value" : "10" },
      { "value" : "11" },
      { "value" : "12" }
    ];

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query('SELECT * FROM vwProject WHERE ProjectID = ' + projectID, function(err, projectForEdit) {
            if(err) logger.error('Error Selecting from Project table: %s ', err);

          request.query('SELECT * FROM vwKeywords', function(err, keywords) {
          request.query('SELECT * FROM ProjectManager WHERE ProjectID = ' + projectID, function(err, projectManagers) {
          request.query('SELECT * FROM ProjectMentor WHERE ProjectID = ' + projectID, function(err, projectMentors) {
          request.query('SELECT * FROM ProjectLeader WHERE ProjectID = ' + projectID, function(err, projectLeaders) {
          request.query('SELECT * FROM vwSubProjectsByProject WHERE ProjectID = ' + projectID + ' ORDER BY SubProjectName', function(err, subprojects) {
          request.query('SELECT * FROM vwCoFundersByProject WHERE ProjectID = ' + projectID + ' ORDER BY InstitutionName', function(err, cofunders) {
          request.query('SELECT * FROM Program ORDER BY ProgramDescription', function(err, programs) {
          request.query('SELECT * FROM vwInstitutionDropDown order by InstitutionName', function(err, institutions) {
          request.query('SELECT * FROM vwManaged', function(err, managed) {
          request.query('SELECT * FROM ProjectStatus', function(err, projectstatus) {
          request.query('SELECT * FROM vwPeople ORDER BY LName, FName', function(err, contacts) {
          request.query('SELECT * FROM vwRenewedProject WHERE ProjectID != ' + projectID + ' ORDER BY ProjectNumberTitle', function(err, mentorProgram) {  
          request.query('SELECT * FROM vwRenewedProject WHERE ProjectID != ' + projectID + ' ORDER BY ProjectNumberTitle', function(err, renewedProject) {    
          request.query('SELECT * FROM vwPeopleRolesForPersonnelTab WHERE ProjectID = ' + projectID  + ' ORDER BY SubProjectName', function(err, peopleRolesByProject) {
          
                
		  request.query('SELECT * FROM vwInstitutionsByProject WHERE ProjectID = ' + projectID, function(err, institutionsByProject) {	  
		  request.query('SELECT * FROM ProjectCollaborator WHERE ProjectID = ' + projectID, function(err, projectCollaborators) {
		  request.query('SELECT * FROM ProjectSACMember WHERE ProjectID = ' + projectID, function(err, projectSACMembers) {  
          request.query('SELECT * FROM vwProjectDiary WHERE ProjectID = ' + projectID + ' ORDER BY ProjectDiaryDate desc', function(err, projectDiary) {  

                        res.render('edit_project', {
                            page_title: 'Edit Project',
                            project: projectForEdit[0],
                            institutions: institutions,
                            programs: programs,
                            managed: managed,
                            cofunders: cofunders,
                            projectstatus: projectstatus,
                            projectLeaders: projectLeaders,
                            contacts: contacts,
                            projectManagers: projectManagers,
                            projectMentors: projectMentors,
                            mentorProgram: mentorProgram,
                            renewedProject: renewedProject,
                            subprojects: subprojects,
                            Years: Years,
                            Months: Months,
                            keywords: keywords,
							peopleRolesByProject: peopleRolesByProject,
							institutionsByProject: institutionsByProject,
							projectCollaborators: projectCollaborators,
                            projectSACMembers: projectSACMembers,
                            projectDiary: projectDiary,
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



exports.renderEditSubProject = function(req, res){  // call: projects/editsubproject/:id
    var SubProjectID = req.params.id;

    logger.debug("SubProjectID = " + SubProjectID);

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
        request.query('SELECT * FROM vwSubProject WHERE SubProjectID = ' + SubProjectID, function(err, subproject) {
            if(err) logger.error('Error Selecting from SubProject table: %s ', err);

          request.query('SELECT * FROM SubProjectPI WHERE SubProjectID = ' + SubProjectID, function(err, principalInvestigators) {
          request.query('SELECT * FROM SubProjectManager WHERE SubProjectID = ' + SubProjectID, function(err, subProjectManagers) {
          request.query('SELECT * FROM SubProjectCoInvestigator WHERE SubProjectID = ' + SubProjectID, function(err, coInvestigators) {
          request.query('SELECT * FROM SubProjectCollaborator WHERE SubProjectID = ' + SubProjectID, function(err, collaborators) {
          request.query('SELECT * FROM SubProjectFinRep WHERE SubProjectID = ' + SubProjectID, function(err, finReps) {
          request.query('SELECT * FROM SubProjectFinOfficer WHERE SubProjectID = ' + SubProjectID, function(err, finOfficers) {
          request.query('SELECT * FROM SubProjectCoFunder WHERE SubProjectID = ' + SubProjectID, function(err, subProjectCoFunders) {
          request.query('SELECT * FROM SubProjectBudget WHERE SubProjectID = ' + SubProjectID, function(err, subProjectBudget) {
          request.query('SELECT * FROM SubProjectOtherPersonnel WHERE SubProjectID = ' + SubProjectID, function(err, otherPersonnel) {    

              if(err) logger.debug('Error Selecting from SubProjectBudget table: %s ', err);

                request.query('SELECT * FROM vwInstitutionDropDown order by InstitutionName', function(err, institutions) {
                request.query('SELECT * FROM vwManaged', function(err, managed) {
                request.query('SELECT * FROM vwPeopleForDropdownList ORDER BY LName, FName', function(err, contacts) {

                        res.render('edit_subproject', {
                            page_title: 'Edit Sub-Project',
                            subproject: subproject[0],
                            institutions: institutions,
                            managed: managed,
                            subProjectCoFunders: subProjectCoFunders,
                            contacts: contacts,
                            principalInvestigators: principalInvestigators,
                            subProjectManagers: subProjectManagers,
                            coInvestigators: coInvestigators,
                            collaborators: collaborators,
                            finReps: finReps,
                            finOfficers: finOfficers,
                            subProjectBudget: subProjectBudget,
                            otherPersonnel: otherPersonnel,
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





exports.save_editsubproject = function(req, res){
    var userID = req.user.UserID;
    var SubProjectID = req.params.id;
    logger.debug('save_editsubproject  === SubProjectID=' + SubProjectID);
    var input = JSON.parse(JSON.stringify(req.body));

    //console.log(input);

    var ProjectID = input.ProjectID;
    logger.debug('save_editsubproject  === ProjectID=' + ProjectID);
    var SubProjectName = input.SubProjectName;
    var SubProjectDescription = input.SubProjectDescription;
    //var BudgetAmendedDate = input.BudgetAmendedDate;
    // var MOUStartDate = input.MOUStartDate;
    // var MOUEndDate = input.MOUEndDate;
    // var MOUExtendedOnDate = input.MOUExtendedOnDate;
    var Notes = input.Notes.replace(/(')/g, "''");
    // var MOUSite = input.MOUSite;

    var editedPrincipalInvestigators = [];
    if (input.editedPrincipalInvestigators != null) {  editedPrincipalInvestigators = JSON.parse(input.editedPrincipalInvestigators);  }

    var deletedPrincipalInvestigators = [];
    if (input.deletedPrincipalInvestigators != null) { deletedPrincipalInvestigators = JSON.parse(input.deletedPrincipalInvestigators);  }

    var editedSubProjectManagers = [];
    if (input.editedSubProjectManagers != null) {  editedSubProjectManagers = JSON.parse(input.editedSubProjectManagers);  }

    var deletedSubProjectManagers = [];
    if (input.deletedSubProjectManagers != null) { deletedSubProjectManagers = JSON.parse(input.deletedSubProjectManagers);  }

    var editedCoInvestigators = [];
    if (input.editedCoInvestigators != null) {  editedCoInvestigators = JSON.parse(input.editedCoInvestigators);  }

    var deletedCoInvestigators = [];
    if (input.deletedCoInvestigators != null) { deletedCoInvestigators = JSON.parse(input.deletedCoInvestigators);  }

    // var editedFinReps = [];
    // if (input.editedFinReps != null) {  editedFinReps = JSON.parse(input.editedFinReps);  }

    // var deletedFinReps = [];
    // if (input.deletedFinReps != null) { deletedFinReps = JSON.parse(input.deletedFinReps);  }

    // var editedFinOfficers = [];
    // if (input.editedFinOfficers != null) {  editedFinOfficers = JSON.parse(input.editedFinOfficers);  }

    // var deletedFinOfficers = [];
    // if (input.deletedFinOfficers != null) { deletedFinOfficers = JSON.parse(input.deletedFinOfficers);  }

    var editedCollaborators = [];
    if (input.editedCollaborators != null) {  editedCollaborators = JSON.parse(input.editedCollaborators);  }

    var deletedCollaborators = [];
    if (input.deletedCollaborators != null) { deletedCollaborators = JSON.parse(input.deletedCollaborators);  }

    var editedSubProjectCoFunders = [];
    if (input.editedSubProjectCoFunders != null) {  editedSubProjectCoFunders = JSON.parse(input.editedSubProjectCoFunders);  }

    var deletedSubProjectCoFunders = [];
    if (input.deletedSubProjectCoFunders != null) { deletedSubProjectCoFunders = JSON.parse(input.deletedSubProjectCoFunders);  }

    var editedSubProjectBudget = [];
    if (input.editedSubProjectBudget != null) {  editedSubProjectBudget = JSON.parse(input.editedSubProjectBudget);  }

    var deletedSubProjectBudget = [];
    if (input.deletedSubProjectBudget != null) { deletedSubProjectBudget = JSON.parse(input.deletedSubProjectBudget);  }

    var editedOtherPersonnel = [];
    if (input.editedOtherPersonnel != null) {  editedOtherPersonnel = JSON.parse(input.editedOtherPersonnel);  }

    var deletedOtherPersonnel = [];
    if (input.deletedOtherPersonnel != null) { deletedOtherPersonnel = JSON.parse(input.deletedOtherPersonnel);  }



    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString = "UPDATE SubProject SET " +
                      " SubProjectName='"+SubProjectName+"'"+
                      ",SubProjectDescription='"+SubProjectDescription+"'"+
                      ",Notes='"+Notes+"'"+
                      ",UpdatedUserID='"+userID+"'"+
                      ",Updated=getdate()"+
                      " WHERE SubProjectID="+SubProjectID;
     //   ",BudgetAmendedDate='"+BudgetAmendedDate+"'"+
    
    //  ",MOUStartDate='"+MOUStartDate+"'"+
    //  ",MOUEndDate='"+MOUEndDate+"'"+
    //  ",MOUExtendedOnDate='"+MOUExtendedOnDate+"'"+
    //  ",MOUSite='"+MOUSite+"'"+

      logger.debug(sqlString);
      request.query(sqlString, function(err, rows) {

         if (err) logger.error("Error updating SubProject table: %s ", err);


//----------- other personnel list ----------------------------------
         for(var obj in editedOtherPersonnel) {
            if(editedOtherPersonnel[obj].hasOwnProperty('id')) {
                  var id = editedOtherPersonnel[obj]['id'];
                  var selectedId = editedOtherPersonnel[obj]['selectedId'];
                  var role = editedOtherPersonnel[obj]['role'];
                  if (id == "-1") {
                      request.query("INSERT INTO SubProjectOtherPersonnel (SubProjectID,ContactID, Role) VALUES ('" +
                      SubProjectID +"','"+selectedId+"','"+role+"') ", function(err, rows) {
                           if (err) logger.error("Error inserting in SubProjectOtherPersonnel table: %s ", err);
                      })
                  } else {
                      request.query("UPDATE SubProjectOtherPersonnel SET "+
                      "ContactID='"+selectedId+"',Role='"+role+"' WHERE SubProjectOtherPersonnelID='" +id+"'", function(err, rows) {
                           if (err) logger.error("Error updating of SubProjectOtherPersonnel table: %s ", err);
                      })
                  }
            }
        }

        for(var obj in deletedOtherPersonnel) {
            if(deletedOtherPersonnel[obj].hasOwnProperty('id')) {
                  var id = deletedOtherPersonnel[obj]['id'];
                  request.query("DELETE SubProjectOtherPersonnel WHERE SubProjectOtherPersonnelID='"+id+"'", function(err, rows) {
                       if (err) logger.error("Error deleting from SubProjectOtherPersonnel table: %s ", err);
                  })
            }
        }


//----------- PI list ----------------------------------

          if (editedPrincipalInvestigators != null) {
             logger.debug("editedPrincipalInvestigators:  " + JSON.stringify(editedPrincipalInvestigators));

              for(var obj in editedPrincipalInvestigators) {
                  if(editedPrincipalInvestigators[obj].hasOwnProperty('id')) {
                        var id = editedPrincipalInvestigators[obj]['id'];
                        var selectedId = editedPrincipalInvestigators[obj]['selectedId'];
                        if (id == "-1") {
                            request.query("INSERT INTO SubProjectPI (SubProjectID,ContactID) VALUES ('" +
                                          SubProjectID +"','"+selectedId+"') ", function(err, rows) {
                                 if (err) logger.error("Error inserting in SubProjectPI table: %s ", err);
                            })
                        } else {
                            request.query("UPDATE SubProjectPI SET "+
                            "ContactID='"+selectedId+"' WHERE SubProjectPIID='" + id+"'", function(err, rows) {
                                 if (err) logger.error("Error updating of SubProjectPI table: %s ", err);
                            })
                        }
                  }
              }
          }

          if (deletedPrincipalInvestigators != null) {
             logger.debug("deletedPrincipalInvestigators:  " + JSON.stringify(deletedPrincipalInvestigators));
              for(var obj in deletedPrincipalInvestigators) {
                  if(deletedPrincipalInvestigators[obj].hasOwnProperty('id')) {
                        var id = deletedPrincipalInvestigators[obj]['id'];
                        request.query("DELETE SubProjectPI WHERE SubProjectPIID='"+id+"'", function(err, rows) {
                             if (err) logger.error("Error deleting from SubProjectPI table: %s ", err);
                        })
                  }
              }
          }


//----------- SubProjectManagers list ----------------------------------

          if (editedSubProjectManagers != null) {
             logger.debug("editedSubProjectManagers:  " + JSON.stringify(editedSubProjectManagers));

              for(var obj in editedSubProjectManagers) {
                  if(editedSubProjectManagers[obj].hasOwnProperty('id')) {
                        var id = editedSubProjectManagers[obj]['id'];
                        var selectedId = editedSubProjectManagers[obj]['selectedId'];
                        if (id == "-1") {
                            request.query("INSERT INTO SubProjectManager (SubProjectID,ContactID) VALUES ('" +
                                          SubProjectID +"','"+selectedId+"') ", function(err, rows) {
                                 if (err) logger.error("Error inserting in SubProjectManager table: %s ", err);
                            })
                        } else {
                            request.query("UPDATE SubProjectManager SET "+
                            "ContactID='"+selectedId+"' WHERE SubProjectManagerID='" + id+"'", function(err, rows) {
                                 if (err) logger.error("Error updating of SubProjectManager table: %s ", err);
                            })
                        }
                  }
              }
          }

          if (deletedSubProjectManagers != null) {
             logger.debug("deletedSubProjectManagers:  " + JSON.stringify(deletedSubProjectManagers));
              for(var obj in deletedSubProjectManagers) {
                  if(deletedSubProjectManagers[obj].hasOwnProperty('id')) {
                        var id = deletedSubProjectManagers[obj]['id'];
                        request.query("DELETE SubProjectManager WHERE SubProjectManagerID='"+id+"'", function(err, rows) {
                             if (err) logger.error("Error deleting from SubProjectManager table: %s ", err);
                        })
                  }
              }
          }

//----------- CoInvestigators list ----------------------------------

          if (editedCoInvestigators != null) {
             logger.debug("editedCoInvestigators:  " + JSON.stringify(editedCoInvestigators));

              for(var obj in editedCoInvestigators) {
                  if(editedCoInvestigators[obj].hasOwnProperty('id')) {
                        var id = editedCoInvestigators[obj]['id'];
                        var selectedId = editedCoInvestigators[obj]['selectedId'];
                        if (id == "-1") {
                            request.query("INSERT INTO SubProjectCoInvestigator (SubProjectID,ContactID) VALUES ('" +
                                          SubProjectID +"','"+selectedId+"') ", function(err, rows) {
                                 if (err) logger.error("Error inserting in SubProjectCoInvestigator table: %s ", err);
                            })
                        } else {
                            request.query("UPDATE SubProjectCoInvestigator SET "+
                            "ContactID='"+selectedId+"' WHERE SubProjectCoInvestigatorID='" + id+"'", function(err, rows) {
                                 if (err) logger.error("Error updating of SubProjectCoInvestigator table: %s ", err);
                            })
                        }
                  }
              }
          }

          if (deletedCoInvestigators != null) {
             logger.debug("deletedCoInvestigators:  " + JSON.stringify(deletedCoInvestigators));
              for(var obj in deletedCoInvestigators) {
                  if(deletedCoInvestigators[obj].hasOwnProperty('id')) {
                        var id = deletedCoInvestigators[obj]['id'];
                        request.query("DELETE SubProjectCoInvestigator WHERE SubProjectCoInvestigatorID='"+id+"'", function(err, rows) {
                             if (err) logger.error("Error deleting from SubProjectCoInvestigator table: %s ", err);
                        })
                  }
              }
          }



//----------- FinReps list ----------------------------------

        //   if (editedFinReps != null) {
        //      logger.debug("editedFinReps:  " + JSON.stringify(editedFinReps));

        //       for(var obj in editedFinReps) {
        //           if(editedFinReps[obj].hasOwnProperty('id')) {
        //                 var id = editedFinReps[obj]['id'];
        //                 var selectedId = editedFinReps[obj]['selectedId'];
        //                 if (id == "-1") {
        //                     request.query("INSERT INTO SubProjectFinRep (SubProjectID,ContactID) VALUES ('" +
        //                                   SubProjectID +"','"+selectedId+"') ", function(err, rows) {
        //                          if (err) logger.error("Error inserting in SubProjectCoInvestigator table: %s ", err);
        //                     })
        //                 } else {
        //                     request.query("UPDATE SubProjectFinRep SET "+
        //                     "ContactID='"+selectedId+"' WHERE SubProjectFinRepID='" + id+"'", function(err, rows) {
        //                          if (err) logger.error("Error updating of SubProjectFinRep table: %s ", err);
        //                     })
        //                 }
        //           }
        //       }
        //   }

        //   if (deletedFinReps != null) {
        //      logger.debug("deletedFinReps:  " + JSON.stringify(deletedFinReps));
        //       for(var obj in deletedFinReps) {
        //           if(deletedFinReps[obj].hasOwnProperty('id')) {
        //                 var id = deletedFinReps[obj]['id'];
        //                 request.query("DELETE SubProjectFinRep WHERE SubProjectFinRepID='"+id+"'", function(err, rows) {
        //                      if (err) logger.error("Error deleting from SubProjectFinRep table: %s ", err);
        //                 })
        //           }
        //       }
        //   }

//----------- FinOfficers list ----------------------------------

        //   if (editedFinOfficers != null) {
        //      logger.debug("editedFinOfficers:  " + JSON.stringify(editedFinOfficers));

        //       for(var obj in editedFinOfficers) {
        //           if(editedFinOfficers[obj].hasOwnProperty('id')) {
        //                 var id = editedFinOfficers[obj]['id'];
        //                 var selectedId = editedFinOfficers[obj]['selectedId'];
        //                 if (id == "-1") {
        //                     request.query("INSERT INTO SubProjectFinOfficer (SubProjectID,ContactID) VALUES ('" +
        //                                   SubProjectID +"','"+selectedId+"') ", function(err, rows) {
        //                          if (err) logger.error("Error inserting in SubProjectFinOfficer table: %s ", err);
        //                     })
        //                 } else {
        //                     request.query("UPDATE SubProjectFinOfficer SET "+
        //                     "ContactID='"+selectedId+"' WHERE SubProjectFinOfficerID='" + id+"'", function(err, rows) {
        //                          if (err) logger.error("Error updating of SubProjectFinOfficer table: %s ", err);
        //                     })
        //                 }
        //           }
        //       }
        //   }

        //   if (deletedFinOfficers != null) {
        //      logger.debug("deletedFinOfficers:  " + JSON.stringify(deletedFinOfficers));
        //       for(var obj in deletedFinOfficers) {
        //           if(deletedFinOfficers[obj].hasOwnProperty('id')) {
        //                 var id = deletedFinOfficers[obj]['id'];
        //                 request.query("DELETE SubProjectFinOfficer WHERE SubProjectFinOfficerID='"+id+"'", function(err, rows) {
        //                      if (err) logger.error("Error deleting from SubProjectFinOfficertable: %s ", err);
        //                 })
        //           }
        //       }
        //   }


//----------- Collaborators list ----------------------------------

          if (editedCollaborators != null) {
             logger.debug("editedCollaborators:  " + JSON.stringify(editedCollaborators));

              for(var obj in editedCollaborators) {
                  if(editedCollaborators[obj].hasOwnProperty('id')) {
                        var id = editedCollaborators[obj]['id'];
                        var selectedId = editedCollaborators[obj]['selectedId'];
                        if (id == "-1") {
                            request.query("INSERT INTO SubProjectCollaborator (SubProjectID,ContactID) VALUES ('" +
                                          SubProjectID +"','"+selectedId+"') ", function(err, rows) {
                                 if (err) logger.error("Error inserting in SubProjectCollaborator table: %s ", err);
                            })
                        } else {
                            request.query("UPDATE SubProjectCollaborator SET "+
                            "ContactID='"+selectedId+"' WHERE SubProjectCollaboratorID='" + id+"'", function(err, rows) {
                                 if (err) logger.error("Error updating of SubProjectFinOfficer table: %s ", err);
                            })
                        }
                  }
              }
          }

          if (deletedCollaborators != null) {
             logger.debug("deletedCollaborators:  " + JSON.stringify(deletedCollaborators));
              for(var obj in deletedCollaborators) {
                  if(deletedCollaborators[obj].hasOwnProperty('id')) {
                        var id = deletedCollaborators[obj]['id'];
                        request.query("DELETE SubProjectCollaborator WHERE SubProjectCollaboratorID='"+id+"'", function(err, rows) {
                             if (err) logger.error("Error deleting from SubProjectCollaborator Collaboratortable: %s ", err);
                        })
                  }
              }
          }


//----------- SubProjectBudget list ----------------------------------

          if (editedSubProjectBudget!= null) {
             logger.debug("editedSubProjectBudget:  " + JSON.stringify(editedSubProjectBudget));

              for(var obj in editedSubProjectBudget) {
                  if(editedSubProjectBudget[obj].hasOwnProperty('id')) {
                        var id = editedSubProjectBudget[obj]['id'];
                        var CoFunderID = editedSubProjectBudget[obj]['selectedCoFunderId'];
                        var InstitutionID = editedSubProjectBudget[obj]['selectedPIInstitutionId'];
                        var PIID = editedSubProjectBudget[obj]['selectedInvestigatorId'];
                        var FinancialOfficerID = editedSubProjectBudget[obj]['selectedFO'];
						var Managed = editedSubProjectBudget[obj]['managed'];
                        var Year1Amt = editedSubProjectBudget[obj]['Year1Amt'] || 0;
                        var Year2Amt = editedSubProjectBudget[obj]['Year2Amt'] || 0;
                        var Year3Amt = editedSubProjectBudget[obj]['Year3Amt'] || 0;
                        var Year4Amt = editedSubProjectBudget[obj]['Year4Amt'] || 0;
                        var Year5Amt = editedSubProjectBudget[obj]['Year5Amt'] || 0;


                        if (id == "-1") {
                           var sqlString = "INSERT INTO SubProjectBudget (SubProjectID,PIID,InstitutionID,CoFunderID,Managed,FinancialOfficerID,Year1Amt,Year2Amt,Year3Amt,Year4Amt,Year5Amt) values ('" +
                            SubProjectID+"','"+PIID+"','"+InstitutionID+"','"+CoFunderID+"','"+Managed+"','"+FinancialOfficerID+
                             "',"+Year1Amt+","+Year2Amt+","+Year3Amt+","+Year4Amt+","+Year5Amt+") ";

                            request.query(sqlString, function(err, rows) {
                                 if (err) logger.error("Error inserting in SubProjectBudget table: %s ", err);
                            })
                        } else {
                            request.query("UPDATE SubProjectBudget SET "+
                            " PIID='"+PIID+"'"+
                            ",InstitutionID='"+InstitutionID+"'"+
                            ",CoFunderID='"+CoFunderID+"'"+
                            ",Managed='"+Managed+"'"+
                            ",FinancialOfficerID='"+FinancialOfficerID+"'"+                           
                            ",Year1Amt='"+accounting.unformat(Year1Amt)+"'"+
                            ",Year2Amt='"+accounting.unformat(Year2Amt)+"'"+
                            ",Year3Amt='"+accounting.unformat(Year3Amt)+"'"+
                            ",Year4Amt='"+accounting.unformat(Year4Amt)+"'"+
                            ",Year5Amt='"+accounting.unformat(Year5Amt)+"'"+
                            " WHERE SubProjectBudgetID='" +id+"'", function(err, rows) {
                                 if (err) logger.error("Error updating of SubProjectBudget table: %s ", err);
                            })
                        }
                  }
              }
          }

          if (deletedSubProjectBudget != null) {
             logger.debug("deletedSubProjectBudget:  " + JSON.stringify(deletedSubProjectBudget));
              for(var obj in deletedSubProjectBudget) {
                  if(deletedSubProjectBudget[obj].hasOwnProperty('id')) {
                        var id = deletedSubProjectBudget[obj]['id'];
                        request.query("DELETE SubProjectBudget WHERE SubProjectBudgetID='"+id+"'", function(err, rows) {
                             if (err) logger.error("Error deleting from SubProjectBudget table: %s ", err);
                        })
                  }
              }
          }



          if (err) logger.error("Error updating SubProject table: %s ", err);
          else {
            res.contentType('application/json');
            var data = JSON.stringify('/projects/edit/' + ProjectID);
            res.header('Content-Length', data.length);
            res.end(data);
          }
      });
    });
};



exports.renderAddNewSubProject = function (req, res) {
    
    var projectID = req.params.id;

    logger.debug('renderAddNewSubProject  === projectID=' + projectID);

    var principalInvestigators = [];
    var subProjectManagers = [];
    var coInvestigators = [];
    var collaborators = [];
    var finReps = [];
    var finOfficers = [];
    var subProjectCoFunders  = [];
    var subProjectBudget = [];


    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
          request.query("select * from vwInstitutionDropDown order by InstitutionName", function(err, institutions) {
          request.query("select * from vwManaged", function(err, managed) {
          request.query("select * from vwPeople ORDER BY LName, FName", function(err, contacts) {
                   
                   res.render('add_subproject', {
                        page_title: "Add Sub-Project",
                        projectID: projectID,
                        institutions: institutions,
                        managed: managed,
                        subProjectCoFunders : subProjectCoFunders ,
                        contacts: contacts,
                        principalInvestigators: principalInvestigators,
                        subProjectManagers: subProjectManagers,
                        coInvestigators: coInvestigators,
                        collaborators: collaborators,
                        finReps: finReps,
                        finOfficers: finOfficers,
                        subProjectBudget: subProjectBudget,
                        user: req.user
                    });
          });
          });
          });
    });
}



exports.save_newsubproject = function(req, res){

    var input = JSON.parse(JSON.stringify(req.body));

    var ProjectID = input.ProjectID;

    logger.debug('save_newsubproject  === ProjectID=' + ProjectID);
    
    var SubProjectName = input.SubProjectName;
    var SubProjectDescription = input.SubProjectDescription;
    //var ProjectShortName = input.ProjectShortName;
    //var BudgetAmendedDate = input.BudgetAmendedDate;
    //var MOUStartDate = input.MOUStartDate;
    var Notes = input.Notes.replace(/(')/g, "''");
	//var MOUSite = input.MOUSite || 0;


	var editedPrincipalInvestigators = [];
    if (input.editedPrincipalInvestigators != null) {  editedPrincipalInvestigators = JSON.parse(input.editedPrincipalInvestigators);  }

    // var editedSubProjectManagers = [];
    // if (input.editedSubProjectManagers != null) {  editedSubProjectManagers = JSON.parse(input.editedSubProjectManagers);  }

    var editedCoInvestigators = [];
    if (input.editedCoInvestigators != null) {  editedCoInvestigators = JSON.parse(input.editedCoInvestigators);  }

    // var editedFinReps = [];
    // if (input.editedFinReps != null) {  editedFinReps = JSON.parse(input.editedFinReps);  }

    // var editedFinOfficers = [];
    // if (input.editedFinOfficers != null) {  editedFinOfficers = JSON.parse(input.editedFinOfficers);  }

    var editedCollaborators = [];
    if (input.editedCollaborators != null) {  editedCollaborators = JSON.parse(input.editedCollaborators);  }

    // var editedSubProjectCoFunders = [];
    // if (input.editedSubProjectCoFunders != null) {  editedSubProjectCoFunders = JSON.parse(input.editedSubProjectCoFunders);  }

    var editedSubProjectBudget = [];
    if (input.editedSubProjectBudget != null) {  editedSubProjectBudget = JSON.parse(input.editedSubProjectBudget);  }

    var editedOtherPersonnel = [];
    if (input.editedOtherPersonnel != null) {  editedOtherPersonnel = JSON.parse(input.editedOtherPersonnel);  }


	console.log('2');
		
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
      var sqlString = "INSERT INTO SubProject (ProjectID,SubProjectName,SubProjectDescription,Notes) values ('" +
                          ProjectID+"','"+
                          SubProjectName+"','"+
                          SubProjectDescription+"','"+
                          Notes +"'); SELECT SCOPE_IDENTITY() AS ID ";

      request.query(sqlString, function(err, rows) {

          var SubProjectID = JSON.stringify(rows[0].ID);

          if (err) logger.error("Error inserting into SubProject table: %s ", err);

          for(var obj in editedPrincipalInvestigators) {
              if(editedPrincipalInvestigators[obj].hasOwnProperty('selectedId')) {
                    var selectedId = editedPrincipalInvestigators[obj]['selectedId'];
                    request.query("INSERT INTO SubProjectPI (SubProjectID,ContactID) values ('" +
                                  SubProjectID+"','"+selectedId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into SubProjectPI table: %s ", err);
                    })
              }
          }

        //   for(var obj in editedSubProjectManagers) {
        //       if(editedSubProjectManagers[obj].hasOwnProperty('selectedId')) {
        //             var selectedId = editedSubProjectManagers[obj]['selectedId'];
        //              request.query("INSERT INTO SubProjectManager (SubProjectID,ContactID) values ('" +
        //                           SubProjectID+"','"+selectedId+"') ", function(err, rows) {
        //                  if (err) logger.error("Error inserting into SubProjectManager table: %s ", err);
        //             })
        //       }
        //   }

          for(var obj in editedCoInvestigators) {
              if(editedCoInvestigators[obj].hasOwnProperty('selectedId')) {
                    var selectedId = editedCoInvestigators[obj]['selectedId'];
                     request.query("INSERT INTO SubProjectCoInvestigator (SubProjectID,ContactID) values ('" +
                                  SubProjectID+"','"+selectedId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into SubProjectCoInvestigator table: %s ", err);
                    })
              }
          }

        //   for(var obj in editedFinReps) {
        //       if(editedFinReps[obj].hasOwnProperty('selectedId')) {
        //             var selectedId = editedFinReps[obj]['selectedId'];
        //              request.query("INSERT INTO SubProjectFinRep (SubProjectID,ContactID) values ('" +
        //                           SubProjectID+"','"+selectedId+"') ", function(err, rows) {
        //                  if (err) logger.error("Error inserting into SubProjectFinRep table: %s ", err);
        //             })
        //       }
        //   }

        //   for(var obj in editedFinOfficers) {
        //       if(editedFinOfficers[obj].hasOwnProperty('selectedId')) {
        //             var selectedId = editedFinOfficers[obj]['selectedId'];
        //              request.query("INSERT INTO SubProjectFinOfficer (SubProjectID,ContactID) values ('" +
        //                           SubProjectID+"','"+selectedId+"') ", function(err, rows) {
        //                  if (err) logger.error("Error inserting into SubProjectFinOfficer table: %s ", err);
        //             })
        //       }
        //   }

          for(var obj in editedCollaborators) {
              if(editedCollaborators[obj].hasOwnProperty('selectedId')) {
                    var selectedId = editedCollaborators[obj]['selectedId'];
                     request.query("INSERT INTO SubProjectCollaborator (SubProjectID,ContactID) values ('" +
                                  SubProjectID+"','"+selectedId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into SubProjectCollaborator table: %s ", err);
                    })
              }
          }


          for(var obj in editedOtherPersonnel) {
            if(editedOtherPersonnel[obj].hasOwnProperty('id')) {
                  var id = editedOtherPersonnel[obj]['id'];
                  var selectedId = editedOtherPersonnel[obj]['selectedId'];
                  var role = editedOtherPersonnel[obj]['role'];
                  if (id == "-1") {
                      request.query("INSERT INTO SubProjectOtherPersonnel (SubProjectID,ContactID, Role) VALUES ('" +
                      SubProjectID +"','"+selectedId+"','"+role+"') ", function(err, rows) {
                           if (err) logger.error("Error inserting in SubProjectOtherPersonnel table: %s ", err);
                      })
                  }
            }
        }


        //   for(var obj in editedSubProjectCoFunders) {
        //         if(editedSubProjectCoFunders[obj].hasOwnProperty('selectedId')) {
        //               var selectedId = editedSubProjectCoFunders[obj]['selectedId'] || 0;
        //               var amount = editedSubProjectCoFunders[obj]['amount'] || 0;
        //               var managed = editedSubProjectCoFunders[obj]['managed'];
        //               request.query("INSERT INTO SubProjectCoFunder (SubProjectID,InstitutionID,Managed,BudgetAmount) values ('" +
        //                             SubProjectID+"','"+selectedId+"','"+managed+"','"+amount+"') ", function(err, rows) {
        //                    if (err) logger.error("Error inserting into SubProjectCoFunder table: %s ", err);
        //               })
        //         }
        //   }

          for(var obj in editedSubProjectBudget) {
                if(editedSubProjectBudget[obj].hasOwnProperty('selectedCoFunderId')) {
                      var CoFunderID = editedSubProjectBudget[obj]['selectedCoFunderId'];
                      var InstitutionID = editedSubProjectBudget[obj]['selectedPIInstitutionId'];
                      var PIID = editedSubProjectBudget[obj]['selectedInvestigatorId'];
                      var Managed = editedSubProjectBudget[obj]['managed'];
                      var Year1Amt = editedSubProjectBudget[obj]['Year1Amt'] || 0;
                      var Year2Amt = editedSubProjectBudget[obj]['Year2Amt'] || 0;
                      var Year3Amt = editedSubProjectBudget[obj]['Year3Amt'] || 0;
                      var Year4Amt = editedSubProjectBudget[obj]['Year4Amt'] || 0;
                      var Year5Amt = editedSubProjectBudget[obj]['Year5Amt'] || 0;

          var sqlString = "INSERT INTO SubProjectBudget (SubProjectID,PIID,InstitutionID,CoFunderID,Managed,Year1Amt,Year2Amt,Year3Amt,Year4Amt,Year5Amt) values ('" +
                            SubProjectID+"','"+PIID+"','"+InstitutionID+"','"+CoFunderID+"','"+Managed+
                             "',"+accounting.unformat(Year1Amt)+","+
							 accounting.unformat(Year2Amt)+","+accounting.unformat(Year3Amt)+","+accounting.unformat(Year4Amt)+","+accounting.unformat(Year5Amt)+") ";

          logger.debug("sqlString: " + sqlString);

                      request.query(sqlString, function(err, rows) {
                           if (err) logger.error("Error inserting into SubProjectBudget table: %s ", err);
                      })
                }
          }


          if (err) logger.error("Error inserting into SubProject table: %s ", err);
          else {
            res.contentType('application/json');
            var data = JSON.stringify('/projects/edit/' + ProjectID );
            res.header('Content-Length', data.length);
            res.end(data);
          }
      });
    });
};




exports.renderAddNewProject = function (req, res) {
    var cofunders = [];
    var projectLeaders = [];
    var projectManagers = [];
    var projectMentors = [];

    var Years = [
      {"value" : "0" },
      {"value" : "1" },
      {"value" : "2" },
      {"value" : "3" },
      {"value" : "4" },
      {"value" : "5" }
    ];
    var Months = [
      { "value" : "0" },
      { "value" : "1" },
      { "value" : "2" },
      { "value" : "3" },
      { "value" : "4" },
      { "value" : "5" },
      { "value" : "6" },
      { "value" : "7" },
      { "value" : "8" },
      { "value" : "9" },
      { "value" : "10" },
      { "value" : "11" },
      { "value" : "12" }
    ];
    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
		
		request.query('SELECT * FROM vwKeywords', function(err, keywords) {
        request.query("SELECT * FROM Program ORDER BY ProgramDescription", function(err, programs) {
        request.query("select * from vwInstitutionDropDown order by InstitutionName", function(err, institutions) {
        request.query("select * from vwManaged", function(err, managed) {
        request.query("select * from ProjectStatus", function(err, projectstatus) {
        request.query("select * from vwPeople ORDER BY LName, FName", function(err, contacts) {
        request.query("SELECT * FROM vwRenewedProject ORDER BY ProjectNumberTitle", function(err, mentorProgram) {  
        request.query("SELECT * FROM vwRenewedProject ORDER BY ProjectNumberTitle", function(err, renewedProject) {  
                   
                   res.render('add_project', {
                        page_title: "Add Project",
                        institutions: institutions,
                        programs: programs,
                        managed: managed,
                        cofunders: cofunders,
                        projectstatus: projectstatus,
                        projectLeaders: projectLeaders,
                        contacts: contacts,
                        projectManagers: projectManagers,
                        projectMentors: projectMentors,
                        mentorProgram: mentorProgram,
                        renewedProject: renewedProject,
						projectSACMembers: [],
                        projectCollaborators: [],
                        projectDiary: [],
                        Years: Years,
                        Months: Months,
                        keywords: keywords,
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
}

exports.getAllPrograms = function (req, res, next){
  sql.connect(config.connection, function(err) {
    var request = new sql.Request();
    request.query("SELECT * FROM Program ORDER BY ProgramDescription", function(err, rows) {

        if (err || !rows.length) {  return next(error);  }
        req.programs = rows;
        return next();
    });
  });
};

exports.save_new = function(req, res){
    console.log('project save_new ... ');
    var userID = req.user.UserID;
    var input = JSON.parse(JSON.stringify(req.body));
    console.log('project save_new ... 1');

    var ProjectTitle = input.ProjectTitle.replace(/(')/g, "''");
    var ProjectNumber = input.ProjectNumber;
    var ProjectShortName = input.ProjectShortName.replace(/(')/g, "''");
    var selectedProgram = input.ProgramType;
    var projectStatus = input.ProjectStatus;
    var StartDate = input.StartDate;
    var LaySummary = input.LaySummary.replace(/(')/g, "''");
    var ScientificSummary = input.ScientificSummary.replace(/(')/g, "''");
    var Renewal = input.Renewal;

    console.log('project save_new ... 2');

    // var projectManagers = JSON.parse(input.ProjectManagers);
    // var projectMentors = JSON.parse(input.ProjectMentors);

    var projectManagers = [];
    if (input.projectManagers != null) { projectManagers = JSON.parse(input.projectManagers); }

    var projectMentors = [];
    if (input.projectMentors != null) { projectMentors = JSON.parse(input.projectMentors); }



    var LetterOfOfferDate = input.LetterOfOfferDate;
    var NCEEndDate = input.NCEEndDate;
    var CloseOutLetterSentDate = input.CloseOutLetterSentDate;
    var FollowUpDate = input.FollowUpDate;
    var ClosedUnusedFunds = input.ClosedUnusedFunds || 0;
    var RefundReceivedDate = input.RefundReceivedDate;
    var BudgetAmendedDate = input.BudgetAmendedDate;
    var ProgressReportFrequency = input.ProgressReportFrequency;
    var ProjectMeetingFrequency = input.ProjectMeetingFrequency;
    var LastSACMeetingDate = input.LastSACMeetingDate;
    var ProgressReportMonths = input.ProgressReportMonths;

    var LastProjectMeetingDate = input.LastProjectMeetingDate;
    var NextSACMeetingDate = input.NextSACMeetingDate; 
    var LastProgressReportReceivedDate = input.LastProgressReportReceived;  
    var NextProjectMeetingDate = input.NextProjectMeetingDate;  
    //var Notes = input.Notes.replace(/(')/g, "''");  
    //var PublicationsList = input.PublicationsList.replace(/(')/g, "''");
    //var CommunicationsNotes = input.CommunicationsNotes.replace(/(')/g, "''");



    var MentorProjectID = input.MentorProgram || 0;
    var RenewedProjectID = input.RenewedProject || 0;
    var LengthOfProjectYears = input.LengthOfProjectYears || 0;
    var LengthOfProjectMonths = input.LengthOfProjectMonths || 0;
    var Keywords = input.Keywords;
	var ExtraKeywords = input.ExtraKeywords;
    
    var LastMetricsReportReceived = input.LastMetricsReportReceived; 
    
	var editedProjectLeaders = [];
    if (input.editedProjectLeaders != null) { editedProjectLeaders = JSON.parse(input.editedProjectLeaders); }

	
	var editedProjectCollaborators = [];
	if (input.editedProjectCollaborators != null) { editedProjectCollaborators = JSON.parse(input.editedProjectCollaborators); }
  
	var editedProjectSACMembers = [];
	if (input.editedProjectSACMembers != null) { editedProjectSACMembers = JSON.parse(input.editedProjectSACMembers); }
	  
    var editedProjectDiary = [];
	if (input.editedProjectDiary != null) { editedProjectDiary = JSON.parse(input.editedProjectDiary); }
	
  
    sql.connect(config.connection, function(err) {
	  var request = new sql.Request();
      var sqlString = "INSERT INTO project (ProjectTitle,ProjectNumber,ProjectShortName,ProgramID,ProjectStatusID,"+
                      "StartDate,LaySummary,ScientificSummary,Renewal,LetterOfOfferDate,NCEEndDate,LastMetricsReportReceived,CloseOutLetterSentDate,FollowUpDate,"+
                      "ClosedUnusedFunds,RefundReceivedDate,BudgetAmendedDate,ProgressReportFrequency,ProjectMeetingFrequency,LastSACMeetingDate,"+
                      "ProgressReportMonths,LastProjectMeetingDate,NextSACMeetingDate,LastProgressReportReceivedDate,NextProjectMeetingDate,"+
                      "MentorProjectID,RenewedProjectID,LengthOfProjectYears,LengthOfProjectMonths,Keywords,CreatedUserID,ExtraKeywords) values ('" +
                      ProjectTitle+"','"+
                      ProjectNumber+"','"+
                      ProjectShortName+"','"+
                      selectedProgram+"','"+
                      projectStatus+"','"+
                      StartDate+"','"+
                      LaySummary+"','"+
                      ScientificSummary+"','"+
                      Renewal+"','"+
                      LetterOfOfferDate+"','"+
                      NCEEndDate+"','"+
                      LastMetricsReportReceived+"','"+
                      CloseOutLetterSentDate+"','"+
                      FollowUpDate+"','"+
                      ClosedUnusedFunds+"','"+
                      RefundReceivedDate+"','"+
                      BudgetAmendedDate+"','"+
                      ProgressReportFrequency+"','"+
                      ProjectMeetingFrequency+"','"+
                      LastSACMeetingDate+"','"+
                      ProgressReportMonths+"','"+
                      LastProjectMeetingDate+"','"+
                      NextSACMeetingDate+"','"+
                      LastProgressReportReceivedDate+"','"+
                      NextProjectMeetingDate+"','"+
                      MentorProjectID+"','"+
                      RenewedProjectID+"','"+
                      LengthOfProjectYears+"','"+
                      LengthOfProjectMonths+"','"+
                      Keywords+"','"+
                      userID+"','"+
					  ExtraKeywords+
                      "'); SELECT SCOPE_IDENTITY() AS ID ";
      logger.debug(sqlString);

      request.query(sqlString, function(err, rows) {
          if (err) logger.error("Error inserting into project table: %s ", err);
          var ProjectID = JSON.stringify(rows[0].ID);

          for(var obj in editedProjectLeaders) {
              if(editedProjectLeaders[obj].hasOwnProperty('selectedId')) {
                    var selectedId = editedProjectLeaders[obj]['selectedId'];
					var institutionId = editedProjectLeaders[obj]['institutionId'];
                    request.query("INSERT INTO ProjectLeader (ProjectID,ContactID,InstitutionID) values ('" +
                                  ProjectID+"','"+selectedId+"','"+institutionId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into ProjectLeader table: %s ", err);
                    })
              }
          }

          for(var obj in projectManagers) {
              if(projectManagers[obj].hasOwnProperty('selectedId')) {
                    var selectedId = projectManagers[obj]['selectedId'];
                    request.query("INSERT INTO ProjectManager (ProjectID,ContactID) values ('" +
                                  ProjectID+"','"+selectedId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into ProjectManager table: %s ", err);
                    })
              }
          }

          for(var obj in projectMentors) {
              if(projectMentors[obj].hasOwnProperty('selectedId')) {
                    var selectedId = projectMentors[obj]['selectedId'];
                    request.query("INSERT INTO ProjectMentor (ProjectID,ContactID) values ('" +
                                  ProjectID+"','"+selectedId+"') ", function(err, rows) {
                         if (err) logger.error("Error inserting into ProjectMentor table: %s ", err);
                    })
              }
          }

		  
		  
 //---------------- project collaborators -----------------------

            for(var obj in editedProjectCollaborators) {
                if(editedProjectCollaborators[obj].hasOwnProperty('id')) {
                    var id = editedProjectCollaborators[obj]['id'];
                    var selectedId = editedProjectCollaborators[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectCollaborator (ProjectID,ContactID) VALUES ('" +
                                        ProjectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectCollaborator table: %s ", err);
                        })
                    }
                }
            }

 //---------------- project SAC members -----------------------

            for(var obj in editedProjectSACMembers) {
                if(editedProjectSACMembers[obj].hasOwnProperty('id')) {
                    var id = editedProjectSACMembers[obj]['id'];
                    var selectedId = editedProjectSACMembers[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectSACMember (ProjectID,ContactID) VALUES ('" +
                                        ProjectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectSACMember table: %s ", err);
                        })
                    }
                }
            }
		  
 //---------------- project Diary -----------------------

            for(var obj in editedProjectDiary) {
                if(editedProjectDiary[obj].hasOwnProperty('id')) {
                    var id = editedProjectDiary[obj]['id'];
                    var ProjectDiaryDate = editedProjectDiary[obj]['ProjectDiaryDate'];
                    var ProjectDiaryEntry = editedProjectDiary[obj]['ProjectDiaryEntry'];
                    
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectDiary (ProjectID,ProjectDiaryDate,ProjectDiaryEntry) VALUES ('" +
                                        ProjectID +"','"+ProjectDiaryDate+ "','"+ProjectDiaryEntry+   "') ", function(err, rows) {
                            if (err) logger.error("Error inserting in ProjectSACMember table: %s ", err);
                        })
                    }
                }
            }		  
		  
          if (err) logger.error("Error inserting into project table: %s ", err);
          else {
            res.contentType('application/json');
            var data = JSON.stringify('/projects');
            res.header('Content-Length', data.length);
            res.end(data);
          }
      });
    });
};


exports.save_edit = function(req, res){
  var userID = req.user.UserID;
  var input = req.body;
  var projectID = req.params.id;
  var ProjectTitle = input.ProjectTitle.replace(/(')/g, "''");
  var ProjectNumber = input.ProjectNumber;
  var ProjectShortName = input.ProjectShortName.replace(/(')/g, "''");
  var StartDate = input.StartDate;
  var EndDate = input.EndDate;
  var selectedProgram = input.ProgramType;
  var projectStatus = input.ProjectStatus;
  var LaySummary = input.LaySummary.replace(/(')/g, "''");;
  var ScientificSummary = input.ScientificSummary.replace(/(')/g, "''");
  var Renewal = input.Renewal;
  //console.log('input.Renewal==' + input.Renewal);

  var LetterOfOfferDate = input.LetterOfOfferDate;
  var NCEEndDate = input.NCEEndDate;
  var CloseOutLetterSentDate = input.CloseOutLetterSentDate;
  var FollowUpDate = input.FollowUpDate;
  var ClosedUnusedFunds = input.ClosedUnusedFunds  || 0;
  var RefundReceivedDate = input.RefundReceivedDate;
  var BudgetAmendedDate = input.BudgetAmendedDate;
  var ProgressReportFrequency = input.ProgressReportFrequency;
  var ProjectMeetingFrequency = input.ProjectMeetingFrequency;
  var LastSACMeetingDate = input.LastSACMeetingDate;
  var ProgressReportMonths = input.ProgressReportMonths;
  var LastProjectMeetingDate = input.LastProjectMeetingDate;
  var NextSACMeetingDate = input.NextSACMeetingDate; 
  var LastProgressReportReceivedDate = input.LastProgressReportReceived;  
  var NextProjectMeetingDate = input.NextProjectMeetingDate;  


  console.log('MentorProgram  === ' + JSON.stringify(input.MentorProgram));

  var MentorProjectID = input.MentorProgram || 0;
  var RenewedProjectID = input.RenewedProject || 0;
  
  console.log('MentorProjectID=' + MentorProjectID)
   //   console.log('RenewedProjectID=' + RenewedProjectID)
  
  
  var LengthOfProjectYears = input.LengthOfProjectYears || 0;
  var LengthOfProjectMonths = input.LengthOfProjectMonths || 0;

  var redirectToSubProjectPage = input.redirectToSubProjectPage || '';
  var Keywords = input.Keywords;
  var ExtraKeywords = input.ExtraKeywords;
  var LastMetricsReportReceived = input.LastMetricsReportReceived;

  console.log('StartDate ==' + StartDate);
  //console.log('EndDate ==' + EndDate);
//   console.log('LetterOfOfferDate ==' + LetterOfOfferDate);
//   console.log('NCEEndDate ==' + NCEEndDate);
//   console.log('CloseOutLetterSentDate ==' + CloseOutLetterSentDate);
//   console.log('FollowUpDate ==' + FollowUpDate);
//   console.log('LastProjectMeetingDate ==' + LastProjectMeetingDate);
//   console.log('NextSACMeetingDate ==' + NextSACMeetingDate);
//   console.log('BudgetAmendedDate ==' + BudgetAmendedDate);
//   console.log('RefundReceivedDate ==' + RefundReceivedDate);
//   console.log('LastSACMeetingDate ==' + LastSACMeetingDate);
//   console.log('NextProjectMeetingDate ==' + NextProjectMeetingDate);
  

  var editedProjectLeaders = [];
  if (input.editedProjectLeaders != null) { editedProjectLeaders = JSON.parse(input.editedProjectLeaders); }
  
  var deletedProjectLeaders = [];
  if (input.deletedProjectLeaders != null) { deletedProjectLeaders = JSON.parse(input.deletedProjectLeaders); }

  var editedProjectManagers = [];
  if (input.editedProjectManagers != null) { editedProjectManagers = JSON.parse(input.editedProjectManagers); }
  
  var deletedProjectManagers = [];
  if (input.deletedProjectManagers != null) { deletedProjectManagers = JSON.parse(input.deletedProjectManagers); }

  var editedProjectMentors = [];
  if (input.editedProjectMentors != null) { editedProjectMentors = JSON.parse(input.editedProjectMentors); }
  
  var deletedProjectMentors = [];
  if (input.deletedProjectMentors != null) { deletedProjectMentors = JSON.parse(input.deletedProjectMentors); }


  var editedProjectCollaborators = [];
  if (input.editedProjectCollaborators != null) { editedProjectCollaborators = JSON.parse(input.editedProjectCollaborators); }
  
  var deletedProjectCollaborators = [];
  if (input.deletedProjectCollaborators != null) { deletedProjectCollaborators = JSON.parse(input.deletedProjectCollaborators); }

  var editedProjectSACMembers = [];
  if (input.editedProjectSACMembers != null) { editedProjectSACMembers = JSON.parse(input.editedProjectSACMembers); }
  
  var deletedProjectSACMembers = [];
  if (input.deletedProjectSACMembers != null) { deletedProjectSACMembers = JSON.parse(input.deletedProjectSACMembers); }
 
  var deletedSubProjects = [];
  if (input.deletedSubProjects != null) { deletedSubProjects = JSON.parse(input.deletedSubProjects); }

  var editedProjectDiary = [];
  if (input.editedProjectDiary != null) { editedProjectDiary = JSON.parse(input.editedProjectDiary); }

  var deletedProjectDiary = [];
  if (input.deletedProjectDiary != null) { deletedProjectDiary = JSON.parse(input.deletedProjectDiary); }
 
console.log('editedProjectDiary == ' + JSON.stringify(editedProjectDiary));

    sql.connect(config.connection, function(err) {
      var request = new sql.Request();

      var sqlString = "UPDATE project SET " +
                     " ProjectTitle='" +ProjectTitle+
                     "',MentorProjectID='"+MentorProjectID+
                     "',ProjectNumber='"+ProjectNumber+
                     "',ProjectShortName='"+ProjectShortName+
                     "',ProgramID='"+selectedProgram+
                     "',ProjectStatusID='"+projectStatus+
                     "',StartDate='"+StartDate+
                     "',LaySummary='"+LaySummary+
                     "',ScientificSummary='"+ScientificSummary+
                     "',LetterOfOfferDate='"+LetterOfOfferDate+
                     "',NCEEndDate='"+NCEEndDate+
                     "',LastMetricsReportReceived='"+LastMetricsReportReceived+
                     "',CloseOutLetterSentDate='"+CloseOutLetterSentDate+
                     "',FollowUpDate='"+FollowUpDate+
                     "',ClosedUnusedFunds='"+ClosedUnusedFunds+
                     "',RefundReceivedDate='"+RefundReceivedDate+
                     "',BudgetAmendedDate='"+BudgetAmendedDate+
                     "',ProgressReportFrequency='"+ProgressReportFrequency+
                     "',ProjectMeetingFrequency='"+ProjectMeetingFrequency+
                     "',LastSACMeetingDate='"+LastSACMeetingDate+
                     "',ProgressReportMonths='"+ProgressReportMonths+
                     "',LastProjectMeetingDate='"+LastProjectMeetingDate+
                     "',NextSACMeetingDate='"+NextSACMeetingDate+
                     "',LastProgressReportReceivedDate='"+LastProgressReportReceivedDate+
                     "',NextProjectMeetingDate='"+NextProjectMeetingDate+   
                     "',RenewedProjectID='"+RenewedProjectID+
                     "',Renewal='"+Renewal+
                     "',LengthOfProjectYears='"+LengthOfProjectYears+
                     "',LengthOfProjectMonths='"+LengthOfProjectMonths+  
                     "',Keywords='"+Keywords+  
                     "',ExtraKeywords='"+ExtraKeywords+
                     "',UpdatedUserID='"+userID+ 
					 "',Updated=getdate()"+
                     " WHERE ProjectID = "+projectID

//"',Notes='"+Notes+
//"',PublicationsList='"+PublicationsList+
// "',CommunicationsNotes='"+CommunicationsNotes+  

      request.query(sqlString, function(err, rows) {

            for(var obj in deletedSubProjects) {
                if(deletedSubProjects[obj].hasOwnProperty('id')) {
                      var id = deletedSubProjects[obj]['id'];
                      //request.query("DELETE SubProject WHERE SubProjectID='"+id+"'", function(err, rows) {
					  request.query("UPDATE SubProject SET IsDeleted = 1, Updated = getdate() WHERE SubProjectID='"+id+"'", function(err, rows) {	  
                           if (err) logger.error("Error deleting from SubProject table: %s ", err);
                      })
                }
            }

 //---------------- project Diary -----------------------

    for(var obj in editedProjectDiary) {
        if(editedProjectDiary[obj].hasOwnProperty('id')) {
            var id = editedProjectDiary[obj]['id'];
            var ProjectDiaryDate = editedProjectDiary[obj]['ProjectDiaryDate'];
            var ProjectDiaryEntry = editedProjectDiary[obj]['ProjectDiaryEntry'];
            
            if (id == "-1") {
                request.query("INSERT INTO ProjectDiary (ProjectID,ProjectDiaryDate,ProjectDiaryEntry) VALUES ('" +
                projectID +"','"+ProjectDiaryDate+ "','"+ProjectDiaryEntry+   "') ", function(err, rows) {
                    if (err) logger.error("Error inserting in ProjectDiary table: %s ", err);
                })
            } else {
                request.query("UPDATE ProjectDiary SET "+
                "ProjectDiaryDate='"+ProjectDiaryDate+
                "',ProjectDiaryEntry='"+ProjectDiaryEntry+
                "' WHERE ProjectDiaryID='" + id+"'", function(err, rows) {
                        if (err) logger.error("Error updating of ProjectDiary table: %s ", err);
                })
            }
        }
    }


    for(var obj in deletedProjectDiary) {
        if(deletedProjectDiary[obj].hasOwnProperty('id')) {
            var id = deletedProjectDiary[obj]['id'];
            request.query("DELETE ProjectDiary WHERE ProjectDiaryID='"+id+"'", function(err, rows) {
                    if (err) logger.error("Error deleting from ProjectDiary table: %s ", err);
            })
        }
    }




//---------------- project leaders -----------------------

            for(var obj in editedProjectLeaders) {
                if(editedProjectLeaders[obj].hasOwnProperty('id')) {
                    var id = editedProjectLeaders[obj]['id'];
                    var selectedId = editedProjectLeaders[obj]['selectedId'];
                    var institutionId = editedProjectLeaders[obj]['institutionId'];

                    if (id == "-1") {
                        request.query("INSERT INTO ProjectLeader (ProjectID,ContactID,InstitutionID) VALUES ('" +
                                        projectID+"','"+selectedId+"','"+institutionId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectLeader table: %s ", err);
                        })
                    } else {
                        request.query("UPDATE ProjectLeader SET "+
                        "ContactID='"+selectedId+
                        "',InstitutionID='"+institutionId+
                        "' WHERE ProjectLeaderID='" + id+"'", function(err, rows) {
                                if (err) logger.error("Error updating of ProjectLeader table: %s ", err);
                        })
                    }
                }
            }

            for(var obj in deletedProjectLeaders) {
                if(deletedProjectLeaders[obj].hasOwnProperty('id')) {
                    var id = deletedProjectLeaders[obj]['id'];
                    request.query("DELETE ProjectLeader WHERE ProjectLeaderID='"+id+"'", function(err, rows) {
                            if (err) logger.error("Error deleting from ProjectLeader table: %s ", err);
                    })
                }
            }

//---------------- project managers -----------------------

            for(var obj in editedProjectManagers) {
                if(editedProjectManagers[obj].hasOwnProperty('id')) {
                    var id = editedProjectManagers[obj]['id'];
                    var selectedId = editedProjectManagers[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectManager (ProjectID,ContactID) VALUES ('" +
                                        projectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectManager table: %s ", err);
                        })
                    } else {
                        request.query("UPDATE ProjectManager SET "+
                        "ContactID='"+selectedId+"' WHERE ProjectManagerID='" + id+"'", function(err, rows) {
                                if (err) logger.error("Error updating of ProjectManager table: %s ", err);
                        })
                    }

                }
            }
            for(var obj in deletedProjectManagers) {
                if(deletedProjectManagers[obj].hasOwnProperty('id')) {
                    var id = deletedProjectManagers[obj]['id'];
                    request.query("DELETE ProjectManager WHERE ProjectManagerID='"+id+"'", function(err, rows) {
                            if (err) logger.error("Error deleting from ProjectManager table: %s ", err);
                    })
                }
            }

 //---------------- project collaborators -----------------------

            for(var obj in editedProjectCollaborators) {
                if(editedProjectCollaborators[obj].hasOwnProperty('id')) {
                    var id = editedProjectCollaborators[obj]['id'];
                    var selectedId = editedProjectCollaborators[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectCollaborator (ProjectID,ContactID) VALUES ('" +
                                        projectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectCollaborator table: %s ", err);
                        })
                    } else {
                        request.query("UPDATE ProjectCollaborator SET "+
                        "ContactID='"+selectedId+"' WHERE ProjectCollaboratorID='" + id+"'", function(err, rows) {
                                if (err) logger.error("Error updating of ProjectCollaborator table: %s ", err);
                        })
                    }

                }
            }
            for(var obj in deletedProjectCollaborators) {
                if(deletedProjectCollaborators[obj].hasOwnProperty('id')) {
                    var id = deletedProjectCollaborators[obj]['id'];
                    request.query("DELETE ProjectCollaborator WHERE ProjectCollaboratorID='"+id+"'", function(err, rows) {
                            if (err) logger.error("Error deleting from ProjectCollaborator table: %s ", err);
                    })
                }
            }

 //---------------- project SAC members -----------------------

            for(var obj in editedProjectSACMembers) {
                if(editedProjectSACMembers[obj].hasOwnProperty('id')) {
                    var id = editedProjectSACMembers[obj]['id'];
                    var selectedId = editedProjectSACMembers[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectSACMember (ProjectID,ContactID) VALUES ('" +
                                        projectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectSACMember table: %s ", err);
                        })
                    } else {
                        request.query("UPDATE ProjectSACMember SET "+
                        "ContactID='"+selectedId+"' WHERE ProjectSACMemberID='" + id+"'", function(err, rows) {
                                if (err) logger.error("Error updating of ProjectSACMember table: %s ", err);
                        })
                    }

                }
            }
            for(var obj in deletedProjectSACMembers) {
                if(deletedProjectSACMembers[obj].hasOwnProperty('id')) {
                    var id = deletedProjectSACMembers[obj]['id'];
                    request.query("DELETE ProjectSACMember WHERE ProjectSACMemberID='"+id+"'", function(err, rows) {
                            if (err) logger.error("Error deleting from ProjectSACMember table: %s ", err);
                    })
                }
            }

//---------------- project mentors -----------------------

            for(var obj in editedProjectMentors) {
                if(editedProjectMentors[obj].hasOwnProperty('id')) {
                    var id = editedProjectMentors[obj]['id'];
                    var selectedId = editedProjectMentors[obj]['selectedId'];
                    if (id == "-1") {
                        request.query("INSERT INTO ProjectMentor (ProjectID,ContactID) VALUES ('" +
                                        projectID +"','"+selectedId+"') ", function(err, rows) {
                                if (err) logger.error("Error inserting in ProjectMentor table: %s ", err);
                        })
                    } else {
                        request.query("UPDATE ProjectMentor SET "+
                        "ContactID='"+selectedId+"' WHERE ProjectMentorID='" + id+"'", function(err, rows) {
                                if (err) logger.error("Error updating of ProjectMentor table: %s ", err);
                        })
                    }

                }
            }
            for(var obj in deletedProjectMentors) {
                if(deletedProjectMentors[obj].hasOwnProperty('id')) {
                    var id = deletedProjectMentors[obj]['id'];
                    request.query("DELETE ProjectMentor WHERE ProjectMentorID='"+id+"'", function(err, rows) {
                            if (err) logger.error("Error deleting from ProjectMentor table: %s ", err);
                    })
                }
            }


            // if (err) logger.error("Error updating of Project table: %s ", err);
            if (err) console.log("Error updating of Project table: %s ", err);
            else {
            res.contentType('application/json');

            var strUrl = '/projects';
        
            var data = JSON.stringify(strUrl);
            
            res.header('Content-Length', data.length);
            res.end(data);
            }
        });
      });
};

exports.subproject_delete = function(req, res){
    var id = req.params.id;
    var projectid = req.params.projectid;
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
	  request.query("UPDATE subproject SET IsDeleted = 1, Updated = getdate() WHERE SubProjectID = " + id , function(err, recordset) {  
          if(err) logger.error("Error deleting from subproject table: %s ", err);
          //res.redirect('/projects');
          res.redirect('/projects/edit/'+projectid);
        });
      });
};

exports.delete = function(req, res){
    var id = req.params.id;
    sql.connect(config.connection, function(err) {
      var request = new sql.Request();
	  request.query("UPDATE project SET IsDeleted = 1, Updated = getdate() WHERE ProjectID = " + id , function(err, recordset) {  
          if(err) logger.error("Error deleting from project table: %s ", err);
          res.redirect('/projects');
        });
      });
};

exports.getAllProjects = function(req, res,next) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwProject order by ProjectNumber desc", function(err, recordset) {
      if (err || !recordset.length) { return next(error);  }
       req.institutions = recordset;
       return next();
		});
  });
};


exports.projects = function(req, res) {
	console.log('projects  ....');
	
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwProject order by ProjectNumber desc", function(err, recordset) {
		request.query('SELECT * FROM vwProgramFilter ORDER BY ProgramID', function(err, programs) {	
		request.query('SELECT * FROM vwProjectStatusFilter ORDER BY ProjectStatusID', function(err, projectstatus) {
		request.query('SELECT * FROM vwProvinceFilter ORDER BY SortOrder', function(err, province) {
		request.query('SELECT * FROM vwInstitutionFilter ORDER BY InstitutionID', function(err, institution) {
			 if(err) logger.error("Error selecting from vwProject table: %s ", err);
			 
			 res.render('Project', { 
					page_title: 'Project', 
					data: recordset,
					programs: programs,
					projectstatus: projectstatus,
                    province: province, 
                    institution: institution		});
		});
		});
		});
		});
		});
  });
}


exports.NotFilteredProjects = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwProject", function(err, data) {
			// if(err) console.log("Error selecting from vwProject table: "+ err);
            if(err) logger.error("Error selecting from vwProject table: %s ", err);
          res.send(data);
		});
  });
}

 exports.filteredProjects = function(req, res) {
	var filter = JSON.parse(req.params.filter);
	console.log('filter= ' + filter.filterProgramType);
	var sqlStr = "select distinct A.* from vwProject A  LEFT JOIN vwProjectFilter B ON B.ProjectID = A.ProjectID where 1=1 ";
    var filterProgramType = filter.filterProgramType;
	var filterProjectStatus = filter.filterProjectStatus;
	
	var filterInstitution = filter.filterInstitution;
	var filterProvince = filter.filterProvince;
	
	if (filterProgramType != 'ALL') sqlStr = sqlStr + " AND A.ProgramDescription = '" + filterProgramType + "'";
	if (filterProjectStatus != 'ALL') sqlStr = sqlStr + " AND A.ProjectStatusDescription = '" + filterProjectStatus + "'";
	
	if (filterInstitution != 'ALL') sqlStr = sqlStr + " AND B.InstitutionName = '" + filterInstitution + "'" ;
	
	console.log('filterInstitution == ' + filterInstitution);
	
	if (filterProvince != 'ALL') sqlStr = sqlStr + " AND B.Province = '" + filterProvince + "'";
	
	
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
        if(err) console.log("Error selecting in filteredProjects function ...");

		request.query(sqlStr, function(err, data) {
          if(err) console.log("Error selecting in filteredProjects function ...");
          //console.log("filtered data == "+ data);
          res.send(data);
		});
	});
}

exports.filterDatasets = function (req, res, next) {
	console.log('filterDatasets  ....');
	
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query('SELECT * FROM vwProgramFilter ORDER BY ProgramID', function(err, programs) {	
		request.query('SELECT * FROM vwProjectStatusFilter ORDER BY ProjectStatusID', function(err, projectstatus) {
		request.query('SELECT * FROM vwProvinceFilter ORDER BY SortOrder', function(err, province) {
		request.query('SELECT * FROM vwInstitutionFilter ORDER BY InstitutionID', function(err, institution) {
			 if(err) console.log("Error selecting in filterDatasets function ...");
             
                var dataset = {
                    programs: programs,
                    projectstatus: projectstatus,
                    province: province, 
                    institution: institution
                }
                req.dataset = dataset;
                return next();
		});
		});
		});
		});
  });
}