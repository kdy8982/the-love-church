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
			<p>더사랑 교회,</p>
			<p>꽃피는 봄날</p>
		</div>
	</div>
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/seniorpastor'">섬기는 이</div>
			<!-- <div class="church_introduce_menu" OnClick="location.href ='/introduce/footprints'">발자취</div> -->
			<div class="church_introduce_menu selected" OnClick="location.href ='/introduce/ministry'">사역</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/worship'">예배 안내</div>
		</div>
		<div class="content ministry">
			<div class="content_title normal-font">진짜 공부방</div>
			<p class="sectionp leftp imagep"></p>
			<p class="sectionp rightp">	
				진짜 공부방이 있는 사방 십리 안에, 돈이 없어 공부의 기회조차 얻지 못하는 아이들이 없도록 하겠습니다.<br> 
				교육 기회의 평등으로 이웃 사랑을 적극적으로 실천하는 행동하는 신앙의 장입니다<br>
				<br>
				더불어 함께 이 아이들의 키다리 아저씨가 되어 주세요. 예수 마을이 되어, 아이들을 함께 키워 가겠습니다.<br>
				진짜 공부방을 위해 기도 부탁드립니다.<br>
				<br>
				<p class="normal-font" style="font-weight: 600; font-size:0.9rem; ">
					 진짜 공부방키다리 아저씨 프로젝트
				</p>
				진짜 공부방에서 꿈을 키우는 아이들은 초등학생이 되는 7세 아이들 9명과 초등학교 6명과 중학생 3명입니다.<br>
				한 아이마다 10만원의 후원금이 필요합니다. <br>
				이 아이들과 공부방의 키다리 아저씨가 되어 주세요. 교회마다 1명씩, 가정마다 우리 아이 학원보낸다고 생각하시고 섬겨주셔도 좋습니다. <br>
				<br>
				■ 후원 안내
				<br>
				- 정기 후원 : <br>
				<a href="https://go.missionfund.org/thelove">https://go.missionfund.org/thelove</a><br>
				
				- 일시 후원 : <br>
				농협 351-1088-1686-23 더사랑교회<br>
			</p>
		</div>
		<div class="content ministry">
			<div class="content_title normal-font"><p>더사랑데이</p></div>
			<p class="sectionp rightp imagep"></p>
			<p class="sectionp leftp">	
				'하나님의 그 사랑으로, 더사랑 하는 날입니다.'<br>
				매월, 이천에 있는 성애원 가족들과 함께하는 문화 공연이 있는 날입니다.<br><br>
				
				벌써 50번이 넘었습니다.<br>
				두살배기 애기가 내년이면 초등학교가고 중2이었던 아이가 대학생이 되었습니다.<br><br>
				
				이렇게 함께 살아가는 날들이 차곡차곡 쌓입니다.<br>
				늘 새로운 사랑이야기가 펼쳐지는 더사랑데이.<br><br>
				
				오선화작가님이 게스트를 초대해주셔서 사랑 가득한 날로 만들어주십니다.<br>
				일상을 공유하는 시간이 최고의 연대입니다.<br>
			</p>
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