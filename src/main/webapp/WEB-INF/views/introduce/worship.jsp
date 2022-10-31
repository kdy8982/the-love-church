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
	<div id="title_wrap" class="title_wrap title_ministry">
		<div class="title title-font">
			<span>더사랑 교회,</p>
			<span>꽃피는 봄날</p>
		</div>
	</div>
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/seniorpastor'">담임목사</div>
			<!-- <div class="church_introduce_menu" OnClick="location.href ='/introduce/footprints'">발자취</div> -->
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/ministry'" >사역</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/worship'" style="text-decoration: underline; text-underline-position: under;">예배 안내</div>
		</div>
		<div class="content worship">
			<div class="content_title normal-font"><p>예배 안내</p></div>
			<div class="worship_kind">	
				<div class="worship_title_wrap">
					<span class="worship_title">주일 예배</span>
				</div>
				주일 오전 10시 다음세대부<br> 
				주일 오전 11시 장년부<br>
				주일 오후 3시   영아/유치부<br>
			</div>
			<div class="worship_kind">
				<div class="worship_title_wrap">
					<span class="worship_title">수요 예배</span>
				</div>
				매주 수요일 저녁 8시	
			</div>
			<div class="worship_kind">	
				<div class="worship_title_wrap">
					<span class="worship_title">금요 독서 모임</span>
				</div>
				매주 금요일 오전 10시
			</div>
			<div class="worship_kind">
				<div class="worship_title_wrap">
					<span class="worship_title">New Temple Stay</span>
				</div>
				매주 둘째주 토요일
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