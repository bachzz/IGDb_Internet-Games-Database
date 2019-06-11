<?php
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
    <link href="style sheet/user.css" rel="stylesheet" />
</head>

<body>
    <div class="bg" style="background-image: url(../resources/test/bg.png);">
        <div class="bodyContainer">
            <?php include '../nav/navigation.php' ?>
            <div class="content">
                <div class="userInfoContainer" style="background-image: url(../resources/test/game2.png);">
                    <span class="userAva">
                        <img src=pictures/game4.jpg width="200px" height="200px">
                    </span>
                    <div class="userInfo">
                        <div class=userName>
                            <div class="userName">John Doe</div>
                        </div>
                        <div class="userEmail">johndoe@gmail.com</div>
                    </div>
                </div>
                <div class="userStatistic">
                    <div class="numGamesContainer">
                        <div class="numGamesText">Number of games:</div>
                        <div class="numGames">5</div>
                    </div>
                    <div class="numReviewsContainer">
                        <div class="numReviewsText">Number of reviews:</div>
                        <div class="numReviews">4</div>
                    </div>
                </div>

                <div class="gamesDisplay">
                    <div class="gameText">
                        <div id="allGames">Library</div>
                        <div class="storeSortButton">
                            <div class="sortButton">Filter
                                <span class="sort-menu">
                                    <p class="sortbyPlaying">Currently playing</p>
                                    <p class="sortbyPlayed">Played</p>
                                    <p class="sortbyWait">Waiting to play</p>
                                    <p class="sortbyDropped">Dropped</p>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class=gamesContainer>
                        <div class="grid-container">
						<?php 
								$result = pg_query($db_conn, "SELECT * FROM igdb.library l INNER JOIN igdb.games g ON l.game_id = g.game_id WHERE l.user_id = '".$_SESSION['user_id']."';");
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
										echo ' <div class="grid-item">
                                        <span class="gameCover">
                                            <img src='.$cover.' width="200px" height="100px">
                                        </span>
                                        <span class="gameInfo">
                                            <div class="gameName">'.$title.'</div>
                                            <div class="gameDescription">'.$description.'</div>
                                        </span>
                                    </div>';
                                    }
                                }

                            ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/user.js"></script>
</body>

</html>