var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 



exports.allorders = function(req, res) {
	sql.connect(config.connection, function(err) {
		var request = new sql.Request();
		request.query("select * from vwPOrderList", function(err, data) {
          if(err) logger.error("Error selecting from vwPOrderList table: %s ", err);
          res.send(data);
		});
  });
}



exports.renderAddNewOrder = function (req, res) {

    sql.connect(config.connection, function(err) {
        var request = new sql.Request();
		
        request.query("select * from OrderStatus", function(err, orderstatus) {
                   
                   res.render('add_order', {
                        orderstatus: orderStatus,
                        user: req.user
        }); 
        }); 
        });           
}
