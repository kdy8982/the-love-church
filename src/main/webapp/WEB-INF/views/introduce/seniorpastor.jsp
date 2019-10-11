<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@page import="java.net.URLEncoder"%>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script type="text/javascript" src="/resources/js/board.js"></script>
<script>
</script>

<title>Insert title here</title>
</head>
<body>
<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
<div class="page_wrap">
	<div id="title_wrap" class="title_wrap title_pastor">
		<div class="title title-font">
			<p>하나님 나라,</p>
			<p>이곳에 내려오다.</p>
		</div>
	</div>
	
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" style="text-decoration: underline; text-underline-position: under;" OnClick="location.href ='/introduce/seniorpastor'">담임목사</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/footprints'">발자취</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/ministry'">사역</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/worship'">예배 안내</div>
		</div>
		
		<div class="content church">
		<div class="content_wrap">
			<div class="content_title normal-font">
				<p>
					하나님의 종으로,<br>
					 열심히 섬기겠습니다.<br>
				 </p>
			 </div>
			<p class="sectionp leftp">	
				하나님 나라의 독립군으로 살고 있습니다. <br>
				그 사랑으로 더사랑하며 사는<br>
				사람다운 삶을 추구합니다.<br><br>
				
				아세아연합신학대학원 M.div<br>
				실천신학대학원대학교에서 공부중<br>
			</p>
		</div>
			<div class="pastor_profile"><img src="http://drive.google.com/uc?export=view&id=1SqB8s3wL7NQig_u7rYVr1miqZ1gvY2Gg"></p>
		</div>
	</div>
	<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
</div>
	
	<div id="mask"></div>
		
	<form id="actionForm" action="/photo/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>
	


</body>
</html>