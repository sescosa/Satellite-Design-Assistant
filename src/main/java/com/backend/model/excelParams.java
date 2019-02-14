package com.backend.model;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class excelParams {
	
	private @Id @GeneratedValue Long id;
	
	@Column( length = 500 )
    private String[] excelList;
	
	private String subsystemName;

	public excelParams(){
		
	}
	
	public excelParams(String[] excelList, String subsystemName){
		this.excelList = excelList;
		this.subsystemName = subsystemName;
	}
}