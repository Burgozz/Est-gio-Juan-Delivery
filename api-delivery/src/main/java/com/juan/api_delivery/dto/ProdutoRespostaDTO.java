package com.juan.api_delivery.dto;

import java.math.BigDecimal;

import com.juan.api_delivery.model.Acessorio;
import com.juan.api_delivery.model.CategoriaProduto;
import com.juan.api_delivery.model.Produto;
import com.juan.api_delivery.model.TipoProduto;
import com.juan.api_delivery.model.Vinho;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO de resposta para consulta do catálogo. Sempre representa um produto
 * ativo (produtos com ativo = false nunca devem ser mapeados para este DTO).
 * Os campos específicos de subtipo que não se aplicam ao {@link #tipo} do
 * produto vêm sempre como null.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProdutoRespostaDTO {
    private Long id;
    private String nome;
    private String descricao;
    private BigDecimal preco;
    private Integer estoque;
    private TipoProduto tipo;

    // Campos específicos de Vinho (null quando tipo != VINHO)
    private CategoriaProduto categoria;
    private Integer safra;
    private Double teorAlcool;
    private String harmonizacao;

    // Campos específicos de Acessorio (null quando tipo != ACESSORIO)
    private String tipoAcessorio;
    private String marca;
    private String material;

    public static ProdutoRespostaDTO from(Produto produto) {
        ProdutoRespostaDTO dto = new ProdutoRespostaDTO();
        dto.setId(produto.getId());
        dto.setNome(produto.getNome());
        dto.setDescricao(produto.getDescricao());
        dto.setPreco(produto.getPreco());
        dto.setEstoque(produto.getEstoque());

        if (produto instanceof Vinho vinho) {
            dto.setTipo(TipoProduto.VINHO);
            dto.setCategoria(vinho.getCategoria());
            dto.setSafra(vinho.getSafra());
            dto.setTeorAlcool(vinho.getTeorAlcool());
            dto.setHarmonizacao(vinho.getHarmonizacao());
        } else if (produto instanceof Acessorio acessorio) {
            dto.setTipo(TipoProduto.ACESSORIO);
            dto.setTipoAcessorio(acessorio.getTipoAcessorio());
            dto.setMarca(acessorio.getMarca());
            dto.setMaterial(acessorio.getMaterial());
        }

        return dto;
    }
}
