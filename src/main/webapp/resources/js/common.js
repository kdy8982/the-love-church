$(function(){
	if( $(window).width()>1024){
		$(window).scroll(function(){
			if( $(window).scrollTop() > 100){
				$("#btn_top").fadeIn(100)
			}else{
				$("#btn_top").stop().fadeOut(100)
			}
		});
		$("#btn_top").click(function(){
			$("html,body").animate({scrollTop:0},200);
		})
	}
});