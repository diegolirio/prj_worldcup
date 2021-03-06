package br.com.tdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import br.com.tdv.model.Classificacao;
import br.com.tdv.model.ClassificacaoHist;
import br.com.tdv.model.Tabela;
import br.com.tdv.model.Usuario;

public class ClassificacaoDao {
    
	private DataSource dataSource;
	
	public ClassificacaoDao(DataSource dataSource){
		this.dataSource = dataSource;
		System.out.println("----------------------------------------------------------------------------------------");
		System.out.println("ClassificacaoDao.constructor() - datasource = "+dataSource);
		System.out.println("----------------------------------------------------------------------------------------");
	}
	
    public List<Classificacao> getClassificacao() {
        List<Classificacao> rancking = null;
        Connection conn = null; 
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        try {
        		int qtdeJgFinalizados = this.getQtdeJogoFinalizados();
        		if(qtdeJgFinalizados == 0) qtdeJgFinalizados = 1; 
        		
                conn = this.dataSource.getConnection(); //FactorConnection.getConnection();
                stmt = conn.prepareStatement("Select posicao, nome, depto, codigo, pontos, a_placar, a_ganhador, erro_zero, " +
                                             " Round(100 * pontos / ("+qtdeJgFinalizados+" * 5), 2) percent," +
								             "   case "+ 
								             "   when depto like '%DESENV%' then 1 "+
								             "   when codigo = '050' then 3 "+
								             "   else 2 "+
								             " end orderna, "+
								              
								             " ( select posicao " + 
								             "   from t_cpm_classhist c "+
								             "   where c.jogo = ( " +
								             "                    select max(jogo) "+
								             "                     from t_cpm_classhist c " +
								             "                     where c.jogo < ( select max(jogo) "+
								             "                                       from t_cpm_classhist cc ) ) "+
								             "     and to_number(c.usuario) = to_number(cl.codigo) ) posicao_ant " +
								             
                                             " from t_cpm_class cl" + 
                                             " order by posicao, 10, nome "); 
                rs = stmt.executeQuery();			                
                rancking = new ArrayList<Classificacao>();                                  
                while(rs.next()) {
                    Classificacao c = new Classificacao();
                    c.setPosicao(rs.getInt("posicao"));
                    c.setPontos(rs.getInt("pontos"));
                    Usuario u = new Usuario();
                    u.setCodigo(rs.getString("codigo"));
                    u.setDepartamento(rs.getString("depto"));
                    u.setNome(rs.getString("nome"));
                    c.setUsuario(u);
                    c.setPercent(rs.getFloat("percent"));
                    c.setObservacao("N");
                    c.setAcertoPlacar(rs.getInt("a_placar"));
                    c.setAcertoGanhador(rs.getInt("a_ganhador"));
                    c.setErroZero(rs.getInt("erro_zero"));
                    c.setPosicaoAnterior(rs.getInt("posicao_ant"));
                    rancking.add(c);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ClassificacaoDao.getClassificacao(): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return rancking;
    }
    
	public Classificacao getClassificacao(Usuario participante) {
		Classificacao c = null;
        Connection conn = null; 
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        try {
        		int qtdeJgFinalizados = this.getQtdeJogoFinalizados();
        		if(qtdeJgFinalizados == 0) qtdeJgFinalizados = 1; 
        		
        		conn = this.dataSource.getConnection(); //FactorConnection.getConnection();
                stmt = conn.prepareStatement("Select posicao, nome, depto, codigo, pontos, a_placar, a_ganhador, erro_zero, " +
                                             " 100 * pontos / ("+qtdeJgFinalizados+" * 5) percent " +
                                             " from t_cpm_class " + 
                                             " where codigo = ? " +
                                             " order by posicao, nome ");
                stmt.setString(1, participante.getCodigo());
                rs = stmt.executeQuery();
                if(rs.next()) {       
                	c = new Classificacao();
                    c.setPosicao(rs.getInt("posicao"));
                    c.setPontos(rs.getInt("pontos"));
                    Usuario u = new Usuario();
                    u.setCodigo(rs.getString("codigo"));
                    u.setDepartamento(rs.getString("depto"));
                    u.setNome(rs.getString("nome"));
                    c.setUsuario(u);
                    c.setPercent(rs.getFloat("percent"));
                    c.setObservacao(qtdeJgFinalizados+"");
                    c.setAcertoPlacar(rs.getInt("a_placar"));
                    c.setAcertoGanhador(rs.getInt("a_ganhador"));
                    c.setErroZero(rs.getInt("erro_zero"));
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ClassificacaoDao.getClassificacao(participante): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
		return c;
	}    
    
	public List<ClassificacaoHist> getHistoricoColocacao(Usuario participante) {
		List<ClassificacaoHist> l = null;
        Connection conn = null; 
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        try {
        	
        		String sql = " Select ch.posicao, " +
        					 "        t.timea, " +
        					 "        t.ra, " +
        					 "        t.timeb, "+
        					 "        t.rb, "+
        					 "		  ch.pontos " +		
        					 " 	from t_cpm_classhist ch, " +
        					 "       t_tabela t " +
        					 " 	where ch.jogo = t.codigo " +
        					 "    and to_number(ch.usuario) = to_number(?) " +
        					 "  order by t.codigo";        	
        		
        		conn = this.dataSource.getConnection(); //FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, participante.getCodigo());
                rs = stmt.executeQuery();
                l = new ArrayList<ClassificacaoHist>();
                while(rs.next()) {       
                	ClassificacaoHist c = new ClassificacaoHist();
                    c.setPosicao(rs.getInt("posicao"));
                    c.setPontos(rs.getInt("pontos"));
                    Tabela t = new Tabela();
                    t.setTimeA(rs.getString("timea"));
                    t.setTimeB(rs.getString("timeb"));
                    t.setResultadoA(rs.getInt("ra")); 
                    t.setResultadoB(rs.getInt("rb"));
                    c.setTabela(t);
                    l.add(c);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ClassificacaoDao.getHistoricoColocacao(participante): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
		return l;
	}   
	
	public int getQtdeJogoFinalizados() {
		int result = 0;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select count(*) qtde from t_tabela t where t.ganhador != 'N'";      
        try {
        		conn = this.dataSource.getConnection(); //FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();
                if(rs.next()) {
                	result = rs.getInt("qtde");
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("ClassificacaoDao.getQtdeJogoFinalizados(): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return result;			
	} 	
    
}
