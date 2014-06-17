package br.com.tdv.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class FactorConnection {

	private static String url;
	private static String user;
	private static String password;
	
	public static Connection getConnection() {
		Connection conn = null;		
        //FactorConnection.url = "jdbc:oracle:thin:@192.9.200.15:1521/tdp"; // TDX
		FactorConnection.url = "jdbc:oracle:thin:@192.9.200.101:1526/tdp"; // TDP
		//FactorConnection.url = "jdbc:oracle:thin:@201.63.16.210:1521/tdp";
		FactorConnection.user = "tdvadm";
		FactorConnection.password = "aged12";		
//		FactorConnection.url = "jdbc:mysql://mysql.asisco.com.br/asisco";
//		FactorConnection.user = "asisco";
//		FactorConnection.password = "123456";		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
//			Class.forName("com.mysql.jdbc.Driver");			
			conn = DriverManager.getConnection(FactorConnection.url, FactorConnection.user, FactorConnection.password);
			System.out.println("Conectado com sucesso...!");
		} catch (SQLException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			throw new RuntimeException(e);
		} 
		return conn; 
	}
	
	public static void close(Connection conn) {
		if(conn != null) {
			try {
				conn.close();
                                System.out.println("Conexão Fechada...!");
			} catch (Exception e) {
				throw new RuntimeException(e); 
			}
		}
	}
	
	public static void close(Connection conn, Statement stmt) {
		if (conn != null) {
			FactorConnection.close(conn);
		}		
		if(stmt != null) {
			try {
				stmt.close();
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}	
	}
	
	public static void close(Connection conn, Statement stmt, ResultSet rs) {
		if (conn != null || stmt != null) {
			FactorConnection.close(conn, stmt);
		}		
		if (rs != null) {
			try {
				rs.close();
			} catch (Exception e) {
				throw new RuntimeException(e);
			}
		}
	}
	
	public static void main(String[] args) {
		try {
			Connection conn = FactorConnection.getConnection();
			Statement stmt = conn.createStatement();
			ResultSet rs = stmt.executeQuery("SELECT * FROM T_CPM_CLASS");
			//ResultSet rs = stmt.executeQuery("Show tables");			
			while(rs.next()) {
				System.out.println(rs.getString(2));
			}			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
