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
})
</script>

<title>Insert title here</title>
</head>
<body>

<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
<div class="page_wrap">
	<div class="title_wrap notice">
		<div class="main_title_wrap">
			<span class="wrap-inner main_title title-font">새소식</span>
		</div>
		<div class="sub_title_wrap title-font">
			<span>
			"그래서 우리는 위로를 받았습니다.<br> 
			또한 우리가 받은 위로 위에 디도의 기쁨이 겹쳐서, 우리는 더욱 기뻐하게 되었습니다.<br>
			 그는 여러분 모두로부터 환대를 받고, 마음에 안정을 얻었던 것입니다."<br>
			고린도후서 7장 13절
			</span>
		</div>
	</div>
	<div class="container page_container">
		
		<div class="content">
			<div class="list_wrap notice_wrap">
				<table class ="notice_table">
					<colgroup>
						<col width="60%">
						<col width="40%">
					</colgroup>
					<thead>
						<tr>
							<th class="title">소식</th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${noticeList}" var="notice" varStatus="status" >
							<c:if test="${status.count % 2 == 1}">
								<tr>
									<td class="even"><a class="move" href='<c:out value="${notice.bno}" />'><c:out value="${notice.title}"></c:out></a></td>
									<td class="even"><fmt:formatDate pattern="yyyy-MM-dd" value="${notice.regdate}" /></td>
								</tr>
							</c:if>
													
							<c:if test="${status.count % 2 == 0}">
								<tr>
									<td><a class="move" href='<c:out value="${notice.bno}" />'><c:out value="${notice.title}"></c:out></a></td>
									<td><fmt:formatDate pattern="yyyy-MM-dd" value="${notice.regdate}" /></td>
								</tr>
							</c:if>

						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
		<div class="bottom_wrap">
			<div class="page_box">
				<ul>
					<c:if test="${pageMaker.prev}">
						<li class="page-item">
							<a class="page-link" href="${pageMaker.startPage -1}" aria-label="Previous">
					        	<span aria-hidden="true">&laquo;</span>
								<span class="sr-only">Previous</span>
							</a>
						</li>
					</c:if>
				
					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
						<li class="page-item ${pageMaker.cri.pageNum == num ? "active":""} "><a class="page_num" href="${num}">${num}</a></li>
					</c:forEach>
					
					<c:if test="${pageMaker.next}">
						<li class="page-item next">
							<a class="page-link" href="${pageMaker.endPage + 1}" aria-label="Next">
								<span aria-hidden="true">&raquo;</span>
	   							<span class="sr-only">Next</span>
							</a>
						</li>
					</c:if>
				</ul>
			</div>
			<div class="search_box">
				<form id="searchForm" action="/notice/list" method="get">
					<select class="select" name="type">
						<option value=""> - </option>
						<option value="T" <c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
						<option value="C" <c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
						<option value="W" <c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
					</select>
					<input class="keyword" type="text" name="keyword" value="<c:out value='${pageMaker.cri.keyword }'/>">
					<input type="hidden" name="pageNum" value='<c:out value="${pageMaker.cri.pageNum}"/>'/> 
					<input type="hidden" name="amount" value='<c:out value="${pageMaker.cri.amount}"/>'/>
					<button class="btn normal_btn search_btn">검색</button>
				</form>
			</div>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<div class="notice_btn">
					<button class="btn normal_btn" onclick="location.href='/notice/register'">새소식 쓰기</button>
				</div>
			</sec:authorize>
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