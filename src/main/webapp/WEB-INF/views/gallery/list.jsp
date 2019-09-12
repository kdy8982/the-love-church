<%@page import="java.net.URLEncoder"%>
<%@page import="org.zerock.domain.*"%>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="../inc/headTop.jsp" flush="true"></jsp:include>
<script>
	var isRequiredBxSlider = "true";

	function open_pop(id){
			var type = $(id).parent().parent().find("li").attr("class");

			if( type=="yesupload"){
				$("#gallery_view").fadeIn("fast",function(){

					if( isRequiredBxSlider == "true"){		
							$('.chara_list').bxSlider({
								auto: true, 
								speed: 500, 
								pause: 2000, 
								mode:'horizontal', 
								minSlides: 1,
								maxSlides: 1,
								nextText: '',
								prevText:'',
								infiniteLoop: true,
								autoControls: true,
								pager: false
							});

							$(".bx-controls-direction .bx-prev").append("<i class='fa fa-chevron-left' aria-hidden='true'></i>");
							$(".bx-controls-direction .bx-next").append("<i class='fa fa-chevron-right' aria-hidden='true'></i>");
						}
					isRequiredBxSlider = 'false';
				});	
			} else {
				$("#gallery_upload").fadeIn("fast");
			}	
	}
	
	/* 페이지 상단 Write 버튼 클릭 */
	function clickUploadBtn() {
		$("#gallery_upload").fadeIn("fast");
	}
	
	$(".yesupload").on("click", function() {
		
		
	})
	
	
</script>
</head>
<body>

	<div id="wrap">
		<jsp:include page="../inc/top.jsp" flush="true"></jsp:include>
		<jsp:include page="../inc/gallery_upload.jsp" flush="true"></jsp:include>
		<jsp:include page="../inc/gallery_view.jsp" flush="true"></jsp:include>
		<div id="container_index">
		
			<section class="cont1">
				<h2 class="title">GALLERY</h2>
				<div class="btn_wrap">
					<button onclick="clickUploadBtn()" class="write_btn btn_normal2">Write</button>
				</div>
				<ul class="character_col">
								
					<c:forEach items="${galleryList}" var="gallery" varStatus="galleryStatus">
						<c:forEach items="${gallery.attachList}" var="attach" varStatus="attachStatus">
								
							<c:if test="${attach.previewImg eq 1}"> <!-- 대표이미지가 설정된 경우 -->
								<li class="yesupload"><!-- 업로드 완료 리스트 -->
									<a onclick="javascript:open_pop(this)">
							
										<c:set target="${attach}" property="wholeFilePath" value="${attach.uploadPath}/s_${attach.uuid}_${attach.fileName}" />
										<%
											GalleryAttachVO vo = (GalleryAttachVO)pageContext.getAttribute("attach");
											pageContext.setAttribute("imgPath", URLEncoder.encode(vo.getWholeFilePath()));
										%>
										<div>
											<img src="/display?fileName=<c:url value='${imgPath}'/>">
										</div>
										
										<div>
											<h3><c:out value="${gallery.koreaName}"/></h3>
											<p><c:out value="${gallery.engName}"/></p>
											
										</div>
									</a>
								</li>
							</c:if>
							
							<c:if test="${attach.previewImg eq 0}"> <!-- 대표이미지가 설정되어 있지 않은 경우 -->
								<li class="noupload"><!-- 업로드 전 리스트 -->
									<a onclick="javascript:open_pop()">
							
										<div>
											<img src="/resources/images/index/main_crt1.png">
											<i class="fa fa-exclamation alert" aria-hidden="true"></i>
											<i class="fa fa-plus add" aria-hidden="true"></i>
										</div>
										
										<div>
											<h3><c:out value="${gallery.koreaName}"/></h3>
											<p><c:out value="${gallery.engName}"/></p>
										</div>
									</a>	
								</li>
							</c:if>
							
						</c:forEach>
					</c:forEach> 
					
					<form id="actionForm" action="/board/list" method="get">
												
					</form>
				</ul>
			</section>
		</div>
		<jsp:include page="../inc/footer.jsp" flush="true"></jsp:include>
	</div>
</body>
</html>
