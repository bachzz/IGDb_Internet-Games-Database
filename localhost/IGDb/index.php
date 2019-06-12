<?php
	session_start();

	if ( isset($_SESSION['user_id']) ){
		header("Location: ./store/store.php");
	}
	else {
		header("Location: ./login/login.php");
		exit(0);
	}
exit();
?>
