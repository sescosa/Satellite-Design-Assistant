package com.backend.util;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;
import org.apache.pdfbox.text.PDFTextStripperByArea;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;

public class ReadPDF {

    public String read(MultipartFile multifile) throws IOException {
    	
	    	File convFile = new File( multifile.getOriginalFilename());
	    	multifile.transferTo(convFile);
	        
        	PDDocument document = PDDocument.load(convFile);
            document.getClass();
		
            PDFTextStripperByArea stripper = new PDFTextStripperByArea();
            stripper.setSortByPosition(true);

            PDFTextStripper tStripper = new PDFTextStripper();

            String pdfFileInText = tStripper.getText(document);
            
            return pdfFileInText;

    }
}