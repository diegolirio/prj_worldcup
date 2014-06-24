<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<html>
<head>
	<title>Regras</title>
	<link rel="shortcut icon" href="/tdv/static/img/ball_24.gif">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.min.css" rel="stylesheet">
	 <link href="/tdv/static/bootstrap/css/__bootstrap.css" rel="stylesheet">
</head>
<body>

	<jsp:include page="menu.jsp"></jsp:include>
	
	<div class="container">
	
			<h2 class="text-info">Regras</h2>		
			
			<hr/>
			
			<h3 class="text-muted">
			Todo participante &eacute; inscrito na competi&ccedil;&atilde;o, e assim tera em todos os jogos seus palpites do placar do Jogo.
			O bol&atilde;o &eacute; um rancking de pontos corridos, onde quem fazer maior n&uacute;mero de pontos vence.
			<br/><br/>A Pontua&ccedil;&atilde;o consiste em:	
			</h3>
			
			<br/>
			
			<div class="row">
				<div class="col-md-6">
					<div class="row">
						<blockquote>
							<p class="text-success"><i class="glyphicon glyphicon-thumbs-up"></i> Acertar o Placar </p>
							<p class="text-success">5 Pontos</p>
							<p class="text-info">exemplo:</p> 
							<p class="offset1"><span class="text-muted">Sua aposta:</span> Braisil 4 X 2 Italia</p>
							<p class="offset1"><span class="text-muted">Jogo:</span>       Braisil 4 X 2 Italia</p>
						</blockquote>
					</div>
					<div class="row">
						<blockquote>
							<p class="text-warning"><i class="glyphicon glyphicon-thumbs-up"></i> Acertar o Vencedor</p>
							<p class="text-warning">3 Pontos</p>
							<p class="text-info">exemplo:</p>
							<p class="offset1"><span class="text-muted">Sua aposta:</span> Braisil 3 X 0 Italia ou Brasil 3 X 1 Italia </p>
							<p class="offset1"><span class="text-muted">Jogo:</span>       Braisil 4 X 2 Italia</p>
						</blockquote>
					</div>
					<div class="row">
						<blockquote>	
							<p class="text-warning"><i class="glyphicon glyphicon-thumbs-up"></i> Acertar o Empate com placar diferente</p>
							<p class="text-warning">3 Pontos</p>
							<p class="text-info">exemplo:</p>
							<p class="offset1"><span class="text-muted">Sua aposta:</span> Braisil 1 X 1 Italia ou Brasil 0 X 0 Italia  </p>
							<p class="offset1"><span class="text-muted">Jogo:</span>       Braisil 2 X 2 Italia     </p>
						</blockquote>
					</div>
					<div class="row">
						<blockquote>	
							<p class="text-danger"><i class="glyphicon glyphicon-thumbs-down"></i> Errou Placar ou Vencedor</p>
							<p class="text-danger">Zero Pontos</p>
							<p class="text-info">exemplo:</p>
							<p class="offset1"><span class="text-muted">Sua aposta:</span> Braisil 1 X 3 Italia ou Brasil 0 X 0 Italia  </p>
							<p class="offset1"><span class="text-muted">Jogo:</span>       Braisil 4 X 2 Italia     </p>
						</blockquote>
					</div>					
				</div>
				<div class="col-md-6">
					<h1 class="text-success"><span class="glyphicon glyphicon-star text-warning"></span> 1º Lugar 80% do Valor </h1>
					<h3 class="text-info"><span class="glyphicon glyphicon-star-empty text-danger"></span> 2º Lugar 20% do Valor </h3>
					
					<br/><br/><br/>
					
					<h3 class="text-muted">Valor da Aposta: <span class="text-success">R$ 30,00</span></h3>
				</div>
			</div>
					
			<br/>
					
			
			
	</div>
	
	<jsp:include page="footer.jsp"></jsp:include>
	<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.js"></script>
	<script type="text/javascript" src="/tdv/static/bootstrap/js/bootstrap.min.js"></script>

</body>
</html>
