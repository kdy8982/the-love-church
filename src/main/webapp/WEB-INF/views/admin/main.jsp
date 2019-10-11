<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script>

$(document).ready(function() {
	var actionForm = $("#actionForm"); 
	$(".page_num").on("click", function(e) {
		e.preventDefault();
		console.log("click page_num !!!");
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	})
	
	var actionForm = $("#actionForm");
	$(".move").on("click", function(e) {
		e.preventDefault();
		console.log($(this).attr('href'));
		actionForm.append("<input type='hidden' name='bno' value='"+ $(this).attr('href') +"'>");
		actionForm.append("<input type='hidden' name='boardType' value='notice'>");
		actionForm.attr("action", "/notice/get");
		actionForm.submit();
	})
	
	var result = new Array();
	<c:forEach items="${memberList}" var="member">
		var json = new Object();
		json.auth="${member.authList[0].auth}";
		result.push(json);
	</c:forEach>
	
})
</script>

<title>관리자 페이지</title>
</head>
<body>

<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
<div class="page_wrap">
	<div class="container page_container">
		<!-- 
		<div class="title_wrap">
			<h2 class="wrap-inner main_tit title-font">회원 관리</h2>
		</div>
		 -->
		 <!-- 
		<div class="sub_title title-font">
		<h3>
			"그래서 우리는 위로를 받았습니다.<br> 
			또한 우리가 받은 위로 위에 디도의 기쁨이 겹쳐서, 우리는 더욱 기뻐하게 되었습니다.<br>
			 그는 여러분 모두로부터 환대를 받고, 마음에 안정을 얻었던 것입니다."<br>
			고린도후서 7장 13절
		 </h3>
		</div>
		 -->
		<div class="content">
			<div class="list_wrap notice_wrap">
				<table class ="notice_table">
					<colgroup>
						<col width="20%">
						<col width="20%">
						<col width="20%">
						<col width="20%">
						<col width="20%">
					</colgroup>
					<thead>
						<tr>
							<th>아이디</th>
							<th class="title">회원이름</th>
							<th>이메일</th>
							<th>등급</th>
							<th>가입일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${memberList}" var="member" varStatus="status" >
							<c:if test="${status.count % 2 == 1}">
								<tr onClick= "location.href='/admin/memberDetail?userid=${member.userid}'" style="cursor:pointer" >
										<td class="even">${member.userid}</td>
										<td class="even">${member.username}</td>
										<td class="even">${member.useremail}</td>
										<td class="even">
												<c:if test="${member.authList[0].auth eq 'ROLE_USER'}">일반</c:if>
												<c:if test="${member.authList[0].auth eq 'ROLE_MEMBER'}">더사랑 성도</c:if>
												<c:if test="${member.authList[0].auth eq 'ROLE_ADMIN'}">더사랑 관리자</c:if>
										</td>
										<td class="even"><fmt:formatDate pattern="yyyy-MM-dd" value="${member.regDate}" /></td>
								</tr>
							</c:if>
							<c:if test="${status.count % 2 == 0}">
								<tr onClick= "location.href='/admin/memberDetail?userid=${member.userid}'" style="cursor:pointer" >
									<td>${member.userid}</td>
									<td>${member.username}</td>
									<td>${member.useremail}</td>
									<td>
											<c:if test="${member.authList[0].auth eq 'ROLE_USER'}">일반</c:if>
											<c:if test="${member.authList[0].auth eq 'ROLE_MEMBER'}">더사랑 성도</c:if>
											<c:if test="${member.authList[0].auth eq 'ROLE_ADMIN'}">더사랑 관리자</c:if>
									</td>
									<td><fmt:formatDate pattern="yyyy-MM-dd" value="${member.regDate}" /></td>
								</tr>
							</c:if>

						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<div class="bottom_wrap">
		</div>
	</div>
		
	<form id="actionForm" action="/notice/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>

<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
</div>
</body>
</html>