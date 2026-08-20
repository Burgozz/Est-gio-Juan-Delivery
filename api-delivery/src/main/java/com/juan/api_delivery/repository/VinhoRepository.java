package com.juan.api_delivery.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.juan.api_delivery.model.Vinho;

@Repository
public interface VinhoRepository extends JpaRepository<Vinho, Long> {
}
