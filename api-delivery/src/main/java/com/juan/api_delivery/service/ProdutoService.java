package com.juan.api_delivery.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.juan.api_delivery.dto.ProdutoDTO;
import com.juan.api_delivery.model.Produto;
import com.juan.api_delivery.repository.ProdutoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ProdutoService {

    private final ProdutoRepository repository;

    public List<Produto> listarTodos() {
        return repository.findByAtivoTrue();
    }

    public Produto buscarPorId(Long id) {
        return repository.findById(id)
            .orElseThrow(() -> new RuntimeException("Produto não encontrado"));
    }

    public Produto criar(ProdutoDTO dto) {
        if (dto.getEstoque() == null || dto.getEstoque() <= 0) {
            throw new IllegalArgumentException("Estoque inicial deve ser maior que zero para criar um produto");
        }
        Produto produto = Produto.builder()
            .nome(dto.getNome())
            .preco(dto.getPreco())
            .descricao(dto.getDescricao())
            .categoria(dto.getCategoria())
            .paisOrigem(dto.getPaisOrigem())
            .safra(dto.getSafra())
            .estoque(dto.getEstoque())
            .build();
        return repository.save(produto);
    }

    public Produto atualizar(Long id, ProdutoDTO dto) {
        Produto produto = buscarPorId(id);
        produto.setNome(dto.getNome());
        produto.setPreco(dto.getPreco());
        produto.setDescricao(dto.getDescricao());
        produto.setCategoria(dto.getCategoria());
        produto.setPaisOrigem(dto.getPaisOrigem());
        produto.setSafra(dto.getSafra());
        produto.setEstoque(dto.getEstoque());
        return repository.save(produto);
    }

    public void deletar(Long id) {
        Produto produto = buscarPorId(id);
        produto.setAtivo(false);
        repository.save(produto);
    }
}