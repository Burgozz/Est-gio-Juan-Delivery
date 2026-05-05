package com.juan.api_delivery.dto;

import java.math.BigDecimal;

import com.juan.api_delivery.model.CategoriaProduto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProdutoDTO {
    private String nome;
    private BigDecimal preco;
    private String descricao;
    private CategoriaProduto categoria;
    private String paisOrigem;
    private Integer safra;
    private Integer estoque;
}