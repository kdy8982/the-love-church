<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script type="text/javascript" src="/resources/js/getPhotoBoardJS.js"></script>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function() {
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	var replyer;
	var bnoValue = <c:out value="${photo.bno}" />;
	var thumbPhoto ;
	<sec:authorize access="isAuthenticated()">;
		replyer = '<sec:authentication property="principal.username"/>';
		userId = '<sec:authentication property="principal.member.userid"/>';
		thumbPhoto = '<sec:authentication property="principal.member.thumbPhoto"/>';
	</sec:authorize>
	replyService.init(replyer, bnoValue, thumbPhoto, csrfHeaderName, csrfTokenValue);
})

</script>

<title>Insert title here</title>
</head>
<body>
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>

	<div class="page_wrap">
		<div class="title_wrap photo">
			<div class="main_title_wrap">
				<h2 class="wrap-inner main_title title-font">사진</h2>
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
				<div class="list_wrap notice_get_wrap">
					<div id="table">

						<div class="row notice_title">${photo.title }</div>

						<div class="row notice_info">
							<div class="row notice_writer">${photo.writer }</div>

							<div class="row notice_date">
								<fmt:formatDate pattern="yyyy-MM-dd" value="${photo.regdate}" />
							</div>
						</div>

						<div class="row notice_content_box" ondragstart="return false">
							<div class="notice_content">${photo.content }</div>
						</div>

						<div class="row bottom_wrap">
							<div class="reply_paging_box"></div>
							<div class="reply_write_li">
								<sec:authorize access="isAuthenticated()">
									<div class="reply_thumb_box">
										<div class="thumb"
											style="background: url(/display?fileName=<sec:authentication property="principal.member.thumbPhoto"/>)no-repeat top center; background-size:cover; background-position: center">
										</div>
									</div>
									<div class="reply_write_box">
										<textarea placeholder="새로운 댓글을 작성해보세요!"></textarea>
										<div class="reply_btn_box">
											<button class="btn small_btn reply_btn">댓글 올리기</button>
										</div>
									</div>
								</sec:authorize>

								<sec:authorize access="isAnonymous()">
									<div class="reply_write_box">
										<textarea placeholder="댓글을 작성하시려면, 로그인 하셔야 합니다."
											readonly="readonly"></textarea>
									</div>
								</sec:authorize>
							</div>

							<div class="notice_btn">
								<ul>
								</ul>
								<button class="btn normal_btn" data-oper="list">목록</button>
								<sec:authorize access="isAuthenticated()">
									<sec:authentication property="principal.member.userid"
										var="loginuserid" />
									<c:if test="${photo.writer eq loginuserid }">
										<button class="btn normal_btn" data-oper="modify">수정</button>
									</c:if>
								</sec:authorize>
							</div>
						</div>

						<form id="openForm" action="/photo/modify" method="post">
							<input type="hidden" id="bno" name="bno"
								value='<c:out value="${photo.bno}"/>' /> <input type="hidden"
								id="writer" name="writer"
								value='<c:out value="${photo.writer}"/>' /> <input
								type="hidden" id="pageNum" name="pageNum"
								value='<c:out value="${cri.pageNum}"/>'> <input
								type="hidden" id="amount" name="amount"
								value='<c:out value="${cri.amount}"/>'> <input
								type="hidden" id="keyword" name="keyword"
								value='<c:out value="${cri.keyword}"/>'> <input
								type="hidden" id="type" name="type"
								value='<c:out value="${cri.type}"/>' /> <input type="hidden"
								name="${_csrf.parameterName}" value="${_csrf.token}" />
						</form>
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
	</div>
</body>
</html>