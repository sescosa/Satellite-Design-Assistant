package com.backend.model;

import java.util.ArrayList;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

import com.backend.model.Parameter;

import lombok.Data;

@Data
@Entity
public class allReports {
    private ArrayList<subsReport> subsReport;
	private @Id @GeneratedValue Long id;
	
	public allReports(){
		
	}
	
	public allReports(ArrayList<subsReport> subsReport){
		this.subsReport = subsReport;
	}
}