<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:include page="./inc/headTop.jsp" flush="true"></jsp:include>


</head>
<body>
	<div id="wrap">
		<jsp:include page="./inc/top.jsp" flush="true"></jsp:include>
		<div id="container_index">
			<section class="cont1">
				<h2 class="title">GALLERY</h2>
				<ul class="character_col">
					
					<c:forEach items="${list}" var="board">
						<li>
							<a href="#">
								<div>
									<img src="/resouzrces/images/index/main_crt1.png">
								</div>
								<div>
									<h3><c:out value="${board.title}"/></h3>
									<p><c:out value="${board.writer}"/></p>
									<p><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}"/></p>
								</div>
							</a>
						</li>
					</c:forEach>
					
				</ul>
			</section>
		</div>
	</div>
	<jsp:include page="./inc/footer.jsp" flush="true"></jsp:include>
</body>
</html>
