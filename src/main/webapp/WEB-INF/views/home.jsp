<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Bolão Della Volpe 2014</title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.css" rel="stylesheet">		
	 <link href="/tdv/static/bootstrap/css/my_css.css" rel="stylesheet">
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	 
	<div class="container">
		<div class="row">
			<div class="col-md-5 well">
				<br/>
				<h1 class="text-danger">Bem-Vindo ao</h1> 
				<h1 class="text-warning">Bolão Della Volpe</h1> 
				<h1 class="text-info">Copa do Mundo 2014 <span class="text-success">Brasil</span></h1>
			</div>
			<div class="col-md-7">
				<!-- <img src="/tdv/static/img/copa2014.png" class="img-responsive"/>  -->
			</div>
		</div>
		<br/><br/><br/><br/><br/><br/>
		<div class="row well text-center"> 
				<div class="col-md-4">
					<a href="/tdv/classificacao">
						<img src="/tdv/static/img/logo_70_t.png" />
						<h1> <span class="label label-success">Classificação</span> </h1>
					</a>
					<br/>
				</div>
				<div class="col-md-4">
					<img alt="Java Programming" title="Java Programming" src="/tdv/static/img/java-programming.png" />
					<br/>
				</div>
				<div class="col-md-4">
					<a href="/tdv/tabela">
						<img src="/tdv/static/img/FULECO_85.png" />
						<h1><span class="label label-warning">Tabela</span></h1>
					</a>
					<br/> 
				</div>
		</div>		
	</div>
	
	<br/><br/><br/><br/><br/><br/><br/>
	
	<jsp:include page="footer.jsp"></jsp:include>

	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>
