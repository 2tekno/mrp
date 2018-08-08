var sql = require('mssql');
var config = require('../config/database');
var logger = require('winston'); 


exports.reportsList = function(req, res) {
  sql.connect(config.connection, function(err) {
    var request = new sql.Request();
    request.query("select * from vwReportsList order by SortOrder", function(err, recordset) {

     if(err) logger.error("Error selecting from vwReportsList table: %s ", err);
 
	 res.render('reportList',{page_title: "Reports",
                  reports: recordset,
                  user: req.user,
									ssrs_url: config.connection.ssrs_url}); 
	 
    });
  });
}

