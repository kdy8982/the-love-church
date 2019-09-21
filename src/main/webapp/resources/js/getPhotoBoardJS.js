console.log("photoGet.js call....");
$(document).ready(function() {
	var actionForm = $("#actionForm"); 
	$(".page_num").on("click", function(e) {
		console.log("click page_num !!");
		e.preventDefault();
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	})

	var openForm = $("#openForm");
	$("button[data-oper='list']").on("click", function(e) {
		e.preventDefault();
		openForm.find("#bno").remove();
		openForm.attr("action", "/photo/list");
		openForm.submit();
	})

	$("button[data-oper='modify']").on("click",function(e) {
		e.preventDefault();
		openForm.attr("action", "/photo/modify").submit();
	})
	
	$(".bigPictureWrapper").on("click", function(e) {
		$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
		setTimeout(function(){
			$(".bigPictureWrapper").hide();
		}, 1000);
	});
})

$(document).on("click", ".bigPictureWrapper", function(e) {
	$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
	setTimeout(function() {
		$(".bigPictureWrapper").hide(); 
	}, 1000)
})
function showImage(fileCallPath) {
	$(".bigPictureWrapper").css("display", "flex").show();
	$(".bigPicture").html("<img src='/display?fileName="+ fileCallPath +"'>")
	.animate({width:'100%', height:'100%'}, 1000);
}