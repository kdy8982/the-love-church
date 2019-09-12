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
	})

</script>
</head>
<body>
	<!-- <div class="login background_wrap"></div> -->
	<jsp:include page="inc/top.jsp" flush="true"></jsp:include>

	<div class="page_wrap title-font login">
		<div class="layer login"> 
		</div>
		<div class="login_wrap">
			
			<span class="top_title">EVERY WALL</span>
			<span class="mid_title">IS A DOOR</span>
			<span class="bottom_title">모든 벽은 문 이다.</span>
			<h2><c:out value="${error}" /></h2>
			<h2><c:out value="${logout}"/></h2>	
			<div class="login_content">
				<form method="post" action="/login">
					<div>
						<input class="login_div input_area" type="text" name="username" value="kdy8982" placeholder="ID">
					</div>
					
					<div>
						<input class="login_div input_area" type="password" name="password" value="dusvlf18" placeholder="PASSWORD">
					</div>
					
					<div class="input_check">
						<input  type="checkbox" name="remember-me"><span>Remember Me</span>
					</div>
					
					<div>
						<input class="input_area_button" type="submit" value="로그인">
					</div>
					
					<div class="input_check">
						<a href="/customSignup"><span>회원가입</span></a>
					</div>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
				</form>
			</div>
		</div>
		
		<jsp:include page="inc/footer.jsp" flush="true"></jsp:include>
	</div>
	
</body>
</html>