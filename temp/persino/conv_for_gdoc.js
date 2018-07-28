var fs = require('fs');
var request = require('request');
var csv = require('csv');
var util = require('util');
const translate = require('google-translate-api');

function print_help() {
	console.log("help: conv_for_gdoc warband_langfileA warband_langfileB outputfile");
}

var args = process.argv.slice(2);
var file_strings = {};

if (typeof args[0] === 'undefined') print_help();
else if (typeof args[1] === 'undefined') print_help();
else if (typeof args[2] === 'undefined') print_help();
else {

	console.log( args[0], args[1], args[2] );

	var opts = { maxLineLength: 999999 };

	var fileA = require('./readline')(args[0], opts);

	fileA.on( 'line', function (line) {
	  splited = line.split("|");
	  str_id = splited[0];
	  str_1 = splited[1];

	  file_strings[str_id] = [ str_1 ];
	});


	fileA.on( 'close', () => {
	  	console.log( "fileA finished" );
	  	// console.log( file_strings );

	    // now read fileB
		var fileB = require('./readline')(args[1], opts);

		fileB.on( 'line', function (line) {
		  	splited = line.split("|");
		  	if ( splited.length <= 1 ) return;

		  	str_id = splited[0];
		  	str_2 = splited[1];

		  	// console.log(file_strings[str_id], "=", str_id, str_2);
		  	if ( typeof file_strings[str_id] === undefined ) {
		  		file_strings[str_id] = [ "undefined" ];
		  	}
		  	if ( !Array.isArray(file_strings[str_id]) ) {
		  		// fuck
		  		console.log( file_strings[str_id], str_id, str_2 );
		  		file_strings[str_id] = [ "undefined" ];
		  	}

		  	file_strings[str_id].push( str_2 );


		});

		fileB.on( 'close', () => {
			// now read fileB
			console.log( "fileB finished" );
			// console.log( file_strings );

			// build csv file

			/*
			var output_data = [];
			Object.keys(file_strings).forEach(function(key) {
			  	var val = file_strings[key];
			  	if ( val.length == 1 ) val.push(val[0]);

			  	// output_data.push( [ key, val[0], val[1] ] );
			  	// var util = require('util');
			  	// output_string += util.format( "%s, \"%s\", \"%s\",na,na,\"\"\n", key, val[0], val[1] );


			});
			*/

			var translated = [];
			Object.keys(file_strings).forEach(function(key) {
			  	var val = file_strings[key];

				translated.push( 
					translate( val[0], {from: 'en', to: 'ko'}).then( res => {
						return [ key, val[0], val[1], res.text ];
					}).catch( err => {
			    		console.error(err);
			    		return [ key, val[0], val[1], "error: ["+err+"]" ];
					})
				);							  	
			});

			Promise.all( translated ).then( (data) => {
				// console.log(data);
				var output_string = "";
				output_string += "str_id, src_lang, dst_lang1, dst_lang_gtrans, dst_lang2, dst_lang3, comment\n";

				for ( var i = 0, len = data.length; i < len; i++ ) {
					var row = data[i]; // key, en, kr, kr_translated

			  		output_string += util.format( "%s, \"%s\", \"%s\", \"%s\",na,na,\"\"\n", row[0], row[1], row[2], row[3] );
				}

				// write to file
				require('fs').writeFileSync( args[2], output_string, 'utf-8' );
				console.log( args[2], " done.")				
			} );

		});

	});

}
