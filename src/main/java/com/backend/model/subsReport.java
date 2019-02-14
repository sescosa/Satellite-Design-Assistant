package com.backend.model;

import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class subsReport {
	private @Id @GeneratedValue Long id;
	private ArrayList<recommendation> recList;
	private String subsystem;
	
	public subsReport(){
		
	}
	
	public subsReport(String subsystem, ArrayList<recommendation> recList){
		this.subsystem = subsystem;
		this.recList = recList;
	}
}