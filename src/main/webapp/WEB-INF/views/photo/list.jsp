<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 
<%@page import="java.net.URLEncoder"%>
<%@page import="org.thelovechurch.domain.*"%>

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
		actionForm.append("<input type='hidden' name='boardType' value='photo'>");
		
		actionForm.attr("action", "/photo/get");
		actionForm.submit();
		
	})
	
	var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = window.location.search.substring(1),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
	        sParameterName = sURLVariables[i].split('=');
	
	        if (sParameterName[0] === sParam) {
	            return sParameterName[1] === undefined ? true : decodeURIComponent(sParameterName[1]);
	        }
	    }
	};
	
	
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
    
    /** 썸네일이 한줄에 네개 이하로  될 시, 예쁘게 정렬되지 않기 때문에 계산하여, 빈<li></li>를 만들어준다. **/
   	var emptyLi = board.makeEmptyLi(12, 4, ${fn:length(photoList)});
    $("ul.gallery_li").append(emptyLi);
})



	
</script>

<title>Insert title here</title>
</head>
<body>
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
			<ul class="gallery_li">
				<c:forEach var="photo" items="${photoList}" varStatus="status">
						<li class="yesupload bg1">
							<div>
							<a class="move" href="<c:out value='${photo.bno}'/>">
								<div class="thumb" style="background: url(${photo.thumbPhoto})no-repeat top center; background-size: cover; background-position: center;">
									<c:if test="${photo.photoCnt eq '0'}">
										<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>
									</c:if>
									<p class="photo-cntbox">
										<i class="fa fa-youtube-play" aria-hidden="true"></i>+${photo.videoCnt} 
										<i class="fa fa-camera-retro" aria-hidden="true"></i>  +${photo.photoCnt} 
										<i class="fa fa-commenting-o" aria-hidden="true"></i>  +${photo.replyCnt}
									</p>
								</div> 
								<div class="desc">
									<div class="center_wrap">
										<h3>${photo.title}</h3>
										<p>${photo.writer}</p>
									</div>
								</div>
							</a>
							</div>
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
				<form id="searchForm" action="/photo/list" method="get">
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
			<sec:authorize access="hasRole('ROLE_MEMBER') or hasRole('ROLE_ADMIN')">
				<div class="notice_btn">
					<button class="btn normal_btn middle" onclick="location.href='/photo/register'">사진 올리기</button>
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
	
	<div id="mask"></div>
		
	<form id="actionForm" action="/photo/list" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		<input type="hidden" name="type" value="${pageMaker.cri.type }">
		<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
	</form>
	


</body>
</html>