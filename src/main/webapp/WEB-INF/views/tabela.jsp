<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>  
<%@ page session="false" %>
<html>
<head>
	<title>Tabela</title>
	 <link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.css" rel="stylesheet">		
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container">
	
			<h2 class="text-info"><img src="/tdv/static/img/FULECO_85.png" />Tabela da Copa do Mundo 2014 <span class="text-success">Brasil</span></h2>
	
			<div class="panel panel-primary">
				<div class="panel-heading">Tabela da Copa do Mundo<a title="Alterar" href="#"><span class="glyphicon glyphicon-pencil"></span></a></div>
				<div class="panel-body">
				    <span class="text-warning">...</span>
				</div>
				<!-- Table -->
				<table class="table">
					<tr class="text-success">			    	
				    	<td class="text-center">Codigo</td>
				    	<td colspan="5" class="text-center">Jogo</td>
				    	<td class="text-center">Data</td>
				    	<td></td> 
				    </tr> 				
					<c:forEach var="j" items="${tabela}" varStatus="status"> 
					  <c:if test="${status.count % 2 == 0 }"> 
					    <tr class="success">			    	
					  </c:if>
					  <c:if test="${status.count % 2 != 0 }"> 
					    <tr class="warning">			    	
					  </c:if>	
					    	<td class="text-center text-muted"><small>${j.codigo}</small></td>
					    	<td class="text-center"><a href="/tdv/aposta_jogo/?codigo=${j.codigo}"><small>${j.timeA}</small></a></td>
					    	<td class="text-center">${j.resultadoA}</td>
					    	<td class="text-center text-muted">X</td>
					    	<td class="text-center">${j.resultadoB}</td>
					    	<td class="text-center"><a href="/tdv/aposta_jogo/?codigo=${j.codigo}"><small>${j.timeB}</small></a></td> 
					    	<td class="text-center text-muted">${j.data.time}</td> 
					    	<td class="text-center"><a href="/tdv/aposta_jogo/?codigo=${j.codigo}" title="ver apostas de todos os participantes de ${j.timeA} X ${j.timeB}"><span class="glyphicon glyphicon-share"></span></a></td>
					    </tr> 
					</c:forEach>	
		  				<c:if test="${fn:length(tabela) <= 0}">
						<h3 class="alert alert-warning">Tabela Não Disponivel </h3>
					</c:if>	
				</table>			
			</div>	
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>	

</body>
</html>
