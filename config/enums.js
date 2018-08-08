
var accessLevelArray = { data:[
		{Id:"0", Text: "Read-Only"},
		{Id:"1", Text: "Add-Edit-Delete"},
		{Id:"2", Text: "Admin"}
	]
}


var OLDaccessLevelArray = { data:[
	{Id:"0", Text: "Read-Only"},
	{Id:"1", Text: "Add-Edit-Delete"},
	{Id:"2", Text: "Admin"},
	{Id:"3", Text: "Edit but No Delete"}
]
}

var enumYesNo = { data:[
		{Id:"0", Text: "No"},
		{Id:"1", Text: "Yes"}
	]
}

module.exports = {
	'accessLevelArray':accessLevelArray.data,
	'enumYesNo': enumYesNo.data
};
