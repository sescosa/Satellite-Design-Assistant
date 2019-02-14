package com.backend.controller;

import org.springframework.data.jpa.repository.JpaRepository;

import com.backend.model.Parameter;
import java.util.List;

interface ParameterRepository extends JpaRepository<Parameter, Long> {
	List<Parameter> findBySubsystemName(String subsystemName);
	Parameter findOneByEntityName(String entityName);
	Parameter findOneByExcelName(String excelName);
	
}