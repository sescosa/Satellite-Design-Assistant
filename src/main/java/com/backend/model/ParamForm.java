package com.backend.model;

import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import com.backend.model.Parameter;

import lombok.Data;

@Data
@Entity
public class ParamForm {
    private ArrayList<Parameter> paramList;
    private String subsystemName;
	private @Id @GeneratedValue Long id;
	
	public ParamForm(){
		
	}
	
	public ParamForm(ArrayList<Parameter> paramList,String subsystemName){
		this.paramList = paramList;
		this.subsystemName = subsystemName;
	}
}