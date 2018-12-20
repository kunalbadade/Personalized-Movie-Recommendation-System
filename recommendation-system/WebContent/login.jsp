<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Movie Recommend</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Loading Bootstrap -->
<link href="css/bootstrap.min.css" rel="stylesheet">

<!-- Loading Flat UI -->
<link href="css/flat-ui.css" rel="stylesheet">

<link rel="shortcut icon" href="../../dist/img/favicon.ico">
<style>
body {
	min-height: 200px;
	padding-top: 70px;
}
</style>
</head>

<body>
	<!-- Static navbar -->
	<div class="navbar navbar-default navbar-fixed-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
				</button>
				<a class="navbar-brand">Personalized Movie Recommendation System</a>
			</div>
		</div>
	</div>

	<div class="container">

		<!-- Main component for a primary marketing message or call to action -->
		<div class="tabbable">
			<div class="tab-content">
				<div id="ERROR_MESSAGE" style="color:red; display:none">Username or Password is wrong</div>
				<input type="hidden" value="<%=request.getAttribute("errorFlg")%>" name="errorFlg" id="errorFlg"/>
				<form action="ControllerServlet?method=login" name="myform" method="post">
					<div>
						Username:
					</div>
					<div>
						<input type="text" name="userName" class="required">
					</div>
					<div>
						Password:
					</div>
					<div>
						<input type="password" name="password" class="required">
					</div>
					<p><p>
					<div>
						<input type="button" class="btn btn-default" name="button" value="Login" style="background-color:#1abc9c"><br>
						<a href="./register.jsp">Haven't Registered Yet? Register Here</a>
					</div>
			    </form>
			</div>
		</div>

	</div>
	<!-- /container -->

	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="js/jquery.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<!-- <script src="js/jquery-ui.js"></script> -->
	<script src="js/flat-ui.js"></script>
	<script src="js/als.js"></script>
	<script type="text/javascript">
        $('input[name="button"]').click(function(){
        	var flg = true;
        	$('.userName_error').remove();
            if($('input[name="userName"]').val() == ""){
                $('input[name="userName"]').parent().append("<span class='userName_error' style='color: red'>Please input Username</span>");
                flg = false;
            }
        	$('.password_error').remove();
            if($('input[name="password"]').val() == ""){
                $('input[name="password"]').parent().append("<span class='password_error' style='color: red'>Please input Password</span>");
                flg = false;
            }
            if (flg) {
            	document.myform.submit();
            }
        });
	</script>
</body>
</html>