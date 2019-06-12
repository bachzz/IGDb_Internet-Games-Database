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
            if ($gameFilter == "newest")
                $_SESSION['gameFilter_query'] = "release_date";
            if ($gameFilter == "popular")
                $_SESSION['gameFilter_query'] = "total_added";
            if ($gameFilter == "rating")
                $_SESSION['gameFilter_query'] = "avg_score";
            header("Location: ./library.php");
            exit(0);
        }

        foreach ($_POST as $key => $value) {
            # code...
            // echo "{$key} = {$value}\r\n";
            if (strpos($key, 'status') !== false){
                $gid = substr($key, -1);
                // echo '<script>alert("'.$value.$gid.'")</script>';
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
                                <div id="allGames">'s Library</div>
                                <form method="post" id="filter-form" class="sortButton">
                                    <select name=gameFilter onchange="this.form.submit()" class="filterButton">
                                            <option value="" disabled selected>Filter</option>
                                            <option class="sortby" value="none">None</option>
                                            <option class="sortby" value="newest">Newest first</option>
                                            <option class="sortby" value="popular">Most popular first</option>
                                            <option class="sortby" value="rating">Highest rated first</option>
                                    </select>
                                </form>
                            </div>

                        <div class=gamesContainer id="normalLib">
                            <div>
                                <div class="submitButtonContainer">
                                    <button id="submitButton" onclick="showEdit()" >Edit</button>
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
                                        echo 'No games added!';
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
                                                        <div class="gameName" onclick="game_onclick(\''.$game_id.'\')">'.$title.'</div>
                                                        <div class="gameDescription">'.$description.' - '.$status.'</div>
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
                                    <input type="submit" value="Submit">
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
                                        echo 'No games added!';
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
                                                        <div class="gameName">'.$title.'</div>
                                                        <div class="gameOption">
                                                            <input type="radio" name="status'.$game_id.'" id="playing" value="playing">
                                                            <label for="playing">Playing</label>
                                                            
                                                            <input type="radio" name="status'.$game_id.'" id="completed" value="completed">
                                                            <label for="completed">Completed</label>
                                                            
                                                            <input type="radio" name="status'.$game_id.'" id="plan" value="plan">
                                                            <label for="plan">Plan to play</label>
                                                            
                                                            <input type="radio" name="status'.$game_id.'" id="dropped" value="dropped">
                                                            <label for="dropped">Dropped</label>
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
</body>

</html>