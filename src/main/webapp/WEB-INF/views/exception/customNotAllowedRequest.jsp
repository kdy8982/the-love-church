<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>더사랑교회  :: The Love Community    </title>
</head>
<body>
	<div class="backgroundimg" style="position: relative; height: 100vh; background: url(/resources/images/common/404error.jpg)no-repeat top center; background-size: cover; background-position: center;">
		<div class="layer"></div>
		<div class="error_box center_wrap">
			<div class="error_message">
				<p class="title-font" style="font-size: 1.2rem; text-align: center; font-weight: 600; margin-bottom: 0.7em;">ERROR</p>
				<p>${exception}</p>
				<p>계속해서 같은 문제가 발생하면 관리자에게 문의해주세요.</p>
			</div>
		</div>
	</div>
</body>
</html>