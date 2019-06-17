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
			header("Location: ./store.php");
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
    <link href="style sheet/store.css" rel="stylesheet" />
</head>

<body>
<div class="bg" style="background-image: url(../resources/test/bg.png);">

        <div class="bodyContainer">

            <?php include '../nav/navigation.php' ?>


            <div class="content">

            <div id="myCarousel" class="carousel slide" data-ride="carousel">


                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <?php
                        $result = pg_query($db_conn, "SELECT * from igdb.games;");
                        $items = pg_fetch_all($result);
                        $item0 = $items[0];
                        $game_id0 = $item0['game_id'];
                        $img_url0 = $item0['img_url'];
                        $cover0 = strtok($img_url0, ";"); 

                        echo '<div class="item active">
                                <img src="'.$cover0.'" style="background-size:auto">
                            </div>';

                        for ($i = 1; $i < count($items); $i++){
                            $item_i = $items[$i];
                            $img_url = $item_i['img_url'];
                            $game_id = $item_i['game_id'];
                            $cover = strtok($img_url, ";");
                            echo '<div class="item" onclick="game_onclick(\''.$game_id.'\')">
                                <img src="'.$cover.'">
                            </div>';
                        }

                    ?>
                </div>

                <!-- Left and right controls -->
                <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
                <div class="gamesDisplay">
                    <div class=gameText>
                    <div id="allGames">All games</div>
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
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/store.js"></script>

  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</body>

</html>
