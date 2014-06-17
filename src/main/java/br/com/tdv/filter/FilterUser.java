/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package br.com.tdv.filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.HashMap;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;

import br.com.tdv.dao.ApostaDao;
import br.com.tdv.dao.ClassificacaoDao;
import br.com.tdv.model.Aposta;
import br.com.tdv.model.Classificacao;
import br.com.tdv.model.Usuario;

/**
 *
 * @author asisco
 */
@WebFilter(filterName = "FilterUser", urlPatterns = {"*"})
public class FilterUser implements Filter {
     
    private static final boolean debug = true;
    // The filter configuration object we are associated with.  If
    // this value is null, this filter instance is not currently
    // configured. 
    private FilterConfig filterConfig = null;
    
    private DataSource dataSource;
    public FilterUser() {
		InitialContext initCtx;		
		DataSource dataSource = null;
		try {
			initCtx = new InitialContext();
			this.dataSource = (DataSource) initCtx.lookup( "java:/comp/env/jdbc/tdv_pool" );
			
			System.out.println("----------------------------------------------------------------------------------------");
			System.out.println("FilterUser.contructor() - datasource = "+dataSource);
			System.out.println("----------------------------------------------------------------------------------------");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
    }    
    
    @Autowired
	private void doBeforeProcessing(ServletRequest request, ServletResponse response) throws IOException, ServletException {
        if (debug) {
            log("FilterLogin:DoBeforeProcessing");
        }
    }    
    
    @Autowired
    private void doAfterProcessing(ServletRequest request, ServletResponse response)
            throws IOException, ServletException {
        if (debug) {
            log("FilterLogin:DoAfterProcessing");
        }
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;  
        Classificacao classificacao = (Classificacao) req.getSession().getAttribute("classificacao");
        //System.out.println("URI: " + req.getRequestURI());         
        if ((classificacao == null && req.getParameter("usuario_codigo") != null) || "S".equals(req.getParameter("troca"))) {   
        	// buscar Classificacao
        	Usuario u = new Usuario(req.getParameter("usuario_codigo"));
        	classificacao = new ClassificacaoDao(this.dataSource).getClassificacao(u);
        	HashMap<String, Aposta> map = new ApostaDao(this.dataSource).getApostaAnteriorProximoJogo(u);
        	req.getSession().setAttribute("classificacao_u", classificacao);
        	req.getSession().setAttribute("aposta_proximo_jogo", map.get("proximo"));
        	req.getSession().setAttribute("aposta_anterior_jogo", map.get("anterior"));
        } else if ("S".equals(req.getParameter("logout"))) {
        	req.getSession().invalidate();
        }
        //req.setAttribute("classificacao_u", classificacao);        
        chain.doFilter(request, response);
    }
    	
    /**
     * Return the filter configuration object for this filter.
     */
    public FilterConfig getFilterConfig() {
        return (this.filterConfig);
    }

    /**
     * Set the filter configuration object for this filter.
     *
     * @param filterConfig The filter configuration object
     */
    public void setFilterConfig(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
    }

    /**
     * Destroy method for this filter
     */
    public void destroy() {        
    }

    /**
     * Init method for this filter
     */
    public void init(FilterConfig filterConfig) {        
        this.filterConfig = filterConfig;
        if (filterConfig != null) {
            if (debug) {                
                log("FilterLogin:Initializing filter");
            }
        }
    }

    /**
     * Return a String representation of this object.
     */
    @Override
    public String toString() {
        if (filterConfig == null) {
            return ("FilterLogin()");
        }
        StringBuffer sb = new StringBuffer("FilterLogin(");
        sb.append(filterConfig);
        sb.append(")");
        return (sb.toString());
    }
    
    @Autowired
    private void sendProcessingError(Throwable t, ServletResponse response) {
        String stackTrace = getStackTrace(t);        
        
        if (stackTrace != null && !stackTrace.equals("")) {
            try {
                response.setContentType("text/html");
                PrintStream ps = new PrintStream(response.getOutputStream());
                PrintWriter pw = new PrintWriter(ps);                
                pw.print("<html>\n<head>\n<title>Error</title>\n</head>\n<body>\n"); //NOI18N

                // PENDING! Localize this for next official release
                pw.print("<h1>The resource did not process correctly</h1>\n<pre>\n");                
                pw.print(stackTrace);                
                pw.print("</pre></body>\n</html>"); //NOI18N
                pw.close();
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        } else {
            try {
                PrintStream ps = new PrintStream(response.getOutputStream());
                t.printStackTrace(ps);
                ps.close();
                response.getOutputStream().close();
            } catch (Exception ex) {
            }
        }
    }
    
    public static String getStackTrace(Throwable t) {
        String stackTrace = null;
        try {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            pw.close();
            sw.close();
            stackTrace = sw.getBuffer().toString();
        } catch (Exception ex) {
        }
        return stackTrace;
    }
    
    public void log(String msg) {
        filterConfig.getServletContext().log(msg);        
    }
}
