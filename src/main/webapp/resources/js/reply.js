console.log("Reply Module..................");

var replyService = (function() {
	function add(reply, callback, error) {
		console.log("reply............");
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
				if (error) {
					error(er);
				}
			}
		})
	}
	
	function addRereply(reply, callback, error) {
		console.log("reply............");
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

	function remove(rno, replyer, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/replies/' + rno,
			data : JSON.stringify({rno:rno, replyer:replyer}),
			contentType : "application/json; charset=utf-8",
			success : function(deleteResult, status, xhr) {
				if (callback) {
					callback(deleteResult);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
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
		add : add,
		addRereply : addRereply,
		getList : getList,
		remove : remove,
		get : get,
		update : update, 
		displayTime : displayTime
	};
	
})();