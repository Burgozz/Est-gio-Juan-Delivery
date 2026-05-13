package com.juan.api_delivery.dto;

import java.math.BigDecimal;

import com.juan.api_delivery.model.CategoriaProduto;

import jakarta.validation.constraints.DecimalMin;
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
    private CategoriaProduto categoria;
    private String paisOrigem;
    private Integer safra;
    private Integer estoque;
}