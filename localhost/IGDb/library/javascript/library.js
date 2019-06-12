function showEdit() {
  document.getElementById('normalLib').style.visibility = "hidden";
  document.getElementById('normalLibEdit').style.visibility = "visible";
}

function game_onclick(game_id){
	location.href = "../game_page/game_page.php?game_id="+game_id;
}