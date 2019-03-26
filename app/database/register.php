<?php

	include 'config.php';
    
    $connection = mysqli_connect($servername, $username, $password, $dbname);
 
	// Check connection
	if($connection === false){
	    die("ERROR: Could not connect. " . mysqli_connect_error());
	}

	$name = $_POST['name'];
	$password = $_POST['password'];
	$email = $_POST['email'];

	// Attempt insert query execution
	$userIdQuery = "select max(userId)+1 as userId from User";

	$userResult = mysqli_query($connection, $userIdQuery);
	if ($userResult) {
		$userIdRow = mysqli_fetch_row($userResult);
		if ($userIdRow) {
			$userId = $userIdRow[0]; // userId
			if ($userId == null) {
				$userId = 0;
			}

			$sql = "insert into User (userId, name, email, password) values ('$userId', '$name', '$email', '$password')";
			$result = mysqli_query($connection, $sql);
			if ($result) {
				$response["user_data"]["result"] = "succes";
			} else {
				$response["user_data"]["result"] = "failed";
			}
		} else {
			$response["user_data"]["result"] = "failed";
		}
	} else {
		$response["user_data"]["result"] = "failed";
	}

    echo(json_encode($response));
	// Close connection
	mysqli_close($connection);

?>