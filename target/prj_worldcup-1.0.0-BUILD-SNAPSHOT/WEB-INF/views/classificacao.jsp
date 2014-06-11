<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Classificacao </title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">	
	 <link href="/tdv/static/bootstrap/css/my_css.css" rel="stylesheet"> 	
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	
	<div class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
	    <div class="modal-dialog modal-lg">
	      <div class="modal-content">	
	        <div class="modal-header">
	          <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	          <h4 class="modal-title" id="myLargeModalLabel">Participante</h4>
	        </div>
	        <div class="modal-body">
				<div>
					<select class="form-control" id="id_cbb_part">
					  	<option value="">Carregando...</option>
					</select>					
				</div>
				<div id="id_char_line" ><img src="/tdv/static/img/350.gif"/></div>
	        </div>
	      </div><!-- /.modal-content -->
	    </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->	 
	
	
	<!-- 	Conteudo -->
	<div class="container">  
	
			<div class="row">
<%-- 				<h3 class="pull-right"><a href="/tdv/simulacao_classificacao?usuario_codigo=${classificacao_u.usuario.codigo}"><span class="text-success glyphicon glyphicon-sort" style="text-shadow: 2px -2px white"> Simulação</span></a></h3> --%>
<!--  				<button class="btn btn-primary pull-right" id="id_plus_info_class" data-toggle="modal" data-target=".bs-example-modal-lg">Large modal</button> -->
				<h2 class="text-info" style="text-shadow: 2px -2px white;"><img src="/tdv/static/img/logo_70_t.png" /> Classificação dos participantes</h2>		
			</div>
			<br/><br/> 
	
			<div class="panel panel-primary">
				<div class="panel-heading">Classificação<a title="Alterar" href="#"><span class="glyphicon glyphicon-pencil"></span></a><span class="pull-right">${qtdeJogosFinalizados} jogos finalizados de ${qtdeJogos}</span></div>
				<div class="panel-body">
					<span class="pull-right"><span class="label label-danger">ER</span><small class="text-danger"> Errou </small></span>
					<span class="pull-right"><span class="label label-warning">AG</span><small class="text-warning"> Acertou Ganhador/Empate </small>&bull; </span>
					<span class="pull-right"><span class="label label-success">AP</span><small class="text-success"> Acertou Placar </small>&bull; </span>					
				    <span class="text-warning">Bolão</span>
				</div>
				<!-- Table -->
				<table class="table">
					<tr class="text-success">			    	
				    	<td class="text-center">Colocação</td>
				    	<!-- <td>${p.usuario.codigo}</td> -->
				    	<td>Participante</td>
				    	<td>Departamento/Local</td>
				    	<td><small>AP</small></td>
				    	<td><small>AG</small></td>
				    	<td><small>ER</small></td>
				    	<td class="text-center">Pontos</td> 
				    	<td class="text-center" title="Percentual de aproveitamento">%</td>
				    </tr> 				
					<c:forEach var="p" items="${classificacao}" varStatus="status">
					  <c:if test="${p.usuario.codigo == classificacao_u.usuario.codigo }"> 
					    <tr class="danger">			    	
					  </c:if>					
					  <c:if test="${status.count % 2 == 0 && p.usuario.codigo != classificacao_u.usuario.codigo}"> 
					    <tr class="success">			    	
					  </c:if>
					  <c:if test="${status.count % 2 != 0 && p.usuario.codigo != classificacao_u.usuario.codigo}">  
					    <tr class="warning">			    	
					  </c:if>					     
					    	<td class="text-center">${p.posicao}&deg;</td>
					    	<!-- <td>${p.usuario.codigo}</td> -->
					    	<td>			    		 
					    		<small><a href="/tdv/aposta/?codigo=${p.usuario.codigo}"> ${p.usuario.nome}</a></small>
					    		<c:if test="${p.posicao == 1}">
					    			<span class="glyphicon glyphicon-star text-warning"></span>
					    		</c:if>
					    		<c:if test="${p.posicao == 2}"> 
					    			<span class="glyphicon glyphicon-star-empty text-danger"></span>
					    		</c:if>							    		
					    	</td>
					    	<td><small>${p.usuario.departamento}</small></td>
					    	<td><small class="text-success">${p.acertoPlacar}</small></td>
					    	<td><small class="text-warning">${p.acertoGanhador}</small></td>
					    	<td><small class="text-danger">${p.erroZero}</small></td>
					    	<td class="text-center"><b>${p.pontos}</b></td> 
					    	<td class="text-center text-muted" title="Percentual de aproveitamento"><small>${p.percent}</small></td>
					    </tr> 
					</c:forEach>	
		  				<c:if test="${fn:length(classificacao) <= 0}">
						<h3 class="alert alert-warning">Classificação Não Disponivel </h3>
					</c:if>	
				</table>			
			</div>	
	</div> 
	
	<jsp:include page="footer.jsp"></jsp:include>

	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	
		var participantes_json = [];
	
		$('#myModal').on('hidden.bs.modal', function (e) {
			
		});
		
		$('#id_plus_info_class').click(function() {
			if(participantes_json.length == 0) {
			 	get_all_participantes();
			}
		});
		
		
		function get_all_participantes() {
	 		$.getJSON('/tdv/get_all_participantes/',  
	 				 function(retorno_participantes) { 
	 					participantes_json = retorno_participantes;
	 					
	 					// Busca primeiro...
	 					// mantem o 1 selecionado no combo...
	 					
	 					var html_ = "";
	 					html_ = '<option value="">Selecione o participante...</option>';
	 					$.each(participantes_json, function(i, p) {
	 						html_ += '<option value="'+p.codigo+'">'+p.codigo+' - ' +p.nome+' - '+ p.departamento +'</option>';
	 					});	 					
	 					$('#id_cbb_part').html(html_); 
	 					
	 					// Busca o historico desse primeiro...
	 					// Popula o historico no Grid...
	 		});
		}		
		
		
	</script>

</body>
</html>
