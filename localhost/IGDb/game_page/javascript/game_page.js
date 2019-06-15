var galleryTop = new Swiper('.gallery-top', {
    spaceBetween: 10,
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
  });
  var galleryThumbs = new Swiper('.gallery-thumbs', {
    spaceBetween: 10,
    centeredSlides: true,
    slidesPerView: 'auto',
    touchRatio: 0.2,
    slideToClickedSlide: true,
  });
  galleryTop.controller.control = galleryThumbs;
  galleryThumbs.controller.control = galleryTop;

document.getElementsByName("uvote").onClick = function () {
	style = window.getComputedStyle(this);
    color = style.setProperty("color", "red", "!important");
};

$(document).ready(function () {
$(".downvote").click(function () {
	the_id = $(this).attr('id');
	$.ajax({
		type: "POST",
		data: "action=downvote&id=" + $(this).attr("id"),
		url: "vote.php",
		success: function (msg) {
			alert("Success");
		},
		error: function () {
			alert("Error");
		}
	});
});
}); 