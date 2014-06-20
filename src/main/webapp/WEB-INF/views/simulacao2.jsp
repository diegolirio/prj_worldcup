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
				
			<h2 class="text-info">Simulação<small>  jogo <span id="id_jg_ini"><img src="/tdv/static/img/ball_24.gif"/></span> </small> </h2>		
			
			<br/>
			
			<div class="row">
				<h2 class="text-center" id="id_jogo_simulado"></h2>  
			</div>
			<div class="row">
				<div class="col-md-12 text-center">				
					<a href="javascript:undefined" id="id_recalcular" class="btn btn-success"><span class="glyphicon glyphicon-refresh"></span>  Recalcular</a>
					<a href="/tdv/simulacao_classificacao" id="id_zerar" class="btn btn-warning"> Zerar simulação</a>
				</div>
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
					    	<td class="text-center" title="Colocação">Col</td>
					    	<td class="text-center text-muted"></td>
					    	<td >Participante</td>
					    	<td>Departamento/Local</td>
					    	<td class="text-center">Pontos</td>
					    	<!-- <td class="text-center"></td> --> 
					    	<!-- <td class="text-center">%</td> -->
					    	<td class="text-center"><small>AP</small></td>
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
	 	
	 	var primeiro_jogo = -1;
	 	var index_atual = -1;

	 	
	 	var jogos_pendentes = [];
	 	var apostas_staticas_simulacao = [];
	 	var classificacao = [];
	 	
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
	 	
	 	var user_cod = _GET('usuario_codigo');
	 		 		 	 
	 	function get_jogo_pendente(codigo) {
	 		$.getJSON('/tdv/jogo_pendente/?codigo='+codigo,  
	 				 function(retorno_jogos) { 
 						if (retorno_jogos.length == 1) {
 							index_atual++;
 							var jogo = retorno_jogos[0];
 							jogos_pendentes.push(jogo);
 		 					$.getJSON('/tdv/aposta_jogo_simul/?codigo='+codigo, 
 		 							function(retorno_apostas) {
					 					$.each(retorno_apostas, function( i, a) {
					 						retorno_apostas[i].ganhador = get_ganhado(a.resultadoA, a.resultadoB);
					 						apostas_staticas_simulacao.push(a);
						 				});	 	 		
					 					popula_jogo(jogo);
					 					load_resultado_aposta_proximo_jogo(jogos_pendentes[index_atual]);
					 					$('#id_load').empty();
 		 					});
 						}
	 				 }
	 		);
	 	}
	 	
	 	$.getJSON('/tdv/jogo_pendente/?codigo='+primeiro_jogo,  
			      function(retorno_jogos) { 
	 				jogos_pendentes = retorno_jogos;
	 				if (jogos_pendentes.length > 0) {
	 					index_atual = 0;
 						$('#id_jg_ini').html(jogos_pendentes[index_atual].codigo);
 						//$('#id_jg_fim').html(jogos_pendentes[max_index_jogos_pendentes].codigo);	 					
	 					primeiro_jogo = jogos_pendentes[index_atual].codigo;
	 					$.getJSON('/tdv/aposta_jogo_simul/?codigo='+primeiro_jogo,  		
								  function(retorno_apostas) {
										apostas_staticas_simulacao = retorno_apostas;
										popula_jogo(jogos_pendentes[index_atual]);
					 					$.each(apostas_staticas_simulacao, function( i, a ) {
						 					apostas_staticas_simulacao[i].ganhador = get_ganhado(a.resultadoA, a.resultadoB);
						 				});	 
					 					
									 	$.getJSON('/tdv/get_class_simulacao/', 
										    	  function(retorno) {
									 					classificacao = retorno;
									 					//alert(JSON.stringify(classificacao));
									 					$.each(classificacao, function( i, c) {
									 						classificacao[i].posicaoAnterior = c.posicao;
									 		 			});																
									 					
									 					// 5º Calcula pontuacao nas apostas 		
									 					// Comentado para não calcular a primeira...
														//calc_aposta(jogos_pendentes[index_atual]); 
									 					// 6º soma pontos calculo aposta + classificacao
									 					$.each( classificacao, function(i, c) {
									 						$.each( apostas_staticas_simulacao, function(x, a) {
									 							if (c.usuario.codigo == a.usuario.codigo) {
									 								c.pontos += a.pontos;
									 							}
									 						});
									 					});
									 					// 6º calcula colocacao da classificacao
									 					ordena_colocacao_classificacao();	
									 					// 7º popula classificacao
									 					popula_classificacao();
									 					// 8º Checa como calculado caso tenha sido calculado
									 					$('#id_jg_ini').html(jogos_pendentes[index_atual].codigo+(jogos_pendentes[index_atual].ganhador != 'N' ? '  <span class="glyphicon glyphicon-check text-success"></span>' : ""));
									 			  }
									 	);										
	 							  }
	 					);
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
			var html_ = "<form>";
			if (jogo.codigo > primeiro_jogo) {
				html_ += '<a href="javascript:underfined" title="Jogo anterior " onclick="proximo_jogo_a_calcular_simulacao('+(jogo.codigo-1)+');" class="pull-left prior-next" data-toggle="tooltip" data-placement="top"><img src="/tdv/static/img/seta_e.png"/></a>';
				//html_ += '<a href="javascript:underfined" title="Jogo anterior: " onclick="proximo_jogo_a_calcular_simulacao(0);" class="pull-left"><img src="/tdv/static/img/seta_e.png"/></a>';
			}
			html_ +=     '<span class="text-danger">' +jogo.timeA + ' </span>';
			html_ +=     '<input type="number" class="class_jogo_resultado_a" style="width: 80px; height: 60px; font-size: 30px;" value="'+jogo.resultadoA+'" min="0" onkeypress="return SomenteNumero(event);"> ';
			html_ +=     '<span class="muted">X</span> ';
			html_ +=     '<input type="number" class="class_jogo_resultado_b" style="width: 80px; height: 60px; font-size: 30px;" value="'+jogo.resultadoB+'" min="0" onkeypress="return SomenteNumero(event);"> ';
			html_ +=     '<span class="text-danger">'+jogo.timeB+'</span>';
			if (jogo.codigo < 48) {
				html_ += '<a href="javascript:underfined" title="Próximo jogo" onclick="proximo_jogo_a_calcular_simulacao('+(jogo.codigo+1)+');" class="pull-right prior-next" data-toggle="tooltip" data-placement="top"><img src="/tdv/static/img/seta_d.png"/></a>';
				//html_ += '<a href="javascript:underfined" title="Próximo jogo:" onclick="proximo_jogo_a_calcular_simulacao(0);" class="pull-right"><img src="/tdv/static/img/seta_d.png"/></a>';
			}
			html_ += "</form>";
			$('#id_jogo_simulado').html(html_); 
			$('#id_time_a').html(jogos_pendentes[index_atual].timeA);
			$('#id_time_b').html(jogos_pendentes[index_atual].timeB);	
			$('#id_jg_ini').html(jogos_pendentes[index_atual].codigo+(jogos_pendentes[index_atual].ganhador != 'N' ? '   <span class="glyphicon glyphicon-check text-success"></span>' : ""));
			
			$.each(apostas_staticas_simulacao, function(i, a) {
				if(user_cod == a.usuario.codigo && jogo.codigo == a.tabela.codigo) {
					popula_meu_placar(jogos_pendentes[index_atual], a);
				}
			});	
		}
		
		function proximo_jogo_a_calcular_simulacao(codigo) {
			$('.result_ab').html('<img src="/tdv/static/img/ball_24.gif"/>');	
			$('#id_jogo_simulado').html('<img src="/tdv/static/img/350.gif"/>'); 
			$('#id_load').html('<img src="/tdv/static/img/350.gif"/>');

			if (codigo < jogos_pendentes[index_atual].codigo) { 
				index_atual--;
				popula_jogo(jogos_pendentes[index_atual]);
				load_resultado_aposta_proximo_jogo(jogos_pendentes[index_atual]);	
				$('#id_load').empty();
			} else if (codigo > jogos_pendentes[index_atual].codigo && ExitJogoJsonLocal(codigo)) {
				index_atual++;
				popula_jogo(jogos_pendentes[index_atual]);
				load_resultado_aposta_proximo_jogo(jogos_pendentes[index_atual]);
				$('#id_load').empty();
			} else if (codigo > jogos_pendentes[index_atual].codigo) { 
				// busca no Banco
				get_jogo_pendente(codigo);
			}
			
		}
		
		function ExitJogoJsonLocal(codigo) {
			var result = false;
			$.each(jogos_pendentes, function( i, j) {
				if (j.codigo == codigo) {	
					result = true;
				}
			});				
			return result;
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
		
		function calc_aposta(jogo) {
			// Calcula somente o ganhador
			jogos_pendentes[index_atual].ganhador = get_ganhado(jogos_pendentes[index_atual].resultadoA, jogos_pendentes[index_atual].resultadoB);			
			// Calcula Pontos nas Apostas
			$.each( apostas_staticas_simulacao, function( i, a) {
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
		
		function get_row_color(numero, usuario_codigo) {
			if(usuario_codigo == user_cod) {
				return "danger";
			} else if(numero % 2 == 0) {
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
				tr += '<tr class="'+get_row_color(i, first_to_last.usuario.codigo)+'">';
				tr +=     '<td class="text-center">'+first_to_last.posicao+'º</td>';
				
				var pos_sobe_desce = (first_to_last.posicaoAnterior-first_to_last.posicao);
				tr +=     '<td class="text-center text-muted"><small>';
				if (pos_sobe_desce > 0) {
					tr +=     '<span class="glyphicon glyphicon-arrow-up text-success">'+pos_sobe_desce;
				} else if (pos_sobe_desce < 0) {
					tr +=     '<span class="glyphicon glyphicon-arrow-down text-danger">'+pos_sobe_desce*-1;
				} else {
					tr +=     '<span class="glyphicon glyphicon-minus">';
				}
				tr +=     '</span></small></td>'; // posicao atual
				
				tr +=     '<td><a href="/tdv/aposta_participante/?codigo='+first_to_last.usuario.codigo+'" target="_blank"><small>'+first_to_last.usuario.nome+'</small></a></td>';
				tr +=     '<td class="text-muted"><small>'+first_to_last.usuario.departamento+'</small></td>';
				tr +=     '<td class="text-center">'+first_to_last.pontos+'<small class="text-muted"> (+'+get_pontos_total_simulado(first_to_last.usuario.codigo)+')</small></td>';
				tr +=     '<td class="text-center text-success"><small>'+(get_acerto(first_to_last.usuario.codigo, 5)+first_to_last.acertoPlacar)+'</small></td>';
				tr +=     '<td class="text-center text-warning"><small>'+(get_acerto(first_to_last.usuario.codigo, 3)+first_to_last.acertoGanhador)+'</small></td>';
				//tr +=     '<td class="text-center text-danger"><small>'+(get_acerto(first_to_last.usuario.codigo, 0)+first_to_last.erroZero)+'</small></td>';
				var ra = 0; // pega o resultado do usuario/participante e o jogo atual (Na tabela de postas)
				var rb = 0; // o mesmo para rb
				$.each(apostas_staticas_simulacao, function(index, a) {
					if(a.usuario.codigo == first_to_last.usuario.codigo && jogos_pendentes[index_atual].codigo == a.tabela.codigo) {
						ra = a.resultadoA;
						rb = a.resultadoB;
					} 
				});
				tr += '<td class="text-center"><b><span class="result_ab ra'+first_to_last.usuario.codigo+'">'+ra+'</span></b></td>';
				//alert('<td class="ra'+first_to_last.usuario.codigo+' text-center text-danger"><span>'+ra+'</span></td>');
				tr += '<td class="text-center text-muted">X</td>'; 
				tr += '<td class="text-center"><b><span class="result_ab rb'+first_to_last.usuario.codigo+'">'+rb+'</b></span></td>';
				tr += '</tr>';
				 
				$('#id_class').append(tr);
				
				// Popula colocacao e posicao do usuario logado na simulacao e meu placar do usuario logado
				if(user_cod == first_to_last.usuario.codigo) {
					var perfil_sim = '<span class="text-info">Simulação: </span><span>'+first_to_last.posicao+'º Colocado</span> - ' +
									 '<span>'+first_to_last.pontos+' pontos</span> '; 
					if (pos_sobe_desce > 0) {
						perfil_sim +=     '<span class="glyphicon glyphicon-arrow-up text-success">'+pos_sobe_desce+'</span>';
					} else if (pos_sobe_desce < 0) {
						perfil_sim +=     '<span class="glyphicon glyphicon-arrow-down text-danger">'+(pos_sobe_desce*-1)+'</span>';
					}
					$('#id_my_simul').html(perfil_sim);
				}
								
				$('#id_load').empty();
				$('#id_table_message').empty();
			});
		}	
		
		function popula_meu_placar(jogo, aposta) {
			var html_meu_placar = "<small>Meu placar: </small>"+
								  jogo.timeA + " " + aposta.resultadoA + " x " + " " + aposta.resultadoB + " " + jogo.timeB;
			$('#id_meu_placar').html(html_meu_placar);					
		}
		
		function recalcular(object) {
			if(jogos_pendentes.length <= 0) {
				$('#id_load').html('Não há jogos há serem calculados!');
			} else {			
				
				var ra_simul = $('#id_jogo_simulado input.class_jogo_resultado_a').val();
				var rb_simul = $('#id_jogo_simulado input.class_jogo_resultado_b').val();
				
				if (ra_simul == "" || rb_simul == "") {
					alert("Resultado A e B são campos Obrigatórios");
					return false;
				}				
				
				$('#id_load').html('<img src="/tdv/static/img/carreg.gif"/>');
				$('#id_table_message').html('calculando...');
				
			 	$.getJSON('/tdv/get_class_simulacao/', 
			    	  function(retorno) {  
		 					classificacao = retorno;
		 					//alert(JSON.stringify(classificacao));
		 					$.each(classificacao, function( i, c) {
		 						classificacao[i].posicaoAnterior = c.posicao;
		 		 			});			 					
		 					
		 					// 1. Preenche Resultado do Jogo
		 					jogo = jogos_pendentes[index_atual];
		 					jogo.resultadoA = ra_simul;
		 					jogo.resultadoB = rb_simul;
		 					// 2. Calcula vencedor do Jogo
		 					jogos_pendentes[index_atual].ganhador = get_ganhado(jogo.resultadoA, jogo.resultadoB);
		 					// 3. Calcula vencedor do Jogo na Aposta
		 					$.each(apostas_staticas_simulacao, function( i, a ) {
		 						if (jogos_pendentes[index_atual].codigo == a.tabela.codigo) {
		 		 					apostas_staticas_simulacao[i].ganhador = get_ganhado(a.resultadoA, a.resultadoB);
		 						}
		 		 			});	
		 					// 4. ReCalcula a aposta
		 					calc_aposta(jogos_pendentes[index_atual]);		 					
		 					
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
		 					
		 					$('#id_jg_ini').html(jogos_pendentes[index_atual].codigo+(jogos_pendentes[index_atual].ganhador != 'N' ? '  <span class="glyphicon glyphicon-check text-success"></span>' : ""));
		 			  }
			 	);								
			}
		}
		
		$('#id_recalcular').click(function() {
			recalcular(this);
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
