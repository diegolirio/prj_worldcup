<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html> 
<head>
	<title> ... &bull; Aposta</title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">		
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container" id="id_container_content_part"> 
	 		
			<div class="row">
				<select class="form-control" id="id_cbb_part">
				  	<option value="">Carregando...</option>
				</select>
			</div>	 
			<div class="row">
				<div class="col-md-7 text-center">
					<h2 id="id_nome"><img src="/tdv/static/img/255.GIF"/></h2>
					<h4 class="text-muted" id="id_departamento"><img src="/tdv/static/img/255.GIF"/></h4>
					<br/>
					<h2 class="text-success" id="id_posicao"><img src="/tdv/static/img/255.GIF"/></h2>
					<h2 class="text-success" id="id_pontos"><img src="/tdv/static/img/255.GIF"/></h2>					
				</div>			 
				<div class="col-md-5">
					<center><div id="chart_div" class="hidden-xs"></div></center>
				</div>			
			</div>
			<div class="row">
				<div id="id_char_line" class="hidden-xs" style="width: 100%; height: 300px;"></div>
			</div>				
			<br/>
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
					    <tbody id="id_tbody"></tbody>					    
					</table>			
					
				</div>
			</div>	
	</div>
	
  <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
  <script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>	
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>	
  
  <script type="text/javascript">
  
  		google.load('visualization', '1.0', {'packages':['corechart']});
  
  		var usuario_json = [];
  		var apostas_json = [];
  		var classificacao_json = [];
  		var participantes_json = [];
  		var historico_json = [];
  
	 	function _GET_(name) {
	 	  	var url   = window.location.search.replace("?", "");
	 	  	var itens = url.split("&");
	 	  	for(n in itens) {
	 	    	if( itens[n].match(name) ) {
	 	      		return decodeURIComponent(itens[n].replace(name+"=", ""));
	 	    	}
	 	  	}
	 	  	return null;
	 	}  	  
	 	
	 	// 1. pega o codigo do parametro
	 	var code_user = _GET_("codigo");
	 	init(code_user, true);
	 	
  	    function init(codigo, load) { 
  	    	code_user = codigo;
  	   		// 2. busca usuario
  		 	$.getJSON('/tdv/get_usuario/?codigo='+codigo,  
  					 function(retorno_usuario) { 
  		 			 	usuario_json = retorno_usuario;  		 				
  		 				// 2.1 popula dados do usuario
  		 			 	$('#id_nome').html('<small> '+usuario_json.codigo+' &bull; </small>'+usuario_json.nome);
  		 			 	$('title').html(usuario_json.nome + ' &bull; Aposta ');
  		 			 	$('#id_departamento').html('( '+usuario_json.departamento+ ' )');  		 			 	 
  		 			 }
  		 	);
  			// 3. busca apostas
  		 	$.getJSON('/tdv/get_apostas/?codigo='+codigo,   
 					 function(retorno_apostas) { 
  		 				apostas_json = retorno_apostas;
  		 				//alert(JSON.stringify(apostas_json));
  		 				// 3.1 popula dados das apostas
  		 				var html_ = "";
  		 				$.each(apostas_json, function(i, a) {
  		 					if (i % 2 == 0) {
  		 						html_ += '<tr class="success">';	
  		 					} else {
  		 						html_ += '<tr class="warning">';
  		 					}
  		 					html_ += '<td class="text-center text-muted"><small>'+a.tabela.codigo+'</small></td>';
  		 					html_ += '<td class="text-center"><small>'+a.tabela.timeA+'</small></td>';
  		 					html_ += '<td class="text-center">'+a.tabela.resultadoA+'</td>';
  		 					html_ += '<td class="text-center text-muted">X</td>';
  		 					html_ += '<td class="text-center">'+a.tabela.resultadoB+'</td>';
  		 					html_ += '<td class="text-center"><small>'+a.tabela.timeB+'</small></td>';
  		 					html_ += '<td><a href="/tdv/aposta_jogo/?usuario_codigo='+codigo+'&codigo='+a.tabela.codigo+'" title="ver apostas de todos os participantes de '+a.tabela.timeA+' X '+a.tabela.timeB+'"><span class="glyphicon glyphicon-share"></span></a></td>';
  		 					html_ += '<td class="text-danger text-center">'+a.resultadoA+'</td>';
  		 					html_ += '<td class="text-muted text-center">X</td>';
  		 					html_ += '<td class="text-danger text-center">'+a.resultadoB+'</td>';
  		 					html_ += '<td class="text-center">';
  		 					if (a.tabela.ganhador == 'N') {
  		 						html_ += '<span class="label label-default">'+a.pontos+'</span>';
  		 					}
  		 					else if (a.pontos == 5 && a.tabela.ganhador != 'N') {
  		 						html_ += '<span class="label label-success">'+a.pontos+'</span>';
  		 					}
  		 					else if (a.pontos == 3 && a.tabela.ganhador != 'N') {
  		 						html_ += '<span class="label label-warning">'+a.pontos+'</span>';
  		 					}
  		 					else if (a.pontos == 0 && a.tabela.ganhador != 'N') {
  		 						html_ += '<span class="label label-danger">'+a.pontos+'</span>';
  		 					}  		 					
  		 					html_ += '  </td>';
  		 					html_ += '</tr> ';	
  		 				});
  		 				$('#id_tbody').html(html_);
 		 			 }
 		 	);  			
		  	// 5. busca todos participantes e historico  	
		  	$.getJSON('/tdv/get_all_participantes_class/',  
					 function(retorno_all_part) { 
						participantes_json = retorno_all_part;
	 					var html_cbb = "";
	 					html_cbb = '<option value="">Selecione o participante...</option>';
	 					$.each(participantes_json, function(i, c) {
	 						html_cbb += '<option value="'+c.usuario.codigo+'" ' + (c.usuario.codigo == codigo ? "selected" : "" ) + ' >'+c.posicao+'º '+c.usuario.nome+' ('+c.usuario.codigo+' ) - '+ c.usuario.departamento +'</option>';
	 					});
	 					$('#id_cbb_part').html(html_cbb); 
	 					if (participantes_json.length > 0) {
	 						// popula grafico....
  		 					if(load) {
  		 						google.setOnLoadCallback(drawChart_line);
  		 					} else {
  		 						drawChart_line();
  		 					}	 						
	 					}		 					
			});
		  	// 4. busca classificacao
  		 	$.getJSON('/tdv/get_classificacao_participante/?codigo='+codigo,   
 					 function(retorno_class) { 
  		 					classificacao_json = retorno_class;
  		 					// 4.1 popula dados dos acertos  em pizza
  		 					$('#id_posicao').html(classificacao_json.posicao+'&deg; <small>Colocado</small>');
  		 					$('#id_pontos').html(classificacao_json.pontos+'<small> Pontos</small>');
  		 					if(load) {
  		 						google.setOnLoadCallback(drawChart);
  		 					} else {
  		 						drawChart();
  		 					}
  		 	});		  	
  	    }  	    
  	    // Grafico de Linha
	    function drawChart_line() {	    
	 		$.getJSON('/tdv/get_historico_colocacao_json/?codigo='+code_user,  
	 				 function(retorno_historico) { 
	 					//alert(JSON.stringify(retorno_historico));
	 					historico_json = retorno_historico;
						var data = get_data_line(retorno_historico);
						var options = {
								title: 'Histótico de Colocação',
								//width:900, height:300,
								vAxis: {maxValue: 10, direction: -1} // Inverte a Coluna em ordem crescente...
							  };
						var chart = new google.visualization.LineChart(document.getElementById('id_char_line'));		
						chart.draw(data, options);
	 		});
	    }  	    
  	    
	    function get_data_line(historico_json) {
			var data = new google.visualization.DataTable();
			data.addColumn('string', 'Jogos');
			data.addColumn('number', 'Colocação');
			data.addRows(historico_json.length);
			$.each(historico_json, function(i, h) {
				data.setValue(i, 0, h.tabela.timeA + " x " + h.tabela.timeB);
				data.setValue(i, 1, h.posicao);					
			});
			return data;
	    }  	    
  	    
        function drawChart() {

            // Create the data table.
            var data = new google.visualization.DataTable();
            data.addColumn('string', 'Critérios de Acertos');
            data.addColumn('number', 'Quantidade');
            data.addRows([
              ['Acertou Placar', classificacao_json.acertoPlacar], // ar
              ['Acertou Ganhador', classificacao_json.acertoGanhador], // ag
    		  ['Errou', classificacao_json.erroZero]  // er
            ]);

            // Set chart options
            var options = {'title':'Jogos', //qtde jogos 
                           'width':350,
                           'height':270,
                           is3D: true,
                           colors:['#31B404','#FFBF00', '#DF0101']
            			  }; 
 
            // Instantiate and draw our chart, passing in some options.
            var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options); 
          }  
        
	    $('#id_cbb_part').change(function() {
	    	//$('#id_container_content_part').html('<center><img src="/tdv/static/img/g.gif"/></div></center>');
	    	//window.location = "/tdv/aposta_participante/?codigo=" + $(this).val();
	    	//window.location = "/tdv/aposta_participante/?codigo=" + $(this).val();
	    	$('#id_nome').html('<img src="/tdv/static/img/g.gif"/>');
	    	init($(this).val(), false);  
	    });	  	    
  
    </script>    	

</body>
</html>
