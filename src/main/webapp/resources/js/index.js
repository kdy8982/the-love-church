console.log("Index Module..................");

var indexService = (function() {

	var bxrolling = {
		'init' : function() {
			this.action();
		},
		'action' : function() {
			var $ele = {
				'roll' : $('.swipe_wrap')
			}
			var bxOption = function() {
				var windowSize = $(window).width();
				if(windowSize >= 768) {
					var vars = {
						mode : 'horizontal',// 가로 방향 수평 슬라이드
						nextSelector: '#bxslider_next',
						prevSelector: '#bxslider_prev',
						nextText : '<i class="fa fa-chevron-right" aria-hidden="true"></i>',
						prevText : '<i class="fa fa-chevron-left" aria-hidden="true"></i>',
						speed : 500, // 이동 속도를 설정
						pause : 2000, // 페이지 넘김 속도를 조절
						pager : false, // 현재 위치 페이징 표시 여부 설정
						moveSlides : 1, // 슬라이드 이동시 개수
						slideWidth : 800, // 슬라이드 너비
						minSlides : 4, // 최소 노출 개수
						maxSlides : 4, // 최대 노출 개수
						slideMargin : 20, // 슬라이드간의 간격
						auto : false, // 자동 실행 여부
						autoHover : true, // 마우스 호버시 정지 여부
						controls : true, // 이전 다음 버튼 노출 여부
						responsive : false,
						touchEnabled : (navigator.maxTouchPoints > 0)
					}
				} else if (windowSize < 768) {
					var vars = {
						mode : 'horizontal',// 가로 방향 수평 슬라이드
						nextSelector: '#bxslider_next',
						prevSelector: '#bxslider_prev',
						nextText : '<i class="fa fa-chevron-right" aria-hidden="true"></i>',
						prevText : '<i class="fa fa-chevron-left" aria-hidden="true"></i>',
						speed : 500, // 이동 속도를 설정
						pause : 2000, // 페이지 넘김 속도를 조절
						pager : false, // 현재 위치 페이징 표시 여부 설정
						moveSlides : 1, // 슬라이드 이동시 개수
						slideWidth : 800, // 슬라이드 너비
						minSlides : 2, // 최소 노출 개수
						maxSlides : 2, // 최대 노출 개수
						slideMargin : 20, // 슬라이드간의 간격
						auto : false, // 자동 실행 여부
						autoHover : true, // 마우스 호버시 정지 여부
						controls : true, // 이전 다음 버튼 노출 여부
						responsive : false,
						touchEnabled : (navigator.maxTouchPoints > 0)
					}
				} 
				return vars;
			}
			
			var rolling = function() {
				roll = $ele.roll.bxSlider(bxOption());
			}
			
			rolling();
			$(window).on({
				'load resize' : function() {
					roll.reloadSlider(bxOption());
				}
			})
		}
	}
	
	function init(windowSize) {
		var callingOption = function() {
			console.log("calling option.....")
			$('.gallery_li').empty();
			$(".book_li").empty();
			
			if($(window).width() >= 768) {
				$.ajax({
					url: '/pcIndex',
					dataType : "json",
					type: 'GET',
					success: function(result) {
						$.each(result, function(key, value) {
							if(key =='photoList') {
								var str = '';
								$.each(value, function (index, item) {
									if(item.photoCnt != 0) {
										str += '<li class="yesupload bg1">';
										str += 	'<a class="move" href="/photo/get?pageNum=1&boardType=photo&bno='+ item.bno +'" data-type="photo" data-url="/photo/get" data-amount="12">';
										str += 			'<div class="thumb" style="background: url(' + item.thumbPhoto + ')no-repeat top center; background-size: cover; background-position: center;">';
										str += 					'<p class="photo-cntbox">';
										str += 						'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 						 item.videoCnt;
										str +=                      '  ';
										str += 						'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 						 item.photoCnt;
										str +=                      '  ';
										str +=                       '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 						 item.replyCnt;			
										str += 					'</p>';
										str += 			'</div>';
										str += 	'</a>';
										str += '</li>';
									} else if(item.attachList.length == 0) {
										str += '<li class="yesupload bg1">';
										str += 	'<a class="move" href="/photo/get?pageNum=1&boardType=photo&bno='+ item.bno +'" data-type="photo" data-url="/photo/get" data-amount="12">';
										str += 			'<div class="thumb">';
										str += 					'<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>'
										str += 					'<p class="photo-cntbox">';
										str += 						'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 						 item.videoCnt;
										str +=                      '  ';
										str += 						'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 						 item.photoCnt;
										str +=                      '  ';
										str +=                       '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 						 item.replyCnt;			
										str += 					'</p>';
										str += 			'</div>';
										str += 	'</a>';
										str += '</li>';
									}
								})
								$('.gallery_li').append(str);
								if(value.length < 4) {
									console.log("here..!")
									var str = '';
									for(var i=0; i<4-value.length; i++ ) {
										str += "<li style='visibility: hidden'></li>";
									}
									$('.gallery_li').append(str);
								}
							} else if (key == 'essayList') {
								var str = '';
								$.each(value, function (index, item) {
									//if(item.photoCnt != 0) {
										// var filePath = item.attachList[0].uploadPath.replace(/\\/g, '/');
										// var fullFilePath = filePath + '/s_' +item.attachList[0].uuid + '_' + item.attachList[0].fileName;
										str += '<li>';
										str	+= 	'<a class="move" href="/essay/get?pageNum=1&boardType=essay&bno='+ item.bno +'" data-type="essay" data-url="/essay/get" data-amount="6">';
										str +=   		'<div class="thumb" style="background: url(https://img.youtube.com/vi/' + item.thumbVideo + '/hqdefault.jpg)no-repeat top center; background-size: cover; background-position: center;">';
										str += 				'<p class="photo-cntbox">';
										str += 					'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 					 item.videoCnt;
										str +=                   '  ';
										str += 					'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 					 item.photoCnt;
										str +=                   '  ';
										str +=                  '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 					 item.replyCnt;			
										str += 				'</p>';
										str +=   		'</div>';
										str +=   		'<div class="desc_content_box">';
										str +=     			'<div class="desc">';
										str +=     				'<h3 class="book_title">' + item.title + '</h3>';
										str +=     				'<div class="content">';
										str +=             	  		item.content;
										str +=           		'</div>';
										str +=     			'</div>';
										str +=   		'</div>';
										str +=   '</a>';
										str += '</li>';
										/*
									} else if (item.photoCnt == 0) {
										str += '<li>';
										str	+= 	'<a class="move" href="/essay/get?pageNum=1&boardType=essay&bno='+ item.bno +'" data-type="essay" data-url="/essay/get" data-amount="6">';
										str +=   		'<div class="thumb">';
										str += 				'<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>'
										str += 				'<p class="photo-cntbox">';
										str += 					'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 					 item.videoCnt;
										str +=                   '  ';
										str += 					'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 					 item.photoCnt;
										str +=                   '  ';
										str +=                  '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 					 item.replyCnt;			
										str += 				'</p>';
										str +=   		'</div>';
										str +=   		'<div class="desc_content_box">';
										str +=     			'<div class="desc">';
										str +=     				'<h3 class="book_title">' + item.title + '</h3>';
										str +=     				'<p class="book_writer">kdy8982</p>';
										str +=     				'<div class="content">';
										str +=             	  		item.content;
										str +=           		'</div>';
										str +=     			'</div>';
										str +=   		'</div>';
										str +=   '</a>';
										str += '</li>';
									}
									*/
								})
								$('.book_li').append(str);
								$(".desc_content_box .content").each(function(i, obj){
									$(this).html(obj.innerText);
								})
								if(value.length < 3) {
									var str = '';
									for(var i=0; i<3-value.length; i++ ) {
										str += "<li style='visibility: hidden'></li>";
									}
									$('.book_li').append(str);
								}
							}
						})
					}
				})					
			} else if ($(window).width() < 768) {
				$.ajax({
					url: '/mobileIndex',
					dataType : "json",
					type: 'GET',
					success: function(result) {
						$.each(result, function(key, value) {
							if(key =='photoList') {
								var str = '';
								$.each(value, function (index, item) {
									console.log(item.attachList.length)
									if(item.photoCnt != 0) {
										// var filePath = item.attachList[0].uploadPath.replace(/\\/g, '/');
										// var fullFilePath = filePath + '/s_' +item.attachList[0].uuid + '_' + item.attachList[0].fileName;
										str += '<li class="yesupload bg1">';
										str += 	'<a class="move" href="/photo/get?pageNum=1&boardType=photo&bno='+ item.bno +'" data-type="photo" data-url="/photo/get" data-amount="12">';
										str += 			'<div class="thumb" style="background: url(' + item.thumbPhoto + ')no-repeat top center; background-size: cover; background-position: center;">';
										
										str += 					'<p class="photo-cntbox">';
										str += 						'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 						 item.videoCnt;
										str +=        	         	 '  ';
										str += 						'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 						 item.photoCnt;
										str +=       	        	 '  ';
										str +=        	          '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 						 item.replyCnt;			
										str += 					'</p>';
										
										str += 			'</div>';
										str += 	'</a>';
										str += '</li>';
									} else if(item.photoCnt == 0) {
										str += '<li class="yesupload bg1">';
										str += 	'<a class="move" href="/photo/get?pageNum=1&boardType=photo&bno='+ item.bno +'" data-type="photo" data-url="/photo/get" data-amount="12">';
										str += 			'<div class="thumb">';
										str += 					'<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>'
										str += 					'<p class="photo-cntbox">';
										str += 						'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 						 item.videoCnt;
										str +=        	         	 '  ';
										str += 						'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 						 item.photoCnt;
										str +=       	        	 '  ';
										str +=        	          '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 						 item.replyCnt;			
										str += 					'</p>';
										str += 			'</div>';
										str += 	'</a>';
										str += '</li>';
									}
								})
								$('.gallery_li').append(str);
								if(value.length < 2) {
									console.log("here..!")
									var str = '';
									for(var i=0; i<2-value.length; i++ ) {
										str += "<li style='visibility: hidden'></li>";
									}
									$('.gallery_li').append(str);
								}
							} else if (key == 'essayList') {
								var str = '';
								$.each(value, function (index, item) {
									//if(item.photoCnt != 0) {
										// var filePath = item.attachList[0].uploadPath.replace(/\\/g, '/');
										// var fullFilePath = filePath + '/s_' +item.attachList[0].uuid + '_' + item.attachList[0].fileName;
										str += '<li>';
										str	+= 	'<a class="move" href="/essay/get?pageNum=1&boardType=essay&bno='+ item.bno +'" data-type="essay" data-url="/essay/get" data-amount="6">';
										str +=   		'<div class="thumb" style="background: url(https://img.youtube.com/vi/' + item.thumbVideo + '/hqdefault.jpg)no-repeat top center; background-size: cover; background-position: center;">';
										str += 				'<p class="photo-cntbox">';
										str += 					'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 					 item.videoCnt;
										str +=                   '  ';
										str += 					'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 					 item.photoCnt;
										str +=                   '  ';
										str +=                  '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 					 item.replyCnt;			
										str += 				'</p>';
										str +=   		'</div>';
										str +=   		'<div class="desc_content_box">';
										str +=     			'<div class="desc">';
										str +=     				'<h3 class="book_title">' + item.title + '</h3>';
										str +=     				'<p class="book_writer">kdy8982</p>';
										str +=     				'<div class="content">';
										str +=             	  		item.content;
										str +=           		'</div>';
										str +=     			'</div>';
										str +=   		'</div>';
										str +=   '</a>';
										str += '</li>';
										/*
									} else if (item.photoCnt == 0) {
										str += '<li>';
										str	+= 	'<a class="move" href="/essay/get?pageNum=1&boardType=essay&bno='+ item.bno +'" data-type="essay" data-url="/essay/get" data-amount="6">';
										str +=   		'<div class="thumb">';
										str += 				'<div class="center_wrap no_image"><i class="fa fa-picture-o" aria-hidden="true"></i></div>'
										str += 				'<p class="photo-cntbox">';
										str += 					'<i class="fa fa-youtube-play" aria-hidden="true"></i>+';
										str += 					 item.videoCnt;
										str +=                   '  ';
										str += 					'<i class="fa fa-camera-retro" aria-hidden="true"></i>+';
										str += 					 item.photoCnt;
										str +=                   '  ';
										str +=                  '<i class="fa fa-commenting-o" aria-hidden="true"></i>+';
										str += 					 item.replyCnt;			
										str += 				'</p>';
										str +=   		'</div>';
										str +=   		'<div class="desc_content_box">';
										str +=     			'<div class="desc">';
										str +=     				'<h3 class="book_title">' + item.title + '</h3>';
										str +=     				'<p class="book_writer">kdy8982</p>';
										str +=     				'<div class="content">';
										str +=             	  		item.content;
										str +=           		'</div>';
										str +=     			'</div>';
										str +=   		'</div>';
										str +=   '</a>';
										str += '</li>';
									}
									*/
								})
								$('.book_li').append(str);
								$(".desc_content_box .content").each(function(i, obj){
									$(this).html(obj.innerText);
								})
								if(value.length < 2) {
									var str = '';
									for(var i=0; i<2-value.length; i++ ) {
										str += "<li style='visibility: hidden'></li>";
									}
									$('.book_li').append(str);
								}
							}
						})
					}
				})
			}
		}
		callingOption();
		
		var timer = null;
		$(window).on('resize', function() {
			if(windowSize != $(window).width()) { // ios safari에서 스크롤시, 화면이 자동으로 resize되는 것을 막기 위하여 체크해준다.
			   // resize 후 한번만 실행
			   clearTimeout( timer );
			   timer = setTimeout( callingOption, 150 );
			}
		});
	}
	
	return {
		bxrolling : bxrolling,
		init : init
	};
	
})();