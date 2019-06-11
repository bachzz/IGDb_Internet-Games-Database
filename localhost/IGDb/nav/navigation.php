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

</script>