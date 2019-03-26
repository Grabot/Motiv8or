<?php

	include 'config.php';
    
    $connection = mysqli_connect($servername, $username, $password, $dbname);
 
	// Check connection
	if($connection === false){
	    die("ERROR: Could not connect. " . mysqli_connect_error());
	}

	$name = $_POST['name'];
	$password = $_POST['password'];
	// Attempt select query execution
	$sql = "select userId, name, email, password From User where name = '$name' and password = '$password'";

	$result = mysqli_query($connection, $sql);
	if ($result) {
		$row = mysqli_fetch_row($result);
		if ($row) {

			$userId = $row[0]; // userId
			$name = $row[1]; // name
			$email = $row[2]; // email
			$password = $row[3]; // password

			// success
			$response["user_data"]["userId"] = $userId;
			$response["user_data"]["name"] = $name;
			$response["user_data"]["password"] = $password;
			$response["user_data"]["email"] = $email;

    		$response["success"] = 1;

		} else {
			// No user found
    		$response["failed"] = 1;
		}

	} else {
	    echo "ERROR: Not able to execute $sql. " . mysqli_error($connection);
    	$response["failed"] = 1;
	}

    echo(json_encode($response));
	// Close connection
	mysqli_close($connection);

?>