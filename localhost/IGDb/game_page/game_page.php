<?php
	header("Cache-Control: no cache");
	session_cache_limiter("private_no_expire");
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

        function add_game($game_id, $conn){
            $result = pg_query($conn, "INSERT INTO igdb.library (user_id, game_id, category) VALUES ('".$_SESSION['user_id']."', '$game_id', 3);");
            // if (!$result){
            //     die("Error in query: " . pg_last_error());
            //     //echo "<script>alert('".$status."')</script>";
            // }
        }

        //review submit
        if (isset($_POST['comment']) && isset($_POST['radio']) && isset($_POST['reviewSubmit'])) {
            $comment = $_POST['comment'];
            $radio = $_POST['radio'];
            date_default_timezone_set('Vietnam/Hanoi');
            $date = date('Y/m/d'); 
            if($radio == "rec")
                $recStatus= "TRUE";
            if($radio == "notrec")
                $recStatus = "FALSE";
            // echo "<script>alert('.$recStatus.')</script>";
            $result = pg_query($db_conn, "INSERT INTO igdb.reviews (user_id, game_id, game_review, recommend, review_date) 
                                        VALUES ('".$_SESSION['user_id']."', '".$item['game_id']."', '$comment', '$recStatus', '$date');");
            header("Location: ./game_page.php?game_id=".$item['game_id']."");
            exit();
        }

        //review filter
        if (isset($_POST['reviewFilter'])){
            $reviewFilter = $_POST['reviewFilter'];
            $_SESSION['reviewFilter'] = $reviewFilter;
            if ($reviewFilter == "none")
                $_SESSION['reviewFilter_query'] = "review_id";
            if ($reviewFilter == "date")
                $_SESSION['reviewFilter_query'] = "review_date";
            if ($reviewFilter == "pos")
                $_SESSION['reviewFilter_query'] = "t";
            if ($reviewFilter == "neg")
                $_SESSION['reviewFilter_query'] = "f";
            header("Location: ./game_page.php?game_id=".$item['game_id']."");
            return;
        }

        if (isset($_GET['add_game_id']))
            add_game($_GET['add_game_id'], $db_conn);
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
    <div class="bg" style="background-image: url(../resources/test/bg.png);">
        <div class="bodyContainer">
            <?php include '../nav/navigation.php' ?>
            <div class="content">
                <div class="gameTitle"><?php echo $item['title']; ?></div>
                <div class="gameInfo">
                <!-- carousel start -->
<div class="my-carousel">
                <div class="swiper-container gallery-top">
    <div class="swiper-wrapper">
	  <?php
			$result = pg_query($db_conn, "SELECT * from igdb.games WHERE game_id = '".$item['game_id']."';");
			$items = pg_fetch_all($result);
			foreach($items as $item)
            {
				$img_url = $item['img_url'];
				$cover = strtok($img_url, ";");
				while ($cover !== false) {
					echo '<div class="swiper-slide" style="background-image:url('.$cover.')"></div>';
					$cover = strtok(";");
				}
			}
        ?>

    </div>
    <!-- Add Arrows -->
    <div class="swiper-button-next swiper-button-white"></div>
    <div class="swiper-button-prev swiper-button-white"></div>
  </div>
  <div class="swiper-container gallery-thumbs">
    <div class="swiper-wrapper">
	<?php
			$result = pg_query($db_conn, "SELECT * from igdb.games WHERE game_id = '".$item['game_id']."';");
			$items = pg_fetch_all($result);
			foreach($items as $item)
            {
				$img_url = $item['img_url'];
				$cover = strtok($img_url, ";");
				while ($cover !== false) {
					echo '<div class="swiper-slide" style="background-image:url('.$cover.')"></div>';
					$cover = strtok(";");
				}
			}
        ?>
    </div>
  </div>
</div>

                 <!-- carousel end -->
                    <div class="rightInfo">
                        <div class="gameCover">
						<?php
							$result = pg_query($db_conn, "SELECT * from igdb.games WHERE game_id = '".$item['game_id']."';");
							$items = pg_fetch_all($result);
							foreach($items as $item)
							{
								$img_url = $item['img_url'];
								$cover = strtok($img_url, ";");
									echo '<img src='.$cover.' width="375px" height="151px">	';
							}
						?>
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
                                <tr>
                                    <td width="150px">Genre:</td>
                                    <td><?php echo $item['genre']; ?></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="bottomElement">
                    <div class="addContainer">
                        <div class="addText">Add this game to your library</div>
                        <div class="addButtonContainer">
                            <?php
                                $result = pg_query("SELECT * from igdb.library where user_id=".$_SESSION['user_id']." and game_id=".$item['game_id'].";");
                                $numrows = pg_num_rows($result);

                                if ($numrows == 0)
                                    echo '<a href="game_page.php?game_id='.$item['game_id'].'&add_game_id='.$item['game_id'].'" class="addButton">Add to Library</a>';
                                else echo '<button class="addButton">Added</button>'
                            ?>
                        </div>
                    </div>

                    <?php 
                        $result = pg_query($db_conn, "SELECT DISTINCT * FROM igdb.reviews r 
                        INNER JOIN igdb.games g ON g.game_id = r.game_id 
                        INNER JOIN igdb.users u on r.user_id = u.user_id
                        where u.user_id=".$_SESSION['user_id']." AND g.game_id = '".$item['game_id']."';");
                        $numrows = pg_num_rows($result);

                        if ($numrows == 0) {
							$result = pg_query($db_conn, "SELECT * from igdb.library where user_id=".$_SESSION['user_id']." and game_id=".$item['game_id'].";");
							$numrows = pg_num_rows($result);
							if ($numrows == 0) {
								echo '<div class=reviewContainer>
                                                <div class=yourReview> You must add this game to your library before giving review.</div>
                                                </div></div>';
							}
							else {
								echo '<div class="formContainer">
                                    <form method="post" name="review">
                                        <label>
                                            <div class="review">Write your review</div>
                                            <textarea name="comment" class="reviewInput"></textarea>
                                        </label>
                                        <label>
                                            <div class="reviewScore">Do you recommend this game? </div>
                                            <label class="checkboxContainer">Recommend
                                                <input type="radio" checked="checked" name="radio" value="rec" id="rec">
                                                <span class="checkmark"></span>
                                            </label>
                                            <label class="checkboxContainer">Not recommend
                                                <input type="radio" name="radio" value="notrec" id="notrec">
                                                <span class="checkmark"></span>
                                            </label>

                                        </label>
                                        <label>
                                            <div>
                                                <div class="submitButtonContainer">
                                                    <button type="submit" name="reviewSubmit" id="submitButton">Submit</button>
                                                </div>
                                            </div>
                                        </label>
                                    </form>
                                </div>';
							}
                        }
                        else {
                            $arr = pg_fetch_all($result);
                                    foreach($arr as $array)
                                    {
                                        $title = $array['title'];
                                        $recommend = $array['recommend'];
                                        if ($recommend == 't') $recommend = "Recommended";
                                        if ($recommend == 'f') $recommend = "Not Recommended";
                                        $date = $array['review_date'];
                                        $content = $array['game_review'];
                                        $up = $array['upvote'];
                                        $down = $array['downvote'];
										$game_id = $array['game_id'];
										$review_id = $array['review_id'];
                                        echo '<div class=reviewContainer>
                                                <div class=yourReview> Your review on this game:</div>
                                                </div>
                                                <div class=reviewContainer> 
                                                <div class="grid-item">
                                                <span class="userAva">
                                                    <img src='.$array['avatar'].' width="100%" height="100%">
                                                </span>
                                                <div class="reviewInfo">
                                                    <div class=reviewTop>
                                                        <div class="userName">'.$array['name'].'</div>
                                                        <div class="reviewRec">'.$recommend.'</div>
                                                        <div class="reviewDate">'.$array['review_date'].'</div>
                                                        <div class="reviewRating">
														<div class="upvote">up: '.$up.' </div>
														<div class="downvote">down: '.$down.'</div>
                                                    </div>
                                                    </div>
                                                    <div class="reviewText">'.$array['game_review'].'</div>
                                                </div>
                                            </div>
                                            </div>
                                            </div>';
                        
                                    }
                        }
                    ?>

                    <div class=reviewContainer>
                        <div class="reviewMenu">
                            <div class="allReview">All reviews</div>
                                <form method="post" id="filter-form" class="sortButton">
                            		<select name=reviewFilter onchange="this.form.submit()" class="filterButton">
										<option value="" disabled selected>Filter</option>
										<option class="sortby" value="none">None</option>
										<option class="sortby" value="date">Date</option>
										<option class="sortby" value="pos">Positive only</option>
										<option class="sortby" value="neg">Negative only</option>
                            		</select>
                        		</form>
                            </div>
                        <?php 
                            $reviewFilter = isset($_SESSION['reviewFilter']) ? $_SESSION['reviewFilter'] : '';
                            $reviewFilter_query = isset($_SESSION['reviewFilter_query']) ? $_SESSION['reviewFilter_query'] : 'review_id';
                            
                            if ($reviewFilter_query == "review_date" || $reviewFilter_query == "review_id") {
                                $result = pg_query($db_conn, "SELECT DISTINCT * FROM igdb.reviews r 
                                                INNER JOIN igdb.games g ON g.game_id = r.game_id 
                                                INNER JOIN igdb.users u on r.user_id = u.user_id
                                                WHERE g.game_id = '".$item['game_id']."'
                                                ORDER BY $reviewFilter_query DESC;");
                            }
                            if ($reviewFilter_query == "t" || $reviewFilter_query == "f") {
                                $result = pg_query($db_conn, "SELECT DISTINCT * FROM igdb.reviews r 
                                                INNER JOIN igdb.games g ON g.game_id = r.game_id 
                                                INNER JOIN igdb.users u on r.user_id = u.user_id
                                                WHERE r.recommend = '".$reviewFilter_query."' AND g.game_id = '".$item['game_id']."';");
                            }
                                
                            $numrows = pg_num_rows($result);


                            if ($numrows == 0) {
                                echo 'User has no reviews!';
                            }
                            
                            else {
                                $arr = pg_fetch_all($result);
                                foreach($arr as $array) 
                                {
                                    $title = $array['title'];
                                    $recommend = $array['recommend'];
                                    if ($recommend == 't') $recommend = "Recommended";
                                    if ($recommend == 'f') $recommend = "Not Recommended";
                                    $date = $array['review_date'];
                                    $content = $array['game_review'];
                                    $up = $array['upvote'];
                                    $down = $array['downvote'];
                                    $game_id = $array['game_id'];
                                    $review_id = $array['review_id'];
                                        echo '<div class="grid-item">
                                                <span class="userAva">
                                                    <img src='.$array['avatar'].' width="100%" height="100%">
                                                </span>
                                                <div class="reviewInfo">
                                                    <div class=reviewTop>
                                                        <div class="userName">'.$array['name'].'</div>
                                                        <div class="reviewRec">'.$recommend.'</div>
                                                        <div class="reviewDate">'.$array['review_date'].'</div>
                                                        <div class="reviewRating">
														<div id= up_'.$review_id.' class="upvote" name="uvote" onclick="vote('.$review_id.', 1); this.onclick=false;">up: '.$up.' </div>
														<div id= down_'.$review_id.' class="downvote" name="dvote" onclick="vote('.$review_id.', 0); this.onclick=false;">down: '.$down.'</div>
                                                    </div>
                                                    </div>
                                                    <div class="reviewText">'.$array['game_review'].'</div>
                                                </div>
                                            </div>';
                                    }
                                }
                            
                        ?>
                        

                    </div>
                </div>

            </div>
        </div>
    </div>
    <script src="./javascript/jquery-3.3.1.js"></script>
    <script src="./javascript/game_page.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.1.6/js/swiper.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.1.6/css/swiper.min.css">
</body>

</html>></script>
    <script src="javascript/game_page.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.1.6/js/swiper.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/Swiper/4.1.6/css/swiper.min.css">
</body>

</html>
