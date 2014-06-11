package br.com.tdv.model;

public class Usuario {
    
    private String codigo;
    private String nome;
    private String departamento;
    private String email;
    
    public Usuario() { }
    
    public Usuario(String codigo) {
    	this();
    	this.codigo = codigo;
    }
    
    public Usuario(String codigo, String nome, String departamento) {
    	this(codigo);
    	this.nome = nome;
    	this.departamento = departamento;
    }    

    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getDepartamento() {
        return departamento;
    }

    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
    
    
}
