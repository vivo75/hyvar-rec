/** 
This Jolie program sends the json defined in isola.json on port 9001 using the
post method on operation process and prints the result.
**/

include "console.iol"
include "file.iol"
include "json_utils.iol"

interface HyVarRecInterface {
RequestResponse:
	// operation to get the hyvarrec tool response
  process( undefined )( undefined ),
	// operation to check if the service is still alive and responding
  health( void )( void )
}

outputPort ReconfiguratorService {
    Location: "socket://localhost:9001"
    Protocol: http { .method = "post"; .format = "json"; .json_encoding = "strict" } 
    Interfaces: HyVarRecInterface
}

main {
	
	// read the file
	readfile_request.filename = "isola.json";
	readFile@File(readfile_request)(json_string);
	// convert file into json internal representation
	json_string.strictEncoding = true;
	getJsonValue@JsonUtils(json_string)(json_value);
	//println@Console( "Read json object:" )();
	//println@Console( json_string )();
	// send the post request
	println@Console( "Invoking post method on port 9001." )();
	process@ReconfiguratorService(json_value)( json_output );
	// convert json output into a string
	getJsonString@JsonUtils(json_output)(json_string);
	// print the string
	println@Console( "Output:" )();
	println@Console( json_string )()
}
