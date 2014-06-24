	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">	
	 
	<div class="container-fluid hidden-xs">  
	
			<div class="row">
				<select class="form-control" id="id_cbb_part">
				  	<option value="">Carregando...</option>
				</select>
			</div>
			<div class="row">
				<div id="id_char_line" style="width: 100%; height: 500px;"><center><br/><img src="/tdv/static/img/350.gif"/></center></div>
			</div>
			<br/><br/> 
	</div> 
	 
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>	
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript" class="hidden-xs">
	
		var participantes_class_json = [];
		google.load("visualization", "1", {packages:["corechart"]});
		
		init();
		
		function init() {
			get_all_participantes();	
		}
		
		var codigoPart = -1;
		
		function setCodigoPart(codigo) {
			codigoPart = codigo;
		}
		
		function get_all_participantes() {
	 		$.getJSON('/tdv/get_all_participantes_class/',  
	 				 function(retorno_participantes) { 
	 					participantes_class_json = retorno_participantes;
	 					var html_ = "";
	 					html_ = '<option value="">Selecione o participante...</option>';
	 					$.each(participantes_class_json, function(i, c) {
	 						html_ += '<option value="'+c.usuario.codigo+'" ' + (i == 0 ? "selected" : "" ) + ' >'+c.posicao+'º '+c.usuario.nome+' ('+c.usuario.codigo+' ) - '+ c.usuario.departamento +'</option>';
	 					});
	 					if (participantes_class_json.length > 0) {
	 						setCodigoPart(participantes_class_json[0].usuario.codigo);	
	 						// popula grafico....
	 						google.setOnLoadCallback(drawChart_line);
	 					}	 					
	 					$('#id_cbb_part').html(html_); 
	 					$('#id_load').empty();
	 		});
		}
		
	    function drawChart_line() {	    
	 		$.getJSON('/tdv/get_historico_colocacao_json/?codigo='+codigoPart,  
	 				 function(retorno_historico) { 
	 					//alert(JSON.stringify(retorno_historico));
						var data = get_data_line(retorno_historico);
						var codigoLider = codigoPart == participantes_class_json[0].usuario.codigo ? participantes_class_json[1].usuario.codigo : participantes_class_json[0].usuario.codigo;  
						var nomeLider = codigoPart == participantes_class_json[0].usuario.codigo ? participantes_class_json[1].usuario.nome : participantes_class_json[0].usuario.nome;						
						$.getJSON('/tdv/get_historico_colocacao_json/?codigo='+codigoLider,  
								  function(retorno_historico_lider) {
											data.addColumn('number', nomeLider); 
											$.each(retorno_historico_lider, function(i, l) {
												data.setValue(i, 2, l.posicao);					
											});								
											var options = {
													title: 'Histótico de Colocação',
													//width:900, height:300,
													vAxis: {maxValue: 10, direction: -1} // Inverte a Coluna em ordem crescente...
												  };
											var chart = new google.visualization.LineChart(document.getElementById('id_char_line'));		
											chart.draw(data, options);							
						});
	 		});
	    }
	    
	    function get_data_line(historico_json) {
			var data = new google.visualization.DataTable();
			data.addColumn('string', 'Jogos');
			data.addColumn('number', get_name_user(codigoPart));
			data.addRows(historico_json.length);
			$.each(historico_json, function(i, h) {
				data.setValue(i, 0, h.tabela.timeA + " x " + h.tabela.timeB);
				data.setValue(i, 1, h.posicao);					
			});
			return data;
	    }
	    
	    $('#id_cbb_part').change(function() {
	    	setCodigoPart($(this).val());
	    	drawChart_line();
	    });		
	    
	    function get_name_user(codigo) {
	    	var nome_ = null;
			$.each(participantes_class_json, function(i, c) {
					if(codigo == c.usuario.codigo) {
						nome_ = c.usuario.nome;
					}
				});
			return nome_;
	    }	    
	</script>
	