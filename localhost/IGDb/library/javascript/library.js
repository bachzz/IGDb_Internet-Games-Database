function showEdit() {
  document.getElementById('normalLib').style.display = "none";
  document.getElementById('normalLibEdit').style.display = "block";
}

function game_onclick(game_id){
	location.href = "../game_page/game_page.php?game_id="+game_id;
}