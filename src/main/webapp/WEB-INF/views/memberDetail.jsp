<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<script src="/resources/vendor/jQuery-File-Upload-10.2.0/js/vendor/jquery.ui.widget.js"></script>
<script src="/resources/vendor/jQuery-File-Upload-10.2.0/js/jquery.iframe-transport.js"></script>
<script src="/resources/vendor/jQuery-File-Upload-10.2.0/js/jquery.fileupload.js"></script>

<script src="https://blueimp.github.io/JavaScript-Load-Image/js/load-image.all.min.js"></script>
<script src="https://blueimp.github.io/JavaScript-Canvas-to-Blob/js/canvas-to-blob.min.js"></script>
<script src="/resources/vendor/jQuery-File-Upload-10.2.0/js/jquery.fileupload-process.js"></script>
<script src="/resources/vendor/jQuery-File-Upload-10.2.0/js/jquery.fileupload-image.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		var formObj = $("form[role='form']");
		var thumbNail = $(".thumb");
		
		/* 확인 : 서버로 전송 버튼 클릭 이벤트 */
		$(".input_area_button").on("click", function(e) {
			e.preventDefault();
			
			var str="";
			if($(".input_area_button").hasClass("modify") && $(".input_area_button").hasClass("pw_modify")) { // 둘다 변경
				formObj.attr("action","memberPhotoPasswordModify");
				console.log(thumbNail.data("path"));
				str += "<input type='hidden' name='photo' value='"+ thumbNail.data("path") +"'>";
				formObj.append(str); 
				
				if(validate()) {
					formObj.submit();
				};
					
			} else if ($(".input_area_button").hasClass("modify") == true && $(".input_area_button").hasClass("pw_modify") == false ) { // 프로필 사진만 변경
				console.log(thumbNail.data("path"));
				formObj.attr("action", "memberPhotoModify");
				str += "<input type='hidden' name='photo' value='"+ thumbNail.data("path") +"'>";
				formObj.append(str); 
				formObj.submit();
				
			} else if ($(".input_area_button").hasClass("modify") == false && $(".input_area_button").hasClass("pw_modify") == true) { // 암호만 변경
				formObj.attr("action", "memberPasswordModify");
				if(validate()) {
					formObj.submit();
				};
				
			} else { // 암호, 프로필사진 둘다 안바뀌었을 때
				location.href="/";
			}
		})
		
		
		function validate() {
			var rePw = /^[a-zA-Z0-9]{8,12}$/ // 패스워드가 적합한지 검사할 정규식
			
			var pw = $("input[name='userpw']")
			var newPw = $("input[name='newpw']")
			var newPwConfirm = $("input[name='newpw_confirm']")
		     // ------------ 이메일 까지 -----------
		    
		    /* input박스 null값 체크 */
			var inputArea = $(".input_area");
			for(var i=0; i < inputArea.length; i++) {
				if(inputArea[i].value == "") {
					alert("입력하지 않은 정보가 있습니다.");
					return false;
				}
			}
		     
			/* 비밀번호 확인 체크 */
			if(newPw.val() != newPwConfirm.val()) {	
				alert("비밀번호 확인 값을 다르게 입력하셨습니다.");
				newPwConfirm.val("");
				newPwConfirm.focus();
				return false;
			}
		
		     if(!check(rePw,newPw.val(),"패스워드는 8~12자의 영문 대소문자와 숫자로만 입력해야합니다.")) {
		    	 newPw.val("");
		    	 newPwConfirm.val("")
		         return false;
		     }
		     
		     if(!check(rePw,newPwConfirm.val(),"패스워드는 8~12자의 영문 대소문자와 숫자로만 입력해야합니다.")) {
		    	 newPw.val("");
		    	 newPwConfirm.val("")
		         return false;
		     }
		     
		     return true;
		 }
		
		 function check(re, what, message) {
		     if(re.test(what)) {
		         return true;
		     }
		     alert(message);
		     //return false;
		 }
		
		
		
		/** 서버와의 통신 결과를 알리기 위한 모달창 띄우기 위한 부분  **/
		var result = '<c:out value="${result}"/>';
		checkModal(result);

		function checkModal(result) {
			if (result === "") {
				return;
			}
			if (parseInt(result) > 0) {

			} else {
				wrapWindowByMask();
			}
		}

		function wrapWindowByMask() {
			//화면의 높이와 너비를 구한다.
			var maskHeight = $(document).height();
			var maskWidth = $(window).width();

			//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
			$('#mask').css({
				'width' : maskWidth,
				'height' : maskHeight
			});

			$('#mask').fadeTo("slow", 0.8);
			
			
			$('.modal_body').html(result);
			//모달 띄운다.
			$('.modal').css("display", "block");
			//$(".modal").show();
		}

		$(".normal_btn.close").on("click", function() {
			$(".modal").css("display", "none");
			$("#mask").css("display", "none");
		})
		
		/*
		$("input[type='file']").change (function(e) { // 프로필 사진 파일 저장 formdata
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			for(var i = 0; i < files.length; i++) {
				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}
				formData.append("uploadFile", files[i]); //FormData에 "uploadFile"이라는 이름으로 파일을 append시킨다.
			}
			
			$.ajax({
				url : "uploadAjaxAction",
				processData : false, // 기본적으로 String(키:밸류)으로 전송되지만, 파일 전송이기에 object로 보내기 위해 false로 설정한다. 
				contentType : false, 
				beforeSend : function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); // 파일 전송하기 전에 csrf 인증 데이터를 보낸다.
				},
				data : formData, // 이 ajax 요청은 formData를 보내는 것이다. 
				type : "post", 
				dataType : "json",
				success : function(result) { // 서버에 보낸 ajax요청이 성공한 뒤 실행되는 부분. 
					console.log(result);
					showUploadedFile(result);
					$(".input_area_button").addClass("modify");
				},
				error : function(request, status, error) {
			        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			}) // $.ajax();
		})
		*/
		
	}) // document.ready();
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	/* 비밀번호 변경 버튼 클릭 이벤트 : 비밀번호 변경 누를 시, 숨어있던 '새로운 비밀번호'+'새로운 비밀번호 확인'이 나온다. */
	function showPasswordChange() {
		$(".input_area_button").addClass("pw_modify");
		
		$(".show_div").css("display", "none");
		
		var str = '';
		str += '<div class="login_div hidden_div">';
		str += '<span>현재 비밀번호</span>';
		str += '<input class="input_area" type="password" name="userpw" value="">';
		str += '</div>';
		
		str += '<div class="login_div hidden_div">';
		str += '<span>새로운 비밀번호</span>';
		str += '<input class="input_area password" type="password" name="newpw" value="">';
		str += '</div>';
		
		str += '<div class="login_div hidden_div">';
		str += '<span>새로운 비밀번호 확인</span>';
		str += '<input class="input_area password_confirm" type="password" name="newpw_confirm" value="">';
		str += '</div>';
		
		$("form[role='form']").append(str);
		
	} 

	function changeProfilePhoto() {
		$(".input_upload").click();
	    $('.input_upload').fileupload({
	    	url: '/uploadAjaxAction',
	        dataType: 'json',
			beforeSend: function(xhr) {
				$(".layer").css("display", "block");
				$(".center_wrap").css("display","block");
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
			},
	       	singleFileUploads: false,
	        disableImageResize: /Android(?!.*Chrome)|Opera/
	            .test(window.navigator && navigator.userAgent),
	        done: function (e, data) {
	        	$(".input_area_button").addClass("modify");
	        	console.log(data);
				showUploadedFile(data);
				$("input[type='file']").val("");
	        }
	    }); // $('.input_upload').fileupload()
	}
	
	function showUploadedFile(uploadResultArr) {
		if(!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
		
		var uploadResult = $(".profile_wrap");
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			console.log(obj.result[0].uploadPath);
			//var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName); // 썸네일 사진
			//var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName; // 원본 사진
			//originPath = originPath.replace(new RegExp(/\\/g), "/");
			
			$(".thumb").attr("data-path", obj.result[0].uploadPath); // data-path 태그 속성은 업로드 submit시에 formdata로 사용된다. 
			
			$(".unknown_image").remove(); // 기존 unknown image div는 삭제한다.
			
			$(".thumb").css("background", "url(http://drive.google.com/uc?export=view&id=" + obj.result[0].uploadPath + ") no-repeat top center");
			$(".thumb").css("background-size", "cover");
			$(".thumb").css("background-position", "center");
				
		});	
		uploadResult.append(str);
	}
	
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

</script>

</head>
<body>

	<jsp:include page="inc/top.jsp" flush="true"></jsp:include>
	<div class="page_wrap">
	<div class="login_wrap memberDetail">
		<h2><c:out value="${error}" /></h2>
		<h2><c:out value="${logout}"/></h2>	
		
		<div class="profile_wrap">
			<div class="thumb" style="background: url(http://drive.google.com/uc?export=view&id=<sec:authentication property="principal.member.photo"/>)no-repeat top center; background-size:cover; background-position: center">
				<sec:authentication var="userProfilePhoto" property='principal.member.photo'/>
				<c:if test="${userProfilePhoto eq null }">			
					<div class="unknown_image center_wrap">
						<i class="fa fa-user-circle-o" aria-hidden="true"></i>
					</div>
				</c:if> 	
				<i class="fa fa-camera-retro profile_change" aria-hidden="true" onclick="changeProfilePhoto()"></i>
				<input class="input_upload" type="file" name="uploadFile" style="display:none">
			</div>
		</div>
		<div class="login_content">
			<form role="form" method="post" action="/memberModify">
				<div class="login_div">
					<span>이름</span>
					<input class="input_area" type="text" name="username" value="<sec:authentication property="principal.member.username"/>" readonly="readonly">
				</div>
				<div class="login_div">
					<span>아이디</span>
					<input class="input_area" type="text" name="userid" value="<sec:authentication property="principal.member.userid"/>" readonly="readonly">
				</div>
				<div class="login_div">
					<span>회원 유형</span>
					<sec:authentication property="principal.member.authList" var="authList"/>
					
					<input class="input_area" type="text" name="auth" value='<c:if test="${authList[0].auth eq 'ROLE_USER'}">일반</c:if><c:if test="${authList[0].auth eq 'ROLE_MEMBER'}">더사랑 성도</c:if><c:if test="${authList[0].auth eq 'ROLE_ADMIN'}">더사랑 관리자</c:if>' readonly="readonly">
				</div>
				<div class="login_div">
					<span>이메일</span>
					<input class="input_area" type="text" name="useremail" value="<sec:authentication property="principal.member.useremail"/>" readonly="readonly">
				</div>

 				<div class="login_div input_check show_div">
					<span onclick="showPasswordChange()">비밀번호 변경</span>
				</div>
				
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
			<div>
				<input class="input_area_button" type="submit" data-modify="false" value="확인">
			</div>
		</div>
	</div>
	
	<jsp:include page="inc/footer.jsp" flush="true"></jsp:include>
	</div>
	
	<div class="modal">
			<div class="modal_header row">
				<div class="modal_title">알림</div>
				<!-- <button class="close_btn"><i class="fa fa-times" aria-hidden="true"></i></button> -->
			</div>

			<div class="modal_body row">정상적으로 처리 되었습니다.</div>

			<div class="modal_footer row">
				<button class="btn normal_btn close" type="submit">확인</button>
			</div>
		</div>
	<div id="mask"></div>
</body>
</html>