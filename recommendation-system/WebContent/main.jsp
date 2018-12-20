<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page language="java" import="java.util.*"%>
<%@page import="com.data.manager.entity.Label"%>

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
		.moviesTable{      
			table-layout:fixed;      
			border:1px solid #FF0000; 
			margin:0px;       
			background-color:#BDE1F2;       
		}      
		.moviesTable tr td{       
			text-overflow:ellipsis; /* for IE */       
			-moz-text-overflow: ellipsis; /* for Firefox,mozilla */       
			overflow:hidden;      
			white-space: nowrap;      
			border:1px solid #FFFF33;      
			text-align:left       
		}         
	</style>
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
				<a class="navbar-brand">Personalized Movie Recommendation System</a>
			</div>
			<div style="float:right">
				Hello,&nbsp;<%=request.getSession().getAttribute("userName")%>
				&nbsp;&nbsp;
				<a href="./login.jsp">LOG OUT</a><br>
				<%=request.getSession().getAttribute("preference")%>
			</div>
		</div>
	</div>
	<div class="container">
		<!-- Main component for a primary marketing message or call to action -->
		<div class="tabbable">
			<!-- Only required for left/right tabs -->
			<ul class="nav nav-tabs">
				<li class="active"><a href="#tab1" data-toggle="tab">Introduction</a></li>
				<li><a href="#tab2" data-toggle="tab">Simulation</a></li>
				<li><a href="#tab3" data-toggle="tab">Demographic Model</a></li>
				<li><a href="#tab4" data-toggle="tab">Content-based Model</a></li>
				<li><a href="#tab5" data-toggle="tab">Item-based Model</a></li>
				<li><a href="#tab6" data-toggle="tab">User-based Model</a></li>
			</ul>
			<div class="tab-content">
				<div class="tab-pane active" id="tab1">
					<br>
					<p>This system recommends movies to user using four techniques. 
						The system is built in Python. The function includes:</p>
					<ul>
						<li>Data Training</li>
					</ul>	
					<p>The four techniques are:</p>
					<ul>
						<li>Demographic Model</li>
						<li>Content-based Model</li>
						<li>Item-based Model</li>
						<li>User-based Model</li>
					</ul>	
					<p>Validation Model:</p>
					<ul>
						<li>TopN Model - Precision</li>
					</ul>
				</div>
				<div class="tab-pane" id="tab2">
					<br>
					<div class="row">
						<div class="">
							<p>Check the movies to generate user profile 
								<span style="float:right">
									Rating:
									<select name="rating" id="rating">
										<option value="1">1</option>
										<option value="2">2</option>
										<option value="3">3</option>
										<option value="4">4</option>
										<option value="5">5</option>
									</select>
									<span style="display:none">
										&nbsp;&nbsp;&nbsp;
										Recommend to User:
										<input type="text" id="recommendUserId" name="recommendUserId" style="width:50px">
									</span>
									<input id="train_model" class="btn btn-default" type="button" value="Train" style="background-color:#1abc9c">
								</span>
								
							</p>
							<form role="form">
								<div class="form-group">
									<table class="moviesTable" width="1170px">
										<c:forEach items="${movieList}" var="item" varStatus="status"> 
										<c:set var="indexId" value="${status.index}" scope="request"/>
											<%
												int indexId = Integer.parseInt(request.getAttribute("indexId").toString());
												if (indexId%4 == 0) {
											%>
												<tr>
											<%
												}
											%>
												<td width="25%">
													<c:choose>  
														<c:when test="${item.key.equals(item.ifChecked)}">
															<input name="movies" type="checkbox" value="${item.key}" checked="checked" disabled="disabled"/>
														</c:when>  
														<c:otherwise>
															<input name="movies" type="checkbox" value="${item.key}"/>
														</c:otherwise>  
													</c:choose>  
													${item.value}
												</td>
										</c:forEach>
									</table>
								</div>
							</form>
						</div>
					</div>
					<!-- /.row -->
				</div>
				<div class="tab-pane " id="tab3">
					<br>
					<div class="row">
						<div class="">
							<p>Click the recommend button to make recommendations
								<span style="padding-left:25px">
									<input id="demographic_recommend" class="btn btn-default" type="button" value="Recommend" style="background-color:#1abc9c">
								</span>
								<span id="precision_demographic" style="float:right"></span>
							</p>
							<form role="form">
								<div class="form-group">
									<table class="moviesTable" width="1170px" id="demographicMoviesTable">
									</table>
								</div>
							</form>
						</div>
					</div>
					<!-- /.row -->
				</div>
				<div class="tab-pane " id="tab4">
					<br>
					<div class="row">
						<div class="">
							<p>Click the recommend button to make recommendations
								<span style="padding-left:25px">
									<input id="content_based_recommend" class="btn btn-default" type="button" value="Recommend" style="background-color:#1abc9c">
								</span>
								<span id="precision_content_based" style="float:right"></span>
							</p>
							<form role="form">
								<div class="form-group">
									<table class="moviesTable" width="1170px" id="contentBasedMoviesTable">
									</table>
								</div>
							</form>
						</div>
					</div>
					<!-- /.row -->
				</div>
				<div class="tab-pane " id="tab5">
					<br>
					<div class="row">
						<div class="">
							<p>Click the recommend button to make recommendations
								<span style="padding-left:25px">
									<input id="item_based_collaborative_recommend" class="btn btn-default" type="button" value="Recommend" style="background-color:#1abc9c">
								</span>
								<span id="precision_item_based" style="float:right"></span>
							</p>
							<form role="form">
								<div class="form-group">
									<table class="moviesTable" width="1170px" id="itemBasedMoviesTable">
									</table>
								</div>
							</form>
						</div>
					</div>
					<!-- /.row -->
				</div>
				<div class="tab-pane " id="tab6">
					<br>
					<div class="row">
						<div class="">
							<p>Click the recommend button to make recommendations								
								<span style="padding-left:25px">
									<input id="user_based_collaborative_recommend" class="btn btn-default" type="button" value="Recommend" style="background-color:#1abc9c">
								</span>
								<span id="precision_user_based" style="float:right"></span>
							</p>
							<form role="form">
								<div class="form-group">
									<table class="moviesTable" width="1170px" id="userBasedMoviesTable">
									</table>
								</div>
							</form>
						</div>
					</div>
					<!-- /.row -->
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