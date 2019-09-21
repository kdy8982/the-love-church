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