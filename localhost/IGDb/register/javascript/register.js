
function checkValidate()                                    
{ 
    var name = document.register.inputName;               
    var email = document.register.inputEmail; 
    var password = document.register.inputPW; 
    var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if (name.value == "")                                  
    { 
        window.alert("Please enter your name."); 
        $('.userBoxContainer').css("border", "1.5px solid red");
        name.focus(); 
        return false; 
    } 
   
    if (email.value == "")                                   
    { 
        window.alert("Please enter your e-mail address."); 
        $('.emailBoxContainer').css("border", "1.5px solid red");
        email.focus(); 
        return false; 
    } 
   
    if (!filter.test(email.value)) {                
        window.alert("Please enter a valid e-mail address."); 
        $('.emailBoxContainer').css("border", "1.5px solid red");
        email.focus(); 
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
