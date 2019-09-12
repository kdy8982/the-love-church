<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
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
var csrfHeaderName = "${_csrf.headerName}";
var csrfTokenValue = "${_csrf.token}";

function showModal() {
	wrapWindowByMask();
}

function wrapWindowByMask() {
	//화면의 높이와 너비를 구한다.
	var maskHeight = $(document).height();
	var maskWidth = $(window).width();

	//마스크의 높이와 너비를 화면 것으로 만들어 전체 화면을 채운다.
	$('#mask').css({
		'width' : maskWidth,
		'height' : maskHeight
	});

	$('#mask').fadeTo("slow", 0.8);
	
	$('.modal').css("display", "block");
	//$(".modal").show();
	
	$('html, body').css({'overflow': 'hidden', 'height': '100%'}); // 모달팝업 중 html,body의 scroll을 hidden시킴
	$('.page_wrap').on('scroll touchmove mousewheel', function(e) { // 터치무브와 마우스휠 스크롤 방지     
		e.preventDefault();    
		e.stopPropagation();     
		return false; 
	});
	
}

$(document).ready(function() {
    var now = new Date();
    var nyear = now.getFullYear();
    var nmon = (now.getMonth()+1) > 9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);          
    
    //년도 selectbox만들기               
    for(var sy = 2002 ; sy <= nyear ; sy++) {
        $('#modal_year').append('<option value="' + sy + '">' + sy + '년</option>');    
    }
    
    // 월별 selectbox 만들기            
    for(var i=1; i <= 12; i++) {
        var sm = i > 9 ? i : "0"+i ;            
        $('#modal_month').append('<option value="' + sm + '">' + sm + '월</option>');    
     }          
    
    $("#modal_year  > option[value="+nyear+"]").attr("selected", "true");    
    $("#modal_month  > option[value="+nmon+"]").attr("selected", "true"); 
    
    
    $(".history_box .monthLine li").mouseenter(function() {
		$(this).find(".eventModBtn_box").css("display", "inline-block");
    }).mouseleave(function() {
    	$(this).find(".eventModBtn_box").hide();
    });
    
    // 새 발자취 남기기 버튼
    $(".footprints button.addBtn").on("click",function() {
    	$("#FootprintsModal button").attr("data-worktype", "add")
    })
    
    // 모달창 서버 전송 버튼
    $(".modal").find("button").on("click", function() {
    	var workType = $(this).data("worktype");
    	var fno;
    	var year = $("#modal_year option:selected").val();
    	var month = $("#modal_month option:selected").val();
    	var title = $("#FootprintsModal").find("textarea").val();
    	var writer = null;
    	'<sec:authorize access="isAuthenticated()">'
    		writer = '<sec:authentication property="principal.username"/>'
   		'</sec:authorize>'
   		
   		if(workType == "modify") {
   			fno = $(this).data("fno");
   		}
   		
    	var history = {
   			fno: fno,
    		year : year,
    		month : month,
    		title : title,
    		writer : writer
    	}
   		console.log(history)
		console.log(workType)    	
		$.ajax({
			type : 'post',
			url : '/introduce/footprints/' + workType , // add
			data : JSON.stringify(history),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success : function(result, status, xhr) {
				alert(result)
				location.reload();
			},
			error : function(xhr, status, er) {
				alert("권한이 없습니다.")
				location.reload();
			}
		})
    	
    	$('html, body').css({'overflow': 'auto', 'height': '100%'}); //scroll hidden 해제
    	$('#element').off('scroll touchmove mousewheel'); // 터치무브 및 마우스휠 스크롤 가능
    	$(".modal").css("display", "none");
    })
    
    // 댓글 삭제 버튼
    $(".deleteHistory").on("click", function() {
    	var fno = $(this).data("fno");
    	var year = $(this).closest("li").data("year");
    	var month = $(this).closest("li").data("month");
    	var title = $(this).closest("li").data("title");
    	var writer = $(this).closest("li").data("writer");
    	
    	var history = {
    		fno : fno,
    		year : year,
    		month : month,
    		title : title,
    		writer : writer
    	}
		$.ajax({
			type : 'post',
			url : '/introduce/footprints/delete',
			data : JSON.stringify(history),
			contentType : "application/json; charset=utf-8",
			beforeSend : function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			success : function(result, status, xhr) {
				alert(result)
				location.reload();
			},
			error : function(xhr, status, er) {
				alert("권한이 없습니다.")
				location.reload();
			}
		})
    })
    
    // 댓글 수정 버튼
    $(".modifyHistory").on("click", function() {
    	var fno = $(this).data("fno");
    	var year = $(this).closest("li").data("year");
    	var month = $(this).closest("li").data("month");
    	var title = $(this).closest("li").data("title");
    	var writer = $(this).closest("li").data("writer");
    	var history = {
    		fno : fno,
    		year : year,
    		month : month,
    		title : title,
    		writer : writer
    	}
    	$("#FootprintsModal .footprints_content>textarea").val(title)
    	$("#FootprintsModal .footprints_content>#modal_year").val(year).prop("selected", true);
    	$("#FootprintsModal .footprints_content>#modal_month").val(month).prop("selected", true);
    	$("#FootprintsModal button").attr("data-worktype", "modify")
    	$("#FootprintsModal button").attr("data-fno", fno)
    	showModal();
    })    
    
    
    // textarea 글자수 제한 및 카운팅
    $('#counter').html($(this).val().length + '/40');
    $(".footprints_content textarea").on('keyup', function() {
    	if($(this).val().length > 40) {
    		alert("글자수는 40자로 이내로 제한됩니다.");
    		$(this).val($(this).val().substring(0, 40));
    	}
    	$('#counter').html($(this).val().length + '/40');
    });
    
})
</script>

<title>Insert title here</title>
</head>
<body>
<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
	
<div class="page_wrap">
	<div id="title_wrap" class="title_wrap title_footprints">
		<div class="title title-font">
			<p>하나님 나라,</p>
			<p>이곳에 내려오다.</p>
		</div>
	</div>
	<div class="container page_container introduce">
		<div class="church_introduce_menubar">
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/church'">교회 소개</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/seniorpastor'">담임목사</div>
			<div class="church_introduce_menu" style="text-decoration: underline; text-underline-position: under;" OnClick="location.href ='/introduce/footprints'">발자취</div>
			<div class="church_introduce_menu" OnClick="location.href ='/introduce/ministry'">사역</div>
			<div class="church_introduce_menu">예배 안내</div>
		</div>
		
		<div class="content footprints">
			<div class="history_box">
				<div class="hitory_bar"><div class="bar"></div></div>
				<ol class="history_line">
					<c:forEach items="${footprintsList}" var="footprint">
						<li class="year ${footprint.key}year">
							<div class="title">
								${footprint.key}
							</div>
							<ol class="month monthLine">
								<c:forEach items="${footprint.value}" var="fpMonth">	
									<li data-year ="${footprint.key}" data-fno="${fpMonth.fno}" data-month="${fpMonth.month}" data-title="${fpMonth.title}" data-writer="${fpMonth.writer}">
										<span class="pointer"><i class="fa fa-circle" aria-hidden="true"></i></span>
										<span class="month">${fpMonth.month}</span>
										<span class="title">${fpMonth.title}</span>
										<sec:authorize access="isAuthenticated()">
											<sec:authentication property="principal.member.authList" var="authList"/>
											<c:if test="${authList[0].auth eq 'ROLE_ADMIN'}">
												<div class="eventModBtn_box">
													<span class="modifyHistory" data-fno="${fpMonth.fno}">
														<i class="fa fa-pencil" aria-hidden="true"></i>
													</span>
													<span class="deleteHistory" data-fno="${fpMonth.fno}">
														<i class="fa fa-times" aria-hidden="true"></i>
													</span>
												</div>
											</c:if>
										</sec:authorize>
									</li>
								</c:forEach>
							</ol>
						</li>
					</c:forEach>
				</ol>
			</div>
			
			<sec:authorize access="isAuthenticated()">
				<sec:authentication property="principal.member.authList" var="authList"/>
				<c:if test="${authList[0].auth eq 'ROLE_ADMIN'}">
					<button class="addBtn normal_btn" OnClick="showModal()">새로운 발자취 남기기</button>
				</c:if>
			</sec:authorize>
		</div>
	</div>

	<div id="FootprintsModal" class="modal">
			<div class="modal_header row">
				<div class="modal_title">새로운 발자취 등록</div>
				<!-- <button class="close_btn"><i class="fa fa-times" aria-hidden="true"></i></button> -->
			</div>
			
			<div class="footprints_modal modal_body row ">
				<div class="date footprints_content">
					<p>날짜</p>
                    <select id="modal_year" name="modal_year" ></select>    
                    <select id="modal_month" name="modal_month" ></select> 
				</div>
				<div class="event footprints_content">
					<p>내용</p>
					<textarea row=2 cols=20></textarea>
					<span id="counter"></span>
				</div>
			</div>
			
			<div class="modal_footer row">
				<button class="btn normal_btn close">확인</button>
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