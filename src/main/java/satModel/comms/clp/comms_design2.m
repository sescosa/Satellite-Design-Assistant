EbN0_symb = lin2dB(Ptx)+Gtx_min+Lp+Ll+Li+La+G_GS+lin2dB(Ls)-lin2dB(k*Tgs*Rb_DL);
margin = EbN0_symb - EbN0_min;

EQN = margin == 4; %4 dB as minimum margin
% 
Gtx_res = double(vpa(solve(EQN,Gtx_min)));
% save first Gtx considered in variable
Gtx_old = Gtx;

if Gtx_res <= 0
    margin_min = double(vpa(subs(margin, Gtx_min, 0)));
    margin_gtx = double(vpa(subs(margin, Gtx_min, Gtx)));
    margin_zero = 0;
    
    %Optimum gain would be 0 or 1 dB
    Gtx_min = 1;
    Gtx = Gtx_min;
    
    Nchannels=BW_NEN(Band)/32e6;
    if Gtx < 3 && Band==1
        lambda=3e8/f_DL;
        if Gtx<1.76
            Ltx=0.1*lambda; %short dipole (gain 1.76dB)
        elseif 1.76<Gtx && Gtx<2.15
            Ltx=0.5*lambda; %dipole lambda/2 (gain 2.15dB)
        elseif 2.15<Gtx && Gtx<5.2
            Ltx=(5/4)*lambda;%dipole 5lambda/4 (gain of about 5.2dB)
        end
        AntennaType='Dipole';
        AntennaCode = 1;
        massA_DL=0.05;
        linkBudgetClosed=true;

    elseif (Gtx<9) && Band<3
        er=6.8;
        [W,L] = DimPatchAntenna(er,f_DL_GHz);
        AntennaType='Patch';
        AntennaCode = 2;
        massA_DL=patchMassFromDimensions(W,L);
        linkBudgetClosed=true;

%                          elseif (9<Gtx)&&(Gtx<15)
%                              lambda=3e8/f_DL;
%                              [N,D,S,pa,theta] = Gain2Helical(Gtx,f_DL_GHz);
%                              Nreal=ceil(N);
%                              massA_DL=helixMassFromDimensions(Nreal,D,S,pa,lambda);
%                              AntennaType='Helical';
%                              linkBudgetClosed=true;
    else
        Dtx=Gain2Diameter(Gtx,f_DL_GHz,0.6);
        if (Dtx<4.5)&&(Dtx>0.3)
            AntennaType='Parabolic';
            AntennaCode = 3;
            linkBudgetClosed=true;
        elseif Dtx<0.3
            Dtx=0.3;
            AntennaType='Parabolic';
            AntennaCode = 3;
            linkBudgetClosed=true;
        end
        massA_DL=parabolicMassFromDiameter(Dtx);
        F=0.5*Dtx;%F/D typically varies between 0.3 and 1
        H=Dtx^2/(16*F);
    end

    if linkBudgetClosed

        %massA=(massA_DL)*params.Red + 0.01*structures.drymass;
        massA=massA_DL;
        massE=massCommElectronics(Ptx)*Red + 0.01*drymass;

        costAntenna=CostAntenna(massA,AntennaType);
        costElectronics=CostCommElectronics(massE,Nchannels);
        comms_cost_new=(costAntenna+costElectronics+CostGroundStations);
        power_comms=comms_power(Ptx);

        if comms_cost_new<cost
            optfound=true;
            cost=comms_cost_new;
            MassOpt=massA+massE;
            MOD_opt=mod;
            f_OPT=Band;
            AntennaTypeOPT=AntennaType;
            power_comms_opt=power_comms;  

            %Outputs Anjit (Sizing Components)
            %Filters/Diplexers --> SMAD
            %Antenna (Dipole cubsatshop,Patch aspect ratio,parabolic aspect ratio)
            %Electronics(mass function of Ptx and drymass, dimensions from excel
            %database (still to be improved))

            % Diameters 
            if Band==1
                massFiltersDiplexers=2;
                dimFiltersDiplexers=[300 150 60];
                massElectronics=massE;
                dimElectronics=[0.171,0.128,0.092];
                if strcmp(AntennaType,'Dipole')
                    %Deployable Antenna System for CubeSats(CubesatShop)
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            elseif Band==2
                massFiltersDiplexers=2;
                dimFiltersDiplexers=[300 150 60];
                massElectronics=massE;
                dimElectronics=[0.140,0.330,0.070];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            elseif Band==3
                massFiltersDiplexers=1.5;
                dimFiltersDiplexers=[220 100 40];
                massElectronics=massE;
                dimElectronics=[0.2,0.22,0.070];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            else
                massFiltersDiplexers=1.2;
                dimFiltersDiplexers=[190 80 40];
                massElectronics=massE;
                dimElectronics=[0.17,0.340,0.090];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            end
        end
    end
    
  % UHF analysis with considered gain
  Band = 1;
  comms_design;
  EbN0_symb = lin2dB(Ptx)+Gtx_old+Lp+Ll+Li+La+G_GS+lin2dB(Ls)-lin2dB(k*Tgs*Rb_DL);
  margin_uhf = EbN0_symb - EbN0_min;
  
% if Gtx_res is positive
else 
    margin_zero = 4;
    margin_min = 0;
    margin_gtx = double(vpa(subs(margin, Gtx_min, Gtx)));
    Gtx_min = Gtx_res;
    Gtx = Gtx_min;
    Nchannels=BW_NEN(Band)/32e6;
    if Gtx < 3 && Band==1
        lambda=3e8/f_DL;
        if Gtx<1.76
            Ltx=0.1*lambda; %short dipole (gain 1.76dB)
        elseif 1.76<Gtx && Gtx<2.15
            Ltx=0.5*lambda; %dipole lambda/2 (gain 2.15dB)
        elseif 2.15<Gtx && Gtx<5.2
            Ltx=(5/4)*lambda;%dipole 5lambda/4 (gain of about 5.2dB)
        end
        AntennaType='Dipole';
        AntennaCode = 1;
        massA_DL=0.05;
        linkBudgetClosed=true;

    elseif (Gtx<9) && Band<3
        er=6.8;
        [W,L] = DimPatchAntenna(er,f_DL_GHz);
        AntennaType='Patch';
        AntennaCode = 2;
        massA_DL=patchMassFromDimensions(W,L);
        linkBudgetClosed=true;

%                          elseif (9<Gtx)&&(Gtx<15)
%                              lambda=3e8/f_DL;
%                              [N,D,S,pa,theta] = Gain2Helical(Gtx,f_DL_GHz);
%                              Nreal=ceil(N);
%                              massA_DL=helixMassFromDimensions(Nreal,D,S,pa,lambda);
%                              AntennaType='Helical';
%                              linkBudgetClosed=true;
    else
        Dtx=Gain2Diameter(Gtx,f_DL_GHz,0.6);
        if (Dtx<4.5)&&(Dtx>0.3)
            AntennaType='Parabolic';
            AntennaCode = 3;
            linkBudgetClosed=true;
        elseif Dtx<0.3
            Dtx=0.3;
            AntennaType='Parabolic';
            AntennaCode = 3;
            linkBudgetClosed=true;
        end
        massA_DL=parabolicMassFromDiameter(Dtx);
        F=0.5*Dtx;%F/D typically varies between 0.3 and 1
        H=Dtx^2/(16*F);
    end

    if linkBudgetClosed

        %massA=(massA_DL)*params.Red + 0.01*structures.drymass;
        massA=massA_DL;
        massE=massCommElectronics(Ptx)*Red + 0.01*drymass;

        costAntenna=CostAntenna(massA,AntennaType);
        costElectronics=CostCommElectronics(massE,Nchannels);
        comms_cost_new=(costAntenna+costElectronics+CostGroundStations);
        power_comms=comms_power(Ptx);

        if comms_cost_new<cost
            optfound=true;
            cost=comms_cost_new;
            MassOpt=massA+massE;
            MOD_opt=mod;
            f_OPT=Band;
            AntennaTypeOPT=AntennaType;
            power_comms_opt=power_comms;  

            %Outputs Anjit (Sizing Components)
            %Filters/Diplexers --> SMAD
            %Antenna (Dipole cubsatshop,Patch aspect ratio,parabolic aspect ratio)
            %Electronics(mass function of Ptx and drymass, dimensions from excel
            %database (still to be improved))

            % Diameters 
            if Band==1
                massFiltersDiplexers=2;
                dimFiltersDiplexers=[300 150 60];
                massElectronics=massE;
                dimElectronics=[0.171,0.128,0.092];
                if strcmp(AntennaType,'Dipole')
                    %Deployable Antenna System for CubeSats(CubesatShop)
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            elseif Band==2
                massFiltersDiplexers=2;
                dimFiltersDiplexers=[300 150 60];
                massElectronics=massE;
                dimElectronics=[0.140,0.330,0.070];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            elseif Band==3
                massFiltersDiplexers=1.5;
                dimFiltersDiplexers=[220 100 40];
                massElectronics=massE;
                dimElectronics=[0.2,0.22,0.070];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            else
                massFiltersDiplexers=1.2;
                dimFiltersDiplexers=[190 80 40];
                massElectronics=massE;
                dimElectronics=[0.17,0.340,0.090];
                if strcmp(AntennaType,'Dipole')
                    massAntenna=massA;
                    dimAntenna=[0.098,0.098,0.007];
                elseif strcmp(AntennaType,'Patch')
                    massAntenna=massA;
                    dimAntenna=[L,W,0.1*max(W,L)];
                elseif strcmp(AntennaType,'Parabolic')
                    massAntenna=massA;
                    dimAntenna=[Dtx/2,H];
                end
            end
        end
    end
  % UHF analysis with considered gain
  Band = 1;
  comms_desgin;
  EbN0_symb = lin2dB(Ptx)+Gtx_old+Lp+Ll+Li+La+G_GS+lin2dB(Ls)-lin2dB(k*Tgs*Rb_DL);
  margin_uhf = EbN0_symb - EbN0_min;
  
end


