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
                        <div class="storeText">Store</div>
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
                            <p class="logout">Logout</p>
                        </span>
                    </div>
                </div>
            </div>
            <div class="content">
                <div class="gameTitle">Game title</div>
                <div class="gameInfo">
                    <div class="screenshot">
                        <img src=pictures/game2.png width="800px" height="450px">
                    </div>
                    <div class="rightInfo">
                        <div class="gameCover">
                            <img src=pictures/game2.png width="375px" height="151px">
                        </div>
                        <div class="gameDescription">
                            asdijsladfjklsdfjklsajfklsjdfdsjfhsjkdfhsjkhfjksahdfjkashfjkashfkjashfdjkahsfjkahsdfjkhasjklfhasjkdsjksjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksjkdsjkdsdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjksdjklsjksjksjksjksjksjksjksjksjksjksjksjksjkjaf
                        </div>
                        <div class="tableContainer">
                            <table class="publisherInfo">
                                <tr>
                                    <td width="150px">Review Score:</td>
                                    <td>10</td>
                                </tr>
                                <tr>
                                    <td width="150px">Release date:</td>
                                    <td>11/11/2019</td>
                                </tr>
                                <tr>
                                    <td width="150px">Publisher:</td>
                                    <td>EA</td>
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

                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>
                        <div class="grid-item">
                            <span class="userAva">
                                <img src=Pictures/game4.jpg width="200px" height="100px">
                            </span>
                            <div class="reviewInfo">
                                <div class=reviewTop>
                                    <div class="userName">John Doe</div>
                                    <div class="reviewDate">01/01/2019</div>
                                </div>
                                <div class="reviewText">This is game1,
                                    ạdhskljfosdajflkasjfklsajfklsjfklasjfasdfsfsdfsdfsdfsdfsdfsjldf</div>
                            </div>
                        </div>

                    </div>
                </div>










            </div>
        </div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/store.js"></script>
</body>

</html>