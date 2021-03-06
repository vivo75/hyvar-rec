/**
 * Copyright (c) 2016, Jacopo Mauro. All rights reserved. 
 * This file is licensed under the terms of the ISC License.
 *
 * For more information related to the use of jolie for receiving post and get
 * operation please have a look at Jolie online documentation:
 * http://docs.jolie-lang.org/#!documentation/web_applications/web_get_post.html
 */


include "console.iol"
include "exec.iol"
include "math.iol"
include "file.iol"
include "string_utils.iol"
include "json_utils.iol"

// execution is concurrent: more than one instance of hyvarrec can be run at the same time
execution { concurrent }

interface HyVarRecInterface {
RequestResponse:
	// operation to get the hyvarrec tool response
	// the input and output are json object (undefined type for jolie)
  process( undefined )( undefined ),
  validate( undefined )( undefined ),
  explain( undefined )( undefined ),
  check_interface( undefined )( undefined ),
  check_features( undefined )( undefined ),
	// operation to check if the service is still alive and responding
  health( void )( void )
}

inputPort ReconfiguratorService {
		// locally the server will be expecting request on port 9001
    Location: "socket://localhost:9001"
		// the protocol used is http and the data send and receive follow json format
    Protocol: http { .format = "json"; .json_encoding = "strict" }
		// the server implements the HyVarRecInterface interface
    Interfaces: HyVarRecInterface
}

/* The program waits for a request and process it.
The operation can be process or healt
*/

main {

	[ process( request )( response ) {
		println@Console( "Received request." )();
		// convert json representation into string
		getJsonString@JsonUtils(request)(json_string);
		//println@Console( json_string )();
		// Save JSON string into a file stored in /tmp
		random@Math()(num);
		json_input_file = "/tmp/" + string(num) + "_in.json";
		json_output_file = "/tmp/" + string(num) + "_out.json";
		write_file_request.content = json_string;
		write_file_request.filename = json_input_file;
		writeFile@File(write_file_request)();
		// Run HyVarRec
		println@Console( "Running HyVarRec." )();
		command_request = "python";
  	    command_request.args[0] = "hyvar-rec.py";
  	    command_request.args[#command_request.args] = "--output-file";
  	    command_request.args[#command_request.args] = json_output_file;
  	    if (is_defined(request.hyvar_options)) {
  	         for ( i = 0, i < #request.hyvar_options._, i++ ) {
	            println@Console( "Found parameter " + request.hyvar_options._[i] )();
	            command_request.args[#command_request.args] = request.hyvar_options._[i]
            }
        };
		command_request.args[#command_request.args] = json_input_file;
		exec@Exec( command_request )( output );
		// Delete input json file
		delete@File(json_input_file)();
		// Print some info
		println@Console( "exit code of HyVarRec: " + string(output.exitCode) )();
		println@Console( "stderr of HyVarRec: <<" + string(output.stderr) + ">>" )();
		println@Console( "output of HyVarRec: <<" + string(output) + ">>" )();
		// Read file and convert into JSON value
		read_request.filename = json_output_file;
		//read_request.format= "json";
        readFile@File( read_request )( output_string );
		// Convert response into json
		output_string.strictEncoding = true;
		getJsonValue@JsonUtils(output_string)(response);
		delete@File(json_output_file)()
	} ] {nullProcess}

	[ validate( request )( response ) {
		println@Console( "Received request." )();
		// convert json representation into string
		getJsonString@JsonUtils(request)(json_string);
		//println@Console( json_string )();
		// Save JSON string into a file stored in /tmp
		random@Math()(num);
		json_input_file = "/tmp/" + string(num) + "_in.json";
		json_output_file = "/tmp/" + string(num) + "_out.json";
		write_file_request.content = json_string;
		write_file_request.filename = json_input_file;
		writeFile@File(write_file_request)();
		// Run HyVarRec
		println@Console( "Running HyVarRec." )();
		command_request = "python";
  	    command_request.args[0] = "hyvar-rec.py";
  	    command_request.args[#command_request.args] = "--validate";
  	    command_request.args[#command_request.args] = "--output-file";
  	    command_request.args[#command_request.args] = json_output_file;
  	    if (is_defined(request.hyvar_options)) {
  	         for ( i = 0, i < #request.hyvar_options._, i++ ) {
	            println@Console( "Found parameter " + request.hyvar_options._[i] )();
	            command_request.args[#command_request.args] = request.hyvar_options._[i]
            }
        };
		command_request.args[#command_request.args] = json_input_file;
		exec@Exec( command_request )( output );
		// Delete input json file
		delete@File(json_input_file)();
		// Print some info
		println@Console( "exit code of HyVarRec: " + string(output.exitCode) )();
		println@Console( "stderr of HyVarRec: <<" + string(output.stderr) + ">>" )();
		println@Console( "output of HyVarRec: <<" + string(output) + ">>" )();
		// Read file and convert into JSON value
		read_request.filename = json_output_file;
		//read_request.format= "json";
        readFile@File( read_request )( output_string );
		// Convert response into json
		output_string.strictEncoding = true;
		getJsonValue@JsonUtils(output_string)(response);
		delete@File(json_output_file)()
	} ] {nullProcess}

	[ explain( request )( response ) {
		println@Console( "Received request." )();
		// convert json representation into string
		getJsonString@JsonUtils(request)(json_string);
		//println@Console( json_string )();
		// Save JSON string into a file stored in /tmp
		random@Math()(num);
		json_input_file = "/tmp/" + string(num) + "_in.json";
		json_output_file = "/tmp/" + string(num) + "_out.json";
		write_file_request.content = json_string;
		write_file_request.filename = json_input_file;
		writeFile@File(write_file_request)();
		// Run HyVarRec
		println@Console( "Running HyVarRec." )();
		command_request = "python";
  	    command_request.args[0] = "hyvar-rec.py";
  	    command_request.args[#command_request.args] = "--explain";
  	    command_request.args[#command_request.args] = "--output-file";
  	    command_request.args[#command_request.args] = json_output_file;
  	    if (is_defined(request.hyvar_options)) {
  	         for ( i = 0, i < #request.hyvar_options._, i++ ) {
	            println@Console( "Found parameter " + request.hyvar_options._[i] )();
	            command_request.args[#command_request.args] = request.hyvar_options._[i]
            }
        };
		command_request.args[#command_request.args] = json_input_file;
		exec@Exec( command_request )( output );
		// Delete input json file
		delete@File(json_input_file)();
		// Print some info
		println@Console( "exit code of HyVarRec: " + string(output.exitCode) )();
		println@Console( "stderr of HyVarRec: <<" + string(output.stderr) + ">>" )();
		println@Console( "output of HyVarRec: <<" + string(output) + ">>" )();
		// Read file and convert into JSON value
		read_request.filename = json_output_file;
		//read_request.format= "json";
        readFile@File( read_request )( output_string );
		// Convert response into json
		output_string.strictEncoding = true;
		getJsonValue@JsonUtils(output_string)(response);
		delete@File(json_output_file)()
	} ] {nullProcess}

	[ check_interface( request )( response ) {
		println@Console( "Received request." )();
		// Save JSON string into a file stored in /tmp
		getJsonString@JsonUtils(request.interface)(json_string);
		random@Math()(num);
		interface_input_file = "/tmp/" + string(num) + "_in.json";
		json_output_file = "/tmp/" + string(num) + "_out.json";
		write_file_request.content = json_string;
		write_file_request.filename = interface_input_file;
		writeFile@File(write_file_request)();
		getJsonString@JsonUtils(request.spl)(json_string);
		random@Math()(num);
		spl_input_file = "/tmp/" + string(num) + "_in.json";
		write_file_request.content = json_string;
		write_file_request.filename = spl_input_file;
		writeFile@File(write_file_request)();

		// Run HyVarRec
		println@Console( "Running HyVarRec." )();
		command_request = "python";
  	    command_request.args[0] = "hyvar-rec.py";
  	    command_request.args[#command_request.args] = "--check-interface";
  	    command_request.args[#command_request.args] = "--output-file";
  	    command_request.args[#command_request.args] = json_output_file;
  	    if (is_defined(request.hyvar_options)) {
  	         for ( i = 0, i < #request.hyvar_options._, i++ ) {
	            println@Console( "Found parameter " + request.hyvar_options._[i] )();
	            command_request.args[#command_request.args] = request.hyvar_options._[i]
            }
        };
  	    command_request.args[#command_request.args] = interface_input_file;
		command_request.args[#command_request.args] = spl_input_file;
		exec@Exec( command_request )( output );
		// Delete input json file
		delete@File(interface_input_file)();
		delete@File(spl_input_file)();
		// Print some info
		println@Console( "exit code of HyVarRec: " + string(output.exitCode) )();
		println@Console( "stderr of HyVarRec: <<" + string(output.stderr) + ">>" )();
		println@Console( "output of HyVarRec: <<" + string(output) + ">>" )();
		// Read file and convert into JSON value
		read_request.filename = json_output_file;
		//read_request.format= "json";
        readFile@File( read_request )( output_string );
		// Convert response into json
		output_string.strictEncoding = true;
		getJsonValue@JsonUtils(output_string)(response);
		delete@File(json_output_file)()
	} ] {nullProcess}

	[ check_features( request )( response ) {
		println@Console( "Received request." )();
		// convert json representation into string
		getJsonString@JsonUtils(request)(json_string);
		//println@Console( json_string )();
		// Save JSON string into a file stored in /tmp
		random@Math()(num);
		json_input_file = "/tmp/" + string(num) + "_in.json";
		json_output_file = "/tmp/" + string(num) + "_out.json";
		write_file_request.content = json_string;
		write_file_request.filename = json_input_file;
		writeFile@File(write_file_request)();
		// Run HyVarRec
		println@Console( "Running HyVarRec." )();
		command_request = "python";
  	    command_request.args[0] = "hyvar-rec.py";
  	    command_request.args[#command_request.args] = "--check-features";
  	    command_request.args[#command_request.args] = "--output-file";
  	    command_request.args[#command_request.args] = json_output_file;
  	    if (is_defined(request.hyvar_options)) {
  	         for ( i = 0, i < #request.hyvar_options._, i++ ) {
	            println@Console( "Found parameter " + request.hyvar_options._[i] )();
	            command_request.args[#command_request.args] = request.hyvar_options._[i]
            }
        };
		command_request.args[#command_request.args] = json_input_file;
		exec@Exec( command_request )( output );
		// Delete input json file
		delete@File(json_input_file)();
		// Print some info
		println@Console( "exit code of HyVarRec: " + string(output.exitCode) )();
		println@Console( "stderr of HyVarRec: <<" + string(output.stderr) + ">>" )();
		println@Console( "output of HyVarRec: <<" + string(output) + ">>" )();
		// Read file and convert into JSON value
		read_request.filename = json_output_file;
		//read_request.format= "json";
        readFile@File( read_request )( output_string );
		// Convert response into json
		output_string.strictEncoding = true;
		getJsonValue@JsonUtils(output_string)(response);
		delete@File(json_output_file)()
	} ] {nullProcess}

	// the health process does not do anything except an
	[ health( request )( response ) ] { nullProcess }
}
