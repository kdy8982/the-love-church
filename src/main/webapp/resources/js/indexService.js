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

            /*$('#main_slider').bxSlider({
                mode: 'fade',
                auto: true,
                pause: 3000,
                pager:true,
                controls: false,
                infiniteLoop: true
            });*/

			if($(window).width() >= 768) {

			} else if ($(window).width() < 768) {
			}
		}

		callingOption();
		
		var timer = null;
		$(window).load(function() {
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