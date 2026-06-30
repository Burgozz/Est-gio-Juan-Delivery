package com.juan.api_delivery.dto;

import java.math.BigDecimal;

import com.juan.api_delivery.model.CategoriaProduto;

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
    private CategoriaProduto categoria;
    private String paisOrigem;
    @Min(value = 1900, message = "Safra deve ser a partir de 1900")
    @Max(value = 2026, message = "Safra não pode ser maior que o ano atual")
    private Integer safra;
    @NotNull(message = "Informe o estoque")
    @Min(value = 0, message = "Estoque não pode ser negativo")
    private Integer estoque;
}