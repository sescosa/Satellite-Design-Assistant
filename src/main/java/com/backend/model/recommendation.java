package com.backend.model;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Data
@Entity
public class recommendation {
	
	private @Id @GeneratedValue Long id;
	private String subsystemName;
	private String explanation;
	private String descriptor;
	
	public recommendation(){
		
	}
	
	public recommendation(String subsystemName, String explanation, String descriptor){
		this.subsystemName = subsystemName;
		this.explanation = explanation;
		this.descriptor = descriptor;
	}


}
