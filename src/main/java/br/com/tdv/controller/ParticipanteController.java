package br.com.tdv.controller;

import java.util.List;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import br.com.tdv.dao.ApostaDao;
import br.com.tdv.dao.ClassificacaoDao;
import br.com.tdv.dao.ParticipanteDao;
import br.com.tdv.model.Aposta;
import br.com.tdv.model.Classificacao;
import br.com.tdv.model.Usuario;

@Controller
public class ParticipanteController {
	
	private DataSource dataSource;
	public ParticipanteController(){
		InitialContext initCtx;		
		DataSource dataSource = null;
		try {
			initCtx = new InitialContext();
			this.dataSource = (DataSource) initCtx.lookup( "java:/comp/env/jdbc/tdv_pool" );
			
			System.out.println("----------------------------------------------------------------------------------------");
			System.out.println("ParticipanteController.constructor() - datasource = "+dataSource);
			System.out.println("----------------------------------------------------------------------------------------");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}
	
	@RequestMapping(value = "/aposta", method = RequestMethod.GET)
	public ModelAndView getApostas(Usuario usuario) {
		ModelAndView mv = new ModelAndView("aposta");
		usuario = new ParticipanteDao(this.dataSource).getParticipante(usuario.getCodigo());
		List<Aposta> apostas = new ApostaDao(this.dataSource).getApostas(usuario);
		mv.addObject("aposta", apostas);
		mv.addObject("usuario", usuario);
		// Devolver colocacao atual, pontos, ar, ag, er, jogos realizados
		
		InitialContext initCtx;		
		DataSource dataSource = null;
		try {
			initCtx = new InitialContext();
			dataSource = (DataSource) initCtx.lookup( "java:/comp/env/jdbc/tdv_pool" );
			
			System.out.println("----------------------------------------------------------------------------------------");
			System.out.println("datasource = "+dataSource);
			System.out.println("----------------------------------------------------------------------------------------");
			
			Classificacao c = new ClassificacaoDao(dataSource).getClassificacao(usuario);
			mv.addObject("classificacao", c);
			mv.addObject("qtdeJogos", c.getObservacao());			
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
		
		return mv;
	}
	
	@RequestMapping(value="/get_all_participantes", method=RequestMethod.GET)
	@ResponseBody
	public List<Usuario> getAllParticipantes() {
		return new ParticipanteDao(this.dataSource).getAllParticipante();
	}

}
