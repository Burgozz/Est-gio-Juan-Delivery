package com.juan.api_delivery.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.juan.api_delivery.dto.ItemPedidoDTO;
import com.juan.api_delivery.model.ItemPedido;
import com.juan.api_delivery.model.Pedido;
import com.juan.api_delivery.model.Produto;
import com.juan.api_delivery.repository.ItemPedidoRepository;
import com.juan.api_delivery.repository.PedidoRepository;
import com.juan.api_delivery.repository.ProdutoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ItemPedidoService {

    private final ItemPedidoRepository repository;
    private final PedidoRepository pedidoRepository;
    private final ProdutoRepository produtoRepository;

    public List<ItemPedido> listarPorPedido(Long pedidoId) {
        return repository.findByPedidoId(pedidoId);
    }

    public ItemPedido adicionar(Long pedidoId, ItemPedidoDTO dto) {
        Pedido pedido = pedidoRepository.findById(pedidoId)
            .orElseThrow(() -> new IllegalArgumentException("Pedido não encontrado"));
        Produto produto = produtoRepository.findById(dto.getProdutoId())
            .orElseThrow(() -> new IllegalArgumentException("Produto não encontrado"));
        ItemPedido item = ItemPedido.builder()
            .pedido(pedido)
            .produto(produto)
            .quantidade(dto.getQuantidade())
            .precoUnit(produto.getPreco())
            .build();
        return repository.save(item);
    }

    public void remover(Long id) {
        ItemPedido item = repository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Item de pedido não encontrado"));
        repository.delete(item);
    }
}
