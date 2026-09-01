package com.juan.api_delivery.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.juan.api_delivery.dto.EnderecoDTO;
import com.juan.api_delivery.model.Endereco;
import com.juan.api_delivery.model.Usuario;
import com.juan.api_delivery.repository.EnderecoRepository;
import com.juan.api_delivery.repository.UsuarioRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class EnderecoService {

    private final EnderecoRepository repository;
    private final UsuarioRepository usuarioRepository;

    public List<Endereco> listarPorUsuario(Long usuarioId) {
        buscarUsuario(usuarioId);
        return repository.findByUsuarioId(usuarioId);
    }

    public Endereco criar(Long usuarioId, EnderecoDTO dto) {
        Usuario usuario = buscarUsuario(usuarioId);
        Endereco endereco = Endereco.builder()
            .rua(dto.getRua())
            .numero(dto.getNumero())
            .bairro(dto.getBairro())
            .cidade(dto.getCidade())
            .estado(dto.getEstado())
            .cep(dto.getCep())
            .usuario(usuario)
            .build();
        return repository.save(endereco);
    }

    public void deletar(Long id) {
        Endereco endereco = repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Endereço não encontrado"));
        repository.delete(endereco);
    }

    private Usuario buscarUsuario(Long usuarioId) {
        return usuarioRepository.findById(usuarioId)
            .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
    }
}
