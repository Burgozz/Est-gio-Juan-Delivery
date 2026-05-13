package com.juan.api_delivery.dto;

import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import java.time.LocalDate;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioDTO {
    private String nome;

    @Email
    private String email;

    private String senha;

    private String telefone;

    private LocalDate dataCadastro;


}