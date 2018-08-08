function SaveGeneralContactTable(row, objMetaData){
    var selectorName = objMetaData.selectorName.toString();  
    var editedListName = objMetaData.editedListName.toString(); 

    var table = $(row).parent().parent().attr('id');
    var id, selectedId;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
         
          $(this).find(selectorName).each(function(){
            selectedId = $(this).val();
          });
    });

    var Leader = {id: id, selectedId: selectedId};
    var list = [];

    if (localStorage.getItem(editedListName) != null) {
      list = JSON.parse(localStorage[editedListName]);
    }

    list.push(Leader);
    localStorage[editedListName] = JSON.stringify(list);
    console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    //************************************* */
    // $(row).find('td:last-child').remove();
    // row = addEditDeleteButtons(row);
    //************************************* */


    var btn1 = $(row).find('td:last-child').children('a:first')
    var btn2 = $(row).find('td:last-child').children('a').eq(1);
    //$(btn1).remove();
    $(row).find('td:last-child').remove();

    $(row).append($('<td>')
    .append($('<a href="#">')
      .attr('class', 'fa fa-pencil')
      .on("click", Edit))
      .append($(btn2))
    );
    

};

function addEditDeleteButtons(row) {
    return (row).append($('<td>')
        .append($('<a href="#">')
          .attr('class', 'fa fa-pencil')
          .on("click", Edit))
        .append($('<a href="#">')
          .attr('class', 'fa fa-trash')
          .attr('id', 'deleteRecord')
          .on("click", Remove))
      );

};

function addSaveDeleteButtons(row) {
    return (row).append($('<td>')
        .append($('<a href="#">')
          .attr('class', 'fa fa-save')
          .on("click", Save))
        .append($('<a href="#">')
          .attr('class', 'fa fa-trash')
          .on("click", Remove))
      );     
};

function addImagesToTableRows(table) {
    $('#' + table).find('tr').next().each(function(){
       addEditDeleteButtons($(this));

       $(this).find('td').each(function(){
         $(this).find('input').each(function(){
           $(this).prop('disabled', true);
         });

         $(this).find('select').each(function(){
           $(this).prop('disabled', true);
         });

         $(this).find('textarea').each(function(){
          $(this).prop('disabled', true);
        });
         
       });
      });
};


function calcEndDate() {

  // var dateMin;
  // if($("#StartDate").val() == '') {
  //   //alert("no date selected");
  //   dateMin= new Date();
  //   //alert(dateMin);
  // } else {
  //   dateMin = $('#StartDate').datepicker("getDate");
  // }

   var dateMin = $('#StartDate').datepicker("getDate");
   var Months = $('#LengthOfProjectMonths').val() || 0;
   var Years = $('#LengthOfProjectYears').val() || 0;
   var finalMonths =   parseInt(Years)*12 + parseInt(Months);
   var rMax = moment(new Date(dateMin.getFullYear(), dateMin.getMonth(),dateMin.getDate()-1)); ; 
   rMax.add(finalMonths, 'months');
   var tD = moment(new Date(rMax)).format('ll');
   $("#EndDate").datepicker({
        dateFormat: 'M d, yy',
        defaultDate: tD
    });
};

function changeEndDate() {

    var dateMin = $('#StartDate').datepicker("getDate");
    var Months = $('#LengthOfProjectMonths').val() || 0;
    var Years = $('#LengthOfProjectYears').val() || 0;
    var finalMonths =   parseInt(Years)*12 + parseInt(Months);
    var rMax = moment(new Date(dateMin.getFullYear(), dateMin.getMonth(),dateMin.getDate()-1)); ; 
    rMax.add(finalMonths, 'months');
    var tD = moment(new Date(rMax)).format('ll');
    $("#EndDate").datepicker("setDate", tD);
};

function addTableRow(table) {
    var trlength= $('#'+table).find('tbody tr').length ;
    trlength = trlength - 1;
    var $tr = $('#'+table).find('tbody tr:first').clone();
    ($tr) = addSaveDeleteButtons($tr);
    ($tr).attr('id', '-1');  // new records !!!

    ($tr).show();
    $('#'+table+' tbody').append($tr);
    
    return true;
};


function addSubProject(projectID){
    console.log('projectID: ' + projectID);


    swal({ title: "You clicked on Add Sub-Project button",   
          text: "All changes on the current page will be saved!",   
          type: "warning",   
          showCancelButton: true,   
          confirmButtonColor: "#DD6B55",   
          confirmButtonText: "Go to Add Sub-Project page.",   
          closeOnConfirm: false }, 
          function(){   

               var str = '/projects/addSubProject/' + projectID;
               $('#redirectToSubProjectPage').val(str);
               $('#edit_project').submit(); 
    });

}



function Send(table) {
    var Partners = [];
    var id, amount, selectedPartnerId;
    $('#' + table + ' tbody').find('tr').next().each(function(){
      id = $(this).attr('id');
      //console.log("id: " + $(this).attr('id') );
      $(this).find('td').each(function(){
        if ($(this).find('select,input').length) {
          $(this).find('input').each(function(){
            //console.log("Input value: " + $(this).val());
            amount = $(this).val();
          });

          $(this).find('select').each(function(){
            //console.log("Selected: " + $(this).val());
            selectedPartnerId = $(this).val();
          });
        }
      });
      var Partner = {id: id, selectedPartnerId: selectedPartnerId, amount: amount};
      Partners.push(Partner);
    });

    console.log('call getPartners: ' + JSON.stringify(Partners));
};

function getPartners(table) {
    var Partners = [];
    $('#' + table + ' tbody').find('tr').next().each(function(){
      var amount, selectedPartnerId;
      $(this).find('td').each(function(){
        if ($(this).find('select,input').length) {
          $(this).find('input').each(function(){
            amount = $(this).val();
          });

          $(this).find('select').each(function(){
            selectedPartnerId = $(this).val();
          });
        }
      });
      Partners.push({selectedPartnerId: selectedPartnerId, amount: amount});
    });
    return Partners;
};

function getCofunders(table) {
    var Cofunders = [];
    $('#' + table + ' tbody').find('tr').next().each(function(){
      var amount, selectedPartnerId;
      $(this).find('td').each(function(){
        if ($(this).find('select,input').length) {
          $(this).find('input').each(function(){
            amount = $(this).val();
          });

          $(this).find('select').each(function(){
            selectedPartnerId = $(this).val();
          });
        }
      });
      Cofunders.push({selectedPartnerId: selectedPartnerId, amount: amount});
    });
    return Cofunders;
};

function getEditedProjectCofunders(table) {
    var ProjectCoFunders = [];
    $('#' + table + ' tbody').find('tr').next().each(function(){
        var id, amount, selectedId, managed;
        id = $(this).attr('id');

        $(this).find('td').each(function(){
              $(this).find('input[name=budgetamount]').each(function(){
                amount = $(this).val();
              });
              $(this).find('select[name=cofunders]').each(function(){
                selectedId = $(this).val();
              });
              $(this).find('select[name=managed]').each(function(){
                managed = $(this).val();
              });
        });

        var Cofunder = {id: id, selectedId: selectedId, managed: managed, amount: amount};
        ProjectCoFunders.push(Cofunder);
    });

    console.log("ProjectCoFunders: " + JSON.stringify(ProjectCoFunders));
    return ProjectCoFunders;
};


function getEditedSubProjectBudgetTable(table) {
    var list = [];
    $('#' + table + ' tbody').find('tr').next().each(function(){
        
        var obj = getSubProjectBudgetTableRow(this);
        list.push(obj);
    });

    console.log("SubProjectBudget: " + JSON.stringify(list));
    return list;
};


function getSubProjectCoFunderTotal(){
   var $rows = $('#subProjectCoFundersTable tbody tr');
   var Total=0;
   var TotalManaged=0;
   var t1 = [];
   var tManaged = [];
   var Amt;
   var AmtManaged;
   
   $rows.each(function(){
        $(this).find('td').each(function(){
            $(this).find('input[name=yearTotalAmt]').each(function(){
              Amt = $(this).val() || 0;
              t1.push(Amt);  
            }); 
        });
    });

	$rows.each(function(){
        $(this).find('td').each(function(){
            $(this).find('select[name=managed]').each(function(){
				if ($(this).val() == 'Yes') {
					$(this).parent().parent().find('input[name=yearTotalAmt]').each(function(){
						AmtManaged = $(this).val() || 0;
						tManaged.push(AmtManaged);  			
					});
				}
            }); 
        });
    });
	
   t1.map(function(item) {Total+=parseFloat(item)});
   tManaged.map(function(item) {TotalManaged+=parseFloat(item)});
   var $footRrow = $('#subProjectCoFundersTable tfoot tr');
   $('#TotalAmountAwarded').val(accounting.formatMoney(Total));   
   $('#TFRIAmount').val(accounting.formatMoney(TotalManaged));   
   
   console.log('TotalManaged =' + TotalManaged);
   
   $footRrow.each(function(){
	 $(this).find('td').each(function(){
		  $(this).find('input[name=Total]').each(function(){ $(this).val(accounting.formatMoney(Total)); });
		  $(this).find('input').each(function(){ $(this).prop('disabled', true); });
	 });
   });

   $rows.each(function(){
         $(this).find('td').each(function(){
              $(this).find('input[class=numbersOnly]').each(function(){ 
			  console.log('accounting here!!!');
				$(this).val(accounting.formatMoney($(this).val())); 
			  });
         });
   });


};

function getCoFunderTotal(){
   var $rows = $('#projectCoFundersTable tbody tr');
   var Total=0;
   var t1 = [];
   var Amt;

   $rows.each(function(){
        $(this).find('td').each(function(){
            $(this).find('input[name=budgetamount]').each(function(){
              Amt = $(this).val() || 0;
              t1.push(Amt);  
            }); 
        });
    });

   t1.map(function(item) {Total+=parseFloat(item)});
   var $footRrow = $('#projectCoFundersTable tfoot tr');
   
   $footRrow.each(function(){
         $(this).find('td').each(function(){
              $(this).find('input[name=Total]').each(function(){ $(this).val(accounting.formatMoney(Total)); });
              $(this).find('input').each(function(){ $(this).prop('disabled', true); });
              //$(this).find('input').each(function(){ $(this).prop('readonly', true); });
         });
   });
   
   $rows.each(function(){
         $(this).find('td').each(function(){
              $(this).find('input[class=numbersOnly]').each(function(){ 
				$(this).val(accounting.formatMoney($(this).val())); 
				$(this).prop('disabled', true);
			  });
         });
   });

   $('#TotalAmountAwarded').val(accounting.formatMoney($('#TotalAmountAwarded').val()));   
   $('#TFRIAmount').val(accounting.formatMoney($('#TFRIAmount').val()));   

   
 };


function getSubProjectBudgetTotal(){
   var $rows = $('#subProjectsTable tbody tr').next();
   var Total=0;
   var t1 = [];
   var Amt;

   $rows.each(function(){
	  $(this).find('td').each(function(){
			$(this).find('input[name=budgetamount]').each(function(){
			  Amt = $(this).val() || 0;
			  t1.push(Amt);  
			}); 
	  });
    });

   //t1.map(function(item) {Total+=parseFloat(item)});
   t1.map(function(item) {Total+=accounting.unformat(item)});
      
   var $footRrow = $('#subProjectsTable tfoot tr');
   
   $footRrow.each(function(){
         $(this).find('td').each(function(){
              //$(this).find('input[name=Total]').each(function(){ $(this).val(Total.toFixed(2)); });
              $(this).find('input[name=Total]').each(function(){ $(this).val(accounting.formatMoney(Total)); });
         });
   });

   
   $rows.each(function(){
         $(this).find('td').each(function(){
              $(this).find('input[class=numbersOnly]').each(function(){ 
				$(this).val(accounting.formatMoney($(this).val())); 
			  });
         });
   });
};





function getBudgetTotal(){
   var $rows = $('#subProjectBudgetTable tbody tr').next();
   var year1Total=0,year2Total=0,year3Total=0,year4Total=0,year5Total=0,GrandTotal=0,Year1Amt,Year2Amt,Year3Amt,Year4Amt,Year5Amt, Total;
    
   var t1 = [];
   var t2 = [];
   var t3 = [];
   var t4 = [];
   var t5 = [];

   var tManaged = [];
   var Amt,TotalManaged=0; 
 
 
   $rows.each(function(){
          $(this).find('td').each(function(){
                $(this).find('input[name=year1Amt]').each(function(){
                  Year1Amt = $(this).val() || 0;
                  t1.push(Year1Amt);  
                });
                $(this).find('input[name=year2Amt]').each(function(){
                  Year2Amt = $(this).val() || 0;
                  t2.push(Year2Amt);  
                });
                $(this).find('input[name=year3Amt]').each(function(){
                  Year3Amt = $(this).val() || 0;
                  t3.push(Year3Amt);  
                });
                $(this).find('input[name=year4Amt]').each(function(){
                  Year4Amt = $(this).val() || 0;
                  t4.push(Year4Amt);  
                });
                $(this).find('input[name=year5Amt]').each(function(){
                  Year5Amt = $(this).val() || 0;
                  t5.push(Year5Amt);  
                });
				Total = accounting.unformat(Year1Amt)+accounting.unformat(Year2Amt)+accounting.unformat(Year3Amt)+accounting.unformat(Year4Amt)+accounting.unformat(Year5Amt);
                $(this).find('input[name=yearTotalAmt]').each(function(){ $(this).val(accounting.formatMoney(Total)); });
            }); 
    });

	
   $rows.each(function(){
	  $(this).find('td').each(function(){
			 $(this).find('select[name=managed]').each(function(){ 
				 if ($(this).val() == 'Yes') {
						$(this).parent().parent().find('input[name=year1Amt]').each(function(){
						  tManaged.push($(this).val() || 0);  
						});
						$(this).parent().parent().find('input[name=year2Amt]').each(function(){
						  tManaged.push($(this).val() || 0);  
						});
						$(this).parent().parent().find('input[name=year3Amt]').each(function(){
						  tManaged.push($(this).val() || 0);  
						});
						$(this).parent().parent().find('input[name=year4Amt]').each(function(){
						  tManaged.push($(this).val() || 0);  
						});
						$(this).parent().parent().find('input[name=year5Amt]').each(function(){
						  tManaged.push($(this).val() || 0);  
						});
				 };
			 });	
		}); 
	});
	
   /*
   t1.map(function(item) {year1Total+=parseFloat(item)});
   t2.map(function(item) {year2Total+=parseFloat(item)});
   t3.map(function(item) {year3Total+=parseFloat(item)});
   t4.map(function(item) {year4Total+=parseFloat(item)});
   t5.map(function(item) {year5Total+=parseFloat(item)});
   */
   
   t1.map(function(item) {year1Total+=accounting.unformat(item)});
   t2.map(function(item) {year2Total+=accounting.unformat(item)});
   t3.map(function(item) {year3Total+=accounting.unformat(item)});
   t4.map(function(item) {year4Total+=accounting.unformat(item)});
   t5.map(function(item) {year5Total+=accounting.unformat(item)});
   
   //GrandTotal = parseFloat(year1Total)+parseFloat(year2Total)+parseFloat(year3Total)+parseFloat(year4Total)+parseFloat(year5Total);
   GrandTotal = accounting.unformat(year1Total)+accounting.unformat(year2Total)+accounting.unformat(year3Total)+accounting.unformat(year4Total)+accounting.unformat(year5Total);

   var $footRrow = $('#subProjectBudgetTable tfoot tr');
   
   $footRrow.each(function(){
         $(this).find('td').each(function(){
              $(this).find('input[name=year1Total]').each(function(){ $(this).val(accounting.formatMoney(year1Total)); });
              $(this).find('input[name=year2Total]').each(function(){ $(this).val(accounting.formatMoney(year2Total)); });
              $(this).find('input[name=year3Total]').each(function(){ $(this).val(accounting.formatMoney(year3Total)); });
              $(this).find('input[name=year4Total]').each(function(){ $(this).val(accounting.formatMoney(year4Total)); });
              $(this).find('input[name=year5Total]').each(function(){ $(this).val(accounting.formatMoney(year5Total)); });
              $(this).find('input[name=yearsTotal]').each(function(){ $(this).val(accounting.formatMoney(GrandTotal)); });
              $(this).find('input').each(function(){ $(this).prop('disabled', true); });
         });
   });

   //tManaged.map(function(item) {TotalManaged+=parseFloat(item)});
   tManaged.map(function(item) {TotalManaged+=accounting.unformat(item)});
  
   
   $('#TotalAmountAwarded').val(accounting.formatMoney(GrandTotal));   
   $('#TFRIAmount').val(accounting.formatMoney(TotalManaged));   

};

function SaveSubProjectCoFundersTable(){
    localStorage.removeItem("editedSubProjectCoFunders");
    var $rows = $('#subProjectCoFundersTable tbody tr').next();
    var editedSubProjectCoFunders = [];     
     $rows.each(function(){
        var obj = getSubProjectCoFundersTableRow($(this));
        editedSubProjectCoFunders.push(obj);
    });
    localStorage["editedSubProjectCoFunders"] = JSON.stringify(editedSubProjectCoFunders);
    console.log('### ' + JSON.stringify(editedSubProjectCoFunders)); 
};

function getSubProjectCoFundersTableRow(row){
    var id, amount, selectedId, managed;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
          $(this).find('input[name=budgetamount]').each(function(){ amount = $(this).val(); });
          $(this).find('select[name=subProjectCoFunders]').each(function(){   selectedId = $(this).val(); });
          $(this).find('select[name=managed]').each(function(){     managed = $(this).val(); });
    });
    var obj = {id: id, selectedId: selectedId, managed: managed, amount: amount};
    return obj;
}

function SaveSubProjectBudgetTable(){
    localStorage.removeItem("editedSubProjectBudget");
    var $rows = $('#subProjectBudgetTable tbody tr').next();
     $rows.each(function(){
        var obj = getSubProjectBudgetTableRow($(this));
        var editedSubProjectBudget = [];
        if (localStorage.getItem("editedSubProjectBudget") != null) {
          editedSubProjectBudget = JSON.parse(localStorage["editedSubProjectBudget"]);
        }
        editedSubProjectBudget.push(obj);
        localStorage["editedSubProjectBudget"] = JSON.stringify(editedSubProjectBudget);
    });
};

function TransformSubProjectBudgetToCoFunders(){
    var $rows = $('#subProjectBudgetTable tbody tr').next();
	var coFunders = [];
     $rows.each(function(){
        var obj = getSubProjectBudgetTableRow($(this));
		if (obj['selectedCoFunderId'] != "0") {
			var Total = accounting.unformat(obj['Year1Amt'] || 0) + accounting.unformat(obj['Year2Amt'] || 0) + accounting.unformat(obj['Year3Amt'] || 0) + accounting.unformat(obj['Year4Amt'] || 0) + accounting.unformat(obj['Year5Amt'] || 0);
			var newCF = {id: obj['selectedCoFunderId'],coFunderName: obj['coFunderName'], managed: obj['managed'], amt: Total};
			
			for(var obj in coFunders) {
                  if(coFunders[obj].hasOwnProperty('id')) {
                        if((coFunders[obj]['id'] == newCF['id']) && (coFunders[obj]['managed'] == newCF['managed'])) {
							coFunders[obj]['amt'] = accounting.unformat(coFunders[obj]['amt']) + accounting.unformat(newCF['amt']);
							newCF = null;
							break;
						}
				  }
			}
			if( newCF != null) { coFunders.push(newCF);	}
		}
    });
	console.log('coFunders== ' + JSON.stringify(coFunders));
	

	var trHTML = '';
	for(var obj in coFunders) {
		trHTML += '<tr><td><input type="text" style="width:100%;" disabled name="coFunderName" value="' + coFunders[obj]['coFunderName'] + '"</td><td>' + 
		coFunders[obj]['managed'] + '</td><td><input type="text" style="width:100%;" disabled name="yearTotalAmt" class="numbersOnly" value="' + coFunders[obj]['amt'] + '"</td></tr>';
	}
	 $('#subProjectCoFundersTable tbody').empty().append(trHTML);  
	 getSubProjectCoFunderTotal(); 
	 getBudgetTotal();
};


function getSubProjectBudgetTableRow(row){
    var id, Year1Amt,Year2Amt,Year3Amt,Year4Amt,Year5Amt, selectedInvestigatorId, selectedPIInstitutionId,selectedCoFunderId, managed, selectedFO;
	var CoFunderName = '';
    id = $(row).attr('id');
    $(row).find('td').each(function(){
          $(this).find('input[name=year1Amt]').each(function(){ Year1Amt = $(this).val(); });
          $(this).find('input[name=year2Amt]').each(function(){ Year2Amt = $(this).val(); });
          $(this).find('input[name=year3Amt]').each(function(){ Year3Amt = $(this).val(); });
          $(this).find('input[name=year4Amt]').each(function(){ Year4Amt = $(this).val(); });
          $(this).find('input[name=year5Amt]').each(function(){ Year5Amt = $(this).val(); });

          $(this).find('select[name=investigators]').each(function(){ selectedInvestigatorId = $(this).val(); });
          $(this).find('select[name=piInstitutions]').each(function(){ selectedPIInstitutionId = $(this).val() || 0; });
          $(this).find('select[name=finOfficer]').each(function(){ selectedFO = $(this).val(); });
          $(this).find('select[name=cofunders]').each(function(){ 
				selectedCoFunderId = $(this).val() || 0; 
				if ($(this).find("option:selected") != null) {
					CoFunderName = $(this).find("option:selected").text().replace(/(\r\n|\n|\r)/gm,"").trim(); 
				}
			});
		  $(this).find('select[name=managed]').each(function(){ managed = $(this).val(); });

    });
    var obj = {id: id, Year1Amt: Year1Amt,Year2Amt: Year2Amt,Year3Amt: Year3Amt,Year4Amt: Year4Amt,Year5Amt: Year5Amt, 
                       selectedInvestigatorId: selectedInvestigatorId, 
                       selectedPIInstitutionId: selectedPIInstitutionId,
                       selectedCoFunderId: selectedCoFunderId,
					   managed: managed, selectedFO: selectedFO,
					   coFunderName: CoFunderName};

    return obj;
}



function warnBeforeRedirect(linkURL) {
   swal({
        title: "Are you sure you want to leave the current page?",
         text: "If you click 'OK', you will be redirected to " + linkURL, 
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        closeOnConfirm: false,
        closeOnCancel: true 
    },
    function() {  window.location.href = linkURL;  }
   );
  } 



function Edit(e){
	e.preventDefault();
    var row = $(this).parent().parent();
    var table = $(row).parent().parent().attr('id');
	
	if (table=="projectLeadersTable") {
		var id,selectedInstitutionId;
		$(row).find('td').each(function(){
			$(this).find('select[name=projectLeaders]').each(function(){ 
			  id = $(this).val();
			});
		});
		$(row).find('td').each(function(){
			$(this).find('select[name=projectLeaderInstitution]').each(function(){ 
			  selectedInstitutionId = $(this).val();
			});
		});
	
		$.get( '/institutionByContact/' + id, function(data) {
		    var options = '';
			for(var obj in data) {
				if (data[obj].hasOwnProperty('InstitutionID')) {
					var id = data[obj]['InstitutionID'];
					var name = data[obj]['InstitutionName'];
					options += '<option value="' + id + '">' + name + 
					'</option>';		
				}
			}
			$(row).find('td').each(function(){
				$(this).find('select[name=projectLeaderInstitution]').each(function(){ 
				  $(this).html(options);
				   $(this).val(selectedInstitutionId);
				});
			});
		});
	}



	if (table=="subProjectBudgetTable") {
		var id,selectedInstitutionId;
		$(row).find('td').each(function(){
			$(this).find('select[name=investigators]').each(function(){ 
			  id = $(this).val();
			});
		});
		$(row).find('td').each(function(){
			$(this).find('select[name=piInstitutions]').each(function(){ 
			  selectedInstitutionId = $(this).val();
			});
		});
	
		$.get( '/institutionByContact/' + id, function(data) {
		    var options = '';
			for(var obj in data) {
				if (data[obj].hasOwnProperty('InstitutionID')) {
					var id = data[obj]['InstitutionID'];
					var name = data[obj]['InstitutionName'];
					options += '<option value="' + id + '">' + name + 
					'</option>';		
				}
			}
			$(row).find('td').each(function(){
				$(this).find('select[name=piInstitutions]').each(function(){ 
				  $(this).html(options);
				   $(this).val(selectedInstitutionId);
				});
			});
		});
	}

	
    if (table=="XXXsubProjectsTable") {
        var subProjectID = $(row).attr('id');
        swal({ title: "You clicked on Edit Sub-Project button",   
              text: "All changes on the current page will be saved!",   
              type: "warning",   
              showCancelButton: true,   
              confirmButtonColor: "#DD6B55",   
              confirmButtonText: "Go to Edit Sub-Project page.",   
              closeOnConfirm: false }, 
              function(){   
                 var str = '/projects/editsubproject/' + subProjectID;
                $('#redirectToSubProjectPage').val(str);
                $('#edit_project').submit(); 
        });


    } else {
        $(row).find('td').each(function(){

          if ($(this).find('select').length) {
            $(this).find('select').each(function(){
              $(this).prop('disabled', false);
            });
          }
          else {
            $(this).find("input:not([name=yearTotalAmt])").each(function(){
              $(this).prop('disabled', false);
            });
          }
          if ($(this).find('textarea').length) {
            $(this).find('textarea').each(function(){
              $(this).prop('disabled', false);
            });
          }
        });


        var btn1 = $(row).find('td:last-child').children('a:first')
        var btn2 = $(row).find('td:last-child').children('a').eq(1).clone(true);
        $(row).find('td:last-child').remove();

        $(row).append($('<td>')
          .append($('<a href="#">')
          .attr('class', 'fa fa-save')
          .on("click", Save))
          .append($(btn2))
        );


        //****************************** */
        // $(row).find('td:last-child').remove();
        // row = addSaveDeleteButtons(row);
        //****************************** */

    }
};


// ------------------------------------------------  SAVE methods -----------------------------



function Save(e){
	e.preventDefault();
    var row = $(this).parent().parent();
    var table = $(row).parent().parent().attr('id');
    console.log("Table==" + table);
    if (table == "partnersTable") {
      SavePartnersTable(row);
    }
    if (table == "projectItemsTable") {
      SaveProjectItemTable(row);
    }
    if (table == "cofundersTable") {
      SaveCofundersTable(row);
    }
    if (table == "institutionTable") {
      SaveContactInstitutionTable(row);
    }
    if (table == "projectCoFundersTable") {
      SaveProjectCoFundersTable(row);
    }
    if (table == "projectLeadersTable") {
      var objMetaData = {selectorName: 'select[name=projectLeaders]', editedListName: 'editedProjectLeaders'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "projectManagersTable") {
      var objMetaData = {selectorName: 'select[name=projectManagers]', editedListName: 'editedProjectManagers'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "projectMentorsTable") {
      var objMetaData = {selectorName: 'select[name=projectMentors]', editedListName: 'editedProjectMentors'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "subProjectBudgetTable") {
      SaveSubProjectBudgetTableRow(row);
	  TransformSubProjectBudgetToCoFunders();  //TEST
    }

    if (table == "principalInvestigatorsTable") {
      var objMetaData = {selectorName: 'select[name=principalInvestigators]', editedListName: 'editedPrincipalInvestigators'};
      SaveGeneralContactTable(row, objMetaData);
    }

    if (table == "subProjectManagersTable") {
      var objMetaData = {selectorName: 'select[name=subProjectManagers]', editedListName: 'editedSubProjectManagers'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "coInvestigatorsTable") {
      var objMetaData = {selectorName: 'select[name=coInvestigators]', editedListName: 'editedCoInvestigators'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "finRepsTable") {
      var objMetaData = {selectorName: 'select[name=finReps]', editedListName: 'editedFinReps'};
      SaveGeneralContactTable(row, objMetaData);
    }

    if (table == "finOfficersTable") {
      var objMetaData = {selectorName: 'select[name=finOfficers]', editedListName: 'editedFinOfficers'};
      SaveGeneralContactTable(row, objMetaData);
    }

    if (table == "collaboratorsTable") {
      var objMetaData = {selectorName: 'select[name=collaborators]', editedListName: 'editedCollaborators'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "adminAssistantsTable") {
      var objMetaData = {selectorName: 'select[name=adminAssistants]', editedListName: 'editedAdminAssistants'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "institutionCommRepTable") {
      var objMetaData = {selectorName: 'select[name=institutionCommReps]', editedListName: 'editedInstitutionCommReps'};
      SaveGeneralContactTable(row, objMetaData);
    }

    if (table == "groupContactsTable") {
      var objMetaData = {selectorName: 'select[name=groupContacts]', editedListName: 'editedGroupContacts'};
      SaveGeneralContactTable(row, objMetaData);
    }

  	if (table == "contactGroupsTable") {
      var objMetaData = {selectorName: 'select[name=contactGroups]', editedListName: 'editedContactGroups'};
      SaveGeneralContactTable(row, objMetaData);
    }
	
    if (table == "groupProjectsTable") {
      var objMetaData = {selectorName: 'select[name=groupProjects]', editedListName: 'editedGroupProjects'};
      SaveGeneralContactTable(row, objMetaData);
    }
    if (table == "subProjectCoFundersTable") { SaveSubProjectCoFundersTableRow(row); }
	
    if (table == "contactPhoneTable") { SaveContactPhoneEmailTableRow(row,'input[name=Phone]','editedContactPhones'); }
    if (table == "contactEmailTable") { SaveContactPhoneEmailTableRow(row,'input[name=Email]','editedContactEmails'); }
    
    if (table == "sacMembersTable") { 
      var objMetaData = {selectorName: 'select[name=projectSACMembers]', editedListName: 'editedProjectSACMembers'};
          SaveGeneralContactTable(row, objMetaData);
    }
    
    if (table == "projectCollaboratorsTable") { 
      var objMetaData = {selectorName: 'select[name=projectCollaborators]', editedListName: 'editedProjectCollaborators'};
          SaveGeneralContactTable(row, objMetaData);
    }
    
    if (table == "projectDiaryTable") { SaveProjectDiaryTableRow(row,'input[name=ProjectDiaryDate]','textarea[name=ProjectDiaryEntry]','editedProjectDiary'); }

    if (table == "otherPersonnelTable") {
      console.log('SaveOtherPersonnelTableRow ... ');
      SaveOtherPersonnelTableRow(row);
    }

    if (table == "groupOwnersTable") {
      var objMetaData = {selectorName: 'select[name=groupOwner]', editedListName: 'editedGroupOwners'};
      SaveGroupOwnerTableRow(row, objMetaData);
    }

};


function SaveGroupOwnerTableRow(row, objMetaData){
  var selectorName = objMetaData.selectorName.toString();  
  var editedListName = objMetaData.editedListName.toString(); 

  var table = $(row).parent().parent().attr('id');
  var id, selectedId;
  id = $(row).attr('id');
  $(row).find('td').each(function(){
       
        $(this).find(selectorName).each(function(){
          selectedId = $(this).val();
        });
  });

  var owner = {id: id, selectedId: selectedId};
  var list = [];

  if (localStorage.getItem(editedListName) != null) {
    list = JSON.parse(localStorage[editedListName]);
  }

  list.push(owner);
  localStorage[editedListName] = JSON.stringify(list);
  console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));

  $(row).find('td').each(function(){
    $(this).find('input').each(function(){
      $(this).prop('disabled', true);
    });

    $(this).find('select').each(function(){
      $(this).prop('disabled', true);
    });
  });

  $(row).find('td:last-child').remove();
  row = addEditDeleteButtons(row);
};



function SaveGroupOwnersTable(objMetaData){
  var selectorName = objMetaData.selectorName.toString();  
  var editedListName = objMetaData.editedListName.toString(); 
  var table = objMetaData.table.toString();
  var list = [];

  localStorage.removeItem(editedListName);

  $('#' + table + ' tbody').find('tr').next().each(function(){

    var id, selectedId;
    id = $(this).attr('id');
    $(this).find('td').each(function(){
         
          $(this).find(selectorName).each(function(){
            selectedId = $(this).val();
          });
    });

    var myObj = {id: id, selectedId: selectedId};
    list.push(myObj);
    
    $(this).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(this).find('td:last-child').remove();
 }); 
 localStorage[editedListName] = JSON.stringify(list);
 console.log("SaveGroupOwnersTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};




function SaveOtherPersonnelTableRow(row){
  var table = $(row).parent().parent().attr('id');
  console.log("Saved id: " + $(row).attr('id') );

  var id, selectedId, role;
  id = $(row).attr('id');
  $(row).find('td').each(function(){
    if ($(this).find('select,input').length) {
      $(this).find('select').each(function(){
        selectedId = $(this).val();
      });

      $(this).find('input[name=Role]').each(function(){
        role = $(this).val();
      });


    }
  });
  var personnel = {id: id, selectedId: selectedId, role: role};
  var editedOtherPersonnel = [];

  if (localStorage.getItem("editedOtherPersonnel") != null) {
    editedOtherPersonnel = JSON.parse(localStorage["editedOtherPersonnel"]);
  }

  editedOtherPersonnel.push(personnel);
  localStorage["editedOtherPersonnel"] = JSON.stringify(editedOtherPersonnel);
  console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedOtherPersonnel"])));

  $(row).find('td').each(function(){
    $(this).find('input').each(function(){
      $(this).prop('disabled', true);
    });

    $(this).find('select').each(function(){
      $(this).prop('disabled', true);
    });
  });

  $(row).find('td:last-child').remove();
  row = addEditDeleteButtons(row);
};

function SaveOtherPersonnelTable(objMetaData){
  var selectorName = objMetaData.selectorName.toString();  
  var editedListName = objMetaData.editedListName.toString(); 
  var table = objMetaData.table.toString();
  var list = [];

  localStorage.removeItem(editedListName);

  $('#' + table + ' tbody').find('tr').next().each(function(){

    var id, selectedId, role;
    id = $(this).attr('id');
    $(this).find('td').each(function(){
  $(this).find(selectorName).each(function(){
    selectedId = $(this).val();
  });
    });

 $(this).find('input[name=Role]').each(function(){ role = $(this).val(); });
  
    var myObj = {id: id, selectedId: selectedId, role: role};
    list.push(myObj);
    
    $(this).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(this).find('td:last-child').remove();
 }); 
 localStorage[editedListName] = JSON.stringify(list);
 console.log("SaveOtherPersonnelTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};

function SaveInstitutionTable(objMetaData){
    var selectorName = objMetaData.selectorName.toString();  
    var editedListName = objMetaData.editedListName.toString(); 
    //var checkBoxName= objMetaData.checkBoxName.toString();  
    var table = objMetaData.table.toString();
    var list = [];

    localStorage.removeItem(editedListName);

    $('#' + table + ' tbody').find('tr').next().each(function(){

      var id, selectedId, role, primary;
      id = $(this).attr('id');
      $(this).find('td').each(function(){
          $(this).find(selectorName).each(function(){
            selectedId = $(this).val();
          });

      });

	    $(this).find('input[name=Role]').each(function(){ role = $(this).val(); });
      $(this).find('input[name=Primary]').each(function(){if ($(this).is(":checked")) { primary=true; } else {primary=false;} });

      var myObj = {id: id, selectedId: selectedId, role: role, primary: primary};
      list.push(myObj);
      
      $(this).find('td').each(function(){
        $(this).find('input').each(function(){
          $(this).prop('disabled', true);
        });

        $(this).find('select').each(function(){
          $(this).prop('disabled', true);
        });
      });

      $(this).find('td:last-child').remove();
   }); 
   localStorage[editedListName] = JSON.stringify(list);
   console.log("SaveInstitutionTable XX**** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};


function SaveGeneralTable(objMetaData){
    var selectorName = objMetaData.selectorName.toString();  
    var editedListName = objMetaData.editedListName.toString(); 
    var table = objMetaData.table.toString();
    var list = [];

    localStorage.removeItem(editedListName);

    $('#' + table + ' tbody').find('tr').next().each(function(){

      var id, selectedId;
      id = $(this).attr('id');
      $(this).find('td').each(function(){
           
            $(this).find(selectorName).each(function(){
              selectedId = $(this).val();
            });
      });

      var myObj = {id: id, selectedId: selectedId};
      list.push(myObj);
      
      $(this).find('td').each(function(){
        $(this).find('input').each(function(){
          $(this).prop('disabled', true);
        });

        $(this).find('select').each(function(){
          $(this).prop('disabled', true);
        });
      });

      $(this).find('td:last-child').remove();
   }); 
   localStorage[editedListName] = JSON.stringify(list);
   console.log("SaveGeneralTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};

function SaveProjectDiaryTableRow(row,inputName,inputName2,editedNameList){
  var table = $(row).parent().parent().attr('id');

  var id, value, value2;
  id = $(row).attr('id');
  $(row).find('td').each(function(){
        $(this).find(inputName).each(function(){ value = $(this).val(); });
        $(this).find(inputName2).each(function(){ value2 = $(this).val(); });
  });

  var obj = {id: id, ProjectDiaryDate: value, ProjectDiaryEntry: value2};
  var list = [];
  if (localStorage.getItem(editedNameList) != null) {
    list = JSON.parse(localStorage[editedNameList]);
  }
  list.push(obj);
  localStorage[editedNameList] = JSON.stringify(list);
  console.log("SaveProjectDiaryTableRow : Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedNameList])));
  $(row).find('td').each(function(){
    $(this).find('input').each(function(){
      $(this).prop('disabled', true);
    });
    $(this).find('textarea').each(function(){
      $(this).prop('disabled', true);
    });
  });
  $(row).find('td:last-child').remove();
  row = addEditDeleteButtons(row);
};

function SaveProjectDiaryTable(objMetaData){
  var inputName = 'input[name=ProjectDiaryDate]';  //'input[name=ProjectDiaryDate]','textarea[name=ProjectDiaryEntry]'
  var inputName2 = 'textarea[name=ProjectDiaryEntry]'; 
  var editedListName = objMetaData.editedListName.toString(); 
  var table = objMetaData.table.toString();
  var list = [];
  localStorage.removeItem(editedListName);

  $('#' + table + ' tbody').find('tr').next().each(function(){
    var id, value,value2;
    id = $(this).attr('id');
    $(this).find('td').each(function(){        
          $(this).find(inputName).each(function(){ value = $(this).val(); });
          $(this).find(inputName2).each(function(){ value2 = $(this).val(); });
    });

    var myObj = {id: id, ProjectDiaryDate: value, ProjectDiaryEntry: value2};
    list.push(myObj);
    
    $(this).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(this).find('td:last-child').remove();
 }); 
 localStorage[editedListName] = JSON.stringify(list);
 console.log("SaveProjectDiaryTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};

function SavePhoneEmailTable(objMetaData){
    var inputName = objMetaData.inputName.toString();  
    var checkBoxName= objMetaData.checkBoxName.toString();  
    var editedListName = objMetaData.editedListName.toString(); 
    var table = objMetaData.table.toString();
    var list = [];
    localStorage.removeItem(editedListName);

    $('#' + table + ' tbody').find('tr').next().each(function(){

      var id, value, primary;
      id = $(this).attr('id');
      $(this).find('td').each(function(){          
            $(this).find(inputName).each(function(){
              value = $(this).val();
            });

            $(this).find(checkBoxName).each(function(){ 
              if ($(this).is(":checked")) { primary=true; } else {primary=false;}
             });
      });

      var myObj = {id: id, value: value, primary: primary};
      list.push(myObj);
      
      $(this).find('td').each(function(){
        $(this).find('input').each(function(){
          $(this).prop('disabled', true);
        });

        $(this).find('select').each(function(){
          $(this).prop('disabled', true);
        });
      });

      $(this).find('td:last-child').remove();
   }); 
   localStorage[editedListName] = JSON.stringify(list);
   console.log("SavePhoneEmailTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};


function SaveGeneralProjectCoFundersTable(objMetaData){
    var editedListName = objMetaData.editedListName.toString(); 
    var table = objMetaData.table.toString();
    var list = [];

   localStorage.removeItem(editedListName);

   $('#' + table + ' tbody').find('tr').next().each(function(){

      var id, amount, selectedId, managed;
      id = $(this).attr('id');
      $(this).find('td').each(function(){
            $(this).find('input[name=budgetamount]').each(function(){
              amount = $(this).val();
            });
            $(this).find('select[name=cofunders]').each(function(){
              selectedId = $(this).val();
            });
            $(this).find('select[name=managed]').each(function(){
              managed = $(this).val();
            });
      });

      var Cofunder = {id: id, selectedId: selectedId, managed: managed, amount: amount};
      list.push(Cofunder);

      $(this).find('td').each(function(){
        $(this).find('input').each(function(){
          $(this).prop('disabled', true);
        });

        $(this).find('select').each(function(){
          $(this).prop('disabled', true);
        });
      });

      $(this).find('td:last-child').remove();
    });
    localStorage[editedListName] = JSON.stringify(list);
    console.log("SaveGeneralProjectCoFundersTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};


function SaveProjectLeadersTable(objMetaData){
    var editedListName = objMetaData.editedListName.toString(); 
    var table = objMetaData.table.toString();
    var list = [];
    localStorage.removeItem(editedListName);
    $('#' + table + ' tbody').find('tr').next().each(function(){
      var id, selectedId, institutionId;
      id = $(this).attr('id');
      $(this).find('td').each(function(){
		$(this).find('select[name=projectLeaders]').each(function(){
		  selectedId = $(this).val();
		});
		$(this).find('select[name=projectLeaderInstitution]').each(function(){
		  institutionId = $(this).val();
		});
      });
      var obj = {id: id, selectedId: selectedId, institutionId: institutionId};
      list.push(obj);
      $(this).find('td').each(function(){
        $(this).find('input').each(function(){
          $(this).prop('disabled', true);
        });
        $(this).find('select').each(function(){
          $(this).prop('disabled', true);
        });
      });

      $(this).find('td:last-child').remove();
    });
    localStorage[editedListName] = JSON.stringify(list);
    console.log("SaveProjectLeadersTable **** Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedListName])));
};


function getEditedGeneralContacts(objMetaData) {
    var table = objMetaData.table.toString();  
    var selectorName = objMetaData.selectorName.toString();  
    var editedListName = objMetaData.editedListName.toString();
    
    var contactArray = [];
    
    $('#' + table + ' tbody').find('tr').next().each(function(){
        var id, selectedId;
        id = $(this).attr('id');
        $(this).find('td').each(function(){
              $(this).find(selectorName).each(function(){
                selectedId = $(this).val();
              });
        });

        var obj = {id: id, selectedId: selectedId};
        contactArray.push(obj);
    });

    console.log(editedListName + " : " + JSON.stringify(contactArray));
    return contactArray;
};


function SaveSubProjectBudgetTableRow(row){
    var table = $(row).parent().parent().attr('id');
    var obj = getSubProjectBudgetTableRow(row);
    
    var editedSubProjectBudget = [];
    if (localStorage.getItem("editedSubProjectBudget") != null) {
      editedSubProjectBudget = JSON.parse(localStorage["editedSubProjectBudget"]);
    }
    editedSubProjectBudget.push(obj);

    localStorage["editedSubProjectBudget"] = JSON.stringify(editedSubProjectBudget);
    console.log("Save editedSubProjectBudget : Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedSubProjectBudget"])));
    

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });
      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });
    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};


function SaveProjectCoFundersTable(row){
    var table = $(row).parent().parent().attr('id');

    var id, amount, selectedId, managed;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
          $(this).find('input[name=budgetamount]').each(function(){ amount = $(this).val(); });
          $(this).find('select[name=cofunders]').each(function(){   selectedId = $(this).val(); });
          $(this).find('select[name=managed]').each(function(){     managed = $(this).val(); });
    });
    var Cofunder = {id: id, selectedId: selectedId, managed: managed, amount: amount};
    var editedProjectCoFunders = [];
    if (localStorage.getItem("editedProjectCoFunders") != null) {
      editedProjectCoFunders = JSON.parse(localStorage["editedProjectCoFunders"]);
    }
    editedProjectCoFunders.push(Cofunder);
    localStorage["editedProjectCoFunders"] = JSON.stringify(editedProjectCoFunders);
    console.log("Save editedProjectCoFunders : Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedProjectCoFunders"])));
    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });
      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });
    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};

function SaveContactPhoneEmailTableRow(row,inputName,editedNameList){
    var table = $(row).parent().parent().attr('id');
    var checkBoxName = 'input[name=Primary]';
    var id, value, primary;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
          $(this).find(inputName).each(function(){ value = $(this).val(); });
          $(this).find(checkBoxName).each(function(){ 
            if ($(this).is(":checked")) { primary=true; } else {primary=false;}
          });

          // EP: add logic to clean primary field from the rest of the records!!!
    });
    var obj = {id: id, value: value, primary: primary};
    var list = [];
    if (localStorage.getItem(editedNameList) != null) {
      list = JSON.parse(localStorage[editedNameList]);
    }
    list.push(obj);
    localStorage[editedNameList] = JSON.stringify(list);
    console.log("SaveContactPhoneEmailTableRow : Edited ids: " + JSON.stringify(JSON.parse(localStorage[editedNameList])));
    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });
    });

    //************************************* */
    // $(row).find('td:last-child').remove();
    // row = addEditDeleteButtons(row);
    //************************************* */


    var btn1 = $(row).find('td:last-child').children('a:first')
    var btn2 = $(row).find('td:last-child').children('a').eq(1).clone(true);
    $(row).find('td:last-child').remove();

    $(row).append($('<td>')
    .append($('<a href="#">')
      .attr('class', 'fa fa-pencil')
      .on("click", Edit))
      .append($(btn2))
    );
};

function SaveSubProjectCoFundersTableRow(row){
    var table = $(row).parent().parent().attr('id');

    var id, amount, selectedId, managed;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
          $(this).find('input[name=budgetamount]').each(function(){ amount = $(this).val(); });
          $(this).find('select[name=cofunders]').each(function(){   selectedId = $(this).val(); });
          $(this).find('select[name=managed]').each(function(){     managed = $(this).val(); });
    });
    var Cofunder = {id: id, selectedId: selectedId, managed: managed, amount: amount};
    var editedSubProjectCoFunders = [];
    if (localStorage.getItem("editedSubProjectCoFunders") != null) {
      editedSubProjectCoFunders = JSON.parse(localStorage["editedSubProjectCoFunders"]);
    }
    editedSubProjectCoFunders.push(Cofunder);
    localStorage["editedSubProjectCoFunders"] = JSON.stringify(editedSubProjectCoFunders);
    console.log("Save editedSubProjectCoFunders : Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedSubProjectCoFunders"])));
    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });
      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });
    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};



function SaveContactInstitutionTable(row){
    var table = $(row).parent().parent().attr('id');
    console.log("Saved id: " + $(row).attr('id') );

    var id, selectedId, role, primary;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
      if ($(this).find('select,input').length) {
        $(this).find('select').each(function(){
          selectedId = $(this).val();
        });
      }

      $(this).find('input[name=Role]').each(function(){ role = $(this).val(); });
      $(this).find('input[name=Primary]').each(function(){if ($(this).is(":checked")) { primary=true; } else {primary=false;} });

    });
    //var Institution = {id: id, selectedId: selectedId};
    var Institution = {id: id, selectedId: selectedId, role: role, primary: primary};
   
    var editedContactInstitutions = [];

    if (localStorage.getItem("editedContactInstitutions") != null) {
      editedContactInstitutions = JSON.parse(localStorage["editedContactInstitutions"]);
    }

    editedContactInstitutions.push(Institution);
    localStorage["editedContactInstitutions"] = JSON.stringify(editedContactInstitutions);
    console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedContactInstitutions"])));

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};


function SaveProjectItemTable(row){
    var table = $(row).parent().parent().attr('id');
    console.log("Saved id: " + $(row).attr('id') );

    var pi, projectDescription,amount, selectedRecipientId;
    id = $(row).attr('id');

    $(row).find('td').each(function(){
      if ($(this).find('select,input').length) {
        $(this).find('#amount').each(function(){
          amount = $(this).val();
        });
        $(this).find('#projectItemTitle').each(function(){
          projectDescription = $(this).val();
        });
        $(this).find('select').each(function(){
          $(this).find('#recipient').each(function(){
            selectedRecipientId = $(this).val();
          });
          $(this).find('#pi').each(function(){
            pi = $(this).val();
          });

        });
      }
    });

    var ProjectItem = {pi: pi, projectDescription: projectDescription, selectedRecipientId: selectedRecipientId, amount: amount};
    var editedProjectItems = [];

    if (localStorage.getItem("editedProjectItems") != null) {
      editedProjectItems = JSON.parse(localStorage["editedProjectItems"]);
    }

    editedProjectItems.push(ProjectItem);
    localStorage["editedProjectItems"] = JSON.stringify(editedProjectItems);
    console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedProjectItems"])));

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};

function SavePartnersTable(row){
    var table = $(row).parent().parent().attr('id');
    console.log("Saved id: " + $(row).attr('id') );

    var id, amount, selectedPartnerId;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
      if ($(this).find('select,input').length) {
        $(this).find('input').each(function(){
          amount = $(this).val();
        });

        $(this).find('select').each(function(){
          selectedPartnerId = $(this).val();
        });
      }
    });
    var Partner = {id: id, selectedPartnerId: selectedPartnerId, amount: amount};
    var editedPartners = [];

    if (localStorage.getItem("editedPartners") != null) {
      editedPartners = JSON.parse(localStorage["editedPartners"]);
    }

    editedPartners.push(Partner);
    localStorage["editedPartners"] = JSON.stringify(editedPartners);
    console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedPartners"])));

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};

function SaveCofundersTable(row){
    var table = $(row).parent().parent().attr('id');
    console.log("Saved id: " + $(row).attr('id') );

    var id, amount, selectedId;
    id = $(row).attr('id');
    $(row).find('td').each(function(){
      if ($(this).find('select,input').length) {
        $(this).find('input').each(function(){
          amount = $(this).val();
        });

        $(this).find('select').each(function(){
          selectedId = $(this).val();
        });
      }
    });
    var Cofunder = {id: id, selectedId: selectedId, amount: amount};
    var editedCofunders = [];

    if (localStorage.getItem("editedCofunders") != null) {
      editedCofunders = JSON.parse(localStorage["editedCofunders"]);
    }

    editedCofunders.push(Cofunder);
    localStorage["editedCofunders"] = JSON.stringify(editedCofunders);
    console.log("Edited ids: " + JSON.stringify(JSON.parse(localStorage["editedCofunders"])));

    $(row).find('td').each(function(){
      $(this).find('input').each(function(){
        $(this).prop('disabled', true);
      });

      $(this).find('select').each(function(){
        $(this).prop('disabled', true);
      });
    });

    $(row).find('td:last-child').remove();
    row = addEditDeleteButtons(row);
};


// ---------------------------------------------- REMOVE methods -------------------------------

function Remove(e){
  e.preventDefault();
  var r = confirm("Do you want to remove this record?");

// swal({ title: "Delete",   
//               text: "Do you want to remove this record?",   
//               type: "warning",   
//               showCancelButton: true,   
//               confirmButtonColor: "#DD6B55",   
//               confirmButtonText: "Delete",   
//               closeOnConfirm: true }, 
//               function(){   r = true;   });


  if (r == true) {
      var row = $(this).parent().parent(); //tr
      var table = $(row).parent().parent().attr('id');
      console.log("Remove: table = " + table);
      if (table == "partnersTable") {
        RemovePartnersTable(row);
      }
      if (table == "projectItemsTable") {
        RemoveProjectItemTable(row);
      }
      if (table == "institutionTable") {
        RemoveInstitutionTable(row);
      }
      if (table == "projectCoFundersTable") {
        var objMetaData = {deletedListName: 'deletedProjectCoFunders'};
        RemoveGeneralTable(row, objMetaData);
        getCoFunderTotal();
      }
      if (table == "projectLeadersTable") {
        var objMetaData = {deletedListName: 'deletedProjectLeaders'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "projectManagersTable") {
        var objMetaData = {deletedListName: 'deletedProjectManagers'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "projectMentorsTable") {
        var objMetaData = {deletedListName: 'deletedProjectMentors'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "principalInvestigatorsTable") {
        var objMetaData = {deletedListName: 'deletedPrincipalInvestigators'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "subProjectManagersTable") {
        var objMetaData = {deletedListName: 'deletedSubProjectManagers'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "coInvestigatorsTable") {
        var objMetaData = {deletedListName: 'deletedCoInvestigators'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "finRepsTable") {
        var objMetaData = {deletedListName: 'deletedFinReps'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "finOfficersTable") {
        var objMetaData = {deletedListName: 'deletedFinOfficers'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "collaboratorsTable") {
        var objMetaData = {deletedListName: 'deletedCollaborators'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "projectCoFundersTable") {
        var objMetaData = {deletedListName: 'deletedProjectCoFunders'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "subProjectBudgetTable") {
        var objMetaData = {deletedListName: 'deletedSubProjectBudget'};
        RemoveGeneralTable(row, objMetaData);
        getBudgetTotal();
      }

      if (table == "adminAssistantsTable") {
        var objMetaData = {deletedListName: 'deletedAdminAssistants'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "institutionCommRepTable") {
        var objMetaData = {deletedListName: 'deletedInstitutionCommReps'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "subProjectsTable") {
        var objMetaData = {deletedListName: 'deletedSubProjects'};
        RemoveGeneralTable(row, objMetaData);
        getSubProjectBudgetTotal();
      }

      if (table == "groupContactsTable") {
        var objMetaData = {deletedListName: 'deletedGroupContacts'};
        RemoveGeneralTable(row, objMetaData);
      }
	  
      if (table == "contactGroupsTable") {
        var objMetaData = {deletedListName: 'deletedContactGroups'};
        RemoveGeneralTable(row, objMetaData);
      }
	  
      if (table == "groupProjectsTable") {
        var objMetaData = {deletedListName: 'deletedGroupProjects'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "subProjectCoFundersTable") {
        var objMetaData = {deletedListName: 'deletedSubProjectCoFunders'};
        RemoveGeneralTable(row, objMetaData);
          getSubProjectCoFunderTotal();
      }
	    if (table == "contactPhoneTable") {
        var objMetaData = {deletedListName: 'deletedContactPhones'};
        RemoveGeneralTable(row, objMetaData);
      }
	    if (table == "contactEmailTable") {
        var objMetaData = {deletedListName: 'deletedContactEmails'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "projectCollaboratorsTable") {
        var objMetaData = {deletedListName: 'deletedProjectCollaborators'};
        RemoveGeneralTable(row, objMetaData);
      }
	    if (table == "sacMembersTable") {
        var objMetaData = {deletedListName: 'deletedProjectSACMembers'};
        RemoveGeneralTable(row, objMetaData);
      }
      if (table == "projectDiaryTable") {
        var objMetaData = {deletedListName: 'deletedProjectDiary'};
        RemoveGeneralTable(row, objMetaData);
      }

      if (table == "groupOwnersTable") {
        var objMetaData = {deletedListName: 'deletedGroupOwners'};
        RemoveGeneralTable(row, objMetaData);
      }
  }
};


function RemoveGeneralTable(row, objMetaData) {
  console.log("RemoveGeneralTable ****");

  var deletedListName = objMetaData.deletedListName.toString();  
  var deletedObjs = [];
  var deletedId ={id: $(row).attr('id')};

  if (localStorage.getItem(deletedListName) != null) {
    deletedObjs = JSON.parse(localStorage[deletedListName]);
  }

  deletedObjs.push(deletedId);
  localStorage[deletedListName] = JSON.stringify(deletedObjs);
  console.log("Deleted ids: " + JSON.stringify(JSON.parse(localStorage[deletedListName])));
  row.remove();
}


function RemoveInstitutionTable(row) {
  var deletedContactInstitutions = [];
  var deletedId ={id: $(row).attr('id')};

  if (localStorage.getItem("deletedContactInstitutions") != null) {
    deletedContactInstitutions = JSON.parse(localStorage["deletedContactInstitutions"]);
  }

  deletedContactInstitutions.push(deletedId);
  localStorage["deletedContactInstitutions"] = JSON.stringify(deletedContactInstitutions);
  console.log("Deleted ids: " + JSON.stringify(JSON.parse(localStorage["deletedContactInstitutions"])));

  row.remove();
}

function RemoveCofundersTable(row) {
  var deletedCofunders = [];
  var deletedId ={id: $(row).attr('id')};

  if (localStorage.getItem("deletedCofunders") != null) {
    deletedCofunders = JSON.parse(localStorage["deletedCofunders"]);
  }

  deletedCofunders.push(deletedId);
  localStorage["deletedCofunders"] = JSON.stringify(deletedCofunders);
  console.log("Deleted ids: " + JSON.stringify(JSON.parse(localStorage["deletedCofunders"])));

  row.remove();
}


function RemoveProjectItemTable(row) {
  var deletedProjectItems = [];
  var deletedId ={id: $(row).attr('id')};

  if (localStorage.getItem("deletedProjectItems") != null) {
    deletedProjectItems = JSON.parse(localStorage["deletedProjectItems"]);
  }

  deletedProjectItems.push(deletedId);
  localStorage["deletedProjectItems"] = JSON.stringify(deletedProjectItems);
  console.log("Deleted ids: " + JSON.stringify(JSON.parse(localStorage["deletedProjectItems"])));

  row.remove();
}

function RemovePartnersTable(row) {
  var deletedPartners = [];
  var deletedId ={id: $(row).attr('id')};

  if (localStorage.getItem("deletedPartners") != null) {
    deletedPartners = JSON.parse(localStorage["deletedPartners"]);
  }

  deletedPartners.push(deletedId);
  localStorage["deletedPartners"] = JSON.stringify(deletedPartners);
  console.log("Deleted ids: " + JSON.stringify(JSON.parse(localStorage["deletedPartners"])));

  row.remove();
}


function Search()
{
   alert("!!!");

}