package br.com.tdv.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import br.com.tdv.model.Classificacao;
import br.com.tdv.model.Usuario;

public class ParticipanteDao {
	
	private DataSource dataSource;
	
	public ParticipanteDao(DataSource dataSource){
		this.dataSource = dataSource;
		System.out.println("----------------------------------------------------------------------------------------");
		System.out.println("ParticipanteDao.constructor() - datasource = "+dataSource);
		System.out.println("----------------------------------------------------------------------------------------");
	}	
	
	public Usuario getParticipante(String codigo) {
		Usuario u = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select u.codigo, u.nome, u.depto, u.email "+
        			 "	 from t_usuario u "+
        			 " 	 where u.codigo = ? ";        
        try {
                conn = this.dataSource.getConnection();// FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, codigo);
                rs = stmt.executeQuery();			                                                 
                if(rs.next()) {
                	u = new Usuario();
                	u.setCodigo(codigo);
                	u.setNome(rs.getString("nome"));
                	u.setDepartamento(rs.getString("depto"));
                	u.setEmail(rs.getString("email"));
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ParticipanteDao.getParticipante(codigo): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return u;				
	}
	
	public List<Usuario> getAllParticipante() {
		List<Usuario> l = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = "select u.codigo, u.nome, u.depto, u.email "+
        			 "	 from t_usuario u ";   
        try {
        		conn = this.dataSource.getConnection();// FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();			     
                l = new ArrayList<Usuario>();
                while(rs.next()) {
                	Usuario u = new Usuario();
                	u.setCodigo(rs.getString("codigo"));
                	u.setNome(rs.getString("nome"));
                	u.setDepartamento(rs.getString("depto"));
                	u.setEmail(rs.getString("email"));
                	l.add(u);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ParticipanteDao.getAllParticipante(): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return l;				
	}	
	
	public List<Classificacao> getAllParticipanteClassificacao() {
		List<Classificacao> l = null;
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null; 
        
        String sql = " select c.posicao, u.codigo, u.nome, u.depto, u.email " +
        			 "   from t_cpm_class c, "+
        			 "        t_usuario u "+
        			 "  where c.codigo = u.codigo "+
        			 " order by c.posicao, c.nome ";
 
        try {
        		conn = this.dataSource.getConnection();// FactorConnection.getConnection();
                stmt = conn.prepareStatement(sql);
                rs = stmt.executeQuery();			     
                l = new ArrayList<Classificacao>();
                while(rs.next()) {
                	Usuario u = new Usuario();
                	u.setCodigo(rs.getString("codigo"));
                	u.setNome(rs.getString("nome"));
                	u.setDepartamento(rs.getString("depto"));
                	u.setEmail(rs.getString("email"));
                	Classificacao c = new Classificacao();
                	c.setUsuario(u);
                	c.setPosicao(rs.getInt("posicao"));
                	l.add(c);
                }
        } catch(Exception e) {
            throw new RuntimeException(e);
        } finally {
        	System.out.println("ParticipanteDao.getAllParticipanteClassificacao(): executado...!");
            FactorConnection.close(conn, stmt, rs);
        } 
        return l;				
	}		

}
