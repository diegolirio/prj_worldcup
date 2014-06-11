package br.com.tdv.controller;

import java.util.List;

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
	
	@RequestMapping(value = "/aposta", method = RequestMethod.GET)
	public ModelAndView getApostas(Usuario usuario) {
		ModelAndView mv = new ModelAndView("aposta");
		usuario = new ParticipanteDao().getParticipante(usuario.getCodigo());
		List<Aposta> apostas = new ApostaDao().getApostas(usuario);
		mv.addObject("aposta", apostas);
		mv.addObject("usuario", usuario);
		// Devolver colocacao atual, pontos, ar, ag, er, jogos realizados
		Classificacao c = new ClassificacaoDao().getClassificacao(usuario);
		mv.addObject("classificacao", c);
		mv.addObject("qtdeJogos", c.getObservacao());
		return mv;
	}
	
	@RequestMapping(value="/get_all_participantes", method=RequestMethod.GET)
	@ResponseBody
	public List<Usuario> getAllParticipantes() {
		return new ParticipanteDao().getAllParticipante();
	}

}
