<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here1</title>


<script type="text/javascript">
	$(document).ready(function() {
		
		var formObj = $("form[role='form']");
		var thumbNail = $(".thumb");
		
		/* 확인 : 서버로 전송 버튼 클릭 이벤트 */
		$(".input_area_button").on("click", function(e) {
			e.preventDefault();
			formObj.submit();
		})
		
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
			//모달 같은 거 띄운다.
			$('.modal').css("display", "block");
			//$(".modal").show();
		}

		$(".normal_btn.close").on("click", function() {
			$(".modal").css("display", "none");
			$("#mask").css("display", "none");
		})
		
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
		
		
		$("select[name='auth']").on("change", function() {
			
			
		})
		
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

	function showUploadedFile(uploadResultArr) {
		if(!uploadResultArr || uploadResultArr.length == 0) {
			return;
		}
		
		var uploadResult = $(".profile_wrap");
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			if(obj.image) {
				var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName); // 썸네일 사진
				var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName; // 원본 사진
				
				originPath = originPath.replace(new RegExp(/\\/g), "/");
				
				$(".thumb").attr("data-path", obj.uploadPath + "_" + obj.uuid+"_" + obj.fileName); // data-path 태그 속성은 업로드 submit시에 formdata로 사용된다. 
				
				$(".unknown_image").remove(); // 기존 unknown image div는 삭제한다.
				
				$(".thumb").css("background", "url(/display?fileName="+ fileCallPath +")no-repeat top center");
				$(".thumb").css("background-size", "cover");
				$(".thumb").css("background-position", "center");
				
			} 
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

	<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	<div class="page_wrap">
	<div class="login_wrap">
		<h2><c:out value="${error}" /></h2>
		<h2><c:out value="${logout}"/></h2>	
		
		<div class="profile_wrap">
			<div class="thumb" style="background: url(/display?fileName=${member.thumbPhoto})no-repeat top center; background-size:cover; background-position: center">
				<c:if test="${member.photo eq null}">			
					<div class="unknown_image center_wrap">
						<i class="fa fa-user-circle-o" aria-hidden="true"></i>
					</div>
				</c:if> 	
			</div>
		</div>
		<div class="login_content">
			<form role="form" method="post" action="/admin/grantAuth">
				<div class="login_div">
					<span>이름</span>
					<input class="input_area" type="text" name="username" value="${member.username}" readonly="readonly">
				</div>
				<div class="login_div">
					<span>아이디</span>
					<input class="input_area" type="text" name="userid" value="${member.userid}" readonly="readonly">
				</div>
				<div class="login_div">
					<span>회원 유형</span>
						<select name="auth">	
							<c:if test="${member.authList[0].auth eq 'ROLE_USER'}"><option value="ROLE_USER" selected>일반</option><option value="ROLE_MEMBER">더사랑 교인</option><option value="ROLE_ADMIN">더사랑 관리자</option></c:if>
							<c:if test="${member.authList[0].auth eq 'ROLE_MEMBER'}"><option value="ROLE_USER">일반</option><option value="ROLE_MEMBER" selected>더사랑 교인</option><option value="ROLE_ADMIN">더사랑 관리자</option></c:if>
							<c:if test="${member.authList[0].auth eq 'ROLE_ADMIN'}"><option value="ROLE_USER">일반</option><option value="ROLE_MEMBER">더사랑 교인</option><option value="ROLE_ADMIN" selected>더사랑 관리자</option></c:if>
						</select>
				</div>
				<div class="login_div">
					<span>이메일</span>
					<input class="input_area" type="text" name="useremail" value="${member.useremail}" readonly="readonly">
				</div>

<!-- 				<div class="login_div hidden_div" style="display:none">
					<span>현재 비밀번호</span>
					<input class="input_area" type="password" name="userpw" value="">
				</div>
				
				<div class="login_div hidden_div" style="display: none">
					<span>새로운 비밀번호</span>
					<input class="input_area password" type="password" name="newpw" value="">
				</div>
				
				<div class="login_div hidden_div" style="display: none">
					<span>새로운 비밀번호 확인</span>
					<input class="input_area password_confirm" type="password" value="">
				</div>
 -->
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
			</form>
			<div>
				<input class="input_area_button" type="submit" data-modify="false" value="확인">
			</div>
		</div>
	</div>
	
	<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
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