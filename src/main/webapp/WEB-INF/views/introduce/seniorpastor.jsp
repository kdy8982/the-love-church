<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@page import="java.net.URLEncoder"%>
<%@page import="org.zerock.domain.*"%>

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
			<div class="church_introduce_menu">예배 안내</div>
		</div>
		
		<div class="content church">
			<div class="content_title normal-font">
				<p>하나님의 종으로,<br>
				 열심히 섬기겠습니다.</p>
			 </div>
			<p class="sectionp leftp">	
				당신의 시처럼 하늘을 우러러<br>
				한 점 부끄러움이 없길<br>
				당신의 삶처럼 모든 죽어가는 것을<br>
				사랑할 수 있길<br>
				<br>​
				때론 사는 게 허무하고 무기력할 때<br>
				당신의 육첩방을 밝혔던<br>
				등불을 기억할게<br>
				난 왜 느끼지 못하고 외우려했을까<br>
				용기내지 못하고<br>
				뒤로 숨으려 했을까<br>
				그에게 총칼 대신<br>
				연필 끝에 힘이 있었기에<br>
				차가운 창살 건너편의<br>
				하늘과 별을 바라봐야했네<br>
			</p>
			<p class="sectionp rightp"><img src="/resources/images/sub/lys.jpg"></img></p>
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