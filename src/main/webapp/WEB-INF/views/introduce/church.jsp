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
	<div id="title_wrap" class="title_wrap title_church">
		<div class="title title-font">
			<p>더사랑 교회,</p>
			<p>꽃피는 봄날</p>
		</div>
	</div>
	
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" style="text-decoration: underline; text-underline-position: under;" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/seniorpastor'">담임목사</div>
			<!-- <div class="church_introduce_menu" OnClick="location.href ='/introduce/footprints'">발자취</div> -->
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/ministry'">사역</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/worship'">예배 안내</div>
		</div>
		
		<div class="content church">
			<div class="content_title normal-font">
				<p>더욱 사랑하는 공간,<br>
				 더사랑 교회입니다.</p>
			</div>
			<p class="church_profile"><img src="/resources/images/index/index2.jpg"></img></p>
			<p class="sectionp leftp">
			 	사람이 온다는 건<br>
			  	실은 어마어마한 일이다<br>
			   	그는<br>
			   	그의 과거와<br>
			   	현재와<br>
			   	그리고<br>
			   	그의 미래와 함께 오기 때문이다<br>
			   	한 사람의 일생이 오기 때문이다<br>
			   	부서지기 쉬운<br>
			   	그래서 부서지기도 했을<br>
			   	마음이 오는 것이다 - 그 갈피를<br>
			   	아마 바람은 더듬어 볼 수 있을<br>
			   	마음,<br>
			   	내 마음이 그런 바람을 흉내낸다면<br>
			   	필경 환대가 될 것이다.<br><br>
			   	사람과 사람이 만나는 기적같은 일이<br> 소소한 일상을 충만하게 합니다.<br> 그 소소함을 소박하게 나누는 더사랑 교회입니다.
			</p>
		</div>
		<div class="content church">
			<div class="content_title normal-font">
				<p>Vision & Mission</p>
			</div>
			<div class="vision_wrap">
				<p class="vision"><img class="vision_image" src="/resources/images/sub/rice.png"></img></p>
				<p class="vision vision_title">	
					환대
				</p>
				<p class="vision vision_content"> 
					이웃 사랑의 실천
				</p>
			</div>
			<div class="vision_wrap">
				<p class="vision"><img class="vision_image" src="/resources/images/sub/community.png"></img></p>
				<p class="vision vision_title">	
					공동체
				</p>
				<p class="vision vision_content"> 
					생명력과 신실함과 돌봄이 있는 공동체
				</p>
			</div>
			<div class="vision_wrap">
				<p class="vision"><img class="vision_image" src="/resources/images/sub/education.png"></img></p>
				<p class="vision vision_title">	
					교육
				</p>
				<p class="vision vision_content"> 
					자유ㆍ평화ㆍ평등 다음 세대 교육을 통한 <br>
					하나님 나라 가치 추구
				</p>
			</div>
		</div>
	</div>
</div>
<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>

	<div id="mask"></div>
		
	<form id="actionForm" action="/photo/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>
	


</body>
</html>