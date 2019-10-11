<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="org.zerock.domain.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="inc/headTop.jsp" flush="true"></jsp:include>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript" src="/resources/js/board.js"></script>
<script type="text/javascript" src="/resources/js/index.js"></script>
<script type="text/javascript">
$(window).scroll(
		function() {
			var s_top = jQuery(".main_visual").innerHeight();
			//alert(s_top);
			var con_top = jQuery("#section01").innerHeight();
			if ($(this).scrollTop() < s_top
					&& !$('.slider').hasClass("fixed")) {
				$('.slider').addClass("fixed");
				//alert(con_top);
			} else if ($(this).scrollTop() > s_top
					&& $('.slider').hasClass("fixed")) {
				$('.slider').removeClass("fixed");
			}
		});

$(window).scroll(
		function() {
	if ($(this).scrollTop() > 1) {
		$('.scroll_btn').fadeOut();
	} else {
		$('.scroll_btn').fadeIn();
	}
});

$(document).ready(function() {
	var windowSize = $(window).width();
	indexService.bxrolling.init();
	indexService.init(windowSize);
	/*
	var actionForm = $("#actionForm");
	$(document).on("click", ".move", function(e) {
		e.preventDefault();
		console.log($(this).attr('href'));
		actionForm.append("<input type='hidden' name='amount' value='"
						+ $(this).data('amount')
						+ "'>");
		actionForm.append("<input type='hidden' name='bno' value='"
						+ $(this).attr('href')
						+ "'>");
		actionForm.append("<input type='hidden' name='boardType' value='"
						+ $(this).data('type')
						+ "'>");
		actionForm.attr("action", $(this).data("url"));
		actionForm.submit();
	})
	*/
})
					
</script>

</head>

<body>
	<jsp:include page="inc/top.jsp" flush="true"></jsp:include>

	<div class="page_wrap">
		<div class="main_visual_wrap">

			<div class="main_visual">
				<div class="slider fixed">
					<div class="main_slg" alt="메인사진, 슬로건"></div>

					<div class="scroll_btn" style="display: block;">
						<span class="mouse"> <span> </span>
						</span>
						<p>scroll down</p>
					</div>

				</div>
			</div>
		</div>

		<div class="section_wrap main_section">

			<section class="main_row1" id="section01">
			<div class="container">
				<div class="index_title">
					<span class="main_tit normal-font">새소식</span>
				</div>
				<div class="notice_wrap">
					<div class="swipe_wrap controls">
						<c:forEach items="${noticeList}" var="notice">
							<div>
								<a class="move" href='/notice/get?pageNum=1&boardType=notice&bno=<c:out value="${notice.bno}"/>' data-type="notice" data-url="/notice/get" data-amount="10">
									<div class="notice_box">
											<p class="main_notice">
												<c:out value="${notice.title}"></c:out>
											</p>
											<p class="sub_notice">
												<fmt:formatDate pattern="yyyy-MM-dd"
													value="${notice.regdate}" />
											</p>
									</div>
								</a>
							</div>
						</c:forEach>
					</div>
					<span id="bxslider_prev" class="bxslider_btn"></span>
					<span id="bxslider_next" class="bxslider_btn"></span>
				</div>
				<div class="viewmore_wrap">
					<span>
						<a class="viewmore_btn" href="/notice/list">더보기</a>
					</span>
				</div>
			</div>
			</section>


			<section class="main_row2 even_row" id="section03">
				<div class="container">
					<div class="index_title normal-font">
						<span class="main_tit normal-font">사진</span>
					</div>
					<div>
						<ul class="gallery_li">
						</ul>
						<div class="viewmore_wrap">
							<span>
								<a class="viewmore_btn" href="/photo/list?amount=12">더보기</a>
							</span>
						</div>
					</div>
				</div>
			</section>


			<section class="main_row3 " id="section03">
			<div class="container">

				<div class="index_title normal-font">
					<span class="main_tit normal-font">더사랑 이야기</span>
				</div>
				<ul class="book_li">
				
				</ul>
				<div class="viewmore_wrap">
					<span>
						<a class="viewmore_btn" href="/essay/list">더보기</a>
					</span>
				</div>
			</div>
			</section>


		</div>
	<jsp:include page="./inc/footer.jsp" flush="true"></jsp:include>
	</div>

	<form id="actionForm" action="/notice/list" method="get">
		<input type="hidden" name="pageNum" value="1">
	</form>

</body>
</html>