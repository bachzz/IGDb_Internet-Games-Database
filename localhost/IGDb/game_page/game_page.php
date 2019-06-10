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
            <div class="header">
                <div class="leftHeader">
                    <div class="logo">
                        <div class="logoText">IGDb</div>
                    </div>
                    <div class="Store">
                        <div class="storeText" id="store">Store</div>
                    </div>
                    <div class="Library">
                        <div class="libText" id="library">Library</div>
                    </div>
                    <div class="Search">
                        <div class="searchText">Search</div>
                    </div>

                    <div class="User">
                        <div class="userText">User</div>
                        <span class="user-menu">
                            <p class="profile" id="user_profile">Profile</p>
                            <p class="logout" id="logout">Logout</p>
                        </span>
                    </div>
                </div>
            </div>
            <div class="content">
                <div class="gameTitle"><?php echo $item['title']; ?></div>
                <div class="gameInfo">
                <div class="slider-wrap">
                        <div class="slider" id="slider">
                            <div class="holder">
                                <div class="slide" id="slide-0" style="background-image:  url(pictures/game1.jpg);
                                background-size: 1280px 720px;">
                                </div>
                                <div class="slide" id="slide-1" style="background-image:  url(pictures/game1.jpg);
                                background-size: 1280px 720px;">
                                </div>
                                <div class="slide" id="slide-2" style="background-image:  url(pictures/game1.jpg);
                                background-size: 1280px 720px;">
                                </div>
                                <div class="slide" id="slide-3" style="background-image:  url(pictures/game1.jpg);
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
                                <textarea rows="7" cols="188" name="comment" class="reviewInput"></textarea>
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
</body>

</html>