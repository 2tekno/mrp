var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 


exports.renderAddNewProduct = function (req, res) {

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
		
            request.query("SELECT * FROM Vendors ORDER BY Name", function(err, vendors) {         
                   res.render('add_product', {
                      vendors: vendors,
                      user: req.user
        }); 
        }); 
        }); 
}

exports.allproductsSS = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("SELECT * FROM vwProducts ORDER BY Description", function(err, data) {
          if(err) logger.error("Error selecting from Products table: %s ", err);
          var iTotalRecords = data.length;
          var returnObj = {
            aaData: data,
            iTotalRecords: iTotalRecords,
            iTotalDisplayRecords: iTotalRecords
          }
          res.send(returnObj);
		});
  });
}


exports.allproducts = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("SELECT * FROM vwProducts ORDER BY Description", function(err, data) {
          if(err) logger.error("Error selecting from Products table: %s ", err);
          res.send(data);
		});
  });
}


exports.renderAddNewOrder = function (req, res) {

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
		
        request.query("SELECT * FROM OrderStatus ORDER BY Description", function(err, orderStatus) {
            request.query("SELECT * FROM Vendors ORDER BY Name", function(err, vendors) {         
                request.query("SELECT * FROM Products ORDER BY Description", function(err, products) {         
                   res.render('add_order', {
                      orderStatus: orderStatus,
                      vendors: vendors,
                      products: products,
                      user: req.user
        }); 
        }); 
        }); 
        }); 
        });           
}



exports.save_new = function(req, res){
    var input = JSON.parse(JSON.stringify(req.body));

    //console.log('orderItems  == ' + JSON.stringify(input.orderItems));
    console.log('orderItems  == ' + input.orderItems);

    // var Notes = input.Notes.replace(/(')/g, "''");

    // var editedGroupProjects = [];
    // if (input.editedGroupProjects != null) {  editedGroupProjects = JSON.parse(input.editedGroupProjects);  }

    // sql.connect(config.connection, function(err) {
    //   var request = new sql.Request();

    //   request.query("INSERT INTO PeopleGroup (GroupName,Notes) values ('"+GroupName+"','"+Notes+"'); SELECT SCOPE_IDENTITY() AS ID", function(err, rows) {
    //     var PeopleGroupID = JSON.stringify(rows[0].ID);



    //     for(var obj in editedGroupProjects) {
    //         if(editedGroupProjects[obj].hasOwnProperty('id')) {
    //               var id = editedGroupProjects[obj]['id'];
    //               var selectedId = editedGroupProjects[obj]['selectedId'];
    //               if (id == "-1") {
    //                   request.query("INSERT INTO PeopleGroupProject (PeopleGroupID,ProjectID) VALUES ('" +
    //                                 PeopleGroupID +"','"+selectedId+"') ", function(err, rows) {
    //                        if (err) logger.error("Error inserting in PeopleGroupProject table: %s ", err);
    //                   })
    //               } 
    //         }
    //     }


    //      if (err) logger.error("Error inserting into PeopleGroup table: %s ", err);
    //      else {
    //           res.contentType('application/json');
    //           var data = JSON.stringify('/groups');
    //           res.header('Content-Length', data.length);
    //           res.end(data);
    //       }

    //   });
    // });
};
