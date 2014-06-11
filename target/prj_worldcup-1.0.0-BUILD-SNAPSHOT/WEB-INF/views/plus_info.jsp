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
	
	<div class="container">  
	
			<div class="row">
				<div class="pull-right" id="id_load"><img src="/tdv/static/img/g.gif"/></div>
				<h2 class="text-info" style="text-shadow: 2px -2px white;"><img src="/tdv/static/img/logo_70_t.png" /> Participantes</h2>		
			</div>
			<br/><br/> 
	
			<div class="panel panel-primary">
				<div class="panel-heading">Historio de Colocacao<a title="Alterar" href="#"><span class="glyphicon glyphicon-pencil"></span></a><span class="pull-right">jogos finalizados de ${qtdeJogos}</span></div>
				<div class="panel-body">
					<span class="pull-right"><span class="label label-danger">ER</span><small class="text-danger"> Errou </small></span>
					<span class="pull-right"><span class="label label-warning">AG</span><small class="text-warning"> Acertou Ganhador/Empate </small>&bull; </span>
					<span class="pull-right"><span class="label label-success">AP</span><small class="text-success"> Acertou Placar </small>&bull; </span>					
				    <span class="text-warning">?????</span>
				</div>
				
				<div>
					<select class="form-control" id="id_cbb_part">
					  	<option value="">Carregando...</option>
					</select>					
				</div>
				
				<div id="id_char_line" style="width: 700px; height: 300px;"><img src="/tdv/static/img/350.gif"/></div>
				
				<br/><br/><br/>
				
			</div>	
	</div> 
	
	<jsp:include page="footer.jsp"></jsp:include>
	
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>	
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript">
	
		var participantes_json = [];
	
		init();
		
		function init() {
			get_all_participantes();	
		}
		
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
	 					
	 					$('#id_load').empty();
	 		});
		}
		
	      google.load("visualization", "1", {packages:["corechart"]});
	      google.setOnLoadCallback(drawChart);
	      function drawChart() {
		    var data = new google.visualization.DataTable();
			data.addColumn('string', 'Jogos');
			data.addColumn('number', 'Minha Colocação');
	        //data.addColumn('number', 'Expenses');
	        data.addRows(36);
	        data.setValue(0, 0, '1º Jogo');
	        data.setValue(0, 1, 21);
	        //data.setValue(0, 2, 400);
	        data.setValue(1, 0, '2º Jogo');
	        data.setValue(1, 1, 15);
	        //data.setValue(1, 2, 460);
	        data.setValue(2, 0, '3º Jogo');
	        data.setValue(2, 1, 2);
	        //data.setValue(2, 2, 1120);
	        data.setValue(3, 0, '4º Jogo');
	        data.setValue(3, 1, 1);
	        //data.setValue(3, 2, 540);
			data.setValue(4, 0, '5º Jogo');
	        data.setValue(4, 1, 5);
	        //data.setValue(3, 2, 540);
	        data.setValue(5, 0, '6º Jogo');
	        data.setValue(5, 1, 12);
	        //data.setValue(3, 2, 540);
	        data.setValue(6, 0, '7º Jogo');
	        data.setValue(6, 1, 9);
	        //data.setValue(3, 2, 540);


	        data.setValue(7, 0, '8º');
	        data.setValue(7, 1, 5);
	        data.setValue(8, 0, '9º');
	        data.setValue(8, 1, 3);		


	        data.setValue(9, 0, '10º Jogo');
	        data.setValue(9, 1, 1);
	        //data.setValue(0, 2, 400);
	        data.setValue(10, 0, '11º Jogo');
	        data.setValue(10, 1, 5);
	        //data.setValue(1, 2, 460);
	        data.setValue(11, 0, '12º Jogo');
	        data.setValue(11, 1, 6);
	        //data.setValue(2, 2, 1120);
	        data.setValue(12, 0, '13º Jogo');
	        data.setValue(12, 1, 4);
	        //data.setValue(3, 2, 540);
			data.setValue(13, 0, '14º Jogo');
	        data.setValue(13, 1, 7);
	        //data.setValue(3, 2, 540);
	        data.setValue(14, 0, '15º Jogo');
	        data.setValue(14, 1, 5);
	        //data.setValue(3, 2, 540);
	        data.setValue(15, 0, '16º Jogo');
	        data.setValue(15, 1, 4);
	        //data.setValue(3, 2, 540);


	        data.setValue(16, 0, '17º Jogo');
	        data.setValue(16, 1, 2);
	        data.setValue(17, 0, '18º Jogo');
	        data.setValue(17, 1, 1);		


	        data.setValue(18, 0, '19º Jogo');
	        data.setValue(18, 1, 1);
	        //data.setValue(0, 2, 400);
	        data.setValue(19, 0, '20º Jogo');
	        data.setValue(19, 1, 1);
	        //data.setValue(1, 2, 460);
	        data.setValue(20, 0, '21º Jogo');
	        data.setValue(20, 1, 1);
	        //data.setValue(2, 2, 1120);
	        data.setValue(21, 0, '22º Jogo');
	        data.setValue(21, 1, 1);
	        //data.setValue(3, 2, 540);
			data.setValue(22, 0, '23º Jogo');
	        data.setValue(22, 1, 2);
	        //data.setValue(3, 2, 540);
	        data.setValue(23, 0, '24º Jogo');
	        data.setValue(23, 1, 2);
	        //data.setValue(3, 2, 540);
	        data.setValue(24, 0, '25º Jogo');
	        data.setValue(24, 1, 3);
	        //data.setValue(3, 2, 540);


	        data.setValue(25, 0, '26º Jogo');
	        data.setValue(25, 1, 2);
	        data.setValue(26, 0, '27º Jogo');
	        data.setValue(26, 1, 2);		


	        data.setValue(27, 0, '28º Jogo');
	        data.setValue(27, 1, 3);
	        //data.setValue(0, 2, 400);
	        data.setValue(28, 0, '29º Jogo');
	        data.setValue(28, 1, 3);
	        //data.setValue(1, 2, 460);
	        data.setValue(29, 0, '30º Jogo');
	        data.setValue(29, 1, 3);
	        //data.setValue(2, 2, 1120);
	        data.setValue(30, 0, '31º Jogo');
	        data.setValue(30, 1, 4);
	        //data.setValue(3, 2, 540);
			data.setValue(31, 0, '32º Jogo');
	        data.setValue(31, 1, 6);
	        //data.setValue(3, 2, 540);
	        data.setValue(32, 0, '33º Jogo');
	        data.setValue(32, 1, 6);
	        //data.setValue(3, 2, 540);
	        data.setValue(33, 0, '34º Jogo');
	        data.setValue(33, 1, 5);
	        //data.setValue(3, 2, 540);


	        data.setValue(34, 0, '35º Jogo');
	        data.setValue(34, 1, 7);
	        data.setValue(35, 0, '36º Jogo');
	        data.setValue(35, 1, 8);				


			/*
	        var data = google.visualization.arrayToDataTable([
	          ['Jogo', 'Colocação'],
			  ['1º jogo', 75],
	          ['2º jogo', 15],
	          ['3º jogo',  2],
	          ['4º jogo',  1],
	          ['5º jogo',  5],
			  ['6º jogo',  12],
			  ['7º jogo',  9]
	        ]);
			*/
	        var options = {
	          title: 'Histótico de Colocação',
			  vAxis: {maxValue: 10, direction: -1} // Inverte a Coluna em ordem crescente...
	        };


	        var chart = new google.visualization.LineChart(document.getElementById('id_char_line'));		
	        chart.draw(data, options);
	        
	      }
		
		
	</script>

</body>
</html>
