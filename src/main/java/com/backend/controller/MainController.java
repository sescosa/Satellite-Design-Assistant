package com.backend.controller;

import org.springframework.core.io.InputStreamResource;
import org.springframework.data.repository.core.RepositoryMetadata;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.apache.commons.io.FilenameUtils;
import org.apache.poi.hssf.usermodel.HSSFFormulaEvaluator;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.FormulaEvaluator;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Arrays;

import com.backend.util.ExcelGenerator;
import com.backend.util.ReadPDF;

import jess.JessException;
import satModel.evaluator;

import com.backend.model.Parameter;
import com.backend.model.Message;
import com.backend.model.ParamForm;
import com.backend.model.allForms;
import com.backend.model.allReports;
import com.backend.model.excelParams;
import com.backend.model.Subsystem;
import com.backend.model.inputText;
import com.backend.model.recommendation;
import com.backend.model.subsReport;

@Controller
public class MainController {
 
	private final ParameterRepository repository;
	private final SubsystemRepository repositoryS;
	private final ExcelParamsRepository repositoryE;
	private final MessageRepository repositoryM;
	private ArrayList<ParamForm> formList = new ArrayList<ParamForm>();
	
	private int it;
	
	MainController(ParameterRepository repository,SubsystemRepository repositoryS,
			ExcelParamsRepository repositoryE, ArrayList<ParamForm> formList, 
			MessageRepository repositoryM ){
		this.repository = repository;
		this.repositoryS = repositoryS;
		this.formList = formList;
		this.repositoryE = repositoryE;
		this.repositoryM = repositoryM;

	}
	
	/*@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView init() {
		allForms wrapper = new allForms();
		wrapper.setFormList(formList);
		
		inputText input = new inputText();
		
		ModelAndView mav = new ModelAndView("home");
    	mav.addObject("wrapper",wrapper);
    	mav.addObject("input",input);
		return mav;
	}*/
	
	@RequestMapping(value = "/clear", method = RequestMethod.GET)
	public ModelAndView clearValues() {

		repository.findAll().forEach(param -> {
			param.setValue(null);
			repository.save(param);
		});
		repositoryM.deleteAll();
		ModelAndView mav = new ModelAndView("redirect:/app");
        return mav;
	}

    @RequestMapping(value = "/app", method = RequestMethod.GET)
    public ModelAndView showForm(@ModelAttribute("wrapper") allForms wrapper,
    		@ModelAttribute("input") inputText input) {
    	
    	it = 0;
    	
      	repositoryS.findAll().forEach(el -> {
    		ArrayList<Parameter> paramList = new ArrayList<Parameter>();
        	repository.findBySubsystemName(el.getSubsystemName()).forEach(param -> {
    			paramList.add(param);
    		});
        	ParamForm form = new ParamForm(paramList,el.getSubsystemName());
	    	if(formList.size() < 8) {
	    		formList.add(form);
	    	}else {
	    		formList.set((int)(el.getId() - 1), form);
	    	}
	    	it = it++;
    	});

    	ArrayList<String> messageList = new ArrayList<String>();
      	repositoryM.findAll().forEach(m ->{
      		messageList.add(m.getMessage());
      	});
      	
      	if (repositoryM.count() == 0) { 
      		messageList.add(null);
      	}

      	
    	wrapper.setFormList(formList);
    	input.setMessageList(messageList);
    	ModelAndView mav = new ModelAndView("application");
    	mav.addObject("wrapper",wrapper);
    	mav.addObject("input",input);
    	repositoryM.deleteAll();
        return mav;
    }
 
    @RequestMapping(value = "/submit", method = RequestMethod.POST)
    public ModelAndView submit(@ModelAttribute("wrapper") allForms wrapper) {
    		
    		
    		wrapper.getFormList().forEach(element -> {
        	element.getParamList().forEach(param -> {
        		repository.findById(param.getId()).map(myParameter -> {
							myParameter.setValue(param.getValue());
							return repository.save(myParameter);
							});
			});
        });
		
			
		ModelAndView mav = new ModelAndView("redirect:/app");
        return mav;
		
    }
    
    @RequestMapping(value = "/inputText", method = RequestMethod.POST)
    public ModelAndView inputText(@ModelAttribute("input") inputText input) throws IOException, InterruptedException {
    		
    	String raw_text = input.getText(); 
    	String s = null;
    	
    	repositoryM.deleteAll();
    	
    	System.out.println("Interpreting text...");
    	
    	System.setProperty("python.console.encoding", "UTF-8");

    	Process p = Runtime.getRuntime().exec("py inputText.py " + "\"" + raw_text + "\"");
    	
    	BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
		String errorMessage = "Sorry! No parameters found.";
    	Parameter myParameter = new Parameter();
    	it = 1;
    	
    	while ((s = stdInput.readLine()) != null) {

        	System.out.println(s);
    		if (! errorMessage.equals(s)) {
				if (it % 2 == 0) {
					myParameter.setValue(s);
					if (myParameter.getEntityName() != null) {
						Parameter parmeterToUpdate = repository.findOneByEntityName(myParameter.getEntityName());
		            	parmeterToUpdate.setValue(myParameter.getValue());
		            	repository.save(parmeterToUpdate);
		            	Message message = new Message("Parameter saved... " + myParameter.getEntityName() + ": " + myParameter.getValue());
		            	repositoryM.save(message);
					}
					it = it+1;
				} else if (it % 2 != 0) {
					myParameter.setEntityName(s);
					it = it+1;
				}
    		} else {
    			Message message = new Message(s);
        		repositoryM.save(message);
    		}
    		
        }
    
		ModelAndView mav = new ModelAndView("redirect:/app");
        return mav;
		
    }
    
   
    @RequestMapping(value = "/evaluate", method = RequestMethod.POST)
    public ModelAndView excelUpload(@RequestParam("subCheck") ArrayList<String> subsystemsCheck) throws IOException {
        
    	// CHECK IF SELECTION OF SUBSYSTEMS IS EMPTY
        
        if (subsystemsCheck.isEmpty()) {
        	Message message = new Message("You need to choose which subsystems you want to evalute!");
        	repositoryM.save(message);
        	ModelAndView mav = new ModelAndView("redirect:/app");
            return mav;
        	
        } else {
        	subsystemsCheck.remove(0);
        	        	
        	for (String subsystem: subsystemsCheck) {
        		            		            		
            		// FILL EXCEL FILES FOR EVALUATOR
            		
                	excelParams excelList = new excelParams();
                	excelList = repositoryE.findBySubsystemName(subsystem);
                   
                	ArrayList<Parameter> parameters = new ArrayList<Parameter>();

                    for (String s: excelList.getExcelList()) {       	            	
        	            if(repository.findOneByExcelName(s) == null) {          	
        	            		Parameter newParam = new Parameter(subsystem,s,"nil",s,null);
        	            		parameters.add(newParam);
        	            } else {
        	            	if (repository.findOneByExcelName(s).getValue().equals(null) || repository.findOneByExcelName(s).getValue() == "") {
        	            		Message message = new Message("There is a missing parameter in the " + repository.findOneByExcelName(s).getSubsystemName().toUpperCase() + " table: " + repository.findOneByExcelName(s).getEntityName());
        	                	repositoryM.save(message);
        	                	ModelAndView mav = new ModelAndView("redirect:/app");
        	                    return mav;
        	            	} else {
        	            		parameters.add(repository.findOneByExcelName(s));
        	            	}
        	            	
        	            }
                    }
                    	
                     
                	Workbook workbook = ExcelGenerator.parametersToExcel(parameters);
            		
            		String filename = "src/main/java/satModel/" + excelList.getSubsystemName() + "/xls/" + excelList.getSubsystemName() + "_AttributeSet.xls";
            		
        			//write out the XLSX
        			FileOutputStream out = null;
        			try {
        				out = new FileOutputStream(filename);
        			} catch (FileNotFoundException e) {
        				e.printStackTrace();
        			}
        			try {
        				workbook.write(out);
        				out.close();
        				System.out.println("Saving..." + filename);
        			} catch (IOException e) {
        				// TODO Auto-generated catch block
        				e.printStackTrace();
        			}

        			//save copy as XLSX ----------------END
     
            }
        	
        	// TODO EVALUATION - JESS
        	
        	evaluator evaluator = new evaluator();
        	allReports allReports = new allReports();

        	ArrayList<subsReport> reportList = new ArrayList<subsReport>();
        	
        	for (String subsystem: subsystemsCheck) {
        		
        		subsReport subsReport = new subsReport();
        		
    			// CREATE LIST OF SUBSYSTEMS THAT WILL BE REVIEWED
        		
        		System.out.println("I'm evaluating the subsystem:" + subsystem);

            	subsReport.setSubsystem(subsystem);
            	
				try {
					
					ArrayList<recommendation> recList = evaluator.evaluate(subsystem);
					
					subsReport.setRecList(recList);
					
					reportList.add(subsReport);
					
					
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		
        	}
        	
        	// CREATE REPORT VIEW
        	allReports.setSubsReport(reportList);
        	
        	ModelAndView mav = new ModelAndView("report");
        	mav.addObject("wrapper",allReports);
            return mav;
        }
        
        
	
    }
    
    @RequestMapping(value = "/import", method = RequestMethod.POST)
    public ModelAndView readFiles(@RequestParam("file") MultipartFile file) throws IOException {
    	
    	String extension = FilenameUtils.getExtension(file.getOriginalFilename());
    	
    	if (extension.equals("xls")) {
    		
    		HSSFWorkbook workbook = new HSSFWorkbook(file.getInputStream());
            HSSFSheet worksheet = workbook.getSheetAt(0);
            DataFormatter objDefaultFormat = new DataFormatter();
            FormulaEvaluator objFormulaEvaluator = new HSSFFormulaEvaluator((HSSFWorkbook) workbook);
            
            for(int i=1;i<worksheet.getPhysicalNumberOfRows() ;i++) {
               
                HSSFRow row = worksheet.getRow(i);
            
                String entityName = row.getCell(0).getStringCellValue();
                Cell cellValue = row.getCell(1);
                String value = objDefaultFormat.formatCellValue(cellValue,objFormulaEvaluator);
                value = value.toString().replace(",", ".");
                            
                if(repository.findOneByEntityName(entityName) == null) {          	
            		System.out.println("This parameter is not displayed on the web");
                }  else {
                	System.out.println("Entity: " + entityName + ", Value: " + value);
                	Parameter parmeterToUpdate = repository.findOneByEntityName(entityName);
                	parmeterToUpdate.setValue(value);
                	repository.save(parmeterToUpdate);
                }
        		
      
            }
            
            ModelAndView mav = new ModelAndView("redirect:/app");
            return mav;
            
    	} else if (extension.equals("pdf")) {
    		
    		ReadPDF readPDF = new ReadPDF();
    		String raw_text = readPDF.read(file);
    		
    		System.out.println("Text: " + raw_text);
    		String s = null;
    		repositoryM.deleteAll();
        	
        	System.out.println("Interpreting text...");
        	
        	System.setProperty("python.console.encoding", "UTF-8");

        	Process p = Runtime.getRuntime().exec("py inputText.py " + "\"" + raw_text + "\"");
        	
        	BufferedReader stdInput = new BufferedReader(new InputStreamReader(p.getInputStream()));
    		String errorMessage = "Sorry! No parameters found.";
        	Parameter myParameter = new Parameter();
        	it = 1;
        	
        	while ((s = stdInput.readLine()) != null) {

            	System.out.println(s);
        		if (! errorMessage.equals(s)) {
    				if (it % 2 == 0) {
    					myParameter.setValue(s);
    					if (myParameter.getEntityName() != null) {
    						Parameter parmeterToUpdate = repository.findOneByEntityName(myParameter.getEntityName());
    		            	parmeterToUpdate.setValue(myParameter.getValue());
    		            	repository.save(parmeterToUpdate);
    		            	Message message = new Message("Parameter saved... " + myParameter.getEntityName() + ": " + myParameter.getValue());
    		            	repositoryM.save(message);
    					}
    					it = it+1;
    				} else if (it % 2 != 0) {
    					myParameter.setEntityName(s);
    					it = it+1;
    				}
        		} else {
        			Message message = new Message(s);
            		repositoryM.save(message);
        		}
        		
            }
        
    		ModelAndView mav = new ModelAndView("redirect:/app");
            return mav;
            
    	} else {

    		Message message = new Message("This file extension is not available as an input.");
        	repositoryM.save(message);
    		
    		ModelAndView mav = new ModelAndView("redirect:/app");
            return mav;
    	}
    	
        
    }
    
    @RequestMapping(value = "/downloadFile", method = RequestMethod.GET)
    public ResponseEntity<InputStreamResource> downloadFile() throws FileNotFoundException {
        
    	// Load file as Resource
    	File file = new File("download/template_AttributeSet.xls");
        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
        
        return ResponseEntity.ok()
                // Content-Disposition
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + file.getName())
                // Content-Length
                .contentLength(file.length()) //
                .body(resource);
    }
}