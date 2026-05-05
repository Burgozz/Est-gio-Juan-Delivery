package com.juan.api_delivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.juan.api_delivery.model.Produto;

@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long> {
}