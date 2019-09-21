var modify = (function() {
	var boardType;
	function init(boardType) {
		console.log("init function call..")
		this.boardType = boardType;
	}
	return {
		init : init
	}
})();

$(document).ready(function(){
	board.nextIndex($(".write_box").find(".uploadedFile").length);
	
	var formObj = $("form[role='form']");
	var deleteFileArr = [];
	$("button[data-oper='modify']").on("click",function(e) {
		e.preventDefault();
		var str = "";
		var videoCnt = ($(".write_box").find("iframe").length);
		str += "<input type='hidden' name='videoCnt' value='" + videoCnt + "'>";
		console.log("videoCnt : " + videoCnt);
		
		if(!board.checkEmptyDataBeforeSubmit()){
			alert("글을 등록하기 위해서는, 제목과 내용을 입력하셔야 합니다.")
			return;
		};
		
		/** x버튼 누른, 실제 파일 삭제**/
		$(deleteFileArr).each(function(index, item) {
			$.ajax({
				url : '/deleteFile',
				data : {
					fileName : item.targetFile, 
					uploadPath : item.uploadPath
				},
				beforeSend : function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType : 'text',
				type : 'POST',
				success : function(result) {
				}
			})
		})
		
		/** 첨부파일 인덱스를 다시 0부터 순차적으로 매긴다 **/
		$(".write_box").find(".uploadedFile").each(function(index, item) {
			// console.log($(item).data("index"));
			$(item).attr("data-index", index);
		})
		$(".uploadResult .file_li").each(function(index, item) {
			console.log($(item).data("index"));
			$(item).attr("data-index", index);
		})
		
		str += "<input type='hidden' name='bno' value='" + modify.boardType.bno + "'>";
		
		$("textarea").html($(".write_box").html());
		
		$(".uploadResult ul .file_li").each(function(i, obj) {
			var jobj = $(obj);

			str += "<input type='hidden' name='attachList["
					+ i
					+ "].fileName' value='"
					+ jobj
							.data("filename")
					+ "'>";
			str += "<input type='hidden' name='attachList["
					+ i
					+ "].uuid' value='"
					+ jobj
							.data("uuid")
					+ "'>";
			str += "<input type='hidden' name='attachList["
					+ i
					+ "].uploadPath' value='"
					+ jobj
							.data("path")
					+ "'>";
			str += "<input type='hidden' name='attachList["
					+ i
					+ "].fileType' value='"
					+ jobj
							.data("type")
					+ "'>";
		});
		formObj.append(str).submit();
	})

	$("button[data-oper='delete']").on("click", function(e) {
		e.preventDefault();
		formObj.attr("action", "/photo/delete");

		formObj.append("<input type='hidden' name='bno' value='"+ modify.boardType.bno +"'>")
		formObj.submit();
	})
					
	$("button[data-oper='upload']").on("click", function(e) {
		e.preventDefault();
		$(".input_upload").click();
	})
	

	/* 첨부파일 추가 */
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz|mp4|MOV)$");
	var maxSize = 5242880;

	function checkExtension(fileName, fileSize) { // 파일 확장자 및 사이즈 체크 메서드.
		if (fileSize > maxSize) {
			alert("파일 사이즈 초과 !!");
			return false;
		}

		if (regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드 할 수 없습니다.");
			return false;
		}
		return true;
	} // checkExtension(fileName, fileSize)

	$("input[type='file']").change(function(e) { // 파일업로드의 input 값이 변하면 자동으로 실행 되게끔 처리
		$(".layer").css("display", "block");
		$(".center_wrap").css("display","block");
		
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;

		for (var i = 0; i < files.length; i++) {
			if (!checkExtension(
					files[i].name,
					files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}

		$.ajax({
			url : "/uploadAjaxAction",
			processData : false,
			contentType : false,
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data : formData,
			type : "post",
			dataType : "json",
			success : function(result) {
				// $(".uploadDiv").html(cloneObj.html());
				$(".layer").css("display", "none");
				$(".center_wrap").css("display","none");
				board.showUploadedFile(result);
				$("input[type='file']").val("");
			},
			error : function(
					request,
					status, error) {
				alert("code:"
						+ request.status
						+ "\n"
						+ "message:"
						+ request.responseText
						+ "\n"
						+ "error:"
						+ error);
			}
		}) // $.ajax()
	}) // $("input[type='file']").change

	// 처음 로딩될 때 첨부파일 리스트 뿌려주는 부분
	var bno = modify.boardType.bno;
	$.getJSON("/board/getAttachList", { bno : bno }, function(arr) {
		var str = "";
		var uploadResult = $(".uploadResult ul");
		$(arr).each(function(i, obj) {
			//image type (썸네일)
			if (obj.fileType) {
				var fileCallPath = encodeURIComponent(obj.uploadPath
						+ "/s_"
						+ obj.uuid
						+ "_"
						+ obj.fileName);
				var originPath = obj.uploadPath
						+ "\\"
						+ obj.uuid
						+ "_"
						+ obj.fileName;

				originPath = originPath.replace(new RegExp(/\\/g), "/");
				var onlyFilename = obj.fileName.split(".");
				str += "<li class='file_li' " + "data-index='" + i + "'" + "data-thumbpath='" + fileCallPath + "'" + "' data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid + "' data-filename = '" + obj.fileName + "' data-type='" + obj.fileType + "' data-info='"+ obj.uuid + "_" + onlyFilename[0] +"'><div>";
				str += "<button type='button' class='close_btn' data-file=\'"+ obj.uuid + "_" + obj.fileName +"\' data-type='"+obj.fileType+"' data-path='" + obj.uploadPath + "' data-uuid='"+ obj.uuid +"'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="
						+ fileCallPath
						+ "'>";
				str += "</div></li>";
			} else {
				str += "<li data-path ='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid +"' data-filename='"+ obj.fileName +"' data-type ='"+ obj.fileType + "'>";
				str += "<div>"
				str += "<img src='/resources/img/attach.png'>"
				str += "</div>"
				str += "</li>"
			}
		});
		board.refreshFileUploadPreview($(".uploadResult ul"), str, 15, 5, arr.length)
		// $(".uploadResult ul").html(str);
	})

	$(document).on("click", ".uploadResult .close_btn" ,function () {
		var thisBtn = $(this);
		var targetFile = $(this).data("file");
		var uploadPath = $(this).data("path")
		var targetLi = $(this).closest("li");
		var deleteFile = {
			thisBtn : thisBtn,
			targetFile : targetFile,
			uploadPath : uploadPath,
			targetLi : targetLi
		}
		deleteFileArr.push(deleteFile);
		
		targetLi.remove();
		$("[data-info='" + thisBtn.data("file") + "']").remove();
		board.refreshFileUploadPreview($(".uploadResult ul"), "", 15, 5, $(".uploadResult").find(".file_li").length);
	});
	
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


