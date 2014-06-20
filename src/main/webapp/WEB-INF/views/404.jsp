<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Bolão Della Volpe 2014</title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">		
	 <style type="text/css">
		body {
			background-image:url("/tdv/static/img/404_.jpg");
			display: block;
  			max-width: 100%;
  			height: auto;
		} 
	 </style>
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	 
	<div class="container">

		<div class="alert alert-warning">
			<h1 style="text-shadow: 2px -2px white;"><span class="glyphicon glyphicon-exclamation-sign text-warning"></span> Página não encontrada !!!</h1>
			<br/><br/>
			<a href="/tdv" class="btn btn-primary">Ir para página inicial</a>
		</div>
		<br/>		 
		<br/><br/><br/><br/><br/><br/>
		
	</div>
	
	<br/><br/><br/><br/><br/><br/><br/>
	
	<jsp:include page="footer.jsp"></jsp:include>

	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>
