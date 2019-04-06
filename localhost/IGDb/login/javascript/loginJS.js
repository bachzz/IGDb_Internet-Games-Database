
function checkValidate()                                    
{ 
    var name = document.login.inputName;               
    var password = document.login.inputPW; 
    if (name.value == "")                                  
    { 
        window.alert("Please enter your name."); 
        $('.userBoxContainer').css("border", "1.5px solid red");
        name.focus(); 
        return false; 
    } 
   
    if (password.value == "")                        
    { 
        window.alert("Please enter your password");
        $('.pwBoxContainer').css("border", "1.5px solid red"); 
        password.focus(); 
        return false; 
    } 
   
    return true; 
}

document.getElementById("register").onclick = function () {
    location.href = "http://localhost/IGDb/register/register.php";
};
