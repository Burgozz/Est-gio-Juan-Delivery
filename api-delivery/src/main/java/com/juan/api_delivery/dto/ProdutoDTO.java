package com.juan.api_delivery.dto;

import java.math.BigDecimal;

import com.juan.api_delivery.model.CategoriaProduto;
import com.juan.api_delivery.model.TipoProduto;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProdutoDTO {
    @NotBlank
    private String nome;
    @NotNull
    @DecimalMin("0.0")
    private BigDecimal preco;
    private String descricao;
    @NotNull(message = "Informe o tipo do produto (VINHO ou ACESSORIO)")
    private TipoProduto tipo;

    // Campos específicos de Vinho
    private CategoriaProduto categoria;
    private String paisOrigem;
    @Min(value = 1900, message = "Safra deve ser a partir de 1900")
    @Max(value = 2026, message = "Safra não pode ser maior que o ano atual")
    private Integer safra;
    private Double teorAlcool;
    private String harmonizacao;

    // Campos específicos de Acessorio
    private String tipoAcessorio;
    private String marca;
    private String material;

    @NotNull(message = "Informe o estoque")
    @Min(value = 0, message = "Estoque não pode ser negativo")
    private Integer estoque;

    // safra e teorAlcool são campos wrapper aqui (compartilhados com o DTO de
    // Acessorio, que nunca os envia), mas na entidade Vinho viraram tipos
    // primitivos. Exigi-los apenas quando tipo == VINHO evita tanto o
    // NullPointerException no unboxing quanto a quebra da criação/atualização
    // de Acessorio.
    @AssertTrue(message = "Safra é obrigatória para vinhos")
    public boolean isSafraValida() {
        return tipo != TipoProduto.VINHO || safra != null;
    }

    @AssertTrue(message = "Teor alcoólico é obrigatório para vinhos")
    public boolean isTeorAlcoolValido() {
        return tipo != TipoProduto.VINHO || teorAlcool != null;
    }
}