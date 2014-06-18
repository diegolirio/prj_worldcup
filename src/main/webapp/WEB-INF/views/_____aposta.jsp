<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html> 
<head>
	<title>${usuario.nome} &bull; Aposta</title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">		
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container"> 
	 
			<div class="row">
				<div class="col-md-7">
					<h2>${usuario.nome} <small> &bull; ${usuario.codigo} </small></h2>
					<h4 class="text-muted">( ${usuario.departamento} )</h4>
					<br/>
					<h2 class="text-success">${classificacao.posicao}&deg; <small>Colocado</small></h2>
					<h2 class="text-success">${classificacao.pontos } <small>Pontos</small></h2>					
				</div>			
				<div class="col-md-5">
					<div id="chart_div" class="hidden-xs"><img src="/tdv/static/img/g.gif"/></div>
				</div>
			</div>
			<div class="row">
				<div class="panel panel-primary">
					<div class="panel-heading">Aposta<a title="Alterar" href="#"><span class="glyphicon glyphicon-pencil"></span></a></div>
					<div class="panel-body">
					    <span class="text-warning">Palpites</span>
					</div>
					<!-- Table -->
					<table class="table">
						<tr class="text-success">			    	
							<td></td>
					    	<td colspan="5" class="text-center">Resultado do Jogo</td>
					    	<td></td>
					    	<td colspan="3" class="text-center">Aposta</td>
					    	<td class="text-center">Pontos</td>
					    </tr> 				
						<c:forEach var="a" items="${aposta}" varStatus="status">
						  <c:if test="${status.count % 2 == 0 }"> 
						    <tr class="success">			    	
						  </c:if>
						  <c:if test="${status.count % 2 != 0 }"> 
						    <tr class="warning">			    	
						  </c:if>				    	 
						    	<td class="text-center text-muted"><small>${a.tabela.codigo}</small></td>
						    	<td class="text-center"><small>${a.tabela.timeA}</small></td>
						    	<td class="text-center">${a.tabela.resultadoA}</td>
						    	<td class="text-center text-muted">X</td>
						    	<td class="text-center">${a.tabela.resultadoB}</td>
						    	<td class="text-center"><small>${a.tabela.timeB}</small></td>
						    	<td><a href="/tdv/aposta_jogo/?usuario_codigo=${param.usuario_codigo}&codigo=${a.tabela.codigo}" title="ver apostas de todos os participantes de ${a.tabela.timeA} X ${a.tabela.timeB}"><span class="glyphicon glyphicon-share"></span></a></td>
						    	<!-- <td>${a.tabela.data}</td> -->
						    	<td class="text-danger text-center">${a.resultadoA}</td>
						    	<td class="text-muted text-center">X</td>
						    	<td class="text-danger text-center">${a.resultadoB}</td>
						    	<td class="text-center">
									<c:if test="${a.tabela.ganhador eq 'N'}">
										<span class="label label-default">${a.pontos}</span>
									</c:if>					    	
									<c:if test="${a.pontos == 5 && a.tabela.ganhador != 'N'}">
										<span class="label label-success">${a.pontos}</span>
									</c:if>
									<c:if test="${a.pontos == 3 && a.tabela.ganhador != 'N'}">  
										<span class="label label-warning">${a.pontos}</span>
									</c:if>		
									<c:if test="${a.pontos == 0 && a.tabela.ganhador != 'N'}">
										<span class="label label-danger">${a.pontos}</span>
									</c:if>	
						    	</td>					    	
						    </tr> 
						</c:forEach>	
			  				<c:if test="${fn:length(aposta) <= 0}">
							<h3 class="alert alert-warning">Aposta Nao Disponivel </h3>
						</c:if>	
					</table>			
				</div>
			</div>	
	</div>
	
  <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
  <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>	
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>	
  <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});
      //google.load('visualization', '1.0', {'packages':['columnchart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChart);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Critérios de Acertos');
        data.addColumn('number', 'Quantidade');
        data.addRows([
          ['Acertou Placar', ${classificacao.acertoPlacar}], // ar
          ['Acertou Ganhador', ${classificacao.acertoGanhador}], // ag
		  ['Errou', ${classificacao.erroZero}]  // er
        ]);

        // Set chart options
        var options = {'title':'${qtdeJogos} Jogos', //qtde jogos
                       'width':350,
                       'height':270,
                       is3D: true,
                       colors:['#31B404','#FFBF00', '#DF0101']
        			  }; 

        // Instantiate and draw our chart, passing in some options.
        var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
        chart.draw(data, options);
      }
    </script>    	

</body>
</html>
