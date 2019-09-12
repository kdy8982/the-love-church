<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
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
		actionForm.append("<input type='hidden' name='boardType' value='essay'>");
		actionForm.attr("action", "/essay/get");
		actionForm.submit();
		
	})
	
	var searchForm = $("#searchForm");
	$(".search_btn").on("click", function(e) {
		e.preventDefault();
		searchForm.submit();
	})
	
	var result='<c:out value="${result}"/>';
	checkModal(result);
	
	function checkModal(result) {
		if(result === "") {
			return;
		}
		if(parseInt(result) > 0) {
			
		} else {
			wrapWindowByMask();
		}
	}
	
    function wrapWindowByMask() {
        //화면의 높이와 너비를 구한다.
        var maskHeight = $(document).height();  
        var maskWidth = $(window).width();
        
        //마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
        $('#mask').css({'width':maskWidth,'height':maskHeight});  

        $('#mask').fadeTo("slow",0.8);    

        //모달 같은 거 띄운다.
    	 $('.modal').css("display", "block");
        //$(".modal").show();
    }
    
    $(".normal_btn.close").on("click", function (){
    	$(".modal").css("display", "none");
    	$("#mask").css("display", "none");
    })
    
    // 리스트 ui 출력을 위한 부분. 
    var emptyLi = board.makeEmptyLi(6, 3, ${fn:length(essayList)});
    $("ul.book_li").append(emptyLi);
    
    // 각 게시글의 제목 미리보기 출력 부분(이미지를 제외하기 위함).
	$(".desc_content_box .content").each(function(i, obj){
		console.log($(obj))
		$(this).html(obj.innerText);
	})
    
})

	
</script>

<title>Insert title here</title>
</head>
<body>
<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
	<div class="page_wrap list">
		<div class="title_wrap essay">
			<div class="main_title_wrap">
				<h2 class="wrap-inner main_title title-font">더사랑 이야기</h2>
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
				<ul class="book_li">
					<c:forEach var="essay" items="${essayList}" varStatus="status">
							<li class="yesupload bg1">
								<a class="move" href="<c:out value='${essay.bno}'/>">
									<c:set var="attach" value="${essay.attachList[0].uploadPath}/s_${essay.attachList[0].uuid}_${essay.attachList[0].fileName}" />
									<%
										String url = (String)pageContext.getAttribute("attach");
										pageContext.setAttribute("filepath", URLEncoder.encode(url));
									%>
									<div class="thumb" style="background: url(/display?fileName=<c:url value='${filepath}'/>)no-repeat top center; background-size: cover; background-position: center;">
									<c:if test="${essay.photoCnt eq '0'}">
										<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>
									</c:if>							
										
										<p class="photo-cntbox">
											<i class="fa fa-youtube-play" aria-hidden="true"></i>+${essay.videoCnt} 
											<i class="fa fa-camera-retro" aria-hidden="true"></i>  +${essay.photoCnt} 
											<i class="fa fa-commenting-o" aria-hidden="true"></i>  +${essay.replyCnt}
										</p>
									</div> 
									<div class="desc_content_box">
										<div class="desc">
											<p class="desc_title">${essay.title}</p>
											<p class="desc_writer">${essay.writer}</p>
											<div class="content">${essay.content}</div>
										</div>
									</div>
								</a>
							</li>		
					</c:forEach>
				</ul>
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
					<form id="searchForm" action="/essay/list" method="get">
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
				<sec:authorize access="isAuthenticated()">
				<div class="notice_btn">
					<button class="btn normal_btn middle" onclick="location.href='/essay/register'">글쓰기</button>
				</div>
				</sec:authorize>
			</div>
			<div class="modal">
					<div class="modal_header row">
						<div class="modal_title">알림</div>
						<!-- <button class="close_btn"><i class="fa fa-times" aria-hidden="true"></i></button> -->
					</div>
					
					<div class="modal_body row">
						정상적으로 처리 되었습니다.
					</div>
					
					<div class="modal_footer row">
						<button class="btn normal_btn close">확인</button>
					</div>
			</div>
		</div>
		
		<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
	</div>
	
	
	<div id="mask">
	
	</div>
		
	<form id="actionForm" action="/essay/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>
	

</body>
</html>