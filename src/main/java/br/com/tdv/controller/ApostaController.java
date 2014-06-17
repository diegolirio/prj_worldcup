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
import br.com.tdv.dao.TabelaDao;
import br.com.tdv.model.Aposta;
import br.com.tdv.model.Tabela;

@Controller
public class ApostaController { 
	
	private DataSource dataSource;
	public ApostaController(){
		InitialContext initCtx;		
		DataSource dataSource = null;
		try {
			initCtx = new InitialContext();
			this.dataSource = (DataSource) initCtx.lookup( "java:/comp/env/jdbc/tdv_pool" );
			
			System.out.println("----------------------------------------------------------------------------------------");
			System.out.println("ApostaController.constructor() - datasource = "+dataSource);
			System.out.println("----------------------------------------------------------------------------------------");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
	}	
	
	@RequestMapping(value = "/aposta_jogo", method = RequestMethod.GET) 
	public ModelAndView getApostas(Tabela jogo) {
		ModelAndView mv = new ModelAndView("aposta_jogo");
		TabelaDao dao = new TabelaDao(this.dataSource);
		jogo = dao.getJogo(jogo.getCodigo());
		mv.addObject("jogo", jogo); 
		List<Aposta> apostas = new ApostaDao(this.dataSource).getApostas(jogo);
		mv.addObject("apostas", apostas);
		int [] qtdeAcertos = dao.getJogosQtdeAcerto(jogo);
		mv.addObject("qtde_ar", qtdeAcertos[0]);
		mv.addObject("qtde_ag", qtdeAcertos[1]);
		mv.addObject("qtde_er", qtdeAcertos[2]);		
		return mv;
	}
	
	@RequestMapping(value="apostas_simulacao", method=RequestMethod.GET)
	@ResponseBody
	public List<Aposta> getApostasJogosNaoFinalizados(int qtde) {
		List<Aposta> apostas = new ApostaDao(this.dataSource).getApostasJogosNaoFinalizados(qtde);
		return apostas;
	}
	
	@RequestMapping(value="aposta_jogo_simul", method=RequestMethod.GET)
	@ResponseBody
	public List<Aposta> getApostaJogoNaoFinalizado(int codigo) {
		List<Aposta> apostas = new ApostaDao(this.dataSource).getApostaJogoNaoFinalizado(codigo);
		return apostas;
	}	

}
