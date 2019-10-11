<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<jsp:include page="inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here1</title>


<script type="text/javascript">
	$(document).ready(function() {
		
		var formObj = $("form[role='form']");
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(".input_area_button").on("click", function(e) {
			e.preventDefault();
			
			if(validate()) {
				formObj.submit();
			};
		})
		
		function validate() {
			var reId = /^[가-힣a-zA-Z0-9]{4,12}$/ // 아이디가 적합한지 검사할 정규식
			var rePw = /^[a-zA-Z0-9]{8,12}$/ // 패스워드가 적합한지 검사할 정규식
			var reEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i; // 이메일이 적합한지 검사할 정규식
			var reName =  /^[가-힣]{2,5}$/ // 이름이 적합한지 검사할 정규식
			
		    var name = $("input[name='username']")
		    var email = $("input[name='useremail']")
			var id = $("input[name='userid']")
			var pw = $("input[name='userpw']")
			var pwConfirm = $("input[name='userpw_confirm']")
			//var email = document.getElementById("email");
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
			if(pw.val() != pwConfirm.val()) {	
				alert("비밀번호 확인 값을 다르게 입력하셨습니다.");
				pwConfirm.val("");
				pwConfirm.focus();
				return false;
			}
			
		     if(!check(reEmail,email.val(),"적합하지 않은 이메일 형식입니다.")) {
		    	 email.val("");
		         return false;
		     }
		     
		     if(!check(reName,name.val(),"이름을 확인해주세요.")) {
		    	 name.val("");
		         return false;
		     }
		     
		     if(!check(reId,id.val(),"아이디는 4~8자의 영문 대소문자와 숫자로만 입력해야합니다.")) {
		    	 id.val("");
		         return false;
		     }
		
		     if(!check(rePw,pw.val(),"패스워드는 8~12자의 영문 대소문자와 숫자로만 입력해야합니다.")) {
		    	 pw.val("");
		         return false;
		     }
		     
		     var ajaxReturn = true; // ajax success data의 return false를 메인 검증 로직에 적용하기 위한 임시 변수
		     $.ajax({
		    	 url : "/checkIdIsSigned", // 아이디 중복 검증
		    	 beforeSend: function(xhr) {
		    		 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
		    	 },
		    	 type : "post",
		    	 async : false,
		    	 dataType : 'json',
		    	 data : id,
		    	 success : function(data) {
		    		 if(data == 1) {
		    			 alert("이미 가입된 아이디 입니다.")
		    			 ajaxReturn = false;
		    		 } 
		    	 }
		     });
		     
		     $.ajax({
		    	 url : "/checkEmailIsSigned", // 이메일 중복 검증
		    	 beforeSend: function(xhr) {
		    		 xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); 
		    	 },
		    	 type : "post",
		    	 async : false,
		    	 dataType : 'json',
		    	 data : email,
		    	 success : function(data) {
		    		 if(data == 1) {
		    			 alert("이미 사용중인 이메일 입니다.")
		    			 ajaxReturn = false;
		    		 } 
		    	 }
		     });
		     
		     if(!ajaxReturn) {
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
			//모달 같은 거 띄운다.
			$('.modal').css("display", "block");
			//$(".modal").show();
		}
		
	})

</script>

</head>
<body>

	<jsp:include page="inc/top.jsp" flush="true"></jsp:include>
	<div class="page_wrap login">
		<div class="layer login">
		</div>
		<div class="login_wrap title-font">
			<h2><c:out value="${error}" /></h2>
			<h2><c:out value="${logout}"/></h2>	
			
			<span class="top_title">EVERY WALL</span>
			<span class="mid_title">IS A DOOR</span>
			<span class="bottom_title">모든 벽은 문 이다</span>
			<div class="login_content">
				<form role="form" method="post" action="/customSignup">
					<div>
						<input class="login_div input_area" type="text" name="username" placeholder="NAME">
					</div>
				
					<div>
						<input class="login_div input_area" type="text" name="userid" placeholder="ID">
					</div>
					
					<div>
						<input class="login_div input_area" type="text" name="useremail" placeholder="EMAIL">
					</div>
					
					<div>
						<input class="login_div input_area password" type="password" name="userpw" placeholder="PASSWORD">
					</div>
					
					<div>
						<input class="login_div input_area password_confirm" type="password" name="userpw_confirm" placeholder="PASSWORD CONFIRM">
					</div>
					
					<div>
						<input class="input_area_button" type="submit" value="가입하기">
					</div>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<!-- <input type="hidden" name="authList[0].auth" value="ROLE_USER" /> -->
				</form>
			</div>
		</div>
	</div>
	<jsp:include page="inc/footer.jsp" flush="true"></jsp:include>
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
</body>
</html>