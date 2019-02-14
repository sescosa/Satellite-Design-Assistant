package com.backend.model;

import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import com.backend.model.Parameter;

import lombok.Data;

@Data
@Entity
public class allForms {
    private ArrayList<ParamForm> formList;
	private @Id @GeneratedValue Long id;
	
	public allForms(){
		
	}
	
	public allForms(ArrayList<ParamForm> formList){
		this.formList = formList;
	}
}