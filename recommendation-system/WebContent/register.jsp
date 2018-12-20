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
	<script type="text/javascript">

    </script>
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
				<form action="ControllerServlet?method=register" name="myform" method="post">
					<table>
						<tr>
							<td>Username:</td>
							<td>
								<div>
									<input type="text" name="userName" class="required">
								</div>
							</td>
						</tr>
						<tr>
							<td>Age:</td>
							<td>
								<div>
									<input type="text" name="age" class="required">
								</div>
							</td>
						</tr>
						<tr>
							<td>Gender:</td>
							<td>
								<div>
									<input type="radio" name="sex" value="M" checked="checked">Male
									<input type="radio" name="sex" value="F">Female
								</div>
							</td>
						</tr>
						<tr>
							<td>Occupation:</td>
							<td>
								<div>
									<select name="occupation">
										<option value="administrator">Administrator</option>
										<option value="artist">Artist</option>
										<option value="doctor">Doctor</option>
										<option value="educator">Educator</option>
										<option value="engineer">Engineer</option>
										<option value="entertainment">Entertainment</option>
										<option value="executive">Executive</option>
										<option value="healthcare">Healthcare</option>
										<option value="homemaker">Homemaker</option>
										<option value="lawyer">Lawyer</option>
										<option value="librarian">Librarian</option>
										<option value="marketing">Marketing</option>
										<option value="none">None</option>
										<option value="other">Other</option>
										<option value="programmer">Programmer</option>
										<option value="retired">Retired</option>
										<option value="salesman">Salesman</option>
										<option value="scientist">Scientist</option>
										<option value="student">Student</option>
										<option value="technician">Technician</option>
										<option value="writer">Writer</option>
									</select>
								</div>
							</td>
						</tr>
						<tr>
							<td>Zip code:</td>
							<td>
								<div>
									<input type="text" name="zipCode" class="required">
								</div>
							</td>
						</tr>
						<tr>
							<td>Password:</td>
							<td>
								<div>
									<input type="password" name="password" class="required">
								</div>
							</td>
						</tr>
						<tr>
							<td><input type="button" class="btn btn-default" name="button" value="Register" style="background-color:#1abc9c"></td>
							<td>
							</td>
						</tr>
					</table>
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
            
        	$('.age_error').remove();
            if($('input[name="age"]').val() == ""){
                $('input[name="age"]').parent().append("<span class='age_error' style='color: red'>Please input Age</span>");
                flg = false;
            }
            
        	$('.zipCode_error').remove();
            if($('input[name="zipCode"]').val() == ""){
                $('input[name="zipCode"]').parent().append("<span class='zipCode_error' style='color: red'>Please input Zip Code</span>");
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