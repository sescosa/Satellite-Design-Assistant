package com.backend.model;

import lombok.Data;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Data
@Entity
public class Parameter {
	
	private @Id @GeneratedValue Long id;
	private String subsystemName;
	private String entityName;
	private String excelName;
	private String unit;
	private String value;
	
	public Parameter(){
		
	}
	
	public Parameter(String subsystemName, String entityName, String value, String excelName, String unit){
		this.subsystemName = subsystemName;
		this.entityName = entityName;
		this.value = value;
		this.excelName = excelName;
		this.unit = unit;
	}


}
