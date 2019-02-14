package com.backend.model;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Data
@Entity
public class Message {
	
	private @Id @GeneratedValue Long id;
	private String message;
	
	public Message(){
		
	}
	
	public Message(String message){
		this.message = message;
	}

}
