package satModel;


import java.io.File;
import java.io.IOException;
import java.util.*;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class ReadExcelLaunch 
{

    private String inputFile;
    String[][] data = null;
    HashMap<String, Integer> keyVariables= null;
    HashMap<String, Integer> keyOrbits= null;
    String[] keys = null;
    String[] values = null;
    String[] value = null;

    public void setInputFile(String inputFile) 
    {
        this.inputFile = inputFile;
    }

    public String[][] read() 
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
            keyOrbits = new HashMap<String, Integer>();
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
            int i = 0;
            for (int j=0; j < sheet.getColumns(); j++)
            {
                Cell cell = sheet.getCell(j,i);
                keyOrbits.put(cell.getContents(),j);
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

        // Gets the first column (except first row) containing list of ID
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

    public String[] getOrbits (){

        // Gets the first row (except first column) containing list of possible orbits
        //Only used in LAUNCH module
        File inputWorkbook = new File(inputFile);
        Workbook w;

        try 
        {
            w = Workbook.getWorkbook(inputWorkbook);
            // Get the first sheet
            
            Sheet sheet = w.getSheet(0);
            keys = new String[sheet.getColumns()-1];
            keys = keyOrbits.keySet().toArray(new String[keyOrbits.size()]);
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

        public String[] getPerformance (String launcher, String orbit){


        File inputWorkbook = new File(inputFile);
        Workbook w;
        int row;
        int column;

        try 
        {
            w = Workbook.getWorkbook(inputWorkbook);
            // Get the first sheet


            Sheet sheet = w.getSheet(0);
            value = new String[1];
            row = keyVariables.get(launcher);
            column = keyOrbits.get(orbit);
            // Loop over first 10 column and lines
            //System.out.println(sheet.getColumns() +  " " +sheet.getRows());
            Cell cell = sheet.getCell(column,row);
            value[0] = cell.getContents();
            //System.out.println(cell.getContents());
            

        } 
        catch (BiffException e) 
        {
            e.printStackTrace();
        }
        catch (IOException e) 
        {
            e.printStackTrace();
        }

        return value;
    }

    public static void main(String[] args) {
        ReadExcelLaunch readTest = new ReadExcelLaunch();
        readTest.setInputFile("C:\\TFG\\TFG\\LAUNCH\\xls\\Launcher_DataSet.xls");
        readTest.read();
        readTest.getOrbits();
        readTest.getVars();
        readTest.getValues("Vega");
        readTest.getPerformance("Taurus-XL","LEO-polar");
        //System.out.println(Arrays.deepToString(readTest.data));
        System.out.println(Arrays.toString(readTest.value));
        //System.out.println(readTest.keyVariables.keySet());
        //System.out.println(readTest.keyOrbits.keySet());
        /*for (String param: readTest.keyVariables.keySet()){

            String key =param.toString();
            String value = readTest.keyVariables.get(param).toString();  
            System.out.println(key + " " + value);  
        }*/

    } 
}


