<?php
    session_start();
    
    if ( isset($_GET['game_id']) ){
        include '../shared.php';
        
        // connect to database
        $db_conn = pg_connect("host=$host port=$port user=$user password=$pass dbname=$dbname") or die('Could not connect: ' . pg_last_error());

        $id = $_GET['game_id'];
        $result = pg_query($db_conn, "SELECT * FROM igdb.games WHERE game_id='$id';");
        $numrows = pg_num_rows($result);
        if ($numrows == 0){
            header("Location: ../store/store.php");
            exit(0);
        }
        $item = pg_fetch_array($result, 0);
        //echo "<script language='javascript'>alert('".$item['title']."')</script>";
    }
    else {
        header("Location: ../store/store.php");
        exit(0);
    }
?>

<!DOCTYPE html>
<html>

<head>
    <title>IGDb</title>
    <link href="style sheet/game_page.css" rel="stylesheet" />
</head>

<body>
    <div class="bg">
        <div class="bodyContainer">
            <?php include '../nav/navigation.php' ?>
            <div class="content">
                <div class="gameTitle"><?php echo $item['title']; ?></div>
                <div class="gameInfo">
                <div id="myCarousel" class="carousel slide" data-ride="carousel">


                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <div class="item active">
                    <img src="../resources/test/game2.png">
                    </div>

                    <div class="item">
                    <img src="../resources/test/game2.png">
                    </div>

                    <div class="item">
                    <img src="../resources/test/game2.png">
                    </div>
                    <div class="item">
                    <img src="../resources/test/game2.png">
                    </div>
                    <div class="item">
                    <img src="../resources/test/game2.png">
                    </div>
                    <div class="item">
                    <img src="../resources/test/game2.png">
                    </div>
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
                    <div class="rightInfo">
                        <div class="gameCover">
                            <img src=pictures/game2.png width="375px" height="151px">
                        </div>
                        <div class="gameDescription">
                            <?php echo $item['description']; ?>
                        </div>
                        <div class="tableContainer">
                            <table class="publisherInfo">
                                <tr>
                                    <td width="150px">Average Score:</td>
                                    <td><?php echo $item['avg_score']?></td> 
                                </tr>
                                <tr>
                                    <td width="150px">Recommends:</td>
                                    <td><?php 
                                        $result = pg_query("SELECT count(*) from igdb.reviews where recommend = TRUE and game_id = ".$item['game_id']."");
                                        $recommend = pg_fetch_array($result, 0);
                                        $result = pg_query("SELECT count(*) from igdb.reviews where game_id = ".$item['game_id']."");
                                        $reviews_num = pg_fetch_array($result, 0);
                                        echo $recommend['count']." / ".$reviews_num['count']; 
                                    ?></td>
                                </tr>
                                <tr>
                                    <td width="150px">Release date:</td>
                                    <td><?php echo $item['release_date']; ?></td>
                                </tr>
                                <tr>
                                    <td width="150px">Publisher:</td>
                                    <td><?php echo $item['publisher']; ?></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="bottomElement">
                    <div class="addContainer">
                        <div class="addText">Add this game to your library</div>
                        <div class="addButtonContainer">
                            <button class="addButton">Add to Library</button>
                        </div>
                    </div>

                    <div class="formContainer">
                        <form method="post" name="review">
                            <label>
                                <div class="review">Write your review</div>
                                <textarea name="comment" class="reviewInput"></textarea>
                            </label>
                            <label>
                                <div class="reviewScore">Do you recommend this game? </div>
                                <label class="checkboxContainer">Recommend
                                    <input type="radio" checked="checked" name="radio">
                                    <span class="checkmark"></span>
                                </label>
                                <label class="checkboxContainer">Not recommend
                                    <input type="radio" name="radio">
                                    <span class="checkmark"></span>
                                </label>

                            </label>
                            <label>
                                <div>
                                    <div class="submitButtonContainer">
                                        <button type="submit" id="submitButton">Submit</button>
                                    </div>
                                </div>
                            </label>
                        </form>
                    </div>
                    <div class=reviewContainer>
                        <div class="reviewMenu">
                            <div class="allReview">All reviews</div>
                            <div class="reviewSortButton">
                                <div class="sortButton">Filter
                                    <span class="sort-menu">
                                        <p class="sortbyDate">Date</p>
                                        <p class="sortbyNeg">Negative first</p>
                                        <p class="sortbyPos">Positive first</p>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <?php 
                            $result = pg_query($db_conn, "SELECT * FROM igdb.reviews where game_id = ".$item['game_id']." ORDER BY review_id ASC;");
                            $arr = pg_fetch_all($result);
                            foreach($arr as $array)
                            {
                                $user_id = $array['user_id'];
                                $result = pg_query($db_conn, "SELECT * FROM igdb.users where user_id = '$user_id'");
                                $user = pg_fetch_array($result, 0);
                                echo '<div class="grid-item">
                                        <span class="userAva">
                                            <img src='.$user['avatar'].' width="100%" height="100%">
                                        </span>
                                        <div class="reviewInfo">
                                            <div class=reviewTop>
                                                <div class="userName">'.$user['name'].'</div>
                                                <div class="reviewRec">'.$array['recommend'].'</div>
                                                <div class="reviewDate">'.$array['review_date'].'</div>
                                                <div class="reviewRating">
                                                <div class="upvote">up</div>
                                                <div class="downvote">down</div>
                                            </div>
                                            </div>
                                            <div class="reviewText">'.$array['game_review'].'</div>
                                        </div>
                                    </div>';
                            }
                        ?>
                        

                    </div>
                </div>

            </div>
        </div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/game_page.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
</body>

</html>