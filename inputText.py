import sys
import functions

def evalText(raw_text):

	# List of parameters in the webpage:
	parameterNames = ["Launcher","Orbit Type","Orbit Altitude","Orbit RAAN","Orbit Inclination","Orbit Eccentricity",
	                  "Satellite Dry Mass","Satellite Wet Mass","Satellite Dimensions","Lifetime","Planet orbiting",
	                  "Injection to Orbit Propellant","ADCS propellant","Mission type","DeltaV","Propulsion mass",
	                  "Deorbiting strategy","Payload mean power","Payload peak power","Solar cell type","Battery type","EPS mass",
	                  "Solar array mass","Solar array area","Battery mass","Accuracy requirement","Moments of inertia","Slew angle",
	                  "Slew control system","Number of reaction wheels","ADCS mass","ADCS type","Maximum Operational Temperature",
	                  "Minimum Operational Temperature","TCS type","TCS mass","TCS power",
	                  "Maximum internal heat","Minimum internal heat","Radiator material","Insulator material",
	                  "Data transmitted per day","Redundancy","Antenna type","Antenna gain","Transmitted power","Band",
	                  "Number of ground stations","Modulation","TTC power ","TTC mass","Main structure length",
	                  "Main structure diameter","Axial load factor","Lateral load factor","Bending load factor",
	                  "Structural mass","Number solar arrays","Material","Main structure type"]

	#raw_text = "The satellite has a dry mass of 200 kg, a wet mass of 230 kg. The lifetime is 7 years."
	#raw_text = "The satellite has a dry mass of 200 kg and an orbit altitude of 600 km."
	#raw_text = "The Thermal control subsystem type is active."
	finalList = functions.mainNLP(raw_text,parameterNames)
	return finalList

if __name__ == '__main__':
	raw_text = sys.argv[1]
	finalList = evalText(raw_text)
	if not finalList:
		print("Sorry! No parameters found.")
	else:
		for param in finalList:
			print(param[0])
			print(param[1])




        
