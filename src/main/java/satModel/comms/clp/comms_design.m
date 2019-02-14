%% COMMS SUBSYSTEM DESIGN
%Author: Sergio Escosa
%% Input
bands_NEN={'UHF','Sband','Xband','Kaband'};
BW_NEN=[137.825e6-137.175e6 2.29e9-2.2e9 8.175e9-8.025e9 27e9-25.5e9];

GS_name={'Wallops','WhiteSands','Solna'};


[num,txt,rawTime]=xlsread('C:/TFG/TFG/TTC/xls/NEN_contacts_duration.xlsx',2,'B6:H85');
[num1,txt1,rawDL]=xlsread('C:/TFG/TFG/TTC/xls/NEN_contacts_duration.xlsx',2,'J6:Z9');
[num2,txt2,rawUL]=xlsread('C:/TFG/TFG/TTC/xls/NEN_contacts_duration.xlsx',2,'J14:T17');

EbN0=[10.6 10.6 14 18.3]; %Eb/N0 necessary to achieve a good communication for BER=10e-6 and M=2,4,8,16 (M-PSK)
Modulation = [2 4 8 16]; 

epsmin =  10; % GroundAntennaMinElevationAngle in deg
alfa = 0.25; %correction factor
k = 1.38e-23; %Boltzmann constant
BER = 10e-5; %Bit Error Rate
mod = log2(MOD);
c = 3e8;
eff = 0.6; %antenna efficiency
Red = 2; %Redundancy level
% % Design inputs
% Red=2; %Redundancy level
% dpd = 10e6; %bits to be sent per day
% h = 400; %altitude in km
% inc = 30; %orbit inclination
% Gtx = 8; %Gain of the transmitter antenna
% Ptx = 7; %Power in W of the transmitter antenna
% cost=3000e4; %cost of the comms subsystem estimated by user
% lifetime = 7; %in years
% drymass = 800; %satellite dry mass in kg
% Band = 1; %which band(s) will be used  [UHF Sband Xband Kaband]
% MOD = 3; %which modulation do we choose [2 4 8 16]
% ngs = 1; %number of Ground Stations used (from 1 to 3 [Wallops, WhiteSands, Solna])

%Ground stations
    igs=1;
    %ContactTimePerDayTotal=0;
    NEN_DL=cell(ngs,17);
    NEN_UL=cell(ngs,11);
    while igs<=ngs
        info1=false;
        info2=false;
        nr=0;
        while ~info1 && nr<length(rawTime)
            nr=nr+1;
            if  rawTime{nr,1}== inc &&  rawTime{nr,2}== h && strcmp( rawTime{nr,3}, GS_name(igs))
                Naccessesday_GS_SAT_MAX= rawTime{nr,6};
                meanAccessTime= rawTime{nr,7};
                info1=true;
            end
        end
        nr=0;
        while ~info2 && nr<length(rawDL)
            nr=nr+1;
            if strcmp(rawDL{nr,1}, GS_name(igs))
                NEN_DL(igs,:)= rawDL(nr,:);
                NEN_UL(igs,:)= rawUL(nr,:);
                info2=true;
            end
        end
        %ContactTimePerDay=meanAccessTime*0.95*Naccessesday_GS_SAT_MAX; %Mean Contact Time per day
        %%ContactTimePerDayTotal=ContactTimePerDayTotal+ContactTimePerDay;
        %%contact time is calculated with orekit
        igs=igs+1;
    end
    Software=100*220;%100KLOC @ 220$/LOC
    Equipment=0.81*Software;
    Facilities=0.18*Software;
    Mainteinance=0.1*(Software+Equipment+Facilities);%cost mainetinance/year
    ContractLabors=10*160;%10 workers at 160k$/year
    CostGroundStations=((Mainteinance+ContractLabors)*lifetime)*ngs; %cost GS mainteinance for the whole mission in k$
    Rb_DL= dpd/ContactTimePerDayTotal; %data rate in the downlink Satellite-GroundStation [bps]
    Rb_UL=68e3; %64kbps(Telemetry) + 4kbps(Telecommand)

%% Shannon Limit

eta = Rb_DL/(BW_NEN(Band)*(1+alfa));
EbN0_shannon = (2^eta - 1)/eta;


%% Link Budget Equation
%MODULATION INFORMATION
linkBudgetClosed=false;
Nsymb=2^mod;
EspEff=log2(Nsymb)/(1+alfa);
Rb_Max=EspEff*BW_NEN(Band);

    igs=1;
    if ~strcmp(NEN_DL{igs,Band+1},'NO')

        f_DL=NEN_DL{igs,Band+1};
        f_DL_GHz = f_DL/1e9;
        lambda = 3e8/f_DL;
        G_GS=NEN_DL{igs,Band+5};%GroundStation Antenna Gain [dB]
        Tgs=NEN_DL{igs,Band+13}; %Noise Temperature GS antenna [K]
        EbN0_min=EbN0(mod);
        R = CalcRange(h,epsmin);
        Ls = (c/(4*pi*R*f_DL))^2; %space loss
        Ll = -1; %transmitter line loss in dB
        Li = -2; %implementation loss
        La = -0.3; %attenuation loss
        [Dtx,theta] = Gain2Diameter(Gtx,f_DL_GHz,eff);
        et = theta/3; %antenna pointing offset
        %Gtx_peak_smad = -159.9 + 20*log(Dtx)+20*log(f_DL) + 10*log(eff);
        Lp = -12*(et/theta)^2;
        %Gtx_smad = Gtx_peak_smad + Lp; %substracting pointing losses
        %EbN0 = lin2dB(Ptx)+Gtx+G_GS+2*lin2dB(lambda/(4*pi*R))-lin2dB(k*Tgs*Rb_DL); %no losses here
        EbN0 = lin2dB(Ptx)+Gtx+Lp+Ll+Li+La+G_GS+lin2dB(Ls)-lin2dB(k*Tgs*Rb_DL);

    end


