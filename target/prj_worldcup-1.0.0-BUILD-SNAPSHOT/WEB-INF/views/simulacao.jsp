<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Simulação</title>
	 <link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">	 
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container">
	
			<h2 class="text-info">Simulação<small>  jogo <span id="id_jg_ini"><img src="/tdv/static/img/ball_24.gif"/></span> ao <span id="id_jg_fim"><img src="/tdv/static/img/ball_24.gif"/></span></small></h2>		
			
			<br/>
			
			<div class="row">
				<p class="text-center text-muted" id="id_jogo_sim_seq"></p>
				<h2 class="text-center" id="id_jogo_simulado"></h2>  
			</div>
			<div class="row">
				<div class="col-md-4"></div>
				<div class="col-md-3">
					<a href="#" id="id_recalcular" class="btn btn-success"><span class="glyphicon glyphicon-refresh"></span>  Recalcular</a>
					<a href="/tdv/simulacao_classificacao" id="id_zerar" class="btn btn-warning"> Zerar simulação</a>
				</div>
				<div class="col-md-5"></div>
			</div>
			<br/>
	
			<div class="panel panel-primary">
				<div class="panel-heading">Simulação do Bolão dos Jogos Restantes<a title="Mais jogos a Simular" href="#" id="id_plus_play"><span class="glyphicon glyphicon-pencil"></span></a></div>
				<div class="panel-body">
					<!-- <span class="pull-right"><span class="label label-danger">ER</span><small class="text-danger"> Errou </small></span>  -->
					<span class="pull-right"><span class="label label-warning">AG</span><small class="text-warning"> Acertou Ganhador/Empate </small></span>
					<span class="pull-right"><span class="label label-success">AP</span><small class="text-success"> Acertou Placar </small>&bull; </span>					
				    <span id="id_table_message" class="text-warning">calculando...</span>
				</div>
				
				<div id="id_load" class="text-center">
					<img src="/tdv/static/img/carreg.gif"/>
				</div>				
				
				<!-- Table -->
				<div class="table-responsive">					
					<table class="table" id="id_table_simulator"> 
						<tr class="text-success">			    	
					    	<td class="text-center">Colocação</td>
					    	<td >Participante</td>
					    	<td>Departamento/Local</td>
					    	<td class="text-center">Pontos</td>
					    	<!-- <td class="text-center"></td> --> 
					    	<!-- <td class="text-center">%</td> -->
					    	<td class="text-center"><small>AR</small></td>
					    	<td class="text-center"><small>AG</small></td>
<!-- 					    	<td class="text-center"><small>ER</small></td> -->
					    	<td id="id_time_a" class="text-center">...</td>
					    	<td class="text-center"> X </td>
					    	<td id="id_time_b" class="text-center">...</td>
					    </tr> 				
						<tbody id="id_class">
						</tbody>	
					</table>	
				</div>		
			</div>	
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>
	 
	 <script type="text/javascript">
	 	
	 	// pontuacao
	 	var PLACAR = 5;
	 	var VENCEDOR = 3;
	 	var EMPATE = 3;
	 	var ERRO = 0;
	 		 	
	 	// index
	 	var max_index_jogos_pendentes = 0;
	 	var index_jogo_view = 0; // atual na tela
	 	
	 	var jogos_pendentes = [];
	 	var apostas_staticas_simulacao = [];
	 	var classificacao = [];
	 	var classificacao_static = [];
	 	
	 	function _GET(name)
	 	{
	 	  var url   = window.location.search.replace("?", "");
	 	  var itens = url.split("&");

	 	  for(n in itens)
	 	  {
	 	    if( itens[n].match(name) )
	 	    {
	 	      return decodeURIComponent(itens[n].replace(name+"=", ""));
	 	    }
	 	  }
	 	  return null;
	 	}
	 	
	 	var qtde = _GET('qtde');
	 	if (qtde == 0 || qtde == null)
	 		qtde = 3; 

		 	// 1º Pega todos os Jogos restantes...
		$.getJSON('/tdv/jogos_pendentes/?qtde='+qtde,  
			      function(retorno_jogos) { 
		 					//alert('');
		 					jogos_pendentes = retorno_jogos;
		 					//alert(JSON.stringify(jogos_pendentes));
		 					max_index_jogos_pendentes = jogos_pendentes.length-1;
		 					if (max_index_jogos_pendentes > 0) {
			 					// Calcula ganhador do jogo
			 					jogos_pendentes[index_jogo_view].ganhador = get_ganhado(jogos_pendentes[index_jogo_view].resultadoA, jogos_pendentes[index_jogo_view].resultadoB);	
		 						// 2º Popula o Jogo (painel de simulacao)
		 						$('#id_jg_ini').html(jogos_pendentes[0].codigo);
		 						$('#id_jg_fim').html(jogos_pendentes[max_index_jogos_pendentes].codigo);
		 						popula_jogo(jogos_pendentes[index_jogo_view]);
		 						// 3º Busca as aposta...
		 						$.getJSON('/tdv/apostas_simulacao/?qtde='+qtde,  		
										  function(retorno_apostas) {
		 												apostas_staticas_simulacao = retorno_apostas;
		 												//alert(apostas_staticas_simulacao.length);
		 							 				    //alert(JSON.stringify(apostas_staticas_simulacao));
		 							 				    //return;	 												
		 							 					// Calcula ganhador do jogo na aposta
		 							 					$.each(apostas_staticas_simulacao, function( i, a ) {
		 							 						apostas_staticas_simulacao[i].ganhador = get_ganhado(a.resultadoA, a.resultadoB);
		 							 					});	 										
														// 4º Pega classificacao 
													 	$.getJSON('/tdv/get_class_simulacao/', 
														    	  function(retorno) {
													 					classificacao = retorno;
													 					classificacao_static = retorno;
																		// 5º Calcula pontuacao nas apostas 
																		calc_aposta(jogos_pendentes[index_jogo_view]);
													 					//alert(JSON.stringify(classificacao));
													 					// soma pontos calculo aposta + classificacao
													 					$.each( classificacao, function(i, c) {
													 						$.each( apostas_staticas_simulacao, function(x, a) {
													 							if (c.usuario.codigo == a.usuario.codigo) {
													 								c.pontos += a.pontos;
													 							}
													 						});
													 					});
													 					// calcula colocacao da classificacao
													 					ordena_colocacao_classificacao();	
													 					// popula classificacao
													 					popula_classificacao();
													 			  }
													 	);
														
													});
		 						
		 					} else {
		 						$('#id_class').html('...'); 
		 						$('#id_load').html('<h2 class="text-danger">Não há jogos a serem simulados...</h2>');
		 						$('#id_jg_ini').html(0);
		 						$('#id_jg_fim').html(0);		 						
		 					}
		 	});	 
		 	
		function get_pontos_total_simulado(participante_codigo) {
			var p = 0;
			$.each(apostas_staticas_simulacao, function( i, a ) {
				if (participante_codigo == apostas_staticas_simulacao[i].usuario.codigo) {	
					p += apostas_staticas_simulacao[i].pontos;
				}
			});	 
			return p;
		} 	
	 	
		function popula_jogo(jogo) {
			var html_ = "";
			if (index_jogo_view > 0) {
				  html_ += '<a href="javascript:underfined" title="Jogo anterior: '+jogos_pendentes[index_jogo_view-1].timeA+' X '+jogos_pendentes[index_jogo_view-1].timeB+'" onclick="proximo_jogo_a_calcular_simulacao('+(index_jogo_view-1)+');" class="pull-left"><img src="/tdv/static/img/seta_e.png"/></a>';
			}
			html_ +=     '<span class="text-danger">' +jogo.timeA + ' </span>';
			html_ +=     '<input type="number" class="class_jogo_resultado_a" style="width: 80px; height: 60px; font-size: 30px;" value="'+jogo.resultadoA+'" min="0" onkeypress="return SomenteNumero(event);"> ';
			html_ +=     '<span class="muted">X</span> ';
			html_ +=     '<input type="number" class="class_jogo_resultado_b" style="width: 80px; height: 60px; font-size: 30px;" value="'+jogo.resultadoB+'" min="0" onkeypress="return SomenteNumero(event);"> ';
			html_ +=     '<span class="text-danger">'+jogo.timeB+'</span>';
			if (index_jogo_view < max_index_jogos_pendentes) {
				html_ += '<a href="javascript:underfined" title="Próximo jogo: '+jogos_pendentes[index_jogo_view+1].timeA+' X '+jogos_pendentes[index_jogo_view+1].timeB+'" onclick="proximo_jogo_a_calcular_simulacao('+(index_jogo_view+1)+');" class="pull-right"><img src="/tdv/static/img/seta_d.png"/></a>';
			}
			$('#id_jogo_simulado').html(html_); 
			$('#id_time_a').html(jogos_pendentes[index_jogo_view].timeA);
			$('#id_time_b').html(jogos_pendentes[index_jogo_view].timeB);	
			$('#id_jogo_sim_seq').html('Jogo '+jogos_pendentes[index_jogo_view].codigo+(jogos_pendentes[index_jogo_view].ganhador != 'N' ? '  <span class="glyphicon glyphicon-check text-info"></span>' : ""));
		}
		
		function proximo_jogo_a_calcular_simulacao(index) {
			//$('#id_img_load_sim').ajaxStart(function() { $(this).html('<img src="/media/images/__159__.gif"/>'); });
			index_jogo_view = index;
			popula_jogo(jogos_pendentes[index_jogo_view]);
			load_resultado_aposta_proximo_jogo(jogos_pendentes[index_jogo_view]);
			//$('#id_img_load_sim').ajaxComplete(function() { $(this).empty(); });
		}
		
		function load_resultado_aposta_proximo_jogo(jogo) {
			$.each( apostas_staticas_simulacao, function( i, a) {
				if (a.tabela.codigo == jogo.codigo) {
					set_resultado_a_participante_view(a.usuario.codigo, a.resultadoA);
					set_resultado_b_participante_view(a.usuario.codigo, a.resultadoB);
				}
			});
		}		
		
		function set_resultado_a_participante_view(usuario_codigo, value) {
			$('#id_table_simulator #id_class').find('td .ra'+usuario_codigo).html(value);
		}

		function set_resultado_b_participante_view(usuario_codigo, value) {
			$('#id_table_simulator #id_class').find('td .rb'+usuario_codigo).html(value);
		}
			 	
// 		function inc_pontuacao_acerto_classificacao(participante_codigo, pontuacao) {
			
// 			$.each(classificacao, function(i, c) {
// 				if (c.usuario.codigo == participante_codigo && pontuacao == 5) {
// 					classificacao[i].acertoPlacar++;
// 				} 
// 				else if (c.usuario.codigo == participante_codigo && pontuacao == 3) {
// 					classificacao[i].acertoGanhador++;
// 				}				
// 				else if (c.usuario.codigo == participante_codigo && pontuacao == 0) {
// 					classificacao[i].erroZero++;
// 				}								
// 			});			
// 		}
		
		function calc_aposta(jogo) {
			// Calcula Pontos nas Apostas
			$.each( apostas_staticas_simulacao, function( i, a ) {
				// 4 - ToDo...: Calcula pontos somatorio (classe inscricao) e quantidade de acertos (ap, ar, av, ae, as, er)
				// 5 - ToDo...: Calcula Rancking (classe inscricao = colocacao)																
				// 6 - popula a classe inscricao na tabela de simulacao			
				if(jogo.codigo == a.tabela.codigo) {		
					
					// Calcula vencedor da aposta..														
					if (a.resultadoA == jogo.resultadoA && a.resultadoB == jogo.resultadoB) {
						//a.pontos = PLACAR;
						apostas_staticas_simulacao[i].pontos = PLACAR;
						// add na classificacao +1 AP
						//inc_pontuacao_acerto_classificacao(apostas_staticas_simulacao[i].usuario.codigo, 5);
					}															
					else if (a.ganhador == jogo.ganhador) {
						//a.pontos = VENCEDOR;
						apostas_staticas_simulacao[i].pontos = VENCEDOR;
						//inc_pontuacao_acerto_classificacao(apostas_staticas_simulacao[i].usuario.codigo, 3);
					}
					else {
						//a.pontos = ERRO;
						apostas_staticas_simulacao[i].pontos = ERRO;
						//inc_pontuacao_acerto_classificacao(apostas_staticas_simulacao[i].usuario.codigo, 0);
					}								 					
					//item_.fields.calculado = true;
					//json_apostas[i].fields.calculado = true;
					//alert(jogo.timeA + ' ' + jogo.resultadoA + ' X ' + jogo.resultadoB + ' ' + jogo.timeB + ' = '+jogo.ganhador+"\n" +
					//		  'Meu: ' + apostas_staticas_simulacao[i].resultadoA + ' X ' + apostas_staticas_simulacao[i].resultadoB + ' pontos = ' + apostas_staticas_simulacao[i].pontos + ' = ' + apostas_staticas_simulacao[i].ganhador);
				}
			});	
		}
		
		function get_ganhado(resultado_a, resultado_b) {
			if (resultado_a > resultado_b) {
				return 'A';
			} else if (resultado_a < resultado_b) {
				return 'B';
			} else {
				return 'E';
			}
		}
		
		function ordena_colocacao_classificacao() {
			var pontos_anterior = -1;
			var posicao_real = 0;
			for (var posicao = 0; posicao <= classificacao.length-1; posicao++) {
				
				// seleciona 1 para pegar o maior
				var classificacao_participante = ""; 
				$.each(classificacao, function(i, c) {
					// observacao utilizado para dizer que ja foi alterado a posicao
					if (c.observacao == 'N') {
						classificacao_participante = c;
					}
				});
							
				// Pega o participante com maior numero de pontos
				$.each(classificacao, function(i, c) {
					if (c.observacao == 'N') {
						//alert(c.usuario.nome + '(' + c.usuario.pontos + ') == ('+classificacao_participante.pontos+')' + classificacao_participante.usuario.nome);
						if (c.pontos >= classificacao_participante.pontos) {
							classificacao_participante = c;
						}
						//alert(c.usuario.nome + '(' + c.usuario.pontos + ') == ('+classificacao_participante.pontos+')' + classificacao_participante.usuario.nome);
					}
				});				
				
				if (pontos_anterior > classificacao_participante.pontos || posicao_real == 0) {
					posicao_real = posicao+1;
				}
				classificacao_participante.posicao = posicao_real;
				classificacao_participante.observacao = 'S';
				
				// Altera na lista
				$.each(classificacao, function(i, c) {
					if (c.usuario.codigo == classificacao_participante.usuario.codigo) {
						classificacao[i] = classificacao_participante;
					}
				});			
				pontos_anterior = classificacao_participante.pontos;
			};
		}
		
		function get_row_color(numero) {
			if(numero % 2 == 0) {
				return "success";
			} else {
				return "warning";
			}
		}	
		
		function get_acerto(participante_codigo, pontos) {
			var qtde = 0;
			$.each(apostas_staticas_simulacao, function( i, a ) {
				if (participante_codigo == a.usuario.codigo && pontos == a.pontos) {// && a.tabela.ganhador != 'N') {	
					qtde++;
				}
			});	 
			return qtde;
		} 			
		
		function popula_classificacao() {			
			
			$.each( classificacao, function( i, p) {
				
				var first_to_last = "";
				$.each( classificacao, function( x, class_posicao) {
					if (class_posicao.observacao == 'S') {
						first_to_last = class_posicao;
					}
				});
				$.each( classificacao, function( x, menor_posicao) {
					if(menor_posicao.observacao == 'S') {
						if(menor_posicao.posicao < first_to_last.posicao) {
							first_to_last = menor_posicao;
						}
					}
				});		 
				first_to_last.observacao = 'N';
				
				var tr = ""; 	
				tr += '<tr class="'+get_row_color(i)+'">';
				tr +=     '<td class="text-center">'+first_to_last.posicao+'º</td>';
				tr +=     '<td><small>'+first_to_last.usuario.nome+'</small></td>';
				tr +=     '<td class="text-muted"><small>'+first_to_last.usuario.departamento+'</small></td>';
				tr +=     '<td class="text-center">'+first_to_last.pontos+'<small class="text-muted"> (+'+get_pontos_total_simulado(first_to_last.usuario.codigo)+')</small></td>';
				tr +=     '<td class="text-center text-success"><small>'+(get_acerto(first_to_last.usuario.codigo, 5)+first_to_last.acertoPlacar)+'</small></td>';
				tr +=     '<td class="text-center text-warning"><small>'+(get_acerto(first_to_last.usuario.codigo, 3)+first_to_last.acertoGanhador)+'</small></td>';
				//tr +=     '<td class="text-center text-danger"><small>'+(get_acerto(first_to_last.usuario.codigo, 0)+first_to_last.erroZero)+'</small></td>';
				var ra = 0; // pega o resultado do usuario/participante e o jogo atual (Na tabela de postas)
				var rb = 0; // o mesmo para rb
				$.each(apostas_staticas_simulacao, function(index, a) {
					if(a.usuario.codigo == first_to_last.usuario.codigo && jogos_pendentes[index_jogo_view].codigo == a.tabela.codigo) {
						ra = a.resultadoA;
						rb = a.resultadoB;
					}
				});
				tr += '<td class="text-center"><b><span class="ra'+first_to_last.usuario.codigo+' result_all">'+ra+'</span></b></td>';
				//alert('<td class="ra'+first_to_last.usuario.codigo+' text-center text-danger"><span>'+ra+'</span></td>');
				tr += '<td class="text-center text-muted">X</td>'; 
				tr += '<td class="text-center"><b><span class="rb'+first_to_last.usuario.codigo+' result_all">'+rb+'</b></span></td>';
				tr += '</tr>';
				
				$('#id_class').append(tr);
				$('#id_load').empty();
				$('#id_table_message').empty();
			});
		}	
		
		function recalcular() {
			if(max_index_jogos_pendentes <= 0) {
				$('#id_load').html('Não há jogos há serem calculados!');
			} else {
				
// 				$("#id_load").ajaxStart(function(){
// 				        $('#id_load').html('<img src="/tdv/static/img/carreg.gif"/>');
// 				    }).ajaxComplete(function(){
// 				        $(this).empty(); 
// 				    });				
				
				$('#id_load').html('<img src="/tdv/static/img/carreg.gif"/>');
				$('#id_table_message').html('calculando...');
				
			 	$.getJSON('/tdv/get_class_simulacao/', 
			    	  function(retorno) { 
		 					classificacao = retorno;
		 					//alert(JSON.stringify(classificacao));
		 					
		 					// 1. Preenche Resultado do Jogo
		 					jogo = jogos_pendentes[index_jogo_view];
		 					jogo.resultadoA = $('#id_jogo_simulado input.class_jogo_resultado_a').val();
		 					jogo.resultadoB = $('#id_jogo_simulado input.class_jogo_resultado_b').val();
		 					// 2. Calcula vencedor do Jogo
		 					jogos_pendentes[index_jogo_view].ganhador = get_ganhado(jogo.resultadoA, jogo.resultadoB);
		 					// 3. Calcula vencedor do Jogo na Aposta
		 					$.each(apostas_staticas_simulacao, function( i, a ) {
		 						if (jogos_pendentes[index_jogo_view].codigo == a.tabela.codigo) {
		 		 					apostas_staticas_simulacao[i].ganhador = get_ganhado(a.resultadoA, a.resultadoB);
		 						}
		 		 			});	
		 					// 4. ReCalcula a aposta
		 					calc_aposta(jogos_pendentes[index_jogo_view]);		 					
		 					
		 					$('#id_class').empty();
		 					// soma pontos calculo aposta + classificacao
		 					$.each( classificacao, function(i, c) {
		 						$.each( apostas_staticas_simulacao, function(x, a) {
		 							if (c.usuario.codigo == a.usuario.codigo) {
		 								classificacao[i].pontos += a.pontos;
		 							}
		 						});
		 					});		 					
		 					// calcula colocacao da classificacao
		 					ordena_colocacao_classificacao();	
		 					// popula classificacao
		 					popula_classificacao();
		 					
		 					$('#id_jogo_sim_seq').html('Jogo '+jogos_pendentes[index_jogo_view].codigo+(jogos_pendentes[index_jogo_view].ganhador != 'N' ? '  <span class="glyphicon glyphicon-check text-info"></span>' : ""));
		 			  }
			 	);								
			}
		}
		
		$('#id_recalcular').click(function() {
			recalcular();
		});
		
		$('#id_zerar').click(function() {
			var okTrue_cancelFalse = confirm("Deseja Zerar simulação ?");
			if (okTrue_cancelFalse == true) {
				$(this).attr('href', '/tdv/simulacao_classificacao');
			} else {
				$(this).attr('href', '#');
			}
		});
		
		$('#id_plus_play').click(function() {
			var qtde = prompt("Quantidade de Jogos a Simular", "48");
			if (qtde != null) {
				window.location = '/tdv/simulacao_classificacao?qtde='+qtde;	
  			}			
		});
		
		function SomenteNumero(e){
			var tecla=(window.event)?event.keyCode:e.which;   
			if(tecla > 47 && tecla < 58)
				return true;
			else {
			    if (tecla == 8 || tecla == 0) 
			    	return true;
				else  
					return false;
		    }
		}
		
		
		
	 </script>	

</body>
</html>
