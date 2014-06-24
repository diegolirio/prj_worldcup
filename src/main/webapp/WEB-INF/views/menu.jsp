	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	
   <div class="navbar navbar-default navbar-fixed-top ">
      <div class="container">
		 <div class="navbar-header">
		      <button class="navbar-toggle" type="button" data-toggle="collapse" data-target=".bs-navbar-collapse">
		        <span class="sr-only">Toggle navigation</span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span> 
		      </button>
		 </div>      
        <div class="navbar-header">
          <a href="/tdv" class="navbar-brand"><img src="/tdv/static/img/xlogo_heigth_25.png" class="img-responsive"/></a>
          <a href="/tdv" class="navbar-brand"><img title="java programming" alt="java programming" src="/tdv/static/img/java.png" class="img-responsive" height="25px" width="25px"/></a>
        </div>
        <div class="navbar-collapse collapse" id="navbar-main">
          <ul class="nav navbar-nav">
          	<li><a href="/tdv/classificacao">Classificação</a></li>
            <li><a href="/tdv/tabela">Tabela</a></li>
<!--             <li><a href="/tdv/plus_info">Estatisticas</a></li> -->
          </ul>
          <ul class="nav navbar-nav navbar-right"> 
          	<li><a href="/tdv/hist_col_chart_line?usuario_codigo=${classificacao_u.usuario.codigo}" onclick="show_full__(this.href); return false;"><small> Historico de colocacao </small></a></li>
          	<li><a href="/tdv/simulacao_classificacao?usuario_codigo=${classificacao_u.usuario.codigo}"><span class="glyphicon glyphicon-sort"> Simulação</span></a></li>
            <li><a href="/tdv/regras">Regras</a></li>
<!--             <li><a data-toggle="modal" data-target="#id_modal_send_mail" href="#"><span class="glyphicon glyphicon-envelope"></span></a></li> -->
            <c:if test="${classificacao_u == null}">
            	<li><a href="#" class="troca_usuario" data-toggle="tooltip" data-placement="bottom" title="Login por código"><span class="glyphicon glyphicon-random text-danger"></span></a></li>
            </c:if> 
            <c:if test="${classificacao_u != null}">
				<li><a href="/tdv/?logout=S" class="sair" data-toggle="tooltip" data-placement="bottom" title="Sair"><small class="text-danger">Sair</small></a></li>            
            </c:if>
          </ul>

        </div>
      </div>
    </div>

	<br/><br/><br/>
	
	<c:if test="${classificacao_u != null}">
		
		<div class="container well">
			<h3>
				<a href="/tdv/aposta_participante/?codigo=${classificacao_u.usuario.codigo}"><span class="glyphicon glyphicon-user"> </span><span class="text-success">${classificacao_u.usuario.nome} </span></a> <small>(${classificacao_u.usuario.codigo})</small>  
				<span class="text-center text-warning">&bull; ${classificacao_u.posicao}&deg; Colocado </span> 
				<span class="text-right text-info">&bull; ${classificacao_u.pontos} pontos </span> 
				<a href="#" class="troca_usuario" data-toggle="tooltip" data-placement="right" title="Trocar de usuário"><small class="glyphicon glyphicon-random"></small></a>
			</h3>			
		</div> 
		 
		<div class="container">
			<div class="pull-right well">
				<div id="id_my_simul" class="text-warning"></div>
				<h3 class="text-muted" id="id_meu_placar">
					<c:if test="${aposta_anterior_jogo != null}">
						<small class="text-danger" style="text-shadow: 2px -2px white;">
							Meu placar do jogo Anterior: 
							<a href="/tdv/aposta_jogo/?codigo=${aposta_anterior_jogo.tabela.codigo}">
								${aposta_anterior_jogo.tabela.timeA} ${ aposta_anterior_jogo.resultadoA} x ${aposta_anterior_jogo.resultadoB} ${aposta_anterior_jogo.tabela.timeB}
							</a>
						</small>
					</c:if> 
					<br/> 
					<c:if test="${aposta_proximo_jogo != null}">
						<small class="text-success" style="text-shadow: 2px -2px white;">
							Meu placar do Próximo jogo: 
							<a href="/tdv/aposta_jogo/?codigo=${aposta_proximo_jogo.tabela.codigo}">
								${aposta_proximo_jogo.tabela.timeA} ${ aposta_proximo_jogo.resultadoA} x ${aposta_proximo_jogo.resultadoB} ${aposta_proximo_jogo.tabela.timeB}
							</a>
						</small>
					</c:if>					
				</h3>
			</div>
		</div>	
		 
	 </c:if>	
	 
	 <script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	 <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	 <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>
	 <script type="text/javascript">	 
	 	 
			function padLeft(value, length, valueAdd) {
				return Array(length-String(value).length+1).join(valueAdd||'0')+value;
			}	 
	 
	 		$('.troca_usuario').click(function() {
	 			var codigo_a = padLeft(prompt("Digite o código da sua aposta", ""), 3);
	 			
	 			if (codigo_a != '000') {		
	 				if (parseInt(codigo_a) > 0) {
	 					$('.troca_usuario').html('<img src="/tdv/static/img/ball_24.gif"/>');
	 					window.location = "/tdv/classificacao/?troca=S&usuario_codigo=" + codigo_a;
	 				} else {
	 					alert('Código inválido');
	 				}	
	 			} else { 
	 				alert('Digite seu código');
	 			}
	 		});
	 		
	 		$('#id_sendmail').click(function() {
	 			var email = $('#id_email').val();
	 			if (email == '') {
	 				alert('Digite o email');
	 				return false;
	 			}
	 			alert('Email enviiado com sucesso para '+email);
	 			$('#id_email').val('');
	 		});
	 		
			function show_full__(url, alt, larg) {
				w = window.open(url,'','height=650, width=1170, top=100, left=30, scrollbars=no, resizable=no');	
			}		 		
	 		
	 </script>
	 
	 <c:if test="${classificacao_u == null}">
	 	<script type="text/javascript">
 			$('.troca_usuario').tooltip('show');
 			$('.sair').tooltip('hide');
		</script>
	 </c:if>
	 <c:if test="${classificacao_u != null}">
	 	<script type="text/javascript">
 			$('.troca_usuario').tooltip('hide');
		</script>
	 </c:if>	 
	 
	 