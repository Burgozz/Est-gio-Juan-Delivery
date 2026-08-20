package com.juan.api_delivery.model;

import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;

@Entity
@DiscriminatorValue("VINHO")
@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class Vinho extends Produto {

    @Enumerated(EnumType.STRING)
    private CategoriaProduto categoria;

    private String paisOrigem;

    private int safra;

    private Double teorAlcool;

    private String harmonizacao;
}
