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
    <script type="text/javascript" src="/resources/js/indexService.js"></script>
    <script type="text/javascript" src="/resources/js/index.js"></script>
</head>

<body>
	<jsp:include page="inc/top.jsp" flush="true"></jsp:include>

	<div class="page_wrap">
		<div class="main_visual_wrap">
			<div class="main_visual">
				<div id="main_slider" class="slider fixed">
					<div class="slides" alt="메인사진, 슬로건1" style="background: url(/resources/images/index/bread.jpeg) no-repeat center; background-size: cover; background-position: 25% 0%; height:100%;"></div>
					<div class="slides" alt="메인사진, 슬로건2" style="background: url(/resources/images/index/thesarang.jpg) no-repeat center; background-size: cover; height:100%;"></div>
					<div class="slides" alt="메인사진, 슬로건3" style="background: url(/resources/images/index/child.jpg) no-repeat center; background-size: cover; height:100%;"></div>
				</div>

                <div id="main_navi">
                    <div id="main_section1">
                        <a href="/notice/list">
                            <h1 style="float: left; width: 140px; line-height: 150px; text-align:center; color: #FFF; font-size: 24px; background-color: #7659306e;">새소식</h1>
                        </a>
                        <div id="main_section1_child">
                            <div style="padding: 25px;">
                                <ul>
                                    <c:forEach items="${noticeList}" var="notice" varStatus="status" >
                                        <li class="move" style="cursor:pointer; white-space: nowrap; text-overflow: ellipsis; overflow: hidden;">
                                            <a href='<c:out value="${notice.bno}" />' style="color:#FFF"><c:out value="${notice.title}"></c:out></a>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div id="main_section2" class="section_wrap">
                        <div id="main_section2_child" class="main_section_child" OnClick="location.href = '/introduce/church'">
                            <div style="display:table-cell; vertical-align:middle;">
                                <img src="/resources/images/sub/rice.png"
                                    style="width:80px; background-color: #d8c1b1; border-radius: 40px;">
                                <p style="font-size:19px; margin-top: 10px;">교회 안내</p>
                            </div>
                        </div>
                        <div class="main_section_child" OnClick="location.href = 'https://us04web.zoom.us/j/5661108777?pwd=NVdsMk0xeExTOEk0YjcwMVQwck9rdz09'">
                            <div style="display:table-cell; vertical-align:middle" >
                                <img src="/resources/images/index/zoom.png" style="width:78px; background-color: #d8c1b1; border-radius: 40px;" />
                                <p style="font-size:19px; margin-top: 10px;">예배 실황</p>
                            </div>
                        </div>
                        <!--
                        <div class="main_section_child" OnClick="location.href = '#'">
                            <div style="display:table-cell; vertical-align:middle; background-color:#7659306e;">
                            </div>
                        </div>
                        -->
                    </div>
                </div>
			</div>
		</div>
	</div>
	<jsp:include page="./inc/footer.jsp" flush="true"></jsp:include>

	<form id="actionForm" action="/notice/list" method="get">
		<input type="hidden" name="pageNum" value="1">
	</form>

</body>
</html>