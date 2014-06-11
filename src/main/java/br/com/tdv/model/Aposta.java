package br.com.tdv.model;

public class Aposta {
    
    private Tabela tabela;
    private Usuario usuario;
    private int resultadoA;
    private int resultadoB;
    private String ganhador;
    private int pontos;
    
    public Aposta() {
        this.usuario = new Usuario();
        this.tabela = new Tabela();
    }

    public Tabela getTabela() {
        return tabela;
    }

    public void setTabela(Tabela tabela) {
        this.tabela = tabela;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public int getResultadoA() {
        return resultadoA;
    }

    public void setResultadoA(int resultadoA) {
        this.resultadoA = resultadoA;
    }

    public int getResultadoB() {
        return resultadoB;
    }

    public void setResultadoB(int resultadoB) {
        this.resultadoB = resultadoB;
    }

    public String getGanhador() {
        return ganhador;
    }

    public void setGanhador(String ganhador) {
        this.ganhador = ganhador;
    }

    public int getPontos() {
        return pontos;
    }

    public void setPontos(int pontos) {
        this.pontos = pontos;
    }

    
}
