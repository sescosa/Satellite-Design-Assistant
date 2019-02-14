package com.backend.util;
 

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
 
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;

import org.apache.poi.ss.usermodel.Font;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
 
import com.backend.model.Parameter;
 
public class ExcelGenerator {
	
	public static Workbook parametersToExcel(ArrayList<Parameter> parameters){
		
		String[] COLUMNs = {"Entity Name", "Value"};
		
		Workbook workbook = new HSSFWorkbook();

		Sheet sheet = workbook.createSheet("Subsystem Parameters");
 
		Font headerFont = workbook.createFont();
 
		CellStyle headerCellStyle = workbook.createCellStyle();
		headerCellStyle.setFont(headerFont);
 
		// Row for Header
		Row headerRow = sheet.createRow(0);
 
		// Header
		for (int col = 0; col < COLUMNs.length; col++) {
			Cell cell = headerRow.createCell(col);
			cell.setCellValue(COLUMNs[col]);
			cell.setCellStyle(headerCellStyle);
		}
 
		int rowIdx = 1;
		for (Parameter parameter : parameters) {
			Row row = sheet.createRow(rowIdx++);
 
			row.createCell(0).setCellValue(parameter.getExcelName());
			if (parameter.getValue() == null) {
				row.createCell(1).setCellValue("nil");
			}else {
				row.createCell(1).setCellValue(parameter.getValue());
			}
		}
 
		return workbook;

	}
}