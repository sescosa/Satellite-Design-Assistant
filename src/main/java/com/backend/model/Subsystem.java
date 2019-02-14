package com.backend.model;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;


@Data
@Entity
public class Subsystem {
	
	private @Id @GeneratedValue Long id;
	private String subsystemName;
	
	public Subsystem(){
		
	}
	
	public Subsystem(String subsystemName){
		this.subsystemName = subsystemName;
	}
}