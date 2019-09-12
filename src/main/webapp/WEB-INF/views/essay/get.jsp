<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script>
$(document).ready(function() {
	console.log($(".notice_content"));
	console.log($(".notice_content").get(0).innerText)
	
	var actionForm = $("#actionForm"); 
	$(".page_num").on("click", function(e) {
		console.log("click page_num !!!");
		e.preventDefault();
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.submit();
	})
	
	var openForm = $("#openForm");
	$("button[data-oper='list']").on("click", function(e) {
		e.preventDefault();
		openForm.find("#bno").remove();
		openForm.attr("action", "/essay/list");
		openForm.submit();
	})
	
	$("button[data-oper='modify']").on("click",function(e) {
		e.preventDefault();
		openForm.attr("action", "/essay/modify").submit();
	})
	
	
	var inputReply = $(".reply_write_box textarea");
	var replyer = null;
	var bnoValue = '<c:out value="${photo.bno}" />';
	
	<sec:authorize access="isAuthenticated()">
		replyer = '<sec:authentication property="principal.username"/>';
	</sec:authorize>
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	$(document).ajaxSend(function(e, xhr, options){
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	})
	
	$(document).on("click", ".reply_btn.remove", function(e) {
		var rno = $(this).data("rno");
		var reply = "작성자에 의해 삭제된 댓글 입니다.";
		var replyer = $(this).data("replyer");
		var reply = {
			rno : rno,
			replyer : replyer,
			reply : reply,
			deleted : 1
		}
		replyService.update(reply, function(result) {
			alert(result);
			$(".reply_ul").remove();
			showList(1);
		});
	})
	var isClickModifyBtn = false;
	$(document).on("click", ".reply_btn.modify", function(e) { // 댓글 수정 버튼 클릭.
		e.preventDefault();

		if(isClickModifyBtn) {
			alert("한번에 하나의 댓글만 수정할 수 있습니다.");
			return;
		}
		isClickModifyBtn = true;
	
		var rno = $(this).data("rno");
		var replyer = $(this).data("replyer");
		
		var replyContentBox = $(this).parent().parent().children(".reply_content_box");
		var replyContentBoxVal = replyContentBox.text();

		replyContentBox.contents().unwrap().wrap('<textarea class="reply_content_box"></textarea>');
		$(this).parent().children(".reply_content_box").text(replyContentBoxVal);
		$(this).parent().children(".reply_content_box").height(1).height($(this).parent().children(".reply_content_box").prop('scrollHeight')-10);

		
		$(this).parent().append("<button class='small_btn reply_modify_submit_btn' data-rno='" + rno + "' data-replyer='" + replyer + "'>확인</button>")
		$(this).prev().remove();
		$(this).next().remove();
		$(this).remove();
	})
	$(document).on("click", ".reply_btn.rereply", function(e) {
		$(this).hide();
		'<sec:authorize access="isAuthenticated()">'
		var str  = "";
		str += "<li class='reply_li re_reply'>"
		str += "<div class='reply_wrap'>"
		str += "<div class='reply_thumb_box'>";
		str += "<div class='thumb' style='background: url(/display?fileName=<sec:authentication property="principal.member.thumbPhoto"/>) no-repeat top center; background-size:cover; background-position: center'>";
		str += "</div>";
		str += "<span class='userid'>" + '<sec:authentication property="principal.member.userid"/>' + "</span>";
		str += "</div> ";
		str += "<textarea class='reply_content_box'>" + "</textarea>";
		str += "<div class='reply_btn_wrap'>";
		str += "<button class='small_btn rereply_submit_btn' data-bno='" + $(this).data("bno") + "' data-rno='" +$(this).data("rno") +"' data-replyer='"+ $(this).data("replyer") +"'>확인</button></div>";
		str += "</li>";
		
		$(this).parents(".reply_li").after(str);
		'</sec:authorize>'
	})
	$(document).on("click", ".reply_modify_submit_btn", function(e) {
		e.preventDefault();
		var reply = {
			reply: $(this).parent().prev().val(),
			replyer: $(this).data('replyer'),
			rno: $(this).data('rno')
		}
		
		replyService.update(reply, function(result) {
			alert(result);
			showList(1);
			isClickModifyBtn = false;
		});
	})
	$(document).on("click", ".rereply_submit_btn", function(e) {
		e.preventDefault();
		'<sec:authorize access="isAuthenticated()">'
		var reply = {
			reply: $(this).parent().prev().val(),
			replyer: '<sec:authentication property="principal.username"/>',
			rno: $(this).data('rno'),
			bno: $(this).data('bno')
		}
		replyService.addRereply(reply, function(result) {
			alert(result);
			showList(1);
			isClickModifyBtn = false;
		});
		'</sec:authorize>'
	})
	$(".reply_btn").on("click", function(e) { // 댓글 등록 버튼 클릭. 
		e.preventDefault();
		if($.trim(inputReply.val()).length == 0) { // 아무것도 입력하지 않았는지 체크(공백이나 엔터는 입력한 문자로 계산하지 않음)
			alert("댓글을 입력하셔야 합니다");
			return;
		}
		var reply = {
			reply : inputReply.val(),
			replyer : replyer,
			bno:bnoValue
		};
		replyService.add(reply , function(result) {
			alert(result);
			$(".reply_ul").remove();
			showList(1);
			inputReply.val("");
		});
	})
	showList(1); // 댓글의 리스트 출력
	function showList(page) {
		replyService.getList({bno:bnoValue, page:page||1}, function (data) {
			console.log(data);
			var replyCnt = data.replyCnt;
			if(replyCnt != 0) {
				$(".bottom_wrap").prepend("<ul class='reply_ul'></ul>");
			}			
			
			if(page == -1) { // -1 --> crud작업이후 바로 일 경우,
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				return;
			}
			
			$(".reply_ul").html("");
			
			var str= "";
			var loginuser = null;
			'<sec:authorize access="isAuthenticated()">'
				loginuser = '<sec:authentication property="principal.username"/>';
			'</sec:authorize>'

			$(data.list).each(function(i, rep) {
				if(rep.thumbPhoto!="") {
					if(rep.parent==null) {
		 				str += "<li class='reply_li'>";
					} else {
						str += "<li class='reply_li re_reply'>"
					}
					str += "<div class='reply_wrap'>"
					str += "<div class='reply_thumb_box'>";
					str += "<div class='thumb' style='background: url(/display?fileName=" + rep.thumbPhoto + ")no-repeat top center; background-size:cover; background-position: center'>";
					str += "</div>";
					str += "<span class='userid'>" + rep.replyer + "</span>";
					str += "</div> ";
					str += "<div class='reply_content_box'>" + rep.reply + "</div>";
					str += "<div class='reply_btn_wrap'>"
					if((rep.replyer == loginuser) && (rep.deleted != 1)) {
						str += '<button class="reply_btn remove" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-times" aria-hidden="true"></i></button>';
						str += '<button class="reply_btn modify" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-pencil" aria-hidden="true"></i></button>';
					}
					if(loginuser != null && rep.parent == null) { // 로그인한 유져이고, 부모댓글 이면 대댓글 버튼이 활성화 된다. 
						str += '<button class="reply_btn rereply" data-bno="' + rep.bno + '" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-commenting-o" aria-hidden="true"></i></button>';
					}
					str += '<div class="reply_date_box">' + replyService.displayTime(rep.replyDate) + '</div>'
					str += "</div>";
					str += "</div>";
					str += "</li>";
				} else {
					if(rep.parent==null) {
		 				str += "<li class='reply_li'>";
					} else {
						str += "<li class='reply_li re_reply'>"
					}
					str += "<div class='reply_wrap'>"
					str += "<div class='reply_thumb_box'>";
					str += "<div class='thumb'>";
					str += "<i class='fa fa-user-circle-o' aria-hidden='true'></i>";
					str += "</div>";
					str += "<span class='userid'>" + rep.replyer + "</span>";
					str += "</div> ";
					str += "<div class='reply_content_box'>" + rep.reply + "</div>";
					str += "<div class='reply_btn_wrap'>"

					if(rep.replyer == loginuser) {
						str += '<button class="reply_btn remove" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-times" aria-hidden="true"></i></button>';
						str += '<button class="reply_btn modify" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-pencil" aria-hidden="true"></i></button>';
					}
					if(loginuser != null && rep.parent == null) {
						str += '<button class="reply_btn rereply" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-commenting-o" aria-hidden="true"></i></button>';
					}
					str += '<div class="reply_date_box">' + replyService.displayTime(rep.replyDate) + '</div>'
					str == "</div>";
					str += "</li>";
				}
			});         
			
			$(".reply_ul").prepend(str);
			
			
			showReplyPage(data.replyCnt); // 넘버링된 페이징 번호를 보여준다.
		}) // end function
	} // end showList()
	/* 댓글 페이징 처리 */
	var pageNum = 1;
	var replyPageFooter = $(".reply_paging_box");
	
	function showReplyPage(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		
		var prev = startNum != 1;
		var next = false;
		
		if(endNum*10 >= replyCnt) {
			endNum = Math.ceil(replyCnt/10.0);
		}
		
		if(endNum*10 < replyCnt) {
			next = true;
		}
		var str = "<ul class='pagination pull-right'>";
		
		if(prev) {
			str += "<li class='page-item'><a class='page-link' href='" + (startNum -1) + "'>Previous</a></li>";
		}
		for(var i = startNum; i <= endNum; i++) {
			var active = pageNum == i ? "active" : "";
			str += "<li class='page-item "+ active + "'><a class='page-link' href='"+ i + "'>" + i + "</a></li>";
		}
		
		if(next) {
			str += "<li class='page-item'><a class='page-link' href='" + (endNum + 1) + "'>Next</a></li>";
			str += "</ul></div>";
			
			console.log(str);
		}
		replyPageFooter.html(str);
	}
		
	/* 댓글 페이지 번호 클릭 이벤트*/
	replyPageFooter.on("click", "li a", function(e) {
		e.preventDefault();
		var targetPageNum = $(this).attr("href");
		console.log("targetPageNum : " + targetPageNum);
		pageNum = targetPageNum;
		showList(targetPageNum);
	})

	/** 댓글 textarea 사이즈 자동 조절  **/
	$(document).on("keyup keydown", ".reply_content_box", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')-10);	
	})
	
	$(document).on("keyup keydown", ".reply_write_box textarea", function(e) {
		$(this).height(1).height( $(this).prop('scrollHeight')-10);	
	})
	
	
})

</script>
<title>Insert title here</title>
</head>
<body>
<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
		
	<div class="page_wrap">
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
				<div class="list_wrap notice_get_wrap">
					<div id="table">
					
						<div class="row notice_title">
							${essay.title}
						</div>
						
						<div class="row notice_info">
							<div class="row notice_writer">
								${essay.writer}
							</div>
							
							<div class="row notice_date">
								<fmt:formatDate pattern="yyyy-MM-dd" value="${essay.regdate}"/>
							</div>
						</div>
						
						<div class="row notice_content_box">
							<div class="notice_content">
								${essay.content}
							</div>
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
								<button class="btn normal_btn" data-oper="list">목록</button>
								<sec:authorize access="isAuthenticated()">
									<sec:authentication property="principal.member.userid" var="loginuserid"/>
									<c:if test="${essay.writer eq loginuserid }">
										<button class="btn normal_btn" data-oper="modify">수정</button>
									</c:if>
								</sec:authorize>
							</div>
						</div>
						
					<form id="openForm" action="/essay/modify" method="post">
						<input type="hidden" id="bno" name="bno" value='<c:out value="${essay.bno}"/>' />
						<input type="hidden" id="writer" name="writer" value='<c:out value="${essay.writer}"/>' />  
						<input type="hidden" id="pageNum" name="pageNum" value='<c:out value="${cri.pageNum}"/>'> 
						<input type="hidden" id="amount" name="amount" value='<c:out value="${cri.amount}"/>'> 
						<input type="hidden" id="keyword" name="keyword" value='<c:out value="${cri.keyword}"/>'> 
						<input type="hidden" id="type" name="type" value='<c:out value="${cri.type}"/>' />
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					</form>
						
					</div>
				</div>
			</div>
		</div>
		<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
	</div>
</body>
</html>