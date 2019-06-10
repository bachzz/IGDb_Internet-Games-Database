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
    <link href="style sheet/store.css" rel="stylesheet" />
</head>

<body>
    <div class="bg">

        <div class="bodyContainer">

            <div class="header">
                <div class="leftHeader">
                    <div class="logo">
                        <div class="logoText">IGDb</div>
                    </div>
                    <div class="Store">
                        <div class="storeText" id="store">Store</div>
                    </div>
                    <div class="Library">
                        <div class="libText">Library</div>
                    </div>
                    <div class="Search">
                        <div class="searchText">Search</div>
                    </div>

                    <div class="User">
                        <div class="userText">User</div>
                        <span class="user-menu">
                            <p class="profile">Profile</p>
                            <p class="logout" id="logout">Logout</p>
                        </span>
                    </div>
                </div>
            </div>


            <div class="content">

                <div class="slider-wrap">
                    <div class="slider" id="slider">
                        <div class="holder">
                        <div class="slide" id="slide-0" style="background-image:  url(Pictures/game1.jpg);
                            background-size: 1280px 720px;">
                            </div>
                            <div class="slide" id="slide-1" style="background-image:  url(Pictures/game1.jpg);
                            background-size: 1280px 720px;">
                            </div>
                            <div class="slide" id="slide-2" style="background-image:  url(Pictures/game1.jpg);
                            background-size: 1280px 720px;">
                            </div>
                            <div class="slide" id="slide-3" style="background-image:  url(Pictures/game1.jpg);
                            background-size: 1280px 720px;">
                            </div>
                        </div>
                    </div>
                    <nav class="slider-nav">
                        <a href="#slide-0" class="active">Slide 0</a>
                        <a href="#slide-1">Slide 1</a>
                        <a href="#slide-2">Slide 2</a>
                        <a href="#slide-3">Slide 3</a>
                    </nav>
                </div>
                <div class="gamesDisplay">
                    <div class=gameText>
                    <div id="allGames">All games</div>
                        <div class="storeSortButton">
                            <div class="sortButton">Filter
                                <span class="sort-menu">
                                    <p class="sortbyDate">Newest first</p>
                                    <p class="sortbyPop">Most popular first</p>
                                    <p class="sortbyScore">Highest rated first</p>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class=gamesContainer>
                        <div class="grid-container">
                            <?php 
                                $result = pg_query($db_conn, "SELECT * FROM igdb.games ORDER BY game_id ASC;");
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
</body>

</html>