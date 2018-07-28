var fs = require('fs');
var request = require('request');
var csv = require('csv');
var util = require('util');
const translate = require('google-translate-api');

var download = function(url, dest, cb) {
    var file = fs.createWriteStream(dest);
    var sendReq = request.get(url);

    // verify response code
    sendReq.on('response', function(response) {
        if (response.statusCode !== 200) {
            return cb('Response status was ' + response.statusCode);
        }
    });

    // check for request errors
    sendReq.on('error', function (err) {
        fs.unlink(dest);
        return cb(err.message);
    });

    sendReq.pipe(file);

    file.on('finish', function() {
        file.close(cb);  // close() is async, call cb after close completes.
    });

    file.on('error', function(err) { // Handle errors
        fs.unlink(dest); // Delete the file async. (But we don't check the result)
        return cb(err.message);
    });
};


function print_help() {
	// http://docs.google.com/spreadsheets/d/174N5QZKA9AdDQqvemFiLaJEcWPNYmB7spm9hspbLN9U/export?format=csv&gid=508446771
	// "https://docs.google.com/spreadsheets/d/%1/export?format=csv&gid=%2"
	console.log("help: conv_for_MB gdoc_url 1~5(gdoc row) target_filename");
}

var args = process.argv.slice(2);
var file_strings = {};

if (typeof args[0] === 'undefined') print_help();
else if (typeof args[1] === 'undefined') print_help();
else if (typeof args[2] === 'undefined') print_help();
else {

	console.log( args[0], args[1], args[2] );

	download( args[0], "./tmp.csv", function (err) {
		// console.log("ok?", err );

		var csv_data = fs.readFileSync( "./tmp.csv", 'utf8' );
		csv.parse( csv_data, function (err, data) {

			var output_csv = "\n";

			// console.log( data[0] );
			// console.log( data[1] );
			// console.log( data[2] );

/*
			translate('I spea Dutch!', {from: 'en', to: 'kr'}).then(res => {
			    console.log(res.text);
			    //=> Ik spreek Nederlands!
			    console.log(res.from.text.autoCorrected);
			    //=> true
			    console.log(res.from.text.value);
			    //=> I [speak] Dutch!
			    console.log(res.from.text.didYouMean);
			    //=> false
			}).catch(err => {
			    console.error(err);
			});

			translate('I spea Dutch!', {from: 'en', to: 'kr'})
*/
			// google translate all eng data to kr
			/*
			var translated = [];

			for ( var i = 0, len = data.length; i < len; i++ ) {
				var csv_row = data[i];
				var src_lang = csv_row[1];
				translated.push( 
					translate( src_lang, {from: 'en', to: 'ko'}).then( res => {
						return res.text;
					}).catch( err => {
			    		console.error(err);
			    		return "error: ["+err+"]";
					})
				);
			}

			Promise.all( translated ).then( (translated_to_kr) => {
				console.log(translated_to_kr);
			} );
			*/

            var row = args[1]; // language row

			for ( var i = 0, len = data.length; i < len; i++ ) {
				var csv_row = data[i];
				var lang_data = csv_row[row];
				if ( csv_row[0] == "qstr_Perisno_v{s1}_" )
				{
					var date_string = new Date().toLocaleDateString().
					  replace(/T/, ' ').      // replace T with a space
					  replace(/\..+/, '');     // delete the dot and everything after
					lang_data += "^한글 패치: ";
					lang_data += date_string;
				}
		  		output_csv += util.format( "%s|\"%s\"\n", csv_row[0], lang_data );
			}


			// write to file
			fs.writeFileSync( args[2], output_csv, 'utf-8' );
			console.log( args[2], " done.")
		});
	});
}

