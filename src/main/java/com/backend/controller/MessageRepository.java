package com.backend.controller;

import org.springframework.data.jpa.repository.JpaRepository;

import com.backend.model.Message;

interface MessageRepository extends JpaRepository<Message, Long> {
	
}