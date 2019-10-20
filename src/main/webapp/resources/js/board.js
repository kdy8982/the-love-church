console.log("Board Module..................");
$(window).bind("pageshow", function(event) {
     if (event.originalEvent.persisted) {
          window.location.reload() 
     }
});
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
		console.log(uploadResultArr)
		console.log("nextIndex.. : " + nextIndex)
		
		if (!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
	
		var uploadResult = $(".uploadResult ul");
		var str = "";
		$(uploadResultArr).each(function(i, obj) {
			console.log(obj.meta.result[0])
			
			if (obj.meta.result[0].image) {
				var fileCallPath = encodeURIComponent(obj.meta.result[0].uploadPath + "/s_" + obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName);
				var originPath = "http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath;
				originPath = originPath.replace(new RegExp(/\\/g), "/");
				
				//$(".write_box").append("<p><a onclick=\"javascript:showImage(\'"+ originPath +"\')\"><img class=uploadedFile" + " data-index='" + nextIndex + "' "+ "data-thumbpath='" + fileCallPath + "'" + " data-path= '" + obj.uploadPath + "'" + " data-uuid='" + obj.uuid + "'" + " data-filename='"+ obj.fileName + "'" + " data-type= '" + obj.image + "'" + " data-info='" + obj.uuid + "_" + obj.fileName + "' src='/display?fileName=" + fileCallPath + "'></a></p></br>");
				//$(".write_box").append("<p><img class=uploadedFile" + "_" + obj.meta.result[0].uuid +" onclick=showImage('" + obj.meta.result[0].uuid + "')" + " data-index='" + nextIndex + "' "+ "data-thumbpath='" + fileCallPath + "'" + " data-path= '" + obj.meta.result[0].uploadPath + "'" + " data-uuid='" + obj.meta.result[0].uuid + "'" + " data-filename='"+ obj.meta.result[0].fileName + "'" + " data-type= '" + obj.meta.result[0].image + "'" + " data-info='" + obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName + "' src='http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath  + "'></p>");

				if(obj.direction == "vertical") {
					$(".write_box").append("<img class='image image_vertical' data-path='" + obj.meta.result[0].uploadPath + "' data-filename='" + obj.meta.result[0].fileName + "' data-uuid='" + obj.meta.result[0].uuid + "' data-type='"+ obj.meta.result[0].image +"' data-thumbpath='http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + "' style='background: url(http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + ")no-repeat center center; background-size: contain;'></img><br>");
				} else {
					$(".write_box").append("<img class='image image_horizontal' data-path='" + obj.meta.result[0].uploadPath + "' data-filename='" + obj.meta.result[0].fileName + "' data-uuid='" + obj.meta.result[0].uuid + "' data-type='"+ obj.meta.result[0].image +"' data-thumbpath='http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + "' style='background: url(http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + ")no-repeat center center; background-size: contain;'></img><br>");
				}
				str += "<li class='file_li' " + "data-index='" + nextIndex + "'" + "data-thumbpath='" + fileCallPath + "'" + "' data-path='"+ obj.meta.result[0].uploadPath +"' data-uuid='"+ obj.meta.result[0].uuid + "' data-filename = '" + obj.meta.result[0].fileName + "' data-type='" + obj.meta.result[0].image + "' data-info='"+ obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName +"'>";
				str += "<button type='button' class='close_btn' data-uuid='" + obj.meta.result[0].uuid + "' data-file=\'"+ obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName +"\' data-type='"+obj.meta.result[0].image+"' data-path='" + obj.meta.result[0].uploadPath  +"'><i class='fa fa-times'></i></button><br>";
				//str += "<img src='http://drive.google.com/uc?export=view&id=" + obj.thumbNailPath + "'>";
				str += "<img class='image image_horizontal' data-thumbpath='http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + "' style='background: url(http://drive.google.com/uc?export=view&id=" + obj.meta.result[0].uploadPath + ")no-repeat center center; background-size: contain;'></img><br>";
				str += "</li>";
			} else {
				var fileCallPath = encodeURIComponent(obj.meta.result[0].uploadPath
						+ "/s_"
						+ obj.meta.result[0].uuid
						+ "_"
						+ obj.meta.result[0].fileName);
				var originPath = obj.meta.result[0].uploadPath
						+ "\\"
						+ obj.meta.result[0].uuid
						+ "_"
						+ obj.meta.result[0].fileName;
				originPath = originPath.replace(new RegExp(/\\/g), "/");
				
				var videoStr = "";
				videoStr += '<br>';
				videoStr += '<video class="uploadedFile video" '+ 'data-index="' + nextIndex + '" '+ 'data-thumbpath="' + fileCallPath + '"' + ' data-path= "' + obj.meta.result[0].uploadPath + '"' + ' data-uuid="' + obj.meta.result[0].uuid + '"' + ' data-filename="'+ obj.meta.result[0].fileName + '"' + ' data-type= "' + obj.meta.result[0].image + '"' + ' data-info="' + obj.meta.result[0].uuid + '_' + obj.meta.result[0].fileName + '" controls="true">';
				// videoStr += '<source src="' + originPath + '" type="video/mp4">';
				videoStr += '<source src="/display?fileName=' + originPath + '" type="video/mp4">';
				// videoStr += '<source src="/resources/video.mp4" type="video/mp4">';
				videoStr +=	'</video>';
				videoStr += '<br>';
				// $(".write_box").append(videoStr);
				
				$(".write_box").focus();
				pasteHtmlAtCaret(videoStr)
				
				str += "<li class='file_li' " + "data-index='" + nextIndex + "'" + "data-thumbpath='" + fileCallPath + "'" + "' data-path='"+ obj.meta.result[0].uploadPath +"' data-uuid='"+ obj.meta.result[0].uuid + "' data-filename = '" + obj.meta.result[0].fileName + "' data-type='" + obj.meta.result[0].image + "' data-info='"+ obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName +"'>"
				str += "<div>";
				str += "<button type='button' class='close_btn' data-file=\'"+ obj.meta.result[0].uuid + "_" + obj.meta.result[0].fileName +"\' data-type='"+obj.meta.result[0].image+"' data-path='" + obj.meta.result[0].uploadPath  +"'><i class='fa fa-times'></i></button><br>";
				str += "<p class='thumb'><i class='fa fa-play-circle-o' aria-hidden='true'></i></p>";
				str += "<p class='filename'>" +  obj.meta.result[0].fileName + "</p>";
				str += "</div>";
				str += "</li>";
			}
			nextIndex++;
			 
			$(".uploadedFile" + "_" + obj.meta.result[0].uuid).load(function() {
				if($(this).height() > $(this).width()) {
					$(".uploadedFile" + "_" + obj.meta.result[0].uuid).addClass("vertical")
				} else {
					$(".uploadedFile" + "_" + obj.meta.result[0].uuid).addClass("horizontal")
				}
			 });
			 
			//console.log($(".uploadedFile" + "_" + obj.uuid).width())
			//console.log($(".uploadedFile" + "_" + obj.uuid).height())
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