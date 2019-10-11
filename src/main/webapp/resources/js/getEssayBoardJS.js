console.log("photoGet.js call....");
$(document).ready(function() {
	var actionForm = $("#actionForm"); 
	$(".page_num").on("click", function(e) {
		console.log("click page_num !!!");
		e.preventDefault();
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	})
	
	var openForm = $("#openForm");
	$("button[data-oper='list']").on("click", function(e) {
		e.preventDefault();
		openForm.find("#bno").remove();
		openForm.attr("action", "/essay/list");
		openForm.submit();
	})
	
	$("button[data-oper='modify']").on("click",function(e) {
		e.preventDefault();
		openForm.attr("action", "/essay/modify").submit();
	})
})

$(document).on("click", ".bigPictureWrapper", function(e) {
	$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
	setTimeout(function() {
		$(".bigPictureWrapper").hide(); 
	}, 1000)
})
function showImage(uuid) {
	var paramObj = {
			"uuid" : uuid	
		};
		
		$.ajax({
			type : 'get',
			url : '/getOriginFileId',
			data : paramObj,
			traditional : true,
			contentType : "application/json; charset=utf-8",
			success : function(result) {
				$(".bigPictureWrapper").css("display", "flex").show();
				$(".bigPicture").html("<img src='http://drive.google.com/uc?export=view&id=" + result + "'>")
				.animate({width:'100%', height:'100%'}, 1000);
			},
			error : function(xhr, status, er) {
				alert("에러 발생");
				location.reload();
			}
		})
		
}