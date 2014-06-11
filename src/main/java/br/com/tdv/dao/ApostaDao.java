package br.com.tdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import br.com.tdv.model.Aposta;
import br.com.tdv.model.Tabela;
import br.com.tdv.model.Usuario;

public class ApostaDao {
	
	public List<Aposta> getApostas(Tabela tabela) {
        List<Aposta> apostas = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = " select a.usuario_codigo, "+
        			 "		  u.nome, "+
        			 "        u.depto, "+
        			 "        a.ra, "+
        			 "        a.rb, "+
        			 "        a.pontos "+
        			 "   from t_aposta a, "+
        			 "        t_usuario u "+
        			 "  where a.usuario_codigo = u.codigo "+
        			 "    and a.tabela_codigo = ? " +
        			 "  order by a.usuario_codigo";      
        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, tabela.getCodigo());
                rs = stmt.executeQuery();			                
                apostas = new ArrayList<Aposta>();                                 
                while(rs.next()) {
                	Aposta a = new Aposta();
                	a.setUsuario(new Usuario(rs.getString("usuario_codigo"), rs.getString("nome"), rs.getString("depto")));
                    a.setResultadoA(rs.getInt("ra"));
                    a.setResultadoB(rs.getInt("rb"));
                    a.setPontos(rs.getInt("pontos"));
                    apostas.add(a);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ApostaDao.getApostas(tabela): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return apostas;			
	}
	
	public List<Aposta> getApostasJogosNaoFinalizados(int qtde) {
        List<Aposta> apostas = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;   
        
        String sql = "select a.usuario_codigo, "+
		   			 "       a.ra, a.rb, "+
		   		     "       a.pontos, "+
		   			 "       a.tabela_codigo "+
		   		     "   from (select x.* " +
		   			 "            from (SELECT * FROM t_tabela order by codigo) x "+
		   		     "            where x.ganhador = 'N' "+
		   			 "              and rownum <= "+ qtde +//Common.QTDE_JOGOS_SIMULACAO +
		   		     "            order by x.codigo) t, "+
		   			 "        t_aposta a "+
		   		     "   where t.codigo = a.tabela_codigo "+
		   			 "     and rownum <= "+qtde+" * (select count(*) from t_usuario) ";    
        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();			                 
                apostas = new ArrayList<Aposta>();                                 
                while(rs.next()) {
                	Aposta a = new Aposta();
                	//a.setUsuario(new ParticipanteDao().getParticipante(rs.getString("usuario_codigo")));
                	a.setUsuario(new Usuario(rs.getString("usuario_codigo")));
                	a.setTabela(new Tabela(rs.getInt("tabela_codigo")));
                    a.setResultadoA(rs.getInt("ra"));
                    a.setResultadoB(rs.getInt("rb"));
                    a.setPontos(rs.getInt("pontos"));
                    apostas.add(a);
                }
        } catch(Exception e) { 
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ApostaDao.getApostasJogosNaoFinalizados(): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return apostas;			
	}	
	
	public List<Aposta> getApostaJogoNaoFinalizado(int codigo) {
        List<Aposta> apostas = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;   
        
        String sql = " select a.usuario_codigo, a.ra, a.rb, a.pontos, a.tabela_codigo " +
        			 "   from t_tabela t, "+
        			 "        t_aposta a "+
        			 "   where t.codigo = a.tabela_codigo "+
        			 "     and t.codigo = " + codigo;
        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();			                 
                apostas = new ArrayList<Aposta>();                                 
                while(rs.next()) {
                	Aposta a = new Aposta();
                	//a.setUsuario(new ParticipanteDao().getParticipante(rs.getString("usuario_codigo")));
                	a.setUsuario(new Usuario(rs.getString("usuario_codigo")));
                	a.setTabela(new Tabela(rs.getInt("tabela_codigo")));
                    a.setResultadoA(rs.getInt("ra"));
                    a.setResultadoB(rs.getInt("rb"));
                    a.setPontos(rs.getInt("pontos"));
                    apostas.add(a);
                }
        } catch(Exception e) { 
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ApostaDao.getApostaJogoNaoFinalizado(): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return apostas;			
	}		

	public List<Aposta> getApostas(Usuario usuario) {
        List<Aposta> apostas = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select a.tabela_codigo,"+
        			 "       t.timea, "+
        			 "       t.ra,"+
        			 "       t.timeb,"+
        			 "       t.rb,"+
        			 "		 t.data,"+	
        			 "       t.ganhador," +	
        			 "       a.ra meu_ra,"+
        			 "       a.rb meu_rb,"+
        			 "       a.pontos "+
        			 "	 from t_aposta a,"+
        			 " 	      t_tabela t "+
        			 " 	 where a.tabela_codigo = t.codigo " +
        			 "	   and a.usuario_codigo = ? " +
        			 "   order by a.tabela_codigo";
        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, usuario.getCodigo());
                rs = stmt.executeQuery();			                
                apostas = new ArrayList<Aposta>();                                 
                while(rs.next()) {
                	Aposta a = new Aposta();
                    a.getTabela().setCodigo(rs.getInt("tabela_codigo"));
                    a.getTabela().setTimeA(rs.getString("timea"));
                    a.getTabela().setTimeB(rs.getString("timeb"));
                    a.getTabela().setResultadoA(rs.getInt("ra"));
                    a.getTabela().setResultadoB(rs.getInt("rb"));
                    a.getTabela().setGanhador(rs.getString("ganhador"));
                    //SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
                    //sdf.format(Date.parse(rs.getString("data")));
                    a.getTabela().setData(Calendar.getInstance());
                    a.setResultadoA(rs.getInt("meu_ra"));
                    a.setResultadoB(rs.getInt("meu_rb"));
                    a.setPontos(rs.getInt("pontos"));
                    apostas.add(a);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ApostaDao.getApostas(usuario): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return apostas;		
	}	
	
	public HashMap<String, Aposta> getApostaAnteriorProximoJogo(Usuario usuario) {
		HashMap<String, Aposta> apostas = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        PreparedStatement stmt_ant = null;
        ResultSet rs_ant = null;         
        
        String sql = "select a.tabela_codigo,"+
		   			 "       t.timea, "+
		   			 "       t.ra,"+
		   			 "       t.timeb,"+
		   			 "       t.rb,"+
		   			 "		 t.data,"+	
		   			 "       t.ganhador," +	
		   			 "       a.ra meu_ra,"+
		   			 "       a.rb meu_rb,"+
		   			 "       a.pontos "+
					 "   from t_aposta a, " +
		   			 "        t_tabela t " +
					 "   where a.usuario_codigo = ? " +
		   			 "     and a.tabela_codigo = t.codigo ";
        
        String prox = "     and a.tabela_codigo = (Select min(x.codigo) "+
					  "                               from t_tabela x " + 
					  "                               where x.ganhador = 'N' ) " +
					  "   order by a.tabela_codigo ";	
        
        String ante = "     and a.tabela_codigo = (Select max(x.codigo) "+
					  "                               from t_tabela x " + 
					  "                               where x.ganhador != 'N' ) " +
					  "   order by a.tabela_codigo ";	        
        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql+prox);
                stmt.setString(1, usuario.getCodigo());
                rs = stmt.executeQuery();		
                apostas = new HashMap<String, Aposta>();
                if(rs.next()) {
                	Aposta aposta = new Aposta();
                    aposta.getTabela().setCodigo(rs.getInt("tabela_codigo"));
                    aposta.getTabela().setTimeA(rs.getString("timea"));
                    aposta.getTabela().setTimeB(rs.getString("timeb"));
                    aposta.getTabela().setResultadoA(rs.getInt("ra"));
                    aposta.getTabela().setResultadoB(rs.getInt("rb"));
                    aposta.getTabela().setGanhador(rs.getString("ganhador"));
                    aposta.getTabela().setData(Calendar.getInstance());
                    aposta.setResultadoA(rs.getInt("meu_ra"));
                    aposta.setResultadoB(rs.getInt("meu_rb"));
                    aposta.setPontos(rs.getInt("pontos"));
                    apostas.put("proximo", aposta);
                }
                
                stmt_ant = conn.prepareStatement(sql+ante);
                System.out.println(sql+ante);
                stmt_ant.setString(1, usuario.getCodigo());
                rs_ant = stmt_ant.executeQuery();	
                if(rs_ant.next()) {
                	Aposta aposta = new Aposta();
                    aposta.getTabela().setCodigo(rs_ant.getInt("tabela_codigo"));
                    aposta.getTabela().setTimeA(rs_ant.getString("timea"));
                    aposta.getTabela().setTimeB(rs_ant.getString("timeb"));
                    aposta.getTabela().setResultadoA(rs_ant.getInt("ra"));
                    aposta.getTabela().setResultadoB(rs_ant.getInt("rb"));
                    aposta.getTabela().setGanhador(rs_ant.getString("ganhador"));
                    aposta.getTabela().setData(Calendar.getInstance());
                    aposta.setResultadoA(rs_ant.getInt("meu_ra"));
                    aposta.setResultadoB(rs_ant.getInt("meu_rb"));
                    aposta.setPontos(rs_ant.getInt("pontos"));
                    apostas.put("anterior", aposta);
                }             
                
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ApostaDao.getApostas(usuario): executado...!");
            FactorConnection.close(conn, stmt, rs);
            FactorConnection.close(conn, stmt_ant, rs_ant);
        } 
        return apostas;			
	}
	
}
