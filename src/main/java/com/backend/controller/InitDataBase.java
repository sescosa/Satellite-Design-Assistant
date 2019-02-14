package com.backend.controller;

import lombok.extern.slf4j.Slf4j;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.ModelAndView;

import com.backend.model.Parameter;
import com.backend.model.Subsystem;
import com.backend.model.allForms;
import com.backend.model.excelParams;
import com.backend.model.inputText;

@Configuration
@Slf4j
class InitDataBase {

	@Bean
	CommandLineRunner initDatabase(ParameterRepository repository, SubsystemRepository repositoryS, ExcelParamsRepository repositoryE) {
		return args -> {
	    	
			log.info("Preloading Subsystems... ");
			repositoryS.save(new Subsystem("general"));

			repositoryS.save(new Subsystem("propulsion"));
			repositoryS.save(new Subsystem("launcher"));
			repositoryS.save(new Subsystem("power"));
			repositoryS.save(new Subsystem("adcs"));
			repositoryS.save(new Subsystem("thermal"));
			repositoryS.save(new Subsystem("comms"));
			repositoryS.save(new Subsystem("structure"));
			
			repository.save(new Parameter("launcher","Launcher",null,"launcher",null));
			repository.save(new Parameter("launcher","Orbit Type",null,"orbit-type","[LEO,MEO,HEO,SSO,GEO]"));
			repository.save(new Parameter("launcher","Orbit Altitude",null,"orbit-altitude#","[km]"));
			repository.save(new Parameter("launcher","Orbit RAAN",null,"orbit-RAAN","[DD,AM,Noon,PM,N-A]"));
			repository.save(new Parameter("launcher","Orbit Inclination",null,"orbit-inclination","[º]"));
			repository.save(new Parameter("launcher","Orbit Eccentricity",null,"orbit-eccentricity",null));
			
			repository.save(new Parameter("general","Satellite Dry Mass",null,"satellite-dry-mass", "[kg]"));
			repository.save(new Parameter("general","Satellite Wet Mass",null,"satellite-wet-mass","[kg]"));
			repository.save(new Parameter("general","Satellite Dimensions",null,"satellite-dimensions","[m] [x y z]"));
			repository.save(new Parameter("general","Lifetime",null,"lifetime","[years]"));
			repository.save(new Parameter("general","Planet orbiting",null,"planet",null));
			
			repository.save(new Parameter("propulsion","Injection to Orbit Propellant",null,"propellant-injection",null));
			repository.save(new Parameter("propulsion","ADCS propellant",null,"propellant-ADCS",null));
			repository.save(new Parameter("propulsion","DeltaV",null,"delta-V","[m/s]"));
			repository.save(new Parameter("propulsion","Propulsion mass",null,"propulsion-mass#","[kg]"));
			repository.save(new Parameter("propulsion","Deorbiting strategy",null,"deorbiting-strategy",null));
			
			repository.save(new Parameter("power","Payload mean power",null,"payload-power#","[W]"));
			repository.save(new Parameter("power","Payload peak power",null,"payload-peak-power#","[W]"));
			repository.save(new Parameter("power","Solar cell type",null,"solar-cell-type","[GaAs,Si,Multijunction]"));
			repository.save(new Parameter("power","Battery type",null,"battery-type","[NiCd,NiH2]"));
			repository.save(new Parameter("power","EPS mass",null,"EPS-mass#","[kg]"));
			repository.save(new Parameter("power","Solar array area",null,"solar-array-area","[m^2]"));
			repository.save(new Parameter("power","Solar array mass",null,"solar-array-mass","[kg]"));
			repository.save(new Parameter("power","Battery mass",null,"battery-mass","[kg]"));
			
			repository.save(new Parameter("adcs","Accuracy requirement",null,"ADCS-requirement","[º]"));
			repository.save(new Parameter("adcs","Moments of inertia",null,"moments-of-inertia","[kg·m^2] [Ix Iy Iz]"));
			repository.save(new Parameter("adcs","Slew angle",null,"slew-angle","[º/s]"));
			repository.save(new Parameter("adcs","Slew control system",null,"slew-control",null));
			repository.save(new Parameter("adcs","Number of reaction wheels",null,"number-RW",null));
			repository.save(new Parameter("adcs","ADCS mass",null,"ADCS-mass#","[kg]"));
			repository.save(new Parameter("adcs","ADCS type",null,"ADCS-type",null));
			
			repository.save(new Parameter("thermal","Maximum Operational Temperature",null,"Thot-max","[K]"));
			repository.save(new Parameter("thermal","Minimum Operational Temperature",null,"Tcold-min","[K]"));
			repository.save(new Parameter("thermal","TCS type",null,"TCS-type","[active or passive]"));
			repository.save(new Parameter("thermal","TCS mass",null,"TCS-mass","[kg]"));
			repository.save(new Parameter("thermal","TCS power",null,"TCS-power","[W]"));
			repository.save(new Parameter("thermal","Maximum internal heat",null,"Qin-max","[W]"));
			repository.save(new Parameter("thermal","Minimum internal heat",null,"Qin-min","[W]"));
			repository.save(new Parameter("thermal","Radiator material",null,"radiator-surface",null));
			repository.save(new Parameter("thermal","Insulator material",null,"insulator-surface",null));
			
			repository.save(new Parameter("comms","Data transmitted per day",null,"data-per-day","[bpd]"));
			repository.save(new Parameter("comms","Redundancy",null,"redundancy",null));
			repository.save(new Parameter("comms","Antenna type",null,"antenna-type",null));
			repository.save(new Parameter("comms","Antenna gain",null,"gain-antenna","[dB]"));
			repository.save(new Parameter("comms","Transmitted power",null,"trans-power","[W]"));
			repository.save(new Parameter("comms","Band",null,"Band",null));
			repository.save(new Parameter("comms","Number of ground stations",null,"ngs",null));
			repository.save(new Parameter("comms","Modulation",null,"MOD",null));
			repository.save(new Parameter("comms","TTC power",null,"peak-power","[W]"));
			repository.save(new Parameter("comms","TTC mass",null,"TTC-mass","[kg]"));
			
			repository.save(new Parameter("structure","Main structure length",null,"length","[m]"));
			repository.save(new Parameter("structure","Main structure diameter",null,"diameter","[m]"));
			repository.save(new Parameter("structure","Axial load factor",null,"LFaxial",null));
			repository.save(new Parameter("structure","Lateral load factor",null,"LFlateral",null));
			repository.save(new Parameter("structure","Bending load factor",null,"LFbending",null));
			repository.save(new Parameter("structure","Axial natural frequency",null,"NF-axial","[Hz]"));
			repository.save(new Parameter("structure","Lateral natural frequency",null,"NF-lateral","[Hz]"));
			repository.save(new Parameter("structure","Structural mass",null,"mass-structure","[kg]"));
			repository.save(new Parameter("structure","Number of solar arrays",null,"number-SA",null));
			repository.save(new Parameter("structure","Material",null,"material","[Al7075]"));
			repository.save(new Parameter("structure","Main structure",null,"struc-type","[monocoque or stringers]"));			
			
			String[] listPROP = {"orbit-type","orbit-RAAN","orbit-altitude#","orbit-inclination","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","orbit-eccentricity","lifetime","satellite-dry-mass","propellant-injection","propellant-ADCS","delta-V","propulsion-mass#","ADCS-type","payload-power#","satellite-dimensions","deorbiting-strategy","satellite-wet-mass","planet"};
			String[] listEPS = {"orbit-type","orbit-RAAN","orbit-altitude#","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","payload-power#","payload-peak-power#","lifetime","satellite-dry-mass","depth-of-discharge","EPS-mass#","satellite-EOL-power#","satellite-BOL-power#","solar-array-area","solar-array-mass","battery-capacity","solar-cell-type","battery-type","battery-mass","planet"};
			String[] listADCS = {"orbit-type","orbit-RAAN","orbit-altitude#","orbit-inclination","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","ADCS-requirement","satellite-dry-mass","moments-of-inertia","drag-coefficient","residual-dipole","slew-angle","satellite-dimensions","ADCS-mass#","ADCS-type","slew-control","number-RW","planet"};
			String[] listTCS = {"orbit-type","orbit-RAAN","orbit-altitude#","orbit-inclination","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","orbit-eccentricity","lifetime","satellite-dry-mass","Thot-max","Tcold-min","Qin-max","Qin-min","satellite-dimensions","payload-power#","TCS-type","TCS-mass","TCS-power","radiator-surface","insulator-surface","planet"};
			String[] listTTC = {"orbit-type", "orbit-RAAN", "orbit-altitude#", "orbit-inclination", "worst-sun-angle", "orbit-period#", "fraction-sunlight", "orbit-semimajor-axis", "redundancy", "data-per-day", "gain-antenna", "peak-power", "lifetime", "satellite-dry-mass", "Band", "MOD", "ngs", "TTC-mass", "antenna-type", "trans-power", "planet"};
			String[] listSTRUC = {"orbit-type","orbit-RAAN","orbit-altitude#","orbit-inclination","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","orbit-eccentricity","lifetime","satellite-wet-mass","length","diameter","LFaxial","LFlateral","LFbending","NF-axial","NF-lateral","SFu","SFy","mass-structure","material","struc-type","planet","solar-array-area","solar-array-mass","number-SA"};
			String[] listLAUNCH = {"orbit-type","orbit-RAAN","orbit-altitude#","orbit-inclination","worst-sun-angle","orbit-period#","fraction-sunlight","orbit-semimajor-axis","orbit-eccentricity","planet","launcher","satellite-dimensions","satellite-wet-mass"};
			
			repositoryE.save(new excelParams(listPROP,"propulsion"));
			repositoryE.save(new excelParams(listEPS,"power"));
			repositoryE.save(new excelParams(listADCS,"adcs"));
			repositoryE.save(new excelParams(listTCS,"thermal"));
			repositoryE.save(new excelParams(listTTC,"comms"));
			repositoryE.save(new excelParams(listSTRUC,"structure"));
			repositoryE.save(new excelParams(listLAUNCH,"launcher"));
			
			
			log.info("Preloading END.");

		};
	}
}