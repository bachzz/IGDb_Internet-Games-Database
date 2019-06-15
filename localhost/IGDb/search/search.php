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
        if ( isset($_POST['filter']) ){
			$filter = $_POST['filter'];
			$_SESSION['filter'] = $filter;
            //echo "<script>alert('".$_POST['filter']."')</script>";
            if ($filter == "none")
				$_SESSION['filter_query'] = "game_id";
            if ($filter == "newest")
				$_SESSION['filter_query'] = "release_date";
            if ($filter == "popular")
				$_SESSION['filter_query'] = "total_added";
            if ($filter == "rating")
				$_SESSION['filter_query'] = "avg_score";
			//$filter = $_POST['filter'];
			header("Location: ./search.php");
			return;
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
    <link href="style sheet/search.css" rel="stylesheet" />
</head>

<body>
    <div class="bg" style="background-image: url(../resources/test/bg.png);">

        <div class="bodyContainer">

            <?php include '../nav/navigation.php' ?>


            <div class="content">
                <div class="gamesDisplay">
                    <div class=gameText>
                    <div id="allGames">Search result for:  </div>
                    <div class="search-result">   "search result"</div>
                        <form method="post" id="filter-form" class="storeSortButton">
                            <select name=filter onchange="this.form.submit()" class="filterButton">
                                    <option value="" disabled selected>Filter</option>
                                    <option class="sortby" value="none">None</option>
                                    <option class="sortby" value="newest">Newest first</option>
                                    <option class="sortby" value="popular">Most popular first</option>
                                    <option class="sortby" value="rating">Highest rated first</option>
                            </select>
                        </form>


                    </div>
                    <div class=gamesContainer>
                        <div class="grid-container">
							<?php 
								$filter = isset($_SESSION['filter']) ? $_SESSION['filter'] : '';
								$filter_query = isset($_SESSION['filter_query']) ? $_SESSION['filter_query'] : 'game_id';
								//$result = pg_query($db_conn, "SELECT * FROM igdb.games ORDER BY game_id ASC;");
                                $result = pg_query($db_conn, "SELECT * FROM igdb.game_view_store ORDER BY $filter_query DESC;");
                                $numrows = pg_num_rows($result);
                                
                                if ($numrows == 0){
                                    echo 'No games added!';
                                }
                                else {
                                    $arr = pg_fetch_all($result);
                                    foreach($arr as $array)
                                    {
                                        $img_url = $array['img_url'];
                                        $cover = strtok($img_url, ";");
                                        $title = $array['title'];
                                        $description = $array['description'];
                                        $game_id = $array['game_id'];

                                        echo '<div class="grid-item">
                                                <span class="gameCover">
                                                    <img src='.$cover.' width="200px" height="100px">
                                                </span>
                                                <span class="gameInfo">
                                                    <div class="gameName" onclick="game_onclick(\''.$game_id.'\')">'.$title.'</div>
                                                    <div class="gameDescription">'.$description.'</div>
                                                </span>
                                            </div>';
                                    }
                                }
                            ?>
                        </div>
                    </div>
                </div>
                <div class=content></div>
            </div>
        </div>
    </div>
</body>

</html>
