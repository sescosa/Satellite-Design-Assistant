package satModel;


import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.*;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class ReadExcel 
{

    private String inputFile;
    String[][] data = null;
    HashMap<String, Integer> keyVariables= null;
    String[] keys = null;
    String[] values = null;

    public void setInputFile(String inputFile) 
    {
        this.inputFile = inputFile;
    }

    public String[][] read() throws FileNotFoundException
    {
        File inputWorkbook = new File(inputFile);
        Workbook w;

        try 
        {
            w = Workbook.getWorkbook(inputWorkbook);
            // Get the first sheet


            Sheet sheet = w.getSheet(0);
            data = new String[sheet.getRows()-1][sheet.getColumns()];
            keyVariables = new HashMap<String, Integer>();
            // Loop over first 10 column and lines
            //System.out.println(sheet.getColumns() +  " " +sheet.getRows());
            for (int j = 0; j <sheet.getColumns(); j++) 
            {
                for (int i = 1; i < sheet.getRows(); i++) 
                {
                    Cell cell = sheet.getCell(j,i);
                    data[i-1][j] = cell.getContents();
                    if (j == 0) {
                       keyVariables.put(cell.getContents(),i); 
                    }
                  //System.out.println(cell.getContents());
                }
            }

        } 
        catch (BiffException e) 
        {
            e.printStackTrace();
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }

    return data;
    }

    public String[] getVars (){

        File inputWorkbook = new File(inputFile);
        Workbook w;

        try 
        {
            w = Workbook.getWorkbook(inputWorkbook);
            // Get the first sheet
            
            Sheet sheet = w.getSheet(0);
            keys = new String[sheet.getColumns()-1];
            keys = keyVariables.keySet().toArray(new String[keyVariables.size()]);
        } 
        catch (BiffException e) 
        {
            e.printStackTrace();
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }

        return keys;
    }

    public String[] getValues (String param){


        File inputWorkbook = new File(inputFile);
        Workbook w;
        int row;

        try 
        {
            w = Workbook.getWorkbook(inputWorkbook);
            // Get the first sheet


            Sheet sheet = w.getSheet(0);
            values = new String[sheet.getColumns()-1];
            row = keyVariables.get(param);
            // Loop over first 10 column and lines
            //System.out.println(sheet.getColumns() +  " " +sheet.getRows());
            for (int j = 1; j <sheet.getColumns(); j++) 
            {
                    Cell cell = sheet.getCell(j,row);
                    values[j-1] = cell.getContents();
                  //System.out.println(cell.getContents());
            }

        } 
        catch (BiffException e) 
        {
            e.printStackTrace();
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }

        return values;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ReadExcel readTest = new ReadExcel();
        readTest.setInputFile("C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\EPS\\xls\\EPS_AttributeSet.xls");
        readTest.read();
        readTest.getValues("orbit-type");
        System.out.println(Arrays.deepToString(readTest.data));
        System.out.println(Arrays.toString(readTest.values));
        System.out.println(readTest.keyVariables.keySet());
        /*for (String param: readTest.keyVariables.keySet()){

            String key =param.toString();
            String value = readTest.keyVariables.get(param).toString();  
            System.out.println(key + " " + value);  
        }*/

    } 
}


