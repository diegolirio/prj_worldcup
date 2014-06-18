<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>  
<%@ page session="false" %>
<html>
<head>
	<title>Apostas ${jogo.timeA} X ${jogo.timeB}</title>
	 <link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">		
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>

	
	<div class="container"> 
	
			<h3>Apostas de todos os participantes do Jogo</h3>
			<h1 class="text-info text-center">
				<c:if test="${jogo.codigo > 1}">
					<a href="/tdv/aposta_jogo/?codigo=${jogo.codigo-1}" title="Jogo Anterior" class="prior-next"><span class="glyphicon glyphicon-chevron-left pull-left text-muted"></span></a>
				</c:if> 
				${jogo.timeA} <span class="label label-success">${jogo.resultadoA }</span> <span class="">X</span> <span class="label label-success">${jogo.resultadoB }</span> ${jogo.timeB}
				<c:if test="${jogo.codigo < 48}">
					<a href="/tdv/aposta_jogo/?codigo=${jogo.codigo+1}" title="Próximo Jogo " class="prior-next"><span class="glyphicon glyphicon-chevron-right pull-right text-muted"></span></a>
				</c:if>
			</h1>
		
			<br/>
		
			<div class="col-md-9">
					<div class="panel panel-success">
						<div class="panel-heading">Todas as Apostas do Jogo ${jogo.timeA} X ${jogo.timeB}</div>
						<div class="panel-body">
						    <span class="text-warning">Palpites</span>
						</div>
						<!-- Table -->
						<table class="table">
							<tr class="text-danger">			    	
						    	<td>Participante</td>
						    	<td class="text-center">Pontos</td>
						    	<td class="text-center">${jogo.timeA }</td>
						    	<td></td>
						    	<td class="text-center">${jogo.timeB }</td>
						    </tr> 				
							<c:forEach var="a" items="${apostas}" varStatus="status">
							  <c:if test="${a.usuario.codigo == classificacao_u.usuario.codigo }"> 
							    <tr class="danger">			    	
							  </c:if>					
							  <c:if test="${status.count % 2 == 0 && a.usuario.codigo != classificacao_u.usuario.codigo}"> 
							    <tr class="success">			    	
							  </c:if>
							  <c:if test="${status.count % 2 != 0 && a.usuario.codigo != classificacao_u.usuario.codigo}">  
							    <tr class="warning">			    	
							  </c:if>		    	 
									<td><small><a href="/tdv/aposta_participante/?codigo=${a.usuario.codigo}">${a.usuario.codigo} - ${a.usuario.nome}</a><span class="text-muted"> (${a.usuario.departamento})</span></small></td>
									<td class="text-center">
										<c:if test="${jogo.ganhador eq 'N'}">
											<span class="label label-default">${a.pontos}</span>
										</c:if>								
										<c:if test="${a.pontos == 5 && jogo.ganhador != 'N'}">
											<span class="label label-success">${a.pontos}</span> 
										</c:if>
										<c:if test="${a.pontos == 3 && jogo.ganhador != 'N'}">
											<span class="label label-warning">${a.pontos}</span>
										</c:if>		
										<c:if test="${a.pontos == 0 && jogo.ganhador != 'N'}">
											<span class="label label-danger">${a.pontos}</span>
										</c:if>													
									</td>	
									<td class="text-center">${a.resultadoA}</td>
									<td class="text-center text-muted">X</td>
									<td class="text-center">${a.resultadoB}</td>
							    </tr> 
							</c:forEach>	
				  				<c:if test="${fn:length(apostas) <= 0}">
								<h3 class="alert alert-warning">Aposta não Disponivel </h3>
							</c:if>	
						</table>			
				</div>	
			</div>
			<div class="col-md-3 text-center hidden-xs"> 
				<div class="row" id="id_chart_p">
				</div>
				<div class="row" id="id_jogos">
					<img src="/tdv/static/img/350.gif"/>
				</div>
			</div>
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>
		
	<c:if test="${jogo.ganhador != 'N' }">
	    <script type="text/javascript" src="https://www.google.com/jsapi"></script>	
	    <script type="text/javascript">    
		     google.load('visualization', '1.0', {'packages':['corechart']});
		     google.setOnLoadCallback(drawChart);    	 
		     function drawChart() {
		        var data = new google.visualization.DataTable();
		        data.addColumn('string', 'Critérios de Acertos');
		        data.addColumn('number', 'Quantidade');
		        data.addRows([
		          ['Acertou Placar', ${qtde_ar}], // ar
		          ['Acertou Ganhador', ${qtde_ag}], // ag
				  ['Errou', ${qtde_er}]  // er
		        ]);
		        var options = {'title':'Acertos', //qtde jogos
		                       'width':350,
		                       'height':270,
		                       is3D: true,
		                       colors:['#31B404','#FFBF00', '#DF0101']
		        			  }; 
		        var chart = new google.visualization.PieChart(document.getElementById('id_chart_p'));
		        chart.draw(data, options);
		     }	
	   </script>
	</c:if>
	   
    <script type="text/javascript">
		
	 	$.getJSON('/tdv/jogos_all/',   
			      function(jogos_all) { 
	 					var html_ = '<p><span class="text-danger">Jogos</span></p>';
	 					$.each(jogos_all, function( i, j) {
	 						html_ += 	'<p><a href="/tdv/aposta_jogo/?codigo='+j.codigo+'">'+j.timeA + ' ' + j.resultadoA + ' x ' + j.resultadoB + ' ' + j.timeB + '</a></p>';
		 				});	
	 					$('#id_jogos').html(html_);
		});	 		
	</script>	

</body>
</html>
