<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Estatisticas </title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/bootstrap.css" rel="stylesheet">	
	 <link href="/tdv/static/bootstrap/css/my_css.css" rel="stylesheet"> 	
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container hidden-xs">  
	
			<div class="row">
				<select class="form-control" id="id_cbb_part">
				  	<option value="">Carregando...</option>
				</select>
			</div>
			<div class="row">
				<div id="id_char_line" style="width: 100%; height: 300px;"><img src="/tdv/static/img/350.gif"/></div>
			</div>
	
			<div class="row">
				<div class="pull-right" id="id_load"><img src="/tdv/static/img/g.gif"/></div>
				<h2 class="text-info" style="text-shadow: 2px -2px white;"><img src="/tdv/static/img/logo_70_t.png" /> Participantes</h2>		
			</div>
			<br/><br/> 
	</div> 
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>	
	<script type="text/javascript" src="https://www.google.com/jsapi" class="hidden-xs"></script>
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
	    
	    $('#id_cbb_part').change(function() {
	    	setCodigoPart($(this).val());
	    	drawChart_line();
	    });		
	</script>

</body>
</html>
