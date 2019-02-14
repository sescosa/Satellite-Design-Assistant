package com.backend.model;

import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class inputText {
    private String text;
	private @Id @GeneratedValue Long id;
	private ArrayList<String> messageList;
	
	public inputText(){
		
	}
	
	public inputText(String text, ArrayList<String> messageList){
		this.text = text;
		this.messageList = messageList;
	}
}