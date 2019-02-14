package com.backend.controller;


import org.springframework.data.jpa.repository.JpaRepository;

import com.backend.model.excelParams;

interface ExcelParamsRepository extends JpaRepository<excelParams, Long> {
	excelParams findBySubsystemName(String subsystemName);
}