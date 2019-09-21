$(document).ready(function() {
	console.log("register.js call..");
	board.nextIndex($(".write_box").find(".uploadedFile").length);
	var formObj = $("form[role='form']");
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
		
		var videoCnt = ($(".write_box").find("iframe").length);
		var str = "<input type='hidden' name='videoCnt' value='" + videoCnt + "'>";

		if(!board.checkEmptyDataBeforeSubmit()) {
			alert("글을 등록하기 위해서는, 제목과 내용을 입력하셔야 합니다.")
			return;
		};
		
		/** 첨부파일 인덱스를 다시 0부터 순차적으로 매긴다 **/
		$(".write_box").find(".uploadImg").each(function(index, item) {
			// console.log($(item).data("index"));
			$(item).attr("data-index", index);
		})
		$(".uploadResult .file_li").each(function(index, item) {
			console.log($(item).data("index"));
			$(item).attr("data-index", index);
		})
		 
		$("textarea").html($(".write_box").html());
		// 각각의 첨부파일마다 서버로 저장할 정보들을 저장한다. 
		$(".uploadResult ul .file_li").each(function(i, obj) {
			var jobj = $(obj);
			str += "<input type='hidden' name='attachList[" + i + "].fileName' value='"+jobj.data("filename")+"'>";
			str += "<input type='hidden' name='attachList[" + i + "].uuid' value='"+jobj.data("uuid")+"'>";
			str += "<input type='hidden' name='attachList["+ i +"].uploadPath' value='"+jobj.data("path")+"'>";
			str += "<input type='hidden' name='attachList[" + i + "].fileType' value='"+jobj.data("type")+"'>";
		})
		formObj.append(str);
		formObj.submit();
	})
	$("button[data-oper='upload']").on("click", function(e) {
		e.preventDefault();
		$(".input_upload").click();
	})
	
	$(document).on("click", ".uploadResult .close_btn" ,function () {
		var thisBtn = $(this);
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		var uploadPath = $(this).data("path")
		var targetLi = $(this).closest("li");
		if(type) {
			type = "image"; 
		}
		
		$.ajax({
			url : '/deleteFile',
			data : {
				fileName : targetFile, 
				type : type,
				uploadPath : uploadPath
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			dataType : 'text',
			type : 'POST',
			success : function(result) {
				alert(result);
				targetLi.remove();
				console.log(thisBtn.data("file"));
				$("[data-info='" + thisBtn.data("file") + "']").remove();
				board.refreshFileUploadPreview($(".uploadResult ul"), "", 15, 5, $(".uploadResult").find(".file_li").length);
			}
		})	
	}) // $(document).on("click", ".uploadResult .close_btn" ,function () {}

	/* 첨부파일 추가 */
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz|mp4|MOV)$");
	var maxSize = 5242880;
	
	function checkExtension(fileName, fileSize) { // 파일 확장자 및 사이즈 체크 메서드.
		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		if (fileSize > maxSize) {
			alert("파일 사이즈 초과 !!");
			return false;
		}
		return true;
	} // checkExtension(fileName, fileSize)
	
	
	/** 파일 업로드 **/
	$("input[type='file']").change(function(e) { // 파일업로드의 input 값이 변하면 자동으로 실행 되게끔 처리
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;

		for (var i = 0; i < files.length; i++) {
			if (!checkExtension(
					files[i].name,
					files[i].size)) {
				return false;
			}
			formData.append("uploadFile",
					files[i]);
		}
		$.ajax({
			url : "/uploadAjaxAction",
			processData : false,
			contentType : false,
			beforeSend: function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
			},
			data : formData,
			type : "post",
			dataType : "json",
			success : function(result) {
				// $(".uploadDiv").html(cloneObj.html());
				board.showUploadedFile(result);
				$("input[type='file']").val("");
			},
			error : function (request,status,error) {
		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
		}) // $.ajax()
	}) // $("input[type='file']").change	
	
	/** 이미지 복사 붙여넣기 막는 이벤트 **/
	$(".write_box").on("paste", function(e) {
		e.preventDefault();
		var pastedData = event.clipboardData ||  window.clipboardData;
		var textData = pastedData.getData('Text');
		window.document.execCommand('insertHTML', false,  textData);
	})
	
	$(".write_box").on("keyup", function(e) {
		var writeBoxVal = $(".write_box").find(".uploadedFile");
		var uploadBoxVal = $(".uploadResult").find(".file_li");
		var writeBoxArr = [];
		var uploadBoxArr = [];

		writeBoxVal.each(function(index, item) {
			writeBoxArr.push($(item).data());
		})
		uploadBoxVal.each(function(index, item) {
			uploadBoxArr.push($(item).data());
		})
		if(writeBoxVal.length != uploadBoxVal.length) {
			$(".uploadResult li").remove();
			var str = "";
			writeBoxVal.each(function(i, item) {
				console.log($(item).data());
				str += "<li class='file_li' " + "data-index='" + i + "'" + "data-thumbpath='" + $(item).data('thumbpath') + "'" + "' data-path='"+ $(item).data('path') +"' data-uuid='"+ $(item).data('uuid') + "' data-filename = '" + $(item).data('filename') + "' data-type='" + $(item).data('type') + "' data-info='"+ $(item).data('info') + "'><div>";
				str += "<button type='button' class='close_btn' data-file=\'"+ $(item).data('uuid') + "_" + $(item).data('filename') +"\' data-type='"+ $(item).data('type') + "' data-path='" + $(item).data('path') + "' data-uuid='"+ $(item).data('uuid') +"'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="
						+ $(item).data('thumbpath')
						+ "'>";
				str += "</div></li>";
			})
			board.refreshFileUploadPreview($(".uploadResult ul"), str, 15, 5, $(".uploadResult").find(".file_li").length);
		} 
	}); // $(".write_box").on("keyup", function(e) {}
	
})
