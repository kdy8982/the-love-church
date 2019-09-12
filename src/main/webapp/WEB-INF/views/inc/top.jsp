<%@ page contentType="text/html; charset=utf-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<script>

function myFunction() {
	var x = document.getElementById("head_ul");
	if (x.style.display === "block") {
		x.style.display = "none";
	} else {
		x.style.display = "block";
	}
}

$(document).ready(function() {
	$('.login_area').mouseenter(function() {
	    $('.member_dropmenu').dequeue().stop(true, true).show(400);
	}).mouseleave(function() {
	    $('.member_dropmenu').dequeue().stop(true, true).hide(400);
	});
})
</script>

<header id="header">
	<div class="header_inner title-font">
		<a class="top_title" href="/">The Love Comunity</a>
		<ul id="head_ul">
			<!-- <li><a href="#">The Love Comunity</a></li> -->
			<li onclick="location.href='/notice/list'"><a href="/notice/list">새소식</a></li>
			<li onclick="location.href='/photo/list'"><a href="/photo/list">사진</a></li>
			<li onclick="location.href='/essay/list'"><a href="/essay/list">더사랑 이야기</a></li>
			<li onclick="location.href='/introduce/church'"><a href="/introduce/church">더사랑 교회</a></li>
			<li onclick="location.href='/customLogin'" class="login_area">				
				<sec:authorize access="isAuthenticated()">
						<a href="/memberDetail?userid=<sec:authentication property="principal.member.userid"/>">
							<div class="thumb" style="background: url(/display?fileName=<sec:authentication property="principal.member.thumbPhoto"/>)no-repeat top center; background-size:cover; background-position: center">
								<sec:authentication var="userProfilePhoto" property='principal.member.photo'/>
								<c:if test="${userProfilePhoto eq null }">			
									<div class="unknown_image center_wrap">
										<i class="fa fa-user-circle-o" aria-hidden="true"></i>
									</div>
								</c:if>
							</div>
							<span class="id">
								<sec:authentication property="principal.member.userid"/>
							</span>
						</a>
					
					<ul class="member_dropmenu">
						<li><a href="/memberDetail?userid=<sec:authentication property='principal.member.userid'/>"><i class="fa fa-user user_mark" aria-hidden="true"></i>내 정보 관리</a></li>
						<li><a href="/customLogout"><i class="fa fa-sign-out user_mark" aria-hidden="true"></i>로그아웃</a></li>
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<li><a href="/admin/main"><i class="fa fa-cogs user_mark" aria-hidden="true"></i>관리자 메뉴</a></li>
						</sec:authorize>
					</ul>
				</sec:authorize>
				
				<sec:authorize access="isAnonymous()">
					<a href="/customLogin"><span alt="로그인">로그인</span></a>
				</sec:authorize>
			</li>
			
		</ul>
		<a href="javascript:void(0);" class="icon" onclick="myFunction()">
   			<i class="fa fa-bars"></i>
		</a>
	</div>
</header>

<aside id="btn_top">
	<span>TOP</span>
</aside>