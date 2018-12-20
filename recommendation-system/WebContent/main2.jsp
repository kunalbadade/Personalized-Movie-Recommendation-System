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
<!-- <link href="css/jquery-ui.css" rel="stylesheet"> -->


<!-- Loading Flat UI -->
<link href="css/flat-ui.css" rel="stylesheet">

<link rel="shortcut icon" href="../../dist/img/favicon.ico">
<!-- HTML5 shim, for IE6-8 support of HTML5 elements. All other JS at the end of file. -->
<!--[if lt IE 9]>
      <script src="../../dist/js/vendor/html5shiv.js"></script>
      <script src="../../dist/js/vendor/respond.min.js"></script>
    <![endif]-->

	<script type="text/javascript">
		function addLoadMsg() {
		    var targelem = document.getElementById("loader_container");
            targelem.style.display = 'block';
        }
		
        function removeLoadMsg() {
            var targelem = document.getElementById("loader_container");
            targelem.style.display = 'none';
        }
    </script>
</head>
<body>
	<style>
body {
	min-height: 200px;
	padding-top: 70px;
}
</style>
	<div id="loader_container" 
		style="display:none;position:absolute;
		top:0px;left:0px;width:100%;height:100%;line-height:630px;
		background-color:rgba(0,0,0,.2);
		font-size:18px;color:#fff;z-index:99;" align="center"> 
		&nbsp;<img src="pic/loading.gif">
	</div>

	<!-- Static navbar -->
	<div class="navbar navbar-default navbar-fixed-top" role="navigation">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="sr-only">Toggle navigation</span>
				</button>
				<a class="navbar-brand">Personalization Recommendation System</a>
			</div>
			<div style="float:right">
				hello,&nbsp;<%=request.getSession().getAttribute("userName")%>
				&nbsp;&nbsp;
				<a href="./login.jsp">LOG OUT</a>
			</div>
		</div>
	</div>

	<div class="container">

		<!-- Main component for a primary marketing message or call to action -->
		<div class="tabbable">
			<!-- Only required for left/right tabs -->
			<ul class="nav nav-tabs">
				<li class="active"><a href="#tab1" data-toggle="tab">Introduction</a></li>
				<li><a href="#tab2" data-toggle="tab">Training</a></li>
				<li><a href="#tab3" data-toggle="tab">Recommend</a></li>
			</ul>
			<div class="tab-content">
				<div class="tab-pane active" id="tab1">
					<br>
					<p>Personalization Recommendation System: Use Python to make recommendations. The function includes
					<li>1)Data Training</li>
					<li>2)Recommendation</li> <br>Model Comparasion
					<li>1)Model1</li>
					<li>2)Model2</li>
					<li>3)Model3</li>
					</p>
				</div>
				<div class="tab-pane" id="tab2">
					<br>
					<div class="row">
						<div class="col-md-8 col-md-offset-1">
							<p>input the parameters and start the data training</p>
							<form class="form-horizontal" role="form">
								<div class="form-group">
								<label class="col-lg-2 control-label">input path</label>
									<div class="col-lg-10">
										<input type="text" class="form-control" id="input_id"
											value="C:\Users\JAMES\PycharmProjects\pythonPro2\ml-100k"
											placeholder="C:\Users\JAMES\PycharmProjects\pythonPro2\ml-100k">
									</div>
								</div>
								<div class="form-group">
								<label class="col-lg-2 control-label">train rating</label>
									<div class="col-lg-10">
										<select id="train_percent" class=" form-control">
											<option value="0.9">90%</option>
											<option value="0.8">80%</option>
											<option value="0.7">70%</option>
											<option value="0.6">60%</option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-2 control-label">train rating2</label>
									<div class="col-lg-10">
										<select id="ranks" class=" form-control">
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-2 control-label">train rating3</label>
									<div class="col-lg-10">
										<select id="lambda" class=" form-control">
											<option value="0.1">0.1</option>
											<option value="0.2">0.2</option>
											<option value="0.5">0.5</option>
											<option value="1">1</option>
											<option value="2">2</option>
											<option value="3">3</option>
											<option value="5">5</option>
											<option value="10">10</option>
											<option value="11">11</option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<label class="col-lg-2 control-label">train rating4</label>
									<div class="col-lg-10">
										<select id="iterations" class=" form-control">
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="10">10</option>
											<option value="11">11</option>
											<option value="20">20</option>
										</select>
									</div>
								</div>
								<div class="form-group">
									<div class="col-lg-offset-2 col-lg-10">
										<input id="train_model" class="btn btn-default" type="button"
											value="train">
									</div>
								</div>
							</form>
						</div>
						<div class="modal fade" id="myModal1" tabindex="-1" role="dialog"
							aria-labelledby="myModalLabel">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									asdfasdfasdfadsf
								</div>
							</div>
						</div>
						<!-- modal fade  -->
						<div class="modal fade" id="myModal2" tabindex="-1" role="dialog"
							aria-labelledby="myModalLabel2">
							<div class="modal-dialog" role="document">
								<div class="modal-content">
									<div class="alert alert-warning" style="margin-bottom: 0px;">
										<a href="#" onclick="closeModal('myModal2')" class="close">
											&times; </a>
										<div id="tipId">Training is done!</div>
									</div>

								</div>
							</div>
						</div>
						<!-- modal fade  -->
						<!-- /.col-md-8 -->
					</div>
					<!-- /.row -->
				</div>
				<div class="tab-pane " id="tab3">
					<br>
					<div class="row">
						<div class="col-md-8 col-md-offset-1">
							<p>input the userId to see the recommend movie</p>
							<div class="form-group">
								<label class="col-lg-2 control-label">User ID</label>
								<div class="col-lg-2"><input type="text" class="form-control" id="userId" value="1"
										placeholder="1">
								</div>
								<div class="col-lg-2">
									<input type="button" class="btn btn-default " id="checkId"
										value="search">
								</div>
								<label class="col-lg-2 control-label">recommend number</label>
								<div class="col-lg-2">
									<select id="recommendNumId" class=" form-control">
											<option value="10">10</option>
											<option value="3">3</option>
											<option value="4">4</option>
											<option value="5">5</option>
											<option value="6">6</option>
											<option value="7">7</option>
											<option value="8">8</option>
											<option value="9">9</option>
											<option value="11">11</option>
											<option value="20">20</option>
										</select>
								</div>
								<div class="col-lg-2">
									<input type="button" class="btn btn-default" id="recommendId"
										value="recommend">
								</div>

							</div>

						</div>
						<!-- col-md-8  -->
						<div class="col-md-10 col-md-offset-1" id="movieResultId">
							
						</div>
					</div>
				</div>
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
</body>
</html>