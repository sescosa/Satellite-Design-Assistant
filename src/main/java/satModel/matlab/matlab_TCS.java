package satModel.matlab;

import matlabcontrol.*;
import java.util.*;

public class matlab_TCS{

	double[] result = null;
	String inputStatement;
	String eqn;
	String variables;



	public double[] designTCS(HashMap<String,Double> inputList, String[] symbVar, String matlabFile, String[] outputVars) 
	{
		try{
		MatlabProxyFactoryOptions options = new MatlabProxyFactoryOptions.Builder()
	    .setUsePreviouslyControlledSession(true)
	    .setHidden(true)
	    .build(); 

	    MatlabProxyFactory factory = new MatlabProxyFactory(options);
	    MatlabProxy proxy = factory.getProxy();
	    //MatlabProxyFactoryOptions options = new MatlabProxyFactoryOptions.Builder().setUsePreviouslyControlledSession(true).build();
	    String symbStatement = "";
		String paramStatement = "";
		String solveStatement = "";
		String runfile2 = "";

		result = new double[outputVars.length];

	    /*Object[] result = proxy.returningEval(inputStatement,1);
	    //Retrieve the first (and only) element from the returned arguments
	    Object firstArgument = result[0];
	    //Like before, cast and index to retrieve the double value
	    double val = ((double[]) firstArgument)[0];
	    //val = Double.toString(d);*/
	    
	    proxy.eval("clear all");
		proxy.eval("addpath('C:\\TFG\\tfg_spring\\src\\main\\java\\satModel\\thermal\\clp')");



	    //System.out.println("running symb");
	    //Then, create matlab statement to declare input variables and its value
	    for (String param: inputList.keySet()){
	    	paramStatement = paramStatement + param.toString() + " = " + inputList.get(param).toString() + ";";
	    }

	    proxy.eval(paramStatement);
	    //System.out.println("running inputs");


	    // Run matlab file with equations for POWER

	    proxy.eval(matlabFile);
	 	
	 	//System.out.println("running matlab file");

	    //First, create matlab syntax to declare symbolic variables
	    symbStatement = "syms";
	    for (int i = 0; i < symbVar.length; i++){
	    	symbStatement = symbStatement + " " + symbVar[i];
	    }

	    proxy.eval(symbStatement);

	    // Run matlab file with script after the solver

	    //runfile2 = matlabFile + "2";
	    //proxy.eval(runfile2);

	    // Solve equations for the output wanted
	    /*for (int i = 1; i <= symbVar.length; i++)
	    {
	    	solveStatement = solveStatement + symbVar[i-1] + "= double(vpa(solve(EQN" + i + "," + symbVar[i-1] + ")));";
	    }
	    //System.out.println(solveStatement);
	    proxy.eval(solveStatement);*/

	    
	  
	    

	    // Get variables of outputVars
	    for (int i = 0; i < outputVars.length; i++){
	    	result[i] = ((double[]) proxy.getVariable(outputVars[i]))[0];
    		//System.out.println(outputVars[i] + " ouputs: " + result[i]);
	    }

	    //Disconnect the proxy from MATLAB
	    proxy.disconnect();
		}
		catch (MatlabConnectionException e) 
        {
            e.printStackTrace();
        }
        catch (MatlabInvocationException e) 
        {
            e.printStackTrace();
        }
        return result;
	}

	public static void main(String[] args) {

		/*matlab_EPS power = new matlab_EPS();

		String[] symbVar = {"Asa","mass_batt"};
		String matlabFile = "power_design";
		String[] outputVars = {"Asa","mass_EPS","mass_batt"};
		HashMap<String,Double> inputList = new HashMap<String,Double>();

		inputList.put("Pavg_payload",100.0);
		inputList.put("Ppeak_payload",120.0);
		inputList.put("period",5800.0);
		inputList.put("lifetime",7.0);
		inputList.put("frac_sunlight",0.66);
		inputList.put("Xe",0.65);
		inputList.put("Xd",0.85);
		inputList.put("Id",0.77);
		inputList.put("P0",202.0);
		inputList.put("worst_sun_angle",0.4014);
		inputList.put("degradation", 0.0375);
		inputList.put("DOD", 0.6);
		inputList.put("n", 0.9);
		inputList.put("dry_mass", 800.0);
		inputList.put("spec_power_sa", 40.0);
		inputList.put("spec_energy_density_batt", 25.0);

		power.designEPS(inputList,symbVar,matlabFile,outputVars);*/

	}
}