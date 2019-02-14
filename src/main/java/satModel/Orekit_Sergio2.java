/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package satModel;

import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.logging.ConsoleHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import seakers.orekit.analysis.Analysis;
import seakers.orekit.analysis.ephemeris.OrbitalElementsAnalysis;
import seakers.orekit.constellations.Walker;
import seakers.orekit.coverage.access.TimeIntervalArray;
import seakers.orekit.event.*;
import seakers.orekit.object.CoverageDefinition;
import seakers.orekit.object.CoveragePoint;
import seakers.orekit.object.Instrument;
import seakers.orekit.object.Satellite;
import seakers.orekit.object.fieldofview.NadirSimpleConicalFOV;
import seakers.orekit.object.fieldofview.OffNadirRectangularFOV;
import seakers.orekit.object.linkbudget.LinkBudget;
import seakers.orekit.propagation.PropagatorFactory;
import seakers.orekit.propagation.PropagatorType;
import seakers.orekit.scenario.Scenario;
import seakers.orekit.scenario.ScenarioIO;
import seakers.orekit.util.OrekitConfig;
import org.hipparchus.stat.descriptive.DescriptiveStatistics;
import org.hipparchus.util.FastMath;
import org.orekit.attitudes.AttitudeProvider;
import org.orekit.bodies.BodyShape;
import org.orekit.bodies.GeodeticPoint;
import org.orekit.bodies.OneAxisEllipsoid;
import org.orekit.errors.OrekitException;
import org.orekit.frames.Frame;
import org.orekit.frames.FramesFactory;
import org.orekit.frames.TopocentricFrame;
import org.orekit.orbits.KeplerianOrbit;
import org.orekit.orbits.Orbit;
import org.orekit.orbits.PositionAngle;
import org.orekit.propagation.Propagator;
import org.orekit.time.AbsoluteDate;
import org.orekit.time.TimeScale;
import org.orekit.time.TimeScalesFactory;
import org.orekit.utils.Constants;
import org.orekit.utils.IERSConventions;
import seakers.orekit.analysis.ephemeris.HohmannTransferAnalysis;
import seakers.orekit.analysis.vectors.VectorAnalisysEclipseSunlightDiffDrag;
import seakers.orekit.coverage.analysis.AnalysisMetric;
import seakers.orekit.coverage.analysis.GroundEventAnalyzer;
import seakers.orekit.coverage.analysis.LatencyGroundEventAnalyzer;
import seakers.orekit.object.Constellation;
import static seakers.orekit.object.CoverageDefinition.GridStyle.EQUAL_AREA;
import static seakers.orekit.object.CoverageDefinition.GridStyle.UNIFORM;
import seakers.orekit.object.CommunicationBand;
import seakers.orekit.object.GndStation;
import seakers.orekit.object.communications.ReceiverAntenna;
import seakers.orekit.object.communications.TransmitterAntenna;
import seakers.orekit.object.fieldofview.NadirRectangularFOV;
import seakers.orekit.util.Orbits;

/**
 *
 * @author Sergio
 */
public class Orekit_Sergio2 {
        /**
         * @param args the command line arguments
         * @throws org.orekit.errors.OrekitException
         */
    
    double ContactTimePerDay;
    
    public double getContactTime(double h, double ideg, int ngs) throws OrekitException{
        //if running on a non-US machine, need the line below
        Locale.setDefault(new Locale("en", "US"));
        
        
        // initializes the look up tables for planetary position (required!)
        OrekitConfig.init(4);

        //setup logger that spits out runtime info
        Level level = Level.ALL;
        Logger.getGlobal().setLevel(level);
        ConsoleHandler handler = new ConsoleHandler();
        handler.setLevel(level);
        Logger.getGlobal().addHandler(handler);
        
        /* setting time for simulation */
        TimeScale utc = TimeScalesFactory.getUTC();
        AbsoluteDate startDate = new AbsoluteDate(2018, 1, 1, 00, 00, 00, utc);
        AbsoluteDate endDate = new AbsoluteDate(2018, 1, 6, 00, 00, 00, utc);
        
        double mu = Constants.WGS84_EARTH_MU; // gravitation coefficient
        
        //must use IERS_2003 and EME2000 frames to be consistent with STK
        Frame earthFrame = FramesFactory.getITRF(IERSConventions.IERS_2003, true);
        Frame inertialFrame = FramesFactory.getEME2000();
        
        BodyShape earthShape = new OneAxisEllipsoid(Constants.WGS84_EARTH_EQUATORIAL_RADIUS,
                Constants.WGS84_EARTH_FLATTENING, earthFrame);
             
        
        double gain = 6.; //antenna gain
        double a = Constants.WGS84_EARTH_EQUATORIAL_RADIUS+h;
        double i = FastMath.toRadians(ideg);
        //double iSSO = Orbits.incSSO(600);
        
        //define instruments
        NadirRectangularFOV fov = new NadirRectangularFOV(FastMath.toRadians(57), FastMath.toRadians(20), 0, earthShape);
        ArrayList<Instrument> payload = new ArrayList<>();
        Instrument view1 = new Instrument("view1", fov, 100, 100);
        payload.add(view1);
        
        
        ArrayList<Satellite> satellites=new ArrayList<>();
        HashSet<CommunicationBand> satBands = new HashSet<>();
        
        //Input satellite band
        satBands.add(CommunicationBand.UHF);
        
        Orbit orb1 = new KeplerianOrbit(a, 0.0001, i, 0.0, Math.toRadians(0), Math.toRadians(0), PositionAngle.MEAN, inertialFrame, startDate, mu);
        Satellite sat1 = new Satellite("sat1", orb1, null, payload,
                new ReceiverAntenna(gain, satBands), new TransmitterAntenna(gain, satBands), Propagator.DEFAULT_MASS, Propagator.DEFAULT_MASS);
        satellites.add(sat1);
        
        // set ground stations
        Set<GndStation> gndStations = new HashSet<>();
        if (ngs >= 1) {
        TopocentricFrame wallopsTopo = new TopocentricFrame(earthShape, new GeodeticPoint(FastMath.toRadians(37.94019444), FastMath.toRadians(-75.46638889), 0.), "Wallops");
        HashSet<CommunicationBand> wallopsBands = new HashSet<>();
        wallopsBands.add(CommunicationBand.UHF);
        gndStations.add(new GndStation(wallopsTopo, new ReceiverAntenna(6., wallopsBands), new TransmitterAntenna(6., wallopsBands), FastMath.toRadians(10.)));
        } 
        if (ngs >= 2) {
        TopocentricFrame whitesandsTopo = new TopocentricFrame(earthShape, new GeodeticPoint(FastMath.toRadians(32.335846), FastMath.toRadians(-106.406348), 0.), "WhiteSands");
        HashSet<CommunicationBand> whitesandsBands = new HashSet<>();
        whitesandsBands.add(CommunicationBand.UHF);
        gndStations.add(new GndStation(whitesandsTopo, new ReceiverAntenna(47., whitesandsBands), new TransmitterAntenna(47., whitesandsBands), FastMath.toRadians(10.)));
        } 
        if (ngs >= 3) {
        TopocentricFrame solnaTopo = new TopocentricFrame(earthShape, new GeodeticPoint(FastMath.toRadians(59.355540), FastMath.toRadians(17.971484), 0.), "Solna");
        HashSet<CommunicationBand> solnaBands = new HashSet<>();
        solnaBands.add(CommunicationBand.UHF);
        gndStations.add(new GndStation(solnaTopo, new ReceiverAntenna(10., solnaBands), new TransmitterAntenna(10., solnaBands), FastMath.toRadians(10.)));
        } 
        if (ngs == 4) {
        TopocentricFrame mcmurdoTopo = new TopocentricFrame(earthShape, new GeodeticPoint(FastMath.toRadians(-77.846271), FastMath.toRadians(166.668056), 0.), "McMurdo");
        HashSet<CommunicationBand> mcmurdoBands = new HashSet<>();
        mcmurdoBands.add(CommunicationBand.UHF);
        gndStations.add(new GndStation(mcmurdoTopo, new ReceiverAntenna(10., mcmurdoBands), new TransmitterAntenna(10., mcmurdoBands), FastMath.toRadians(10.)));
        }
        
        Constellation constel = new Constellation ("sergio_tfg",satellites);

        HashMap<Satellite, Set<GndStation>> stationAssignment = new HashMap<>();
        for (Satellite sat : constel.getSatellites()){
            stationAssignment.put(sat, gndStations);
        }
        
        Properties propertiesPropagator = new Properties();
        propertiesPropagator.setProperty("orekit.propagator.mass", "6");
        propertiesPropagator.setProperty("orekit.propagator.atmdrag", "true");
        propertiesPropagator.setProperty("orekit.propagator.dragarea", "0.075");
        propertiesPropagator.setProperty("orekit.propagator.dragcoeff", "2.2");
        propertiesPropagator.setProperty("orekit.propagator.thirdbody.sun", "true");
        propertiesPropagator.setProperty("orekit.propagator.thirdbody.moon", "true");
        propertiesPropagator.setProperty("orekit.propagator.solarpressure", "true");
        propertiesPropagator.setProperty("orekit.propagator.solararea", "0.058");

        PropagatorFactory pf = new PropagatorFactory(PropagatorType.J2,propertiesPropagator);
        Properties propertiesEventAnalysis = new Properties();
        
        EventAnalysisFactory eaf = new EventAnalysisFactory(startDate, endDate, inertialFrame, pf);
        ArrayList<EventAnalysis> eventanalyses = new ArrayList<>();
        GndStationEventAnalysis gndEvent = (GndStationEventAnalysis) eaf.createGroundStationAnalysis(EventAnalysisEnum.ACCESS, stationAssignment, propertiesEventAnalysis);
        eventanalyses.add(gndEvent);
        
        //set the anlyses
        ArrayList<Analysis<?>> analyses = new ArrayList<>();
        
        //set sceneario
        Scenario scen = new Scenario.Builder(startDate, endDate, utc).
                eventAnalysis(eventanalyses).analysis(analyses).
                name("trial1").properties(propertiesEventAnalysis).
                propagatorFactory(pf).build();
        try {
//            Logger.getGlobal().finer(String.format("Running Scenario %s", scen));
//            Logger.getGlobal().finer(String.format("Number of points:     %d", covDef1.getNumberOfPoints()));
//            Logger.getGlobal().finer(String.format("Number of satellites: %d", constel.getSatellites().size()));
            long start1 = System.nanoTime();
            scen.call();
            long end1 = System.nanoTime();
            Logger.getGlobal().finest(String.format("Took %.4f sec", (end1 - start1) / Math.pow(10, 9)));
            
        } catch (Exception ex) {
            Logger.getLogger(Orekit_Sergio2.class.getName()).log(Level.SEVERE, null, ex);
            throw new IllegalStateException("scenario failed to complete.");
        }
        Logger.getGlobal().finer(String.format("Done Running Scenario %s", scen));
        
        Properties props=new Properties();
        GroundEventAnalyzer ea = new GroundEventAnalyzer(gndEvent.getEvents());
        DescriptiveStatistics accessStats = ea.getStatistics(AnalysisMetric.DURATION, true,props);
        //DescriptiveStatistics accessStats2 = ea.getStatistics(AnalysisMetric.OCCURRENCES, true,props);
        // DescriptiveStatistics gapStats = ea.getStatistics(AnalysisMetric.DURATION, false,props);
        
        /*System.out.println(String.format("Max access time %s", accessStats.getMax()));
        System.out.println(String.format("Mean access time %s", accessStats.getMean()));
        System.out.println(String.format("Min access time %s", accessStats.getMin()));
        System.out.println(String.format("Total access time is %s", accessStats.getSum()));

        System.out.println("---------------------------------");
        
        System.out.println(String.format("Number of access is %s", accessStats2.getSum()));*/
        ContactTimePerDay = accessStats.getSum() / 5; // 5 days simulation
       
        OrekitConfig.end();
       
        return ContactTimePerDay;
    }

    public static void main(String[] args) {
        //INPUTS
        int ngs = 2;
        int h=600000;
        double ideg=98;
        
        Orekit_Sergio2 contact = new Orekit_Sergio2();
        try {
          contact.getContactTime(h,ideg,ngs);  
        }
        catch (OrekitException e){
            e.printStackTrace();
        }
        
        System.out.println(String.format("Contact time per day is %s", contact.ContactTimePerDay));
    }
}
