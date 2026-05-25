package com.juan.api_delivery.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Table(name = "produtos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank
    private String nome;

    @NotNull
    @DecimalMin("0.0")
    private BigDecimal preco;

    private String descricao;

    @Enumerated(EnumType.STRING)
    private CategoriaProduto categoria;

    private String paisOrigem;

    private Integer safra;

    @Min(0)
    private Integer estoque;

    @Builder.Default
    @Column(nullable = false, columnDefinition = "boolean default true")
    private boolean ativo = true;
}