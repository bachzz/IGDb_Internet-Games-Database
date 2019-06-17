<?php
	// header("Cache-Control: no cache");
	// session_cache_limiter("private_no_expire");
    session_start();
    // header("Cache-Control: no cache");
	// session_cache_limiter("private_no_expire");
    if ( isset($_SESSION['user_id']) ){
        include '../shared.php';

        // connect to database
        $db_conn = pg_connect("host=$host port=$port user=$user password=$pass dbname=$dbname") or die('Could not connect: ' . pg_last_error());

        $id = $_SESSION['user_id'];
        $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE user_id='$id';");
        $numrows = pg_numrows($result);
        if ($numrows == 0){
            echo "";
            exit(0);
		}
		$review_id = $_REQUEST['review_id'];
		$value = $_REQUEST['value'];

		$type = $value == "1" ? "upvote":"downvote";
		$result = pg_query($db_conn, "UPDATE igdb.reviews set $type = $type + 1 where review_id = $review_id;");
		$result = pg_query($db_conn, "SELECT * from igdb.reviews where review_id=$review_id;");
		$numrows = pg_num_rows($result);
		if ($numrows != 0){
			$review = pg_fetch_array($result, 0);
			echo "$review[$type]";
		}
		else echo "";
    }
    else {
        echo "";
        exit(0);
	}
?>