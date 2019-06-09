<?php
  session_start();

  include '../shared.php';

  // connect to database
  $db_conn = pg_connect("host=$host port=$port user=$user password=$pass dbname=$dbname") or die('Could not connect: ' . pg_last_error());

  $redirect = 0;

  if (isset($_POST['inputEmail'])){
    $name = $_POST['inputName'];
    $email = $_POST['inputEmail'];
    $pass = $_POST['inputPW'];

    // check if email already exists
    $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE email='$email';");
    $numrows = pg_numrows($result);
    if ($numrows == 1){
      echo "<script language='javascript'>alert('User already exists!')</script>";
    }
    else {
      // check if username already exists
      $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE name='$name';");
      $numrows = pg_numrows($result);
      if ($numrows == 1){
        echo "<script language='javascript'>alert('Username already exists!')</script>";
      }
      else {
        $query = "INSERT INTO igdb.users (name, email, password) VALUES ('$name','$email','$pass');";
        $result =  pg_query($query);

        if($result){
          echo "<script language='javascript'>alert('Registered successfully!')</script>";
          
          // get id of user
          $result = pg_exec($db_conn, "SELECT * FROM igdb.users WHERE name='$name';");
          $numrows = pg_numrows($result);
          
          $row = pg_fetch_array($result, 0);
          $_SESSION['user_id'] = $row['user_id'];

          $redirect = 1;
		  
		  // sleep to show success msg before redirect
		  sleep(2);
        }
        else{
          $error = "There was an error! ".pg_last_error(); 
          echo "<script language='javascript'>alert('$error!')</script>";
        }
      }  
    }
    
  }
  
  pg_close($db_conn);

  if ($redirect){
    header("Location: ../store/store.php");
    exit(0);
  }
?>



<!DOCTYPE html>
<html>
<head>
    <title>IGDB</title>
    <link href="style sheet/register.css" rel="stylesheet" />
</head>
<body>
  <div class = "bg">
      <div class="body">
          <div class="login">
          <div class = "createAccTitleContainer">
                <div class = "logTitle">Create your account</div>
          </div>
          <div class="info">
              <table class="logtable" style="table-layout:fixed;">

                  <form method="post" name = "register" onsubmit = "return checkValidate()">
                    <tr></tr>
                    <tr> </tr>
                    <tr></tr>
                    <tr></tr>
                    <tr></tr>
                    <tr>
                        <label id="emailtag"></label>
                            <td>
                                <div class = "inputLabel">
                                    <div class = "inputContainer">
                                        <div class = "inputTitle">Email</div>
                                        <div class="emailBoxContainer"><input type="email" id="emailbox" name = "inputEmail" style="height:30px;width:480px;"/></div>
                                    </div>
                                </div>
                            </td>
                        </label>
                        <td id="alert2"></td>

                    </tr>
                    <tr>
                        <label id="usertag"></label>
                            <td>
                                <div class = "inputLabel">
                                    <div class = "inputContainer">
                                        <div class = "inputTitle">Username</div>
                                        <div class="userBoxContainer"><input type="name" id="userbox" name = "inputName" style="height:30px;width:480px;"/></div>
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
                                        <div class="pwBoxContainer"><input type="password" id="pwbox"name = "inputPW" style="height:30px;width:480px;" /></div>
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
                                    <button type="submit" id="button">Sign up</button>
                                    </div>
                            </div>
                            </td>
                        </label>
                        <td id="alert3"></td>
                    </tr>
                  </form>
                  <!-- <tr>
                      <td class="login">
                      <p id = "switch-login" style="float: left;">Already have account?</p>
                      <p id = "login">Login</p>
                      </td>
                      <td></td>
                  </tr> -->
                  <tr></tr>
                  <tr> </tr>
                  <tr></tr>
                  <tr></tr>
                  <tr></tr>
                  <tr>
                      <td></td>
                      
                  </tr>
                  <tr>
                  </tr>
              </table>
          <!-- </div> -->

          </div>
      </div>
      <div class="footer"></div>
    </div>
    <script src="javascript/jquery-3.3.1.js"></script>
    <script src="javascript/register.js"></script>

</body>
</html>

