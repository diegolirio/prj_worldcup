package br.com.tdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import br.com.tdv.model.Tabela;

public class TabelaDao {
	
	public Tabela getJogo(int codigo) {
		Tabela t = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select t.codigo, t.data, t.timea, t.timeb, t.ra, t.rb, t.ganhador "+
        			 "	 from t_tabela t "+
        			 " 	 where t.codigo = ? ";        
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql); 
                stmt.setInt(1, codigo);
                rs = stmt.executeQuery();			                                                 
                if(rs.next()) {
                	t = new Tabela();
                	t.setCodigo(codigo);
                	t.setData(Calendar.getInstance());
                	t.setTimeA(rs.getString("timeA"));
                	t.setTimeB(rs.getString("timeB"));
                	t.setResultadoA(rs.getInt("ra")); 
                	t.setResultadoB(rs.getInt("rb")); 
                	t.setGanhador(rs.getString("ganhador"));
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("TabelaDao.getJogo(codigo): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return t;			
	}
	
	public List<Tabela> getTabela() {
		List<Tabela> tabela = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select t.codigo, t.data, t.timea, t.timeb, t.ra, t.rb, t.ganhador "+
        			 "	 from t_tabela t " +
        			 " order by 1 ";      
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();
                tabela = new ArrayList<Tabela>();
                while(rs.next()) {
                	Tabela j = new Tabela();
                	j.setCodigo(rs.getInt("codigo"));
                	
                    if(rs.getString("data") != null && !"".equals(rs.getString("data"))) {					
                        SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");					  
                        Date dataLocal = new Date(format.parse(rs.getString("data")).getTime());
                        

                        Calendar dataFinalizacao = Calendar.getInstance();
                        dataFinalizacao.setTime(dataLocal); 
                        j.setData(dataFinalizacao);
                    }                	
                	
                	j.setTimeA(rs.getString("timeA"));
                	j.setTimeB(rs.getString("timeB"));
                	j.setResultadoA(rs.getInt("ra"));
                	j.setResultadoB(rs.getInt("rb"));
                	j.setGanhador(rs.getString("ganhador"));
                	tabela.add(j);
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("TabelaDao.getTabela(): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return tabela;			
	}	

	public List<Tabela> getJogosPendentes(int qtde) {
		List<Tabela> tabela = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select t.codigo, t.data, t.timea, t.timeb, t.ra, t.rb, t.ganhador "+
        			 "	 from (SELECT * FROM t_tabela order by codigo) t "+
        			 " where t.ganhador = 'N'" +
        			 "   and rownum <= " + qtde + //Common.QTDE_JOGOS_SIMULACAO +
        			 " order by t.codigo";    
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();
                tabela = new ArrayList<Tabela>();
                while(rs.next()) {
                	Tabela j = new Tabela();
                	j.setCodigo(rs.getInt("codigo"));
                	j.setData(Calendar.getInstance());
                	j.setTimeA(rs.getString("timeA"));
                	j.setTimeB(rs.getString("timeB"));
                	j.setResultadoA(rs.getInt("ra"));
                	j.setResultadoB(rs.getInt("rb"));
                	j.setGanhador(rs.getString("ganhador"));
                	tabela.add(j);
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("TabelaDao.getJogosPendentes(): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return tabela;					  	
	}
	
	public List<Tabela> getJogoPendente(int codigo) {
		List<Tabela> tabela = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select t.codigo, t.data, t.timea, t.timeb, t.ra, t.rb, t.ganhador "+
        			 "	 from (SELECT * FROM t_tabela order by codigo) t "+
        			 " where t.ganhador = 'N'";
        			 if(codigo != -1) {
        				 sql += "   and t.codigo = " + codigo;
        			 }
        			 sql += "   and rownum = 1" + 
        			 " order by t.codigo";    
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();
                tabela = new ArrayList<Tabela>();
                while(rs.next()) {
                	Tabela j = new Tabela();
                	j.setCodigo(rs.getInt("codigo"));
                	j.setData(Calendar.getInstance());
                	j.setTimeA(rs.getString("timeA"));
                	j.setTimeB(rs.getString("timeB"));
                	j.setResultadoA(rs.getInt("ra"));
                	j.setResultadoB(rs.getInt("rb"));
                	j.setGanhador(rs.getString("ganhador"));
                	tabela.add(j);
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("TabelaDao.getJogosPendentes(): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return tabela;					  	
	}	
	
	public int[] getJogosQtdeAcerto(Tabela t) {
		int [] r = {0, 0, 0}; 
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = " select sum((case when pontos=5 then 1 else 0 end)) ap, " +
        			 "        sum((case when pontos=3 then 1 else 0 end)) ag, " +
        			 "        sum((case when pontos=0 then 1 else 0 end)) er " +
        			 "	from t_aposta a " +
        			 "	where a.tabela_codigo = ? "; 
        try {
                conn = FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                stmt.setInt(1, t.getCodigo());
                rs = stmt.executeQuery();
                if(rs.next()) {
                	r[0] = rs.getInt("ap");
                	r[1] = rs.getInt("ag");
                	r[2] = rs.getInt("er");
                }
        } catch(Exception e) {
            throw new RuntimeException(e); 
        } finally {
        	System.out.println("TabelaDao.getJogosQtdeAcerto(): executado...!");
            FactorConnection.close(conn, stmt, rs); 
        } 
        return r;		
	}

}
