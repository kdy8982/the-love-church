<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>

<style>
.uploadResult {
	width : 100%;
	background-color: gray;
}
.uploadResult ul {
	display : flex;
	flex-flow : row;
	justify-content : center;
	align-items:center;	
}
.uploadResult ul li {
	list-style:none;
	padding:10px;
	align-center: center;
	text-align:center;
}

.uploadResult ul li img {
	width:100px;
}

.uploadResult ul li span {
	color:white;
}

.bigPictureWrapper {
	position : absolute;
	display:none;
	justify-content : center;
	align-items: center;
	top:0%;
	width:100%;
	height:100%;
	background-color: gray;
	z-index:100;
	background: rgba(255,255,255,0.5);
}
.bigPicture {
	position : relative;
	display : flex;
	justify-content : center;
	align-items : center;
}

.bigPicture img{
	width:600px;
}
</style>



<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Read</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<div class="row">
	<div class="col-lg-12">
		<div class="card">
		
			<div class="card-header">글 수정</div>
			<!-- /.panel-heading -->
			<div class="card-block">
				<form role="form" action="/board/modify" method="post">
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>제목</label>
						<input class="form-control" name='title' value='<c:out value="${board.title}"/>'>
					</div>					
					<div class="form-group">
						<label>글 내용</label>
						<textarea class="form-control" rows="3" name='content'><c:out value="${board.content}"/></textarea>
					</div>					
					<div class="form-group">
						<label>작성자</label>
						<input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>					
					<div class="form-group">
						<label>등록일</label>
						<input class="form-control" name='regDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}"/>' readonly="readonly">
					</div>							
					<div class="form-group">
						<label>수정일</label>
						<input class="form-control" name='updateDate' value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updatedate}"/>' readonly="readonly">
					</div>						
					<sec:authentication property="principal" var="pinfo"/>
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.username eq board.writer}">
							<button type="submit" data-oper='modify' class="btn btn-secondary btn-sm">수정</button>
							<button type="submit" data-oper='remove' class="btn btn-secondary btn-danger btn-sm">삭제</button>
						</c:if>
					</sec:authorize>

					<button type="submit" data-oper='list' class="btn btn-secondary btn-info btn-sm">목록으로</button>
					
					<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
					<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
					<input type="hidden" name="type" value="<c:out value='${cri.type}'/>"/>
					<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>"/>
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
				</form>
			</div>
		</div>
	</div>
</div>

<div class="bigPictureWrapper">
	<div class='bigPicture'>
	</div>
</div> 

<div id="row">
	<div class="card">
		<div class="card-header" style="padding-right: 10px;">
			Files
		</div>
		
		<div class="form-group uploadDiv">
			<input type="file" name="uploadFile" multiple>
		</div>
		
		<div class="card-block uploadResult">
			<ul>
			</ul>
		</div>
	</div>
</div>


<%@include file="../includes/footer.jsp"%>

<script type="text/javascript">
$(document).ready(function() {
	/* 첨부파일 사진 뿌리기 */
	var bno = '<c:out value = "${board.bno}"/>';
	
	$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
		console.log(arr);
		
		var str="";
		
		$(arr).each(function(i, attach) {
			//image type (썸네일1)
			if(attach.fileType) {
				var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+ "_" + attach.fileName);
				
				str += "<li data-path='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type='"+ attach.fileType +"' >";
				str += "<div>";
				str += "<span> " + attach.fileName + "</span>"
				str += "<button type='button' data-file='"+ fileCallPath + "' data-type='image' ";
				str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i>";
				str += "</button><br>"
				str += "<img src='/display?fileName="+ fileCallPath +"'>";
				str += "</div>"
				str += "</li>";
			} else {
				str += "<li data-path ='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type ='"+ attach.fileType + "'>";
				str += "<div>"
				str += "<img src='/resources/img/attach.png'>"
				str += "</div>"
				str += "</li>"
			}
		});
		
		$(".uploadResult ul").html(str);
	})
	
	
	/* 서버로 저장 버튼 클릭 이벤트 */
	var formObj = $("form");
	
	$('button').on("click", function(e) {
		
		e.preventDefault();
		
		var operation = $(this).data("oper");
		console.log(operation)
		
		if(operation === 'remove') {
			formObj.attr("action", "/board/remove");
		} else if(operation === 'list') {
			formObj.attr("action", "/board/list").attr("method","get");
			var pageNumTag = $("input[name='pageNum']").clone();
			var amountTag = $("input[name='amount']").clone();
			var keywordTag = $("input[name='keyword']").clone();
			var typeTag = $("input[name='type']").clone();
			formObj.empty();
			formObj.append(pageNumTag);
			formObj.append(amountTag);
			formObj.append(keywordTag);
			formObj.append(typeTag);
		} else if (operation === 'modify') {
			console.log("submit clicked");
			var str ="";

			$(".uploadResult ul li")
			.each(
					function(i, obj) {
						var jobj = $(obj);
						console.log(jobj);

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
		}
		formObj.submit();
	})
	
	
	/* 첨부파일  x버튼 클릭 이벤트 */
	$(".uploadResult").on("click", "button", function(e) {
		console.log("delete file");
		
		if(confirm("Remove this file? ")) {
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	})
	
	/* 첨부파일 추가 */
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
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
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	$("input[type='file']")
			.change(
					function(e) { // 파일업로드의 input 값이 변하면 자동으로 실행 되게끔 처리
						var formData = new FormData();
						var inputFile = $("input[name='uploadFile']");
						var files = inputFile[0].files;
						var cloneObj = $(".uploadDiv").clone();

						for (var i = 0; i < files.length; i++) {
							if (!checkExtension(files[i].name, files[i].size)) {
								return false;
							}
							formData.append("uploadFile", files[i]);
						}

						$.ajax({
							url : "/uploadAjaxAction",
							processData : false,
							contentType : false,
							beforeSend : function(xhr) {
								/* 
								for (var value of formData.values()) {  // 브라우저 정책상, console.log(formData)로 확인이 안된다.
  									console.log(value);
								}
								 */ 
								xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
							},
							data : formData,
							type : "post",
							dataType : "json",
							success : function(result) {
								console.log(result);
								$(".uploadDiv").html(cloneObj.html());
								showUploadedFile(result);
							},
							error : function (request,status,error) {
						        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
							}
						}) // $.ajax()

					}) // $("input[type='file']").change

	function showUploadedFile(uploadResultArr) {

		if (!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}

		var uploadResult = $(".uploadResult ul");
		var str = "";

		$(uploadResultArr)
				.each(
						function(i, obj) {
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

								originPath = originPath
										.replace(
												new RegExp(
														/\\/g),
												"/");

								str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid + "' data-filename = '" + obj.fileName + "' data-type='" + obj.image + "'><div>";
								str += "<span>"
										+ obj.fileName
										+ "</span>";
								str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+ fileCallPath +"\' data-type='image'><i class='fa fa-times'></i></button><br>";
								str += "<img src='/display?fileName="
										+ fileCallPath
										+ "'>";
								// str += "<a href=\"javascript:showImage('" + originPath + "')\"><img src='/display?fileName=" + fileCallPath + "'></a>"; 
								// str += "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>";
								str += "</div></li>";

							} else {

								var fileCallPath = encodeURIComponent(obj.uploadPath
										+ "/"
										+ obj.uuid
										+ "_"
										+ obj.fileName);
								var fileLink = fileCallPath
										.replace(
												new RegExp(
														/\\/g),
												"/");

								str += "<li";
								str += "data-path='"
										+ obj.uploadPath
										+ "' data-uuid= '"
										+ obj.uuid
										+ "' data-fileName"
							}
						});
		// alert(str);
		uploadResult.append(str);
	} // showUploadedFile(uploadResultArr)

	
	
})
</script>
</body>

</html>
