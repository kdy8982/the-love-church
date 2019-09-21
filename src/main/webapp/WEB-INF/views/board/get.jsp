<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>

<style>
.uploadResult {
	width : 100%;
	background-color: gray;
}
.uploadResult ul {
	display : flex;
	flex-flow : row;
	justify-content : center;
	align-items:center;	
}
.uploadResult ul li {
	list-style:none;
	padding:10px;
	align-center: center;
	text-align:center;
}

.uploadResult ul li img {
	width:100px;
}

.uploadResult ul li span {
	color:white;
}

.bigPictureWrapper {
	position : absolute;
	display:none;
	justify-content : center;
	align-items: center;
	top:0%;
	width:100%;
	height:100%;
	background-color: gray;
	z-index:100;
	background: rgba(255,255,255,0.5);
}
.bigPicture {
	position : relative;
	display : flex;
	justify-content : center;
	align-items : center;
}

.bigPicture img{
	width:600px;
}
</style>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">글 조회</h1>
	</div>
	<!-- /.col-lg-12 -->
</div>
<!-- /.row -->


<div class="row">
	<div class="col-lg-12">
		<div class="card">

			<div class="card-header"></div>
			<!-- /.panel-heading -->
			<div class="card-block" style="margin-bottom: 30px;">
				<div class="form-group">
					<label>글번호</label> <input class="form-control" name='bno'
						value='<c:out value="${board.bno}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>제목</label> <input class="form-control" name='title'
						value='<c:out value="${board.title}"/>' readonly="readonly">
				</div>
				<div class="form-group">
					<label>글 내용</label>
					<textarea class="form-control" rows="3" name='content'
						readonly="readonly"><c:out value="${board.content}" /></textarea>
				</div>
				<div class="form-group">
					<label>작성자</label> <input class="form-control" name='writer'
						value='<c:out value="${board.writer}"/>' readonly="readonly">
				</div>
				
				
				<sec:authentication property="principal" var="pinfo"/>
				<sec:authorize access="isAuthenticated()">
					<c:if test="${pinfo.username eq board.writer}">
						<button data-oper='modify' class="btn btn-secondary">수정</button>
					</c:if>
				</sec:authorize>
				
				<button data-oper='list' class="btn btn-secondary">목록으로</button>

				<form id="openForm" action="/board/modify" method="get">
					<input type="hidden" id="bno" name="bno" value='<c:out value="${board.bno}"/>' /> 
					<input type="hidden" id="pageNum" name="pageNum" value='<c:out value="${cri.pageNum}"/>'> 
					<input type="hidden" id="amount" name="amount" value='<c:out value="${cri.amount}"/>'> 
					<input type="hidden" id="keyword" name="keyword" value='<c:out value="${cri.keyword}"/>'> 
					<input type="hidden" id="type" name="type" value='<c:out value="${cri.type}"/>' />
				</form>
			</div>
		</div>
	</div>
</div>

<div id="row">
	<div class="card">
		<div class="card-header" style="padding-right: 10px;">
			<i class="fa fa-comments fa-fw"></i>Reply
			
			<sec:authorize access="isAuthenticated()">
				<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">댓글 달기</button>
			</sec:authorize>
		</div>
		<div class="card-block">
			<ul class="chat" style="padding-left: 15px;">
			</ul>
		</div>
	</div>
</div>

<!-- 댓글 추가 Modal 창 -->
<div class="modal fade reply-modal" id="replyModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>Reply</label>
					<input class="form-control" name="reply" value="New Reply!!">
				</div>
				<div class="form-group">
					<label>Replyer</label>
					<input class="form-control" name="replyer" readonly="readonly">
				</div>
				<div class="form-group">
					<label>Reply Date</label>
					<input class="form-control" name="replyDate" value="">
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
				<button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
				<button id="modalRegisterBtn" type="button" class="btn btn-primary">Registers</button>
				<button id="modalCloseBtn" type="button" class="btn btn-secondary">close</button>
			</div>
		</div>
	</div>

</div>

<div class="bigPictureWrapper">
	<div class='bigPicture'>
	</div>
</div> 

<div id="row">
	<div class="card">
		<div class="card-header" style="padding-right: 10px;">
			Files
		</div>
		<div class="card-block uploadResult">
			<ul>
			</ul>
		</div>
	</div>
</div>


<%@include file="../includes/footer.jsp"%>
<!-- Bootstrap core JavaScript-->
<!-- <script src="vendor/jquery/jquery.min.js"></script> -->
<script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

<!-- Core plugin JavaScript-->
<script src="vendor/jquery-easing/jquery.easing.min.js"></script>

<!-- Custom scripts for all pages-->
<script src="js/sb-admin-2.min.js"></script>

<!-- Page level plugins -->
<script src="vendor/datatables/jquery.dataTables.min.js"></script>
<script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

<!-- Page level custom scripts -->
<script src="js/demo/datatables-demo.js"></script>
<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
			
		/* 글 조회시, 첨부파일 리스트 조회  */
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList" , {bno : bno}, function (arr) {
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i, attach) {
				//image type (썸네일)
				if(attach.fileType) {
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+ "_" + attach.fileName);
					
					str += "<li data-path='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type='"+ attach.fileType +"' >";
					str += "<div>";
					str += "<img src='/display?fileName="+ fileCallPath +"'>";
					str += "</div>"
					str += "</li>";
				} else {
					str += "<li data-path ='"+ attach.uploadPath +"' data-uuid='"+ attach.uuid +"' data-filename='"+ attach.fileName +"' data-type ='"+ attach.fileType + "'>";
					str += "<div>"
					str += "<img src='/resources/img/attach.png'>"
					str += "</div>"
					str += "</li>"
				}
			});
			
			$(".uploadResult ul").html(str);
		})
		
		$(".uploadResult").on("click", "li", function(e) {
			console.log("view image");
			
			var liObj = $(this);
			 
			var path = encodeURIComponent(liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			if(liObj.data("type")) {
				showImage(path.replace(new RegExp(/\\/g) ,"/"));
			} else {
				self.location = "/download?fileName=" + path
			}
			
		})
		function showImage(fileCallPath) {
			alert(fileCallPath);
			$(".bigPictureWrapper").css("display", "flex").show();
			
			$(".bigPicture").html("<img src='/display?fileName="+ fileCallPath +"'>")
			.animate({width:'100%', height:'100%'}, 1000);
		}
		
		$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
			setTimeout(function() {
				$(".bigPictureWrapper").hide(); 
			}, 1000)
		})
		
		
		var openForm = $("#openForm");

		$("button[data-oper='modify']").on("click", function(e) {
			openForm.attr("action", "/board/modify").submit();
		})

		$("button[data-oper='list']").on("click", function(e) {
			openForm.find("#bno").remove();
			openForm.attr("action", "/board/list");
			openForm.submit();
		})

		var bnoValue = '<c:out value="${board.bno}" />';
		var replyUL = $(".chat");
		
		showList(1);
		
		function showList(page) {
			replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt, list) {
				console.log("replyCnt : " + replyCnt);
				console.log("list : " + list);
				
				if(page == -1) { // -1 --> crud작업이후 바로 일 경우,
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				var str = "";
				if (list==null || list.length==0) {
					replyUL.html("");
					return;
				}
				
				for(var i=0, len=list.length||0; i<len; i++) {
					str+="<li class='left clearfix' data-rno='"+list[i].rno+"' style='list-style: none;'>";
					str+="	<div><div class='header'><strong class='primary-font'>" + list[i].replyer + "</strong>";
					str+="	<small class='pull-right text-muted'>" + replyService.displayTime(list[i].replyDate)+"</small></div>";
					str+="	<p>" + list[i].reply + "</p></div></li>";
				}
				replyUL.html(str);
				showReplyPage(replyCnt);
			}) // end function
		} // end showList()
		
		
		/* [댓글창 띄우기] */ 
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");
		
		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn =  $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		var modalCloseBtn = $("#modalCloseBtn");
		
		var replyer = null;
		<sec:authorize access="isAuthenticated()">
			replyer = '<sec:authentication property="principal.username"/>';
		</sec:authorize>
		
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		$(document).ajaxSend(function(e, xhr, options){
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		})
		
		$("#addReplyBtn").on("click", function(e) {
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id !='modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			
			$("#replyModal").modal("show");
		});
		
		modalRegisterBtn.on("click", function(e) {
			var reply = {
				reply:modalInputReply.val(),
				replyer:modalInputReplyer.val(),
				bno:bnoValue
			};
			
			replyService.add(reply, function(result) {
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				showList(-1);
			});
			
			
		});
		
		$(".chat").on("click", "li", function(e){
			var rno = $(this).data("rno");
			console.log(rno);
			replyService.get(rno, function (reply) {
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalColseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				modalCloseBtn.show()
				$(".modal").modal("show");
				
			})
		})
		
		modalModBtn.on("click", function(e) {
			var originalReplyer = modalInputReplyer.val();
			var reply = {rno : modal.data("rno"), reply : modalInputReply.val(), replyer : originalReplyer};
			
			console.log("RNO!! : " + reply.rno);
			console.log("REPLYER : " + replyer);
			
			if(!replyer) {
				alert("로그인 후에 수정하실 수 있습니다.");
				modal.modal("hide");
				return;
			}
			
			if(originalReplyer != replyer) {
				alert("댓글 작성자만 수정할 수 있습니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.update(reply, function(result) {
				alert(result);
			})
			
			$("#replyModal").modal("hide");
			
			/* 
			showList(1);
			 */
		})
		
		modalRemoveBtn.on("click", function(e) {
			var reply = {rno : modal.data("rno")};
			console.log("RNO : " + reply.rno);
			console.log("REPLYER : " + replyer);
			
			if (!replyer) {
				alert("로그인 후 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			
			if(replyer != originalReplyer) {
				alert("자신이 작성한 댓글만 삭제가 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			replyService.remove(reply.rno, originalReplyer, function (result) {
				alert(result);
				modal.modal("hide");
				showList(1);
			})
			
		});
		
		modalCloseBtn.on("click", function(e) {
			$("#replyModal").modal("hide");
		});
	
		
		/* 댓글 페이징 처리 */
		
		var pageNum = 1;
		var replyPageFooter = $(".card-footer");
		
		function showReplyPage(replyCnt) {
			
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum*5 >= replyCnt) {
				endNum = Math.ceil(replyCnt/5.0);
			}
			
			if(endNum*5 < replyCnt) {
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
		});	
		
		
	
		/*
		// [reply AJAX 메서드 테스트]
		replyService.add(
			{reply : "JS Test", replyer:"tester", bno:bnoValue}
			,
			function(result) {
				alert("RESULT : " + result);
			}
		);
		replyService.getList({bno:bnoValue, page:1}, function(list){
		 for(var i=0, len=list.length||0; i<len; i++) {
			 console.log(list[i])
		 }
		})
		replyService.remove(23, function(count) {
		console.log(count);
		if (count === "success") {
			alert("REMOVED");
		}
		}, function(err) {
		alert("ERROR...");
		})
		replyService.get(10, function(data) {
			console.log(data)
		})
		 */
	});
</script>

