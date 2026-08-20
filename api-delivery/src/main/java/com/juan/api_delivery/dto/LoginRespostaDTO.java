package com.juan.api_delivery.dto;

import com.juan.api_delivery.model.Usuario;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de resposta do login. Nunca expõe a senha do usuário.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LoginRespostaDTO {
    private Long id;
    private String nome;
    private String email;

    public static LoginRespostaDTO from(Usuario usuario) {
        return new LoginRespostaDTO(usuario.getId(), usuario.getNome(), usuario.getEmail());
    }
}
