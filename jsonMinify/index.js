var fs = require('fs');
var jsonminify = require("jsonminify");

var args = process.argv.slice(2);
var source = args[0];
var dest = args[1];

if( !source || !source.length || !dest || !dest.length ){
	console.log("Please specify source and dest filename");
	return;
}

console.log("minified json from " + source + " to " + dest);

fs.readFile(source, 'utf8', function (err,str) {
	if(err){
		console.log(err);
	}
	
	var data = JSON.parse(str);
	for(var i in data){
		if( !data[i]['header'] ){ continue; }

		data[i]['header']['convert-by'] = "Asper";
		data[i]['header']['site'] = "https://airmap.g0v.asper.tw";
	}	
	var jsonStr = JSON.stringify(data);
	
	var json = jsonminify(jsonStr);
	fs.writeFile(dest, json, function(err){
		console.log(err);
	});
});

