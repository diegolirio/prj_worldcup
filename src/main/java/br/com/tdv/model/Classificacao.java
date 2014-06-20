package br.com.tdv.model;

public class Classificacao {
    
    private int posicao;
    private Usuario usuario;
    private int pontos;
    private float percent;
    private String observacao;
    private int acertoPlacar;
    private int acertoGanhador;
    private int erroZero;
    private int posicaoAnterior;
    
    public int getAcertoPlacar() {
		return acertoPlacar;
	}

	public void setAcertoPlacar(int acertoPlacar) {
		this.acertoPlacar = acertoPlacar;
	}

	public int getAcertoGanhador() {
		return acertoGanhador;
	}

	public void setAcertoGanhador(int acertoGanhador) {
		this.acertoGanhador = acertoGanhador;
	}

	public int getErroZero() {
		return erroZero;
	}

	public void setErroZero(int erroZero) {
		this.erroZero = erroZero;
	}

	public Classificacao() {
        this.usuario  = new Usuario();
    }

    public int getPosicao() {
        return posicao;
    }

    public void setPosicao(int posicao) {
        this.posicao = posicao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public int getPontos() {
        return pontos;
    }

    public void setPontos(int pontos) {
        this.pontos = pontos;
    }
    
	public float getPercent() {
		return percent;
	}

	public void setPercent(float percent) {
		this.percent = percent;
	}

	public String getObservacao() {
		return observacao;
	}

	public void setObservacao(String observacao) {
		this.observacao = observacao;
	}

	public int getPosicaoAnterior() {
		return posicaoAnterior;
	}

	public void setPosicaoAnterior(int posicaoAnterior) {
		this.posicaoAnterior = posicaoAnterior;
	}
    
    
    
    
}
