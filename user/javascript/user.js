$("#slider").on("scroll", function() {
    $(".slides").css({
      "background-position": $(this).scrollLeft()/6-100+ "px 0"
    });  
  });

function game_onclick(game_id){
	location.href = "../game_page/game_page.php?game_id="+game_id;
}