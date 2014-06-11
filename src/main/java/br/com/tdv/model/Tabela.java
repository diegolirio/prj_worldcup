package br.com.tdv.model;

import java.util.Calendar;

public class Tabela {
    
    private int codigo;
    private Calendar data;
    private String timeA;
    private String timeB;
    private int resultadoA;
    private int resultadoB;
    private String ganhador;
    
    public Tabela() {}
    
    public Tabela(int codigo) {
    	this.codigo = codigo;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public Calendar getData() {
        return data;
    }

    public void setData(Calendar data) {
        this.data = data;
    }

    public String getTimeA() {
        return timeA;
    }

    public void setTimeA(String timeA) {
        this.timeA = timeA;
    }

    public String getTimeB() {
        return timeB;
    }

    public void setTimeB(String timeB) {
        this.timeB = timeB;
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
    
    
    
}
