<?php

  session_start();

  $host= 'localhost';
  $port= '5432';
  $user= 'giang';
  $pass= 'abcdef090';
  $dbname= 'igdb_db';  

  // connect to database
  $db_conn = pg_connect("host=$host port=$port user=$user password=$pass dbname=$dbname") or die('Could not connect: ' . pg_last_error());

  // handle events

  $location = '';
  $redirect = 0;

    // login event
  if (isset($_POST['inputName'])){
    $name = $_POST['inputName'];
    $pass = $_POST['inputPW'];
    //echo "<script language='javascript'>alert('$i $name $pass')</script>";

    // query all users
    $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE name='$name' AND password='$pass';");
    $numrows = pg_numrows($result);
    
      // login success
    if($numrows == 1){
      echo "<script>alert('Login successfully')</script>";

      $row = pg_fetch_array($result, 0);
      $_SESSION['user_id'] = $row['id'];

      $redirect = 1;
      if ($name == 'Admin'){
        $location = "http://localhost/IGDb/admin/admin.php";
      }
      else{
        // redirect to USER interface if user
        $location = "http://localhost/IGDb/store/store.php";
      }
	  
	  // sleep to show success msg before redirect
	  sleep(2);
    }
      // login fail
    else 
      echo "<script>alert('Username or password is incorrect')</script>";
  
    pg_close($db_conn);
    
    if ($redirect){
      header("Location: $location");
      exit();
    }
  }
?>


<!DOCTYPE html>
<html>
<head>
    <title>IGDB</title>
    <link href="style sheet/login.css" rel="stylesheet" />
</head>
<body>
  <div class = "bg">
      <div class="header"></div>
          <div class="logoholder"></div>
      <div class="body">
          <div class="login">
              <div class="loginbg">
              </div>
              <div class="info">
                  <table class="logtable" style="table-layout:fixed;" >
                      <tr>
                          <td class="logTitle">Log in to IGDb</td>
                          <td></td>
                      </tr>
                      <tr></tr>
                      <tr> </tr>
                      <tr></tr>
                      <tr></tr>
                      <tr></tr>
                      <form method="post" name = "login" onsubmit = "return checkValidate()">
                      <tr>
                            <label id="usertag">
                                <td>
                                    <div class = "inputLabel">
                                        <div class = "inputContainer">
                                            <div class = "inputTitle">Username</div>
                                            <div class="userBoxContainer"><input type="name" id="userbox" name = "inputName" style="height:30px;width:470px;"/></div>
                                        </div>
                                    </div>
                                </td>
                            </label>
                            <td id="alert1"></td>
                        </tr>
                        <tr>
                            <label id="pwtag">
                            <td>
                                <div class = "inputLabel">
                                        <div class = "inputContainer">
                                            <div class = "inputTitle">Password</div>
                                            <div class="pwBoxContainer"><input type="password" id="pwbox"name = "inputPW" style="height:30px;width:470px;" /></div>
                                        </div>
                                </div>
                                </td>
                            </label>
                            <td id="alert3"></td>
                        </tr>
                        <tr>
                            <label id="buttonTag">
                            <td>
                                <div>
                                        <div class = "buttonContainer">
                                        <button type="submit" id="button">Sign in</button>
                                        </div>
                                </div>
                            </td>
                            </label>
                            <td id="alert3"></td>
                        </tr>
                      </form>
                      <tr>
                          <td class="register">
                          <p id = "newtosite" style="float: left;">New to IGDb?</p>
                          <p id = "register">Register</p>
                          </td>
                          <td></td>
                      </tr>
                  </table>
              </div>

          </div>
      </div>
      <div class="footer"></div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/loginJS.js"></script>

</body>
</html>
