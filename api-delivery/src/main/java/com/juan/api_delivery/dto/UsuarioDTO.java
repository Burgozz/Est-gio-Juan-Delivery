package com.juan.api_delivery.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
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

    private String telefone;

    private LocalDate dataCadastro;


}