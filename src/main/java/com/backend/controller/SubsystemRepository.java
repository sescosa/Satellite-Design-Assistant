package com.backend.controller;

import org.springframework.data.jpa.repository.JpaRepository;

import com.backend.model.Subsystem;

interface SubsystemRepository extends JpaRepository<Subsystem, Long> {

}