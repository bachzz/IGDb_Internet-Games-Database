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
            <div class="searchText" onclick="showSearch()">Search</div>
            <form action="../search/search.php" method="get" class="search-container" id="search-container" >
                <!-- <input name="searchInput" type="text" placeholder="Search"> -->
                <span class="search-bar-container"><input class="search-bar" name="search_input" placeholder="Search">
                 </span>
                <input type="radio" name="search_type" id="name-search"  value="name-search">
                <span for="name-search" class="search-field">Search by name</span>
                <input type="radio" name="search_type" id="genre-search"  value="genre-search">
                <span for="genre-search" class="search-field">Search by genre</span>
            </form>

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

<script> 
    document.getElementById("store").onclick = function () {
    location.href = "../store/store.php";
};

document.getElementById("library").onclick = function () {
    location.href = "../library/library.php";
};

document.getElementById("user_profile").onclick = function () {
    location.href = "../user/user.php";
};

document.getElementById("logout").onclick = function () {
    location.href = "../login/logout.php";
};

function showSearch() {
  var x = document.getElementById("search-container");
  if (x.style.visibility !== "visible") {
    x.style.visibility = "visible";
  } else {
    x.style.visibility = "hidden";
  }
}

</script>

<style>
    * {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }

  .bg {
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  margin: 0;
  background-size: cover;
  overflow: auto;
}

.bodyContainer {
  position: relative;
  width: 1280px;
  left: 50%;
  margin-left: -640px;
  margin-top: 50px;
  background-color: white;

}


.content {
  width: 1280px;
  overflow: auto;
  background-color: white;
}


.header {
  width: 1280px;
  height: 50px;
  top: 0;
  position: fixed;
  background-color: black;
  display: inline-block;
  z-index: 9999;
}


.leftHeader {
  float: left;
}

.logo {
  cursor: pointer;
  height: 50px;
  width: 80px;
  margin-left: 20px;
  float: left;
  text-align: center;
  color: #000;
  font-weight: bold;
  margin-right: 20px;
}

.Store {
  cursor: pointer;
  width: 150px;
  text-align: center;
  height: 50px;
  float: left;
}

.Library {
  cursor: pointer;
  width: 150px;
  height: 50px;
  float: left;
  text-align: center;

}

.storeText {
  color: #fff;
  font-size: 30px;
  line-height: 50px;
  border-left: 1px solid white;
  border-right: 1px solid white;
}

.logoText {
  color: #fff;
  font-size: 30px;
  line-height: 50px;
}

.libText {
  color: #fff;
  text-align: center;
  line-height: 50px;
  font-size: 30px;
  border-right: 1px solid white;
}

.Search {
  cursor: pointer;
  width: 150px;
  height: 50px;
  float: left;
  text-align: center;

}

.searchText {
  color: #fff;
  text-align: center;
  line-height: 50px;
  font-size: 30px;
  border-right: 1px solid white;
}

.rightHeader {
  float: right;
}

.User {
  cursor: pointer;
  width: 150px;
  height: 50px;
  float: left;
  text-align: center;
  border-left: 1px solid white;
  border-right: 1px solid white;
}

.userText {
  color: #fff;
  text-align: center;
  line-height: 50px;
  font-size: 30px;
  border-right: 1px solid white;
}

.user-menu {
  display: none;
  position: absolute;
  background-color: #f9f9f9;
  width: 150px;
  box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
  z-index: 1;
}

.profile {
  cursor: pointer;
  width: 150px;
  height: 50px;
  line-height: 50px;
  text-align: center;
  margin: 0px;
}

.logout {
  cursor: pointer;
  width: 150px;
  height: 50px;
  line-height: 50px;
  text-align: center;
  margin: 0px;
}

.profile:hover {
  background-color: black;
  color: white;
}

.logout:hover {
  background-color: black;
  color: white;
}

.User:hover .user-menu {
  display: block;
}

    .search-container{
        width:1280px;
        height:100px;
        background-color:white;
        margin-left:-420px;
        visibility:hidden;
        border: 1px solid black;
        overflow: hidden;
    }
    .search-bar{
        float:left;
        width:100%;
        padding:0px 20px;
        height:50px;
        font-size:20px;
        overflow:hidden;
        border-left:none;
        border-right:none;

    }

    .search-field{
     margin-right:30px;
    }


</style>