<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags"
	prefix="sec"%>

<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	padding-right: 5px;
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rbga(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>


<%@include file="../includes/header.jsp"%>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시물 등록</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<div class="panel-heading">새글 쓰기</div>
			<!-- /.panel-heading -->
			<div class="panel-body">

				<form role="form" action="/board/register" method="post">
					<div class="form-group">
						<label>제목</label> <input class="form-control" name='title'>
					</div>

					<div class="form-group">
						<label>글 내용</label>
						<textarea class="form-control" rows="3" name='content'></textarea>
					</div>

					<div class="form-group">
						<label>작성자</label> <input class="form-control" name='writer'
							value='<sec:authentication property="principal.username"/>'
							readonly="readonly">
					</div>

					<button type="submit" class="btn btn-default btn-outline-secondary">Submit</button>
					<button type="reset" class="btn btn-default btn-outline-secondary">Reset
						Button</button>

					<input type="hidden" name="${_csrf.parameterName}"
						value="${_csrf.token}" />
				</form>

			</div>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">

			<!-- 파일 업로드 -->
			<div class="panel-heading">File Attach</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple>
				</div>
				<div class="uploadResult">
					<ul>
					</ul>
				</div>
			</div>
		</div>

	</div>
</div>


<%@include file="../includes/footer.jsp"%>


<script>
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	// 삭제 버튼
	$(".uploadResult").on("click", "button", function(e) { // 첨부파일 1시방향에 있는 x버튼을 누를 때 이벤트.
		var targetFile = $(this).data("file");
		var type = $(this).data("type");

		var targetLi = $(this).closest("li");

		$.ajax({
			url : '/deleteFile',
			data : {
				fileName : targetFile,
				type : type
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			dataType : 'text',
			type : 'POST',
			success : function(result) {
				alert(result);
				targetLi.remove();
			}
		});

	})

	// 글 등록 버튼
	$(document).ready(function(e) {
		var formObj = $("form[role='form']");
		var cloneObj = $(".uploadDiv").clone();

		$("button[type='submit']").on("click", function(e) {
			e.preventDefault(); // 기본 submit 동작을 막는다.
			console.log("submit clicked");
			var str = "";
			$(".uploadResult ul li").each(function(i, obj) {
				var jobj = $(obj);
				console.log(jobj);

				str += "<input type='hidden' name='attachList[" + i + "].fileName' value='" + jobj.data("filename") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uuid' value='" + jobj.data("uuid") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].uploadPath' value='" + jobj.data("path") + "'>";
				str += "<input type='hidden' name='attachList[" + i + "].fileType' value='" + jobj.data("type") + "'>";

			});
			//alert(formObj.append(str));
			formObj.append(str).submit();
		});

		/* 첨부파일 추가 */
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz|avi|mp4|MOV)$");
		var maxSize = 5242880;

		function checkExtension(fileName, fileSize) { // 파일 확장자 및 사이즈 체크 메서드.
			console.log(fileName)
			console.log(fileSize)
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

		$("input[type='file']").change(function(e) { // 파일업로드의 input 값이 변하면 자동으로 실행 되게끔 처리
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;

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
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				data : formData,
				type : "post",
				dataType : "json",
				success : function(result) {
					$(".uploadDiv").html(cloneObj.html());
					showUploadedFile(result);
				},
				error : function(request, status, error) {
					alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
				}
			}) // $.ajax()

		}) // $("input[type='file']").change

		function showUploadedFile(uploadResultArr) {

			if (!uploadResultArr || uploadResultArr.length == 0) {
				return;
			}

			var uploadResult = $(".uploadResult ul");
			var str = "";

			$(uploadResultArr).each(function(i, obj) {
				if (obj.image) {

					var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;

					originPath = originPath.replace(new RegExp(/\\/g), "/");

					str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid + "' data-filename = '" + obj.fileName + "' data-type='" + obj.image + "'><div>";
					str += "<span>" + obj.fileName + "</span>";
					str += "<button type='button' class='btn btn-warning btn-circle' data-file=\'"+ fileCallPath +"\' data-type='image'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName=" + fileCallPath + "'>";
					// str += "<a href=\"javascript:showImage('" + originPath + "')\"><img src='/display?fileName=" + fileCallPath + "'></a>"; 
					// str += "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>";
					str += "</div></li>";

				} else {

					var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");

					str += "<li";
					str += "data-path='" + obj.uploadPath + "' data-uuid= '" + obj.uuid + "' data-fileName"
				}
			});
			// alert(str);
			uploadResult.append(str);
		} // showUploadedFile(uploadResultArr)

	}) // $(document).ready
</script>

</body>

</html>
