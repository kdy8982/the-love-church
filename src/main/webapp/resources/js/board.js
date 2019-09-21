console.log("Board Module..................");

/** board 클로저 **/
var board = (function() {
	var nextIndex = 0; // 자유변수. 메서드의 호출 이후에도 계속해서 값이 유지가 된다.
	
	nextIndex = function (index) {
		nextIndex = index;
	}
	
	/** 
	 * list 페이지에서 출력할 때 사용. 
	 * CSS display:flex속성의 justify-content: space-between 사용시,
	 * 가운데 정렬할 경우 의도치 않게 발생하는 마진을 조정하기 위해, 
	 * 가상의 <li></li>태그를 계산하여 덧붙여주는 function이다.
	 * makeAndAppendEmptyLi(한 페이지에 표현되는 전체 게시글 수, 한줄당 게시글 수, 실제 게시글 수) **/
	function makeEmptyLi(allPhotoCount, aRowCount, photoCount) {
		var row = Math.ceil(photoCount / aRowCount);   
	    var makeEmptyLiCount = (aRowCount * row) - photoCount;
	    var str = "";
	    
	   	for	(i=0; i<makeEmptyLiCount; i++) {
	   		str += "<li style='visibility: hidden'></li>";
	   	}
	   	return str;
	}
	
	function refreshFileUploadPreview(ulTag, str, allPhotoCount, aRowCount, photoCount) {
		var oldFileLi;
		var emptyLi;
		
		if(photoCount == 0 ) {
			ulTag.html("")
		}
		
		if(ulTag.children(".file_li").length != 0) {
			oldFileLi = ulTag.children(".file_li");
			ulTag.html("");
			ulTag.append(oldFileLi);
		}
		
		ulTag.append(str);
		photoCount = ulTag.find(".file_li").length;
		emptyLi = makeEmptyLi(allPhotoCount, aRowCount, photoCount);
		ulTag.append(emptyLi)

		/*
		ulTag.find(".file_li").each(function(i, obj) {
			$(this).attr('data-index', i) ;
		})
		*/
	}
	
	// input 박스에 새롭게 이미지를 추가했을 때 발생하는 function
	function showUploadedFile(uploadResultArr) {
		console.log("nextIndex.. : " + nextIndex)
		
		if (!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
	
		var uploadResult = $(".uploadResult ul");
		var str = "";
		$(uploadResultArr).each(function(i, obj) {
			if (obj.image) {
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
				
				$(".write_box").append("<p><a onclick=\"javascript:showImage(\'"+ originPath +"\')\"><img class=uploadedFile" + " data-index='" + nextIndex + "' "+ "data-thumbpath='" + fileCallPath + "'" + " data-path= '" + obj.uploadPath + "'" + " data-uuid='" + obj.uuid + "'" + " data-filename='"+ obj.fileName + "'" + " data-type= '" + obj.image + "'" + " data-info='" + obj.uuid + "_" + obj.fileName + "' src='/display?fileName=" + fileCallPath + "'></a></p></br>");
				
				str += "<li class='file_li' " + "data-index='" + nextIndex + "'" + "data-thumbpath='" + fileCallPath + "'" + "' data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid + "' data-filename = '" + obj.fileName + "' data-type='" + obj.image + "' data-info='"+ obj.uuid + "_" + obj.fileName +"'><div>";
				str += "<button type='button' class='close_btn' data-file=\'"+ obj.uuid + "_" + obj.fileName +"\' data-type='"+obj.image+"' data-path='" + obj.uploadPath  +"'><i class='fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="
						+ fileCallPath
						+ "'>";
				str += "</div></li>";
			} else {
				//console.log(obj);
				// src='/display?fileName=" + originPath + "'					
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
				
				console.log(originPath)
				
				var onlyFilename = obj.fileName.split(".");
				var videoStr = "";
				videoStr += '<br>';
				videoStr += '<video class="uploadedFile video" '+ 'data-index="' + nextIndex + '" '+ 'data-thumbpath="' + fileCallPath + '"' + ' data-path= "' + obj.uploadPath + '"' + ' data-uuid="' + obj.uuid + '"' + ' data-filename="'+ obj.fileName + '"' + ' data-type= "' + obj.image + '"' + ' data-info="' + obj.uuid + '_' + obj.fileName + '" controls="true">';
				// videoStr += '<source src="' + originPath + '" type="video/mp4">';
				videoStr += '<source src="/display?fileName=' + originPath + '" type="video/mp4">';
				// videoStr += '<source src="/resources/video.mp4" type="video/mp4">';
				videoStr +=	'</video>';
				videoStr += '<br>';
				// $(".write_box").append(videoStr);
				
				$(".write_box").focus();
				pasteHtmlAtCaret(videoStr)
				
				str += "<li class='file_li' " + "data-index='" + nextIndex + "'" + "data-thumbpath='" + fileCallPath + "'" + "' data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid + "' data-filename = '" + obj.fileName + "' data-type='" + obj.image + "' data-info='"+ obj.uuid + "_" + obj.fileName +"'>"
				str += "<div>";
				str += "<button type='button' class='close_btn' data-file=\'"+ obj.uuid + "_" + obj.fileName +"\' data-type='"+obj.image+"' data-path='" + obj.uploadPath  +"'><i class='fa fa-times'></i></button><br>";
				str += "<p class='thumb'><i class='fa fa-play-circle-o' aria-hidden='true'></i></p>";
				str += "<p class='filename'>" +  obj.fileName + "</p>";
				str += "</div>";
				str += "</li>";
			}
			nextIndex++;
		});
		
		board.refreshFileUploadPreview(uploadResult, str, 15, 5, uploadResult.children(".file_li").length);
	} // showUploadedFile(uploadResultArr)	
	
	function checkEmptyDataBeforeSubmit() {
		//console.log($("textarea[name='content']"));
		if(($(".write_box").get(0).childNodes.length == 0) || ($(".form_title").val() == "")) {
			return false;
		}
		return true;
	}
	
	function pasteHtmlAtCaret(html) {
		console.log("call pasteHtmlAtCaret..!!")
	    var sel, range;
	    if (window.getSelection) {
	        // IE9 and non-IE
	        sel = window.getSelection();
	        if (sel.getRangeAt && sel.rangeCount) {
	            range = sel.getRangeAt(0);
	            range.deleteContents();

	            // Range.createContextualFragment() would be useful here but is
	            // non-standard and not supported in all browsers (IE9, for one)
	            var el = document.createElement("div");
	            el.innerHTML = html;
	            var frag = document.createDocumentFragment(),
	                node, lastNode;
	            while ((node = el.firstChild)) {
	                lastNode = frag.appendChild(node);
	            }
	            range.insertNode(frag);

	            // Preserve the selection
	            if (lastNode) {
	                range = range.cloneRange();
	                range.setStartAfter(lastNode);
	                range.collapse(true);
	                sel.removeAllRanges();
	                sel.addRange(range);
	            }
	        }
	    } else if (document.selection && document.selection.type != "Control") {
	        // IE < 9
	        document.selection.createRange().pasteHTML(html);
	    }
	}

	
	return {
		makeEmptyLi: makeEmptyLi,
		refreshFileUploadPreview: refreshFileUploadPreview,
		showUploadedFile: showUploadedFile,
		checkEmptyDataBeforeSubmit: checkEmptyDataBeforeSubmit,
		nextIndex: nextIndex
	};
	
})();