package com.juan.api_delivery.controller;

import com.juan.api_delivery.dto.LoginDTO;
import com.juan.api_delivery.dto.LoginRespostaDTO;
import com.juan.api_delivery.model.Usuario;
import com.juan.api_delivery.service.UsuarioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioService service;

    @PostMapping("/login")
    public ResponseEntity<LoginRespostaDTO> login(@RequestBody @Valid LoginDTO dto) {
        Usuario usuario = service.login(dto.getEmail(), dto.getSenha());
        return ResponseEntity.ok(LoginRespostaDTO.from(usuario));
    }
}
