package com.juan.api_delivery.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import java.time.LocalDate;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDTO {
    @NotBlank
    @Pattern(
        regexp = "^[\\p{L} ]+$",
        message = "Nome deve conter apenas letras"
    )
    private String nome;

    @NotBlank
    @Size(min = 11, max = 11, message = "CPF deve conter exatamente 11 dígitos")
    @Pattern(
        regexp = "^\\d{11}$",
        message = "CPF deve conter apenas números"
    )
    private String cpf;

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