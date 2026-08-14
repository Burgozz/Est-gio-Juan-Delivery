package com.juan.api_delivery.service;

import com.juan.api_delivery.dto.UsuarioDTO;
import com.juan.api_delivery.model.Usuario;
import com.juan.api_delivery.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository repository;

    public List<Usuario> listarTodos() {
        return repository.findByAtivoTrue();
    }

    public Usuario buscarPorId(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
    }

    public Usuario criar(UsuarioDTO dto) {
        Optional<Usuario> existente = repository.findByEmail(dto.getEmail());
        if (existente.isPresent()) {
            Usuario usuario = existente.get();
            if (usuario.isAtivo()) {
                throw new IllegalArgumentException("Email já cadastrado");
            }
            usuario.setNome(dto.getNome());
            usuario.setSenha(dto.getSenha());
            usuario.setTelefone(dto.getTelefone());
            usuario.setDataCadastro(LocalDate.now());
            usuario.setAtivo(true);
            return repository.save(usuario);
        }
        Usuario usuario = Usuario.builder()
        .nome(dto.getNome())
        .email(dto.getEmail())
        .senha(dto.getSenha())
        .telefone(dto.getTelefone())
        .dataCadastro(LocalDate.now())
        .build();
    return repository.save(usuario);
    }

    public Usuario atualizar(Long id, UsuarioDTO dto) {
        Usuario usuario = buscarPorId(id);
    repository.findByEmail(dto.getEmail())
        .filter(u -> !u.getId().equals(id))
        .ifPresent(u -> { throw new IllegalArgumentException("Email já cadastrado"); });
    usuario.setNome(dto.getNome());
    usuario.setEmail(dto.getEmail());
    usuario.setSenha(dto.getSenha());
    usuario.setTelefone(dto.getTelefone());
    return repository.save(usuario);
    }

    public void deletar(Long id) {
        Usuario usuario = buscarPorId(id);
        usuario.setAtivo(false);
        repository.save(usuario);
    }
}