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
                <div class="userInfoContainer" style="background-image: url(../resources/test/game2.png); background-size: 1280px 720px;">
                    <span class="userAva">
                        <img src=pictures/game4.jpg width="200px" height="200px">
                    </span>
                    <div class="userInfo">
					<?php 
								$result = pg_query($db_conn, "SELECT * FROM igdb.users WHERE user_id = '".$_SESSION['user_id']."';");
                                $numrows = pg_num_rows($result);

                                if ($numrows == 0) {
                                    echo 'No users found!';
                                }
                                else {
                                    $arr = pg_fetch_all($result);
                                    foreach($arr as $array) {
                                        $userName = $array['name'];
                                        $userEmail = $array['email'];
										echo ' <div class=userNameContainer>
										<div class="userName">'.$userName.'</div>
									</div>
									<div class="userEmail">'.$userEmail.'</div>';
                                    }
                                }

                            ?>
                    </div>
                </div>
                <div class="userStatistic">
					<?php 
						$result = pg_query($db_conn, "SELECT count(game_id) as number_of_games FROM igdb.library WHERE user_id = '".$_SESSION['user_id']."' GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo'<div class="numLeftContainer">
								<div class="numReviewsText">Number of games:</div>
								<div class="numReviews">0</div>
							</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_games'];
								echo'<div class="numLeftContainer">
								<div class="numReviewsText">Number of games:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>
                    
					<?php 
						$result = pg_query($db_conn, "SELECT count(review_id) as number_of_reviews FROM igdb.reviews WHERE user_id = '".$_SESSION['user_id']."' GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo' <div class="numLeftContainer">
								<div class="numReviewsText">Number of reviews:</div>
								<div class="numReviews">0</div>
							</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_reviews'];
								echo' <div class="numLeftContainer">
								<div class="numReviewsText">Number of reviews:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>

					<?php 
						$result = pg_query($db_conn, "SELECT count(game_id) as number_of_playing FROM igdb.library WHERE user_id = '".$_SESSION['user_id']."' AND category = 1 GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo'<div class="numRightContainer">
								<div class="numReviewsText">Currently playing:</div>
								<div class="numReviews">0</div>
							</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_playing'];
								echo'<div class="numRightContainer">
								<div class="numReviewsText">Currently playing:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>

					<?php 
						$result = pg_query($db_conn, "SELECT count(game_id) as number_of_completed FROM igdb.library WHERE user_id = '".$_SESSION['user_id']."' AND category = 2 GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo'<div class="numRightContainer">
							<div class="numReviewsText">Completed:</div>
							<div class="numReviews">0</div>
						</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_completed'];
								echo'<div class="numRightContainer">
								<div class="numReviewsText">Completed:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>
                    
					<?php 
						$result = pg_query($db_conn, "SELECT count(game_id) as number_of_hold FROM igdb.library WHERE user_id = '".$_SESSION['user_id']."' AND category = 3 GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo'<div class="numRightContainer">
							<div class="numReviewsText">Plan to play:</div>
							<div class="numReviews">0</div>
						</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_hold'];
								echo'<div class="numRightContainer">
								<div class="numReviewsText">Plan to play:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>
                    
					<?php 
						$result = pg_query($db_conn, "SELECT count(game_id) as number_of_dropped FROM igdb.library WHERE user_id = '".$_SESSION['user_id']."' AND category = 4 GROUP BY user_id;");
						$numrows = pg_num_rows($result);

						if ($numrows == 0) {
							echo'<div class="numRightContainer">
							<div class="numReviewsText">Dropped:</div>
							<div class="numReviews">0</div>
						</div>';
						}

						else {
							$arr = pg_fetch_all($result);
                            foreach($arr as $array) {
								$num = $array['number_of_dropped'];
								echo'<div class="numRightContainer">
								<div class="numReviewsText">Dropped:</div>
								<div class="numReviews">'.$num.'</div>
							</div>';
							}
						}
					?>
                </div>

				<div class="gamesDisplay">
                    <div class="gameText">
                        <div id="allGames">Library</div>
                        <!-- <div class="storeSortButton">
                            <div class="sortButton">Filter
                                <span class="sort-menu">
                                    <p id="sortbyPlaying" class="sort-item">Currently playing</p>
                                    <p id="sortbyPlayed" class="sort-item">Completed</p>
                                    <p id="sortbyWait" class="sort-item">Plan to play</p>
                                    <p id="sortbyDropped" class="sort-item">Dropped</p>
                                </span>
                            </div>
                        </div> -->
						<form method="post" id="filter-form" class="sortButton">
                            <select name=filter onchange="this.form.submit()">
                                    <option value="" disabled selected>Filter</option>
                                    <option class="sortby" id="sortbyPlaying">Currently playing</option>
                                    <option class="sortby" id="sortbyPlayed">Completed</option>
                                    <option class="sortby" id="sortbyWait">PLan to play</option>
                                    <option class="sortby" id="sortbyDropped">Dropped</option>
                            </select>
                        </form>
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
										$game_id = $array['game_id'];

										echo ' <div class="grid-item">
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

                    <div class="reviewMenu">
                            <div class="allReview">All reviews</div>
                                <!-- <div class="sortButton">Filter
                                    <span class="sort-menu">
                                        <p class="sort-item" id="sort-review-by-date">Date</p>
                                        <p class="sort-item" id="sort-review-by-pos">Negative first</p>
                                        <p class="sort-item" id="sort-review-by-neg">Positive first</p>
                                    </span>
                                </div> -->
								<form method="post" id="filter-form" class="sortButton">
                            		<select name=filter onchange="this.form.submit()">
										<option value="" disabled selected>Filter</option>
										<option class="sortby" id="sort-review-by-date">Date</option>
										<option class="sortby" id="sort-review-by-pos">Negative first</option>
										<option class="sortby" id="sort-review-by-neg">Positive first</option>
                            		</select>
                        		</form>
                            </div>

                    <div class=reviewContainer>
							<?php 
								$result = pg_query($db_conn, "SELECT DISTINCT * FROM igdb.reviews r INNER JOIN igdb.games g ON g.game_id = r.game_id INNER JOIN igdb.library l on l.game_id = g.game_id and l.user_id = r.user_id
															WHERE l.user_id = '".$_SESSION['user_id']."';");
                                $numrows = pg_num_rows($result);

                                if ($numrows == 0) {
                                    echo 'User has no reviews!';
								}
								
								else {
									$arr = pg_fetch_all($result);
									foreach($arr as $array) 
									{
										$title = $array['title'];
										$status = $array['category'];
										$img_url = $array['img_url'];
										$cover = strtok($img_url, ";");
										if ($status == 1) $statusText = "Playing";
										else if ($status == 2) $statusText = "Completed";
										else if ($status == 3) $statusText = "Plan to play";
										else if ($status == 2) $statusText = "Dropped";
										$recommend = $array['recommend'];
										if ($recommend == 't') $recommend = "Recommended";
										if ($recommend == 'f') $recommend = "Not Recommended";
										$date = $array['review_date'];
										$content = $array['game_review'];
										$up = $array['upvote'];
										$down = $array['downvote'];
										$game_id = $array['game_id'];
										echo '<div class="grid-item">
												<span class="userAvaReview">
													<img src='.$cover.' width="100%" height="100%">
												</span>
												<div class="reviewInfo">
													<div class=reviewTop>
														<div class="gameNameReview" onclick="game_onclick(\''.$game_id.'\')">'.$title.'</div>
														<div class="gameStatus">'.$statusText.'</div>
														<div class="reviewRec">'.$recommend.'</div>
														<div class="reviewDate">'.$date.'</div>
														<div class="reviewRating">
														<div class="upvote">up: '.$up.' </div>
														<div class="downvote">down: '.$down.'</div>
													</div>
													</div>
													<div class="reviewText">'.$content.'</div>
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
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/user.js"></script>
</body>

</html>