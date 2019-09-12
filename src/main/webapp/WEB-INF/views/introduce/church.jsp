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
	<div id="title_wrap" class="title_wrap title_church">
		<div class="title title-font">
			<p>하나님 나라,</p>
			<p>이곳에 내려오다.</p>
		</div>
	</div>
	
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" style="text-decoration: underline; text-underline-position: under;" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/seniorpastor'">담임목사</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/footprints'">발자취</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/ministry'">사역</div>
			<div class="church_introduce_menu">예배 안내</div>
		</div>
		
		<div class="content church">
			<div class="content_title normal-font">
				<p>더욱 사랑하는 공간,<br>
				 더사랑 교회입니다.</p>
			</div>
			<p class="sectionp leftp">
				이네들은 너무나 멀리 있습니다, 별이 아슬히 멀 듯이<br>
				어머님, 그리고 당신은 북간도에 계십니다<br>
				나는 무엇인지 그리워<br>
				이 많은 별빛이 나린 언덕 우에<br>
				내 이름자를 써 보고, 흙으로 덮어 버리었습니다<br>
				딴은 밤을 새워 우는 벌레는<br>
				부끄러운 이름을 슬퍼하는 까닭입니다<br>
				그러나 겨울이 지나고 나의 별에도 봄이 오면<br>
				무덤 우에 파란 잔디가 피어나듯이<br>
				내 이름자 묻힌 언덕 우에도<br>
				자랑처럼 풀이 무성할 게외다<br>
				</p>
			<p class="sectionp rightp"><img src="/resources/images/index/index2.jpg"></img></p>
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