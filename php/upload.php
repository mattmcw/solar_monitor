<?php

	$success = false;

	$_POST  = filter_input_array(INPUT_POST, FILTER_SANITIZE_STRING);	

	if ( $_POST['data'] ) {
		
	}

	/**
	 * Codes for client script to report success
	 * and potentially trigger jobs on the remote
	 * device if necessary. Need minimal returned
	 * data because this is a on a metered-bandwidth
	 * connection.
	 **/

	if ( $success ) {
		echo "1";
	} else {
		echo "0";
	}
?>
