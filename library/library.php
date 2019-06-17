<?php
    header("Cache-Control: no cache");
    session_cache_limiter("private_no_expire");
    session_start();
    if ( isset($_SESSION['user_id']) ){
        include '../shared.php';
        // connect to database
        $db_conn = pg_connect("host=$host port=$port user=$user password=$pass dbname=$dbname") or die('Could not connect: ' . pg_last_error());

        $id = $_SESSION['user_id'];
        $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE user_id='$id';");
        $numrows = pg_numrows($result);
        if ($numrows == 0){
            header("Location: ../login/login.php");
            exit(0);
        }

        $user = pg_fetch_array($result, 0);

        if ( isset($_POST['gameFilter']) ){
            $gameFilter = $_POST['gameFilter'];
            $_SESSION['gameFilter'] = $gameFilter;

            if ($gameFilter == "none")
                $_SESSION['gameFilter_query'] = "game_id";
            if ($gameFilter == "playing")
                $_SESSION['gameFilter_query'] = 1;
            if ($gameFilter == "completed")
                $_SESSION['gameFilter_query'] = 2;
            if ($gameFilter == "plan")
                $_SESSION['gameFilter_query'] = 3;
            if ($gameFilter == "drop")
                $_SESSION['gameFilter_query'] = 4;
            header("Location: ./library.php");
            exit(0);
        }
	if(isset($_POST['submitEdit'])) {
		foreach ($_POST as $key => $value) {
			if (strpos($key, 'status') !== false){
				$gid = substr($key, 6, strlen($key));
				if ($value == "playing")
					$category = "1";
				if ($value == "completed")
					$category = "2";
				if ($value == "plan")
					$category = "3";
				if ($value == "dropped")
					$category = "4";
				$result = pg_query($db_conn, "UPDATE igdb.library set category=$category where user_id=".$_SESSION['user_id']." and game_id=$gid;");
				
			}
		}
		header("Location: ./library.php");
		exit(0);
	}
		
    }
    else {
        header("Location: ../login/login.php");
        exit(0);
    }

?>

<!DOCTYPE html>
<html>

<head>
    <title>IGDb</title>
    <link href="style sheet/library.css" rel="stylesheet" />
</head>

<body>
    <div class="bg" style="background-image: url(../resources/test/bg.png);">
        <div class="bodyContainer">
            <?php include '../nav/navigation.php' ?>
            <div class="content">
                    <div class="gamesDisplay">
                            <div class="gameText">
                                <div id="allGamesName"><?php echo $user['name']; ?></div>
                                <div id="allGames">'s library</div>
                                <form method="post" id="filter-form" class="sortButton">
                                    <select name=gameFilter onchange="this.form.submit()" class="filterButton">
                                            <option value="" disabled selected>Filter</option>
                                            <option class="sortby" value="none">None</option>
                                            <option class="sortby" value="playing">Playing</option>
                                            <option class="sortby" value="completed">Completed</option>
                                            <option class="sortby" value="plan">Plan to play</option>
                                            <option class="sortby" value="drop">Dropped</option>
                                    </select>
                                </form>
                            </div>

                        <div class=gamesContainer id="normalLib">
                            <div>
                                <div class="submitButtonContainer">
                                    <button id="editButton" onclick="showEdit()" >Edit</button>
                                </div>
                            </div>
                            <div class="grid-container">
                                <?php 
                                    $gameFilter = isset($_SESSION['gameFilter']) ? $_SESSION['gameFilter'] : '';
                                    $gameFilter_query = isset($_SESSION['gameFilter_query']) ? $_SESSION['gameFilter_query'] : 'game_id';
                                    if ($gameFilter_query == "game_id")
                                        $result = pg_query($db_conn, "SELECT g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score,
                                                            count(l.game_id) AS total_added FROM igdb.games g 
                                                            INNER JOIN igdb.library l ON l.game_id = g.game_id 
                                                            WHERE l.user_id = '".$_SESSION['user_id']."'
                                                            GROUP BY g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score
                                                            ORDER BY $gameFilter_query DESC;");
                                    else 
                                        $result = pg_query($db_conn, "SELECT g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score,
                                                            count(l.game_id) AS total_added FROM igdb.games g 
                                                            INNER JOIN igdb.library l ON l.game_id = g.game_id 
                                                            WHERE l.user_id = '".$_SESSION['user_id']."' AND l.category = '".$gameFilter_query."'
                                                            GROUP BY g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score;");

                                    $numrows = pg_num_rows($result);

                                    if ($numrows == 0) {
                                        echo 'There is nothing here';
                                    }
                                    else {
                                        $arr = pg_fetch_all($result);
                                        foreach($arr as $array) {
                                            $img_url = $array['img_url'];
                                            $cover = strtok($img_url, ";");
                                            $title = $array['title'];
                                            $description = $array['description'];
                                            $game_id = $array['game_id'];

                                            $result = pg_query($db_conn, "SELECT * from igdb.library where user_id=".$_SESSION['user_id']." and game_id=$game_id");
                                            $item = pg_fetch_array($result, 0);

                                            if ($item['category'] == 1)
                                                $status = "Playing";
                                            if ($item['category'] == 2)
                                                $status = "Completed";
                                            if ($item['category'] == 3)
                                                $status = "Plan to play";
                                            if ($item['category'] == 4)
                                                $status = "Dropped";

                                            echo '<div class="grid-item">
                                                    <span class="gameCover">
                                                        <img src='.$cover.' width="200px" height="100px">
                                                    </span>
                                                    <span class="gameInfo">
                                                        <div class="name-status">                                                        
                                                            <div class="gameName" onclick="game_onclick(\''.$game_id.'\')">'.$title.'</div>
                                                            <div class="gameStatus">'.$status.'</div>
                                                        </div>
                                                        <div class="gameDescription">'.$description.'</div>
                                                    </span>
                                                </div>';
                                        }
                                    }
                                ?>
                            </div>
                        </div>
                        <!-- edit -->
                        <form method="post" class="gamesContainerEdit" id="normalLibEdit">
                            <div>
                                <div class="submitButtonContainer">
                                    <input id="submitButton" name="submitEdit" type="submit" value="Submit">
                                    <!-- <button id="submitButton" onclick="document.getElement.submit()">Submit</button> -->
                                </div>
                            </div>
                            <div class="grid-container">
                                <?php 
                                    $gameFilter = isset($_SESSION['gameFilter']) ? $_SESSION['gameFilter'] : '';
                                    $gameFilter_query = isset($_SESSION['gameFilter_query']) ? $_SESSION['gameFilter_query'] : 'game_id';
                                    $result = pg_query($db_conn, "SELECT g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score,
                                                                count(l.game_id) AS total_added FROM igdb.games g 
                                                                INNER JOIN igdb.library l ON l.game_id = g.game_id 
                                                                WHERE l.user_id = '".$_SESSION['user_id']."'
                                                                GROUP BY g.game_id, g.title,  g.description, g.img_url, g.release_date, g.avg_score
                                                                ORDER BY $gameFilter_query DESC;");
                                    $numrows = pg_num_rows($result);

                                    if ($numrows == 0) {
                                        echo 'There is nothing here';
                                    }
                                    else {
                                        $arr = pg_fetch_all($result);
                                        foreach($arr as $array) {
                                            $img_url = $array['img_url'];
                                            $cover = strtok($img_url, ";");
                                            $title = $array['title'];
                                            $game_id = $array['game_id'];

                                            echo '<div class="grid-item">
                                                    <span class="gameCover">
                                                        <img src='.$cover.' width="200px" height="100px">
                                                    </span>
                                                    <span class="gameInfo">
                                                        <div class="gameNameEdit">'.$title.'</div>
                                                        <div class="gameOption">
                                                            <input type="radio" " name="status'.$game_id.'" id="playing" value="playing">
                                                            <span class="option-label" for="playing" style="pointer-events: none;
                                                            cursor: default;" >Playing</span>
                                                            
                                                            <input type="radio" name="status'.$game_id.'" id="completed" value="completed">
                                                            <span class="option-label" for="completed" style="pointer-events: none;
                                                            cursor: default;" >Completed</span>

                                                            
                                                            <input type="radio" name="status'.$game_id.'" id="plan" value="plan">
                                                            <span class="option-label" for="plan" style="pointer-events: none;
                                                            cursor: default;">Plan to play</span>

                                                            <input type="radio" " name="status'.$game_id.'" id="dropped" value="dropped">
                                                            <span class="option-label" for="dropped" style="pointer-events: none;
                                                            cursor: default;" >Dropped</span>
                                                        </div>
                                                    </span>
                                                </div>';
                                        }
                                    }
                                ?>  
                            </div>
                        </form>
                        







            </div>
        </div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/library.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

</body>

</html>