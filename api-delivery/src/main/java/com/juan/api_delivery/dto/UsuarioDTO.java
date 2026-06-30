package com.juan.api_delivery.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import java.time.LocalDate;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDTO {
    @NotBlank
    private String nome;

    @Email
    private String email;

    @NotBlank
    private String senha;

    @Pattern(
        regexp = "^[1-9]\\d{9,10}$",
        message = "Telefone inválido. Informe apenas números com DDD (10 ou 11 dígitos)"
    )
    private String telefone;

    private LocalDate dataCadastro;


}