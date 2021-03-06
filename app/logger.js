// var winston = require('winston');
// winston.emitErrs = true;

// var logger = new winston.Logger({
//     transports: [
//         new winston.transports.File({
//             level: 'info',
//             filename: './logs/all-logs.log',
//             handleExceptions: true,
//             json: false,
//             maxsize: 5242880, //5MB
//             maxFiles: 5,
//             colorize: false
//         }),

//         new winston.transports.Console({
//             level: 'debug',
//             handleExceptions: true,
//             json: false,
//             colorize: true
//         })
//     ],
//     exitOnError: false
// });

// module.exports = logger;
// module.exports.stream = {
//     write: function(message, encoding){
//         //logger.info(message);
//         logger.info(message.slice(0, -1));
//     }
// };

var logger = require('winston');
logger.setLevels({debug:0,info: 1,silly:2,warn: 3,error:4,});
logger.addColors({debug: 'green',info:  'cyan',silly: 'magenta',warn:  'yellow',error: 'red'});
logger.remove(logger.transports.Console);
logger.add(logger.transports.Console, { level: 'debug', colorize:true });
logger.add(logger.transports.File, { 
            level: 'error', 
            colorize:false, 
            filename: './logs/all-logs.log',
            handleExceptions: true,
            json: false,
            maxsize: 5242880, //5MB
            maxFiles: 5
});
module.exports = logger;