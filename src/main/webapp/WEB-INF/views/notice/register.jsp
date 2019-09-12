<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script type="text/javascript" src="/resources/js/board.js"></script>
<script type="text/javascript" src="/resources/js/register.js"></script>
<script>
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
</script>
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
	<div class="page_wrap">
		<div class="title_wrap notice">
			<div class="main_title_wrap">
				<h2 class="wrap-inner main_title title-font">새소식</h2>
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
				<form role="form" action="/notice/register" method="post">
					
					<div class="form-group uploadRow">
						<label>제목</label> <input class="form_title" name='title'>
					</div>

					<div class="form-group uploadRow">
						<label>글 내용</label>
						<textarea style="display:none" name="content"></textarea>
						<div class="write_box" contentEditable="true" ondragstart="return false"></div>
					</div>
					
					<div class="form-group uploadRow">
						<label>작성자</label>
						<input class="form_writer" name='writer' readonly="readonly" value="<sec:authentication property="principal.member.userid"/>">
					</div>
					
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					<input type="hidden" name="boardType" value="notice" />
				</form>
				
				<div class="bottom_wrap">
					<button class="btn normal_btn middle" type="submit">작성완료</button>
				</div>
				
				<div class="file_upload_wrap uploadRow">
					<div class="uploadDiv">
						<input class="input_upload" type="file" name="uploadFile" multiple>
					</div>
					
					<button class="tab_btn middle btn" type="upload">이미지 첨부</button>
					<div class="uploadResult uploadLev">
						<ul></ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
	</div>
		
	<form id="actionForm" action="/notice/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>

</body>
</html>