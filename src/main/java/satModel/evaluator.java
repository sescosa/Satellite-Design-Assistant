package satModel;

import java.util.ArrayList;

import jess.*;
import com.backend.model.*;

public class evaluator{

	private Rete engine;
	private QueryBuilder qb;

	public evaluator(){
		this.engine = new Rete();
		this.qb = new QueryBuilder(engine);
	}
	
	public ArrayList<recommendation> evaluate(String subsystem) throws JessException {
		
		ArrayList<recommendation> recList = new ArrayList<recommendation>();
		
		
		if (subsystem.equals("launcher")) {
			engine.executeCommand("(clear) (reset) (batch satModel/launcher/clp/run_launch.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("LAUNCH::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					System.out.println(rec.getDescriptor());
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
			
		} else if (subsystem.equals("power")) {
			
			engine.executeCommand("(clear) (reset) (batch satModel/power/clp/run_eps.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("EPS::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});

		} else if (subsystem.equals("propulsion")) {
			
			engine.executeCommand("(clear) (reset) (batch satModel/propulsion/clp/run_prop.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("PROP::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		} else if (subsystem.equals("thermal")) {
			
			engine.executeCommand("(clear) (reset) (batch satModel/thermal/clp/run_tcs.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("TCS::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		} else if (subsystem.equals("comms")) {
			
			engine.executeCommand("(clear) (reset) (batch satModel/comms/clp/run_ttc.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("TTC::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		} else if (subsystem.equals("structure")) {
			
			engine.executeCommand("(clear) (reset) (batch satModel/structure/clp/run_struc.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("STRUC::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		} else {
			
			engine.executeCommand("(clear) (reset) (batch satModel/adcs/clp/run_adcs.clp)");
			engine.executeCommand("(run-system())");
			
			ArrayList<Fact> vals = qb.makeQuery("ADCS::recommend");
			
			vals.forEach(fact -> {
				try {
					recommendation rec = new recommendation();
					rec.setExplanation(fact.getSlotValue("explanation").stringValue(engine.getGlobalContext()));
					rec.setDescriptor(fact.getSlotValue("correction").stringValue(engine.getGlobalContext()));
					rec.setSubsystemName(subsystem);
					recList.add(rec);
				} catch (JessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			});
		}
		
		return recList;
	}


	public static void main(String[] args) throws JessException {

		evaluator evaluator = new evaluator();

		ArrayList<recommendation> result = evaluator.evaluate("thermal");
		
		result.forEach(el -> {
			System.out.println(el);
		});

	}
}