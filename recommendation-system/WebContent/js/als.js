function addLoadMsg() {
    var targelem = document.getElementById("loader_container");
    targelem.style.display = 'block';
}

function removeLoadMsg() {
    var targelem = document.getElementById("loader_container");
    targelem.style.display = 'none';
}

/**
 * 设置进度条
 * @param id
 * @param value
 */
function setProgress(id,value){
	$("#"+id).css("width",value);
	$("#"+id).html(value);
}

/**
 * 开启模态框
 * @param id
 */
function openModal(id){
        var $modal_dialog = $('#'+id).find('.modal-dialog');
        $('#'+id).css('display', 'block');
        $('#'+id).modal("show")

}
/**
 * 关闭模态框
 * @param id
 */
function closeModal(id){
	$('#'+id).modal("hide");
}

/**
	 * 请求任务进度
	 */
function queryTaskProgress(appId){
	// ajax 发送请求获取任务运行状态，如果返回运行失败或成功则关闭弹框
	$.ajax({
		type : "POST",
		url : "Monitor",
//			dataType : "json",
		async:false,// 同步执行
		data:{APPID:appId},
		success : function(data) {
//			console.info("success:"+data);
			if(data.indexOf("%")==-1){// 不包含 ，任务运行完成（失败或成功）
				clearTimeout(t);// 关闭计时器
				// 关闭弹窗进度条
				$('#myModal1').modal("hide");
				// 开启提示条模态框
			
				$('#tipId').html(data=="FINISHED"?"模型训练完成！": 
					(data=="FAILED"?"调用建模失败!":"模型训练被杀死！"));
				
				openModal("myModal2");
				console.info("closed!");
				return ;
			}
			
			setProgress("progressId", data);
			// 进度查询每次间隔1500ms
			t=setTimeout("queryTaskProgress('"+appId+"')",1500);
		},
		error: function(data){
			console.info("error"+data);
			
		}
	});
}

$(function() {
	
	if ("true" == $("#errorFlg").val()) {
		document.getElementById("ERROR_MESSAGE").style.display="block";
	}
	
	$("form :input.required").each(function(){
        var $required = $("<strong style='color: red'>*</strong>");
        $(this).parent().append($required);
    });
	
	var t ;
	
	// train button
	$("#train_model").click(
		function() {
			var ret = "null";
			var rating = $("#rating").val();
			var recommendUserId = $("#recommendUserId").val();
			var movies = $('input[name="movies"]');
			var movieStr = "";
			for (var i=0; i<movies.length; i++) {
				if (movies[i].disabled == false && movies[i].checked) {
					movieStr = movieStr + "," + movies[i].value;
				}
			}
			if (movieStr == "") {
				alert("Please select movies!");
				return;
			}
			
			addLoadMsg();
			
			$.ajax({
				type : "POST",
				url : "ControllerServlet",
				async: true,
				data : {method:"train", rating:rating, recommendUserId:recommendUserId, movies:movieStr},

				success : function(data) {
					console.info("success:"+data);
					ret = data=="null"?"null":data;
					for (var i=0; i<movies.length; i++) {
						if (movies[i].disabled == false && movies[i].checked) {
							movies[i].disabled = true;
						}
					}
					removeLoadMsg();
				},
				error: function(data){
					console.info("error"+data);
					ret = data=="null"?"null":data;
					for (var i=0; i<movies.length; i++) {
						if (movies[i].disabled == false && movies[i].checked) {
							movies[i].checked = false;
						}
					}
					removeLoadMsg();
				}
			});

		});
	
	
	// demographic recommendation
	$("#demographic_recommend").click(function(){
		var ret = null;
		
		addLoadMsg();
		
		$.ajax({
			type : "POST",
			url : "ControllerServlet",
			async: true,
			data : {method:"demographic"},
			dataType : "json",
			success : function(httpdata) {
				var showResultHtml;
				for(var i=0;i<httpdata.jsonArray.length-1; i++){
					showResultHtml = showResultHtml +
								'<tr>'+
									'<td>'+
									eval(i+1) +
									'</td>'+
									'<td width="65%">'+
									'<a target="_blank" href="https://www.youtube.com/results?search_query=' + httpdata.jsonArray[i].key + '">' + httpdata.jsonArray[i].key +'</a>' +
									'</td>'+
									'<td width="30%">'+
									httpdata.jsonArray[i].value +
									'</td>'+
								'</tr>';
				}
	         	$('#demographicMoviesTable').html(showResultHtml);
	         	$('#precision_demographic').html("Accuracy: " + httpdata.jsonArray[httpdata.jsonArray.length-1].value + "%");
	         	removeLoadMsg();
			},
			error: function(data){
				console.info("error"+data);
				ret = data=="null"?"null":data;
				removeLoadMsg();
			}
		});
	});
	
	// content-based recommendation
	$("#content_based_recommend").click(function(){
		var ret = null;
		addLoadMsg();
		
		$.ajax({
			type : "POST",
			url : "ControllerServlet",
			async: true,
			data : {method:"contentBased"},
			dataType : "json",
			success : function(httpdata) {
				var showResultHtml;
				for(var i=0;i<20; i++){
					showResultHtml = showResultHtml +
								'<tr>'+
									'<td>'+
									eval(i+1) +
									'</td>'+
									'<td width="65%">'+
									'<a target="_blank" href="https://www.youtube.com/results?search_query=' + httpdata.jsonArray[i].key + '">' + httpdata.jsonArray[i].key +'</a>' +
									'</td>'+
									'<td width="30%">'+
									httpdata.jsonArray[i].value +
									'</td>'+
								'</tr>';
				}
	         	$('#contentBasedMoviesTable').html(showResultHtml);
	         	$('#precision_content_based').html("Accuracy: " + httpdata.jsonArray[httpdata.jsonArray.length-1].value + "%");
	         	removeLoadMsg();
			},
			error: function(data){
				console.info("error"+data);
				ret = data=="null"?"null":data;
				removeLoadMsg();
			}
		});
	});
	
	// item_based_collaborative recommendation
	$("#item_based_collaborative_recommend").click(function(){
		var ret = null;
		addLoadMsg();
		
		$.ajax({
			type : "POST",
			url : "ControllerServlet",
			async: true,
			data : {method:"itemBasedCollaborative"},
			dataType : "json",
			success : function(httpdata) {
				var showResultHtml;
				for(var i=0;i<httpdata.jsonArray.length-1; i++){
					showResultHtml = showResultHtml +
								'<tr>'+
									'<td>'+
									eval(i+1) +
									'</td>'+
									'<td width="65%">'+
									'<a target="_blank" href="https://www.youtube.com/results?search_query=' + httpdata.jsonArray[i].key + '">' + httpdata.jsonArray[i].key +'</a>' +
									'</td>'+
									'<td width="30%">'+
									httpdata.jsonArray[i].value +
									'</td>'+
								'</tr>';
				}
	         	$('#itemBasedMoviesTable').html(showResultHtml);
	         	$('#precision_item_based').html("Accuracy: " + httpdata.jsonArray[httpdata.jsonArray.length-1].value + "%");
	         	removeLoadMsg();
			},
			error: function(data){
				console.info("error"+data);
				ret = data=="null"?"null":data;
				removeLoadMsg();
			}
		});
	});
	
	// user_based_collaborative recommendation
	$("#user_based_collaborative_recommend").click(function(){
		var ret = null;
		addLoadMsg();
		
		$.ajax({
			type : "POST",
			url : "ControllerServlet",
			async: true,
			data : {method:"userBasedCollaborative"},
			dataType : "json",
			success : function(httpdata) {
				var showResultHtml;
				for(var i=0;i<httpdata.jsonArray.length-1; i++){
					showResultHtml = showResultHtml +
								'<tr>'+
									'<td>'+
									eval(i+1) +
									'</td>'+
									'<td width="65%">'+
									'<a target="_blank" href="https://www.youtube.com/results?search_query=' + httpdata.jsonArray[i].key + '">' + httpdata.jsonArray[i].key +'</a>' +
									'</td>'+
									'<td width="30%">'+
									httpdata.jsonArray[i].value +
									'</td>'+
								'</tr>';
				}
	         	$('#userBasedMoviesTable').html(showResultHtml);
	         	$('#precision_user_based').html("Accuracy: " + httpdata.jsonArray[httpdata.jsonArray.length-1].value + "%");
	         	removeLoadMsg();
			},
			error: function(data){
				console.info("error"+data);
				ret = data=="null"?"null":data;
				removeLoadMsg();
			}
		});
	});
	
});