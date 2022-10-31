$(document).ready(function() {

    $(window).scroll(function() {
        var s_top = jQuery(".main_visual").innerHeight();
        var con_top = jQuery("#section01").innerHeight();
        if ($(this).scrollTop() < s_top
                && !$('.slider').hasClass("fixed")) {
            $('.slider').addClass("fixed");
            //alert(con_top);
        } else if ($(this).scrollTop() > s_top
                && $('.slider').hasClass("fixed")) {
            $('.slider').removeClass("fixed");
        }
    });

    $(window).scroll(function() {
    	if ($(this).scrollTop() > 1) {
    		$('.scroll_btn').fadeOut();
    	} else {
    		$('.scroll_btn').fadeIn();
    	}
    });

	$('#main_slider').bxSlider({
	    mode: 'fade',
	    auto: true,
	    pause: 3000,
	    pager:false,
	    controls: false,
	    infiniteLoop: true,
	    adaptiveHeight: true
	});

	var actionForm = $("#actionForm");
    $(".move").on("click", function(e) {
        e.preventDefault();
        console.log($(this).attr('href'));
        actionForm.append("<input type='hidden' name='bno' value='"+ $(this).find("a").attr('href') +"'>");
        actionForm.append("<input type='hidden' name='boardType' value='notice'>");
        actionForm.attr("action", "/notice/get");
        actionForm.submit();

    })

})