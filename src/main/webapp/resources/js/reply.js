console.log("Reply Module..................");

var replyService = (function() {
	function init(replyer, bnoValue, thumbPhoto, csrfHeaderName, csrfTokenValue) {
		
		showList(1); // 댓글의 리스트 출력
		
		console.log(replyer)
		console.log(bnoValue)
		console.log(thumbPhoto)
		console.log("replyService.init() call..");
		
		var inputReply = $(".reply_write_box textarea");
		var replyer = replyer;
		var bnoValue = bnoValue;

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
			replyService.remove(reply, function(result) {
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
			var str  = "";
			str += "<li class='reply_li re_reply'>"
			str += "<div class='reply_wrap'>"
			str += "<div class='reply_thumb_box'>";
			str += "<div class='thumb' style='background: url(/display?fileName=" + thumbPhoto + ") no-repeat top center; background-size:cover; background-position: center'>";
			str += "</div>";
			str += "<span class='userid'>" + replyer + "</span>";
			str += "</div> ";
			str += "<textarea class='reply_content_box'>" + "</textarea>";
			str += "<div class='reply_btn_wrap'>";
			str += "<button class='small_btn rereply_submit_btn' data-bno='" + $(this).data("bno") + "' data-rno='" +$(this).data("rno") +"' data-replyer='"+ $(this).data("replyer") +"'>확인</button></div>";
			str += "</li>";
			
			$(this).parents(".reply_li").after(str);
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
				$(".reply_ul").remove();
				showList(1);
				inputReply.val("");
				isClickModifyBtn = false;
			});
		})

		$(document).on("click", ".rereply_submit_btn", function(e) {
			e.preventDefault();
			var reply = {
				reply: $(this).parent().prev().val(),
				replyer: replyer,
				rno: $(this).data('rno'),
				bno: bnoValue
			}
			
			replyService.addRereply(reply, function(result) {
				alert(result);
				$(".reply_ul").remove();
				showList(1);
				inputReply.val("");
				isClickModifyBtn = false;
			});
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

		function showList(page) {
			console.log("show List .....")
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
				$(data.list).each(function(i, rep) {
					if(rep.parent==null) {
		 				str += "<li class='reply_li'>";
					} else {
						str += "<li class='reply_li re_reply'>"
					}
					str += "<div class='reply_wrap'>"
					str += "<div class='reply_thumb_box'>";
					if(rep.thumbPhoto != "") {
						str += "<div class='thumb' style='background: url(/display?fileName=" + rep.thumbPhoto + ") no-repeat top center; background-size:cover; background-position: center'></div>";
					} else {
						str += "<div class='thumb'>";
						str += "<i class='fa fa-user-circle-o' aria-hidden='true'></i>";
						str += "</div>";
					}
					str += "<span class='userid'>" + rep.replyer + "</span>";
					str += "</div> ";
					str += "<div class='reply_content_box'>" + rep.reply + "</div>";
					str += "<div class='reply_btn_wrap'>"

					if(rep.replyer == replyer && rep.deleted != 1) {
						str += '<button class="reply_btn remove" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-times" aria-hidden="true"></i></button>';
						str += '<button class="reply_btn modify" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-pencil" aria-hidden="true"></i></button>';
					}
					if(replyer != null && rep.parent == null) {
						str += '<button class="reply_btn rereply" data-rno="' + rep.rno + '" data-replyer="' + rep.replyer + '"><i class="fa fa-commenting-o" aria-hidden="true"></i></button>';
					}
					str += '<div class="reply_date_box">' + replyService.displayTime(rep.replyDate) + '</div>'
					str == "</div>";
					str += "</li>";
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
	} // init();
	
	function add(reply, callback, error) {
		console.log("reply............");
		console.log(reply)
		$.ajax({
			type : 'post',
			url : '/replies/new',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				console.log(er)
			}
		})
	}
	
	function addRereply(reply, callback, error) {
		console.log("ad ReReply............");
		console.log(reply)
		$.ajax({
			type : 'post',
			url : '/replies/newRereply',
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	}
	
/*	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;

		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
				function(data) {
					if (callback) {
						callback(data.replyCnt, data.list)
					}
				}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}
*/

	function getList(param, callback, error) {
		var bno = param.bno;
		var page = param.page || 1;

		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
				function(data) {
					if (callback) {
						callback(data)
					}
				}).fail(function(xhr, status, err) {
			if (error) {
				error();
			}
		});
	}

	function remove(reply, callback, error) {
		console.log("reply.js - remove() call ...")
		
		$.ajax({
			type : 'DELETE',
			url : '/replies/remove/' + reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr) {
				if (callback) {
					callback(deleteResult);
				}
			}
		})
	}
	
	function get (rno, callback, error) {
		$.get("/replies/" + rno + ".json", function (result) {
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr, status, err) {
			if(error) {
				error();
			}
		});
	}
	
	function update (reply, callback) {
		$.ajax({
			type : "PUT",
			url : "/replies/" + reply.rno, 
			data:JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr) {
				if (callback) {
					callback(result);
				}
			}
		})
	}

	
	
	function displayTime(timeValue)  {
		var today = new Date(); // 오늘시간 
		var gap = today.getTime() - timeValue; // 오늘시간과 주어진 시간의 차이
		var dateObj = new Date(timeValue); // 주어진 시간 객체
		var min = 60 * 1000;
		var minsAgo = Math.floor(gap / min);
		
		var result = {
				//'raw': d.getFullYear() + '-' + (d.getMonth() + 1 > 9 ? '' : '0') + (d.getMonth() + 1) + '-' + (d.getDate() > 9 ? '' : '0') +  d.getDate() + ' ' + (d.getHours() > 9 ? '' : '0') +  d.getHours() + ':' + (d.getMinutes() > 9 ? '' : '0') +  d.getMinutes() + ':'  + (d.getSeconds() > 9 ? '' : '0') +  d.getSeconds(),
				'formatted' : '',
		};
		
		if (minsAgo < 60) { // 1시간 내
			result.formatted = minsAgo + '분 전';
		} else if (minsAgo < 60 * 24) { // 하루 내
			result.formatted = Math.floor(minsAgo / 60) + '시간 전';
		} else { // 하루 이상
			result.formatted = Math.floor(minsAgo / 60 / 24) + '일 전';
		};

		var str = "";
		
		if(gap < (1000 * 60 * 60 * 24)) { // 현재 시간과 작성일이의 차이가 하루가 넘는가?
			var result = {
					//'raw': d.getFullYear() + '-' + (d.getMonth() + 1 > 9 ? '' : '0') + (d.getMonth() + 1) + '-' + (d.getDate() > 9 ? '' : '0') +  d.getDate() + ' ' + (d.getHours() > 9 ? '' : '0') +  d.getHours() + ':' + (d.getMinutes() > 9 ? '' : '0') +  d.getMinutes() + ':'  + (d.getSeconds() > 9 ? '' : '0') +  d.getSeconds(),
					'formatted' : '',
			};
			
			if (minsAgo < 60) { // 1시간 내
				result.formatted = minsAgo + '분 전';
			} else if (minsAgo < 60 * 24) { // 하루 내
				result.formatted = Math.floor(minsAgo / 60) + '시간 전';
			} else { // 하루 이상
				result.formatted = Math.floor(minsAgo / 60 / 24) + '일 전';
			};
			
			
			return result.formatted;
		} else {
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1; // getMonth() is zero-based
			var dd = dateObj.getDate();
			
			return [yy, '/', (mm>9 ? '':'0') + mm, '/', (dd>9? '':'0') + dd].join(''); 
		}
	}; 
	
	
	return {
		init : init,
		add : add,
		addRereply : addRereply,
		getList : getList,
		remove : remove,
		get : get,
		update : update, 
		displayTime : displayTime
	};
	
})();