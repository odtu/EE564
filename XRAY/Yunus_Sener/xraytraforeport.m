%% EE564 - Design of Electrical Machines
%% Project-1: Transformer Design for X-Rays
%%
% Yunus ÞENER
% ID: 1675248

%%
% Specifications

%%
% X-ray transformer
%%
% Single-phase, high frequency, high voltage
%%
% Primary Winding Voltage ± 417 V (peak to peak 834 V for pulsing)
%%
% Secondary Winding Voltage ± 12.5 kV (peak to peak 25 kV for pulsing)
%%
% Rated Power 30 kW (for maximum 100 millisecond)
%%
% Switching Frequency Minimum 100 kHz

%% Procedure
%%
% Core Selection
%%
% P Type Material ferrite U core is selected.
%%
% Saturation Flux Density is set to be 0.3T
%%
% Since this transformer is not operated continuosly, production cost is optimized.
% It is observed that it is not very efficient when cost is optimezed.
%%
% Core Area is swept to obtain minimum cost(xraytrafoopt.m).
%%
% Design Specifications
Vin = 417; %V
Vout = 12500; %V   
Pout = 30000; %W
%%
% Saturation flux:
Bm=0.3; %T
%%
% Permeability:
ur=2500;
u0=4*pi*10^-7; %H/m
u=ur*u0; %H/m
%%
% Switching frequency;
f=100000; %Hz
%%
% Current Density is set to be 2A/mm^2
J=200; %A/cm^2
%%
% Densities are used to calculate weigths of copper and core.
dCopper=8.96; %g/cm^3;
dCore=5; %g/cm^3;
%%
% Resistivity of Copper:
pcu=100*1.68*10^(-8);%Ohm.cm
%%
% Skin depth of copper at 100kHz=0.206mm

%%
% When Core area(Ac) is equal to 8.9cm^2, minimum cost occurs. (Obtained by xraytrafoopt.m)
% However core area is rounded to 9cm^2. All the following equations are related to
% core area, since only one variable is to be optimized, by sweeping core area value
% corea area for minumum is obtained.
Ac=9; %cm'2
%%
% Required Turn Number for primary is calcualated according to emf formula
% for square wave. 
Np=Vin*10^4/(4*Bm*Ac*f);  %Ac cm^2 girilmeli
%%
% Required Turn Number for secondary is calcualated by turns ratio. 
Ns=Np*Vout/Vin;
%%
% Primary Current is calculated such that efficiency of the transformer is 95%
eff=0.95;
Ip=Pout/eff/Vin;
%%
% Primary Wire Size is calculated by dividing current by current density
PrimaryWireSize=Ip/J; %cm^2
%%
% Instead of using parallel wires, foil coil is used.
% Foil Coil Thickness is selected to be 0.206 mm which is equal to skin depth. 
FoilCoilThickness=0.206/10; %cm
%%
% Primary foil coil width is calculated by dividing wire size by foil coil
% thickness.
PrimaryFoilCoilWidth=PrimaryWireSize/FoilCoilThickness; %cm
%%
% Winding height is assumed to be 10% more than primary foil coil width.
% Thus for primary side, one wide foil coil is winded around core. Foil
% coil width determines the winding height.
Hwinding=PrimaryFoilCoilWidth*1.1;
%%
% Secondary Current is calculated by dividing output power to output
% voltage.
Is=Pout/Vout;
%%
% Secondary Wire Size is calculated by dividing current by current density
SecondaryWireSize=Is/J; %cm^2
%%
% Secondary foil coil width is calculated by dividing wire size by foil coil
% thickness. Foil coil thickness is same for primary and secondary.
SecondaryFoilCoilWidth=SecondaryWireSize/FoilCoilThickness;
%%
% Since secondary foil coil width is much smaller than winding height, more
% turns are done each level as shown in trafoþekil.ppt.
% Layer Level is defined as number of coils which overlap. It is obtained by
% dividing secondary turn number to the turn number each layer.
SecondaryLayerLevel=Ns/(PrimaryFoilCoilWidth/SecondaryFoilCoilWidth);
%%
% It is assumed that coils are winded from bottom to top in odd levels (i.e
% first) and from top to bottom in even levels (i.e second).
% Voltage over each layer is obtained by dividing output voltage to layer
% level. Thus maximum voltage over each layer is calculated twice of each
% level.
SecondaryVoltageLevelperlayer=Vout*2/SecondaryLayerLevel;
%%
% PCB clearance calculater(html) is used to model required isolation
% between two overlapping windings.
SecondaryIsolationDistance=SecondaryVoltageLevelperlayer*6.4/12500;
%%
% Primary isolation distance is calculated for 417V and used same for each
% overlapping coil.
PrimaryIsolationLength=0.3;
%%
% Winding width is calculated by adding required widths for windings and
% isolation.
% Primary winding width is calculated by multiplying primary turn number by
% sum of required isolation coil thickness.
Wwindingprimary = Np*(FoilCoilThickness+PrimaryIsolationLength);
%%
% Secondary winding width is calculated by multiplying secondary layer level by
% sum of required isolation coil thickness.
Wwindingsecondary = SecondaryLayerLevel*(FoilCoilThickness+SecondaryIsolationDistance);
%%
% 12.5kV isolation distance is put between primary and secondary.
Wwindingprisec= IsolationLengthat12500V;
%%
% Core is assumed to be square. Coils are winded circular. Thus there is gap between
% first coil and core. It is assumed that coil is tangential at cornets of core. 
% This gap is calculated as half of difference between dioganal length of
% core and side length of core. It is added twice.(One for primary, one for secondary. 
Wwindigcore= sqrt(Ac)*sqrt(2);
%%
% All widths are added to find winding width.
Wwinding=Wwindingprimary + Wwindingsecondary + Wwindingprisec + Wwindigcore;
%%
% Winding area is calculated by multiplying height and width.
Aw=Hwinding*Wwinding;
%%
% Mean coil length per turn for primary side is taken is circumferance of 
% wire in the middle point of innermost and outermost coils. 
MeanPrimaryLengthperTurn=((sqrt(Ac)/sqrt(2)+Np/2*(FoilCoilThickness+PrimaryIsolationLength))*2*pi);
%%
% Copper weight for primary side is calculated by mean turn length, 
% primary turn number, coil and density of copper. 
WeightCopperPrimary=Np*FoilCoilThickness*PrimaryFoilCoilWidth*MeanPrimaryLengthperTurn*dCopper; %g
%%
% Secondary coil length per turn and copper weight is calculated in similar way. 
MeanSecondaryLengthperTurn=((sqrt(Ac)/sqrt(2)+SecondaryLayerLevel/2*(FoilCoilThickness+SecondaryIsolationDistance))*2*pi);
WeightCopperSecondary=Ns*FoilCoilThickness*SecondaryFoilCoilWidth*MeanSecondaryLengthperTurn*dCopper; %g
WeightCopper=WeightCopperPrimary+WeightCopperSecondary;
%%
% Mean core length is calculated by using height and width of winding. 
MeanCoreLength=2*(Hwinding+sqrt(Ac)+Wwinding+sqrt(Ac));
%%
% Core volume is calculated by multipliying core area with mean core
% length.
CoreVolume=Ac*MeanCoreLength;
%%
% Core Weight is calculated.
WeightCore=CoreVolume*dCore;
%%
% Cost of transformer is calculated according to cost models describen in [1]
CopperCost=34*WeightCopper/1000+4.5;
CoreCost=WeightCore*5.5/1000;
Cost=CopperCost+CoreCost;
%%
% Core loss graph for P material is given in "Magnetics" datasheet. Core
% loss is calculated by multiplying core volume by value given in
% datasheet.
CoreLoss=CoreVolume*1.05;
%%
% Primary resistance is calculated.
Rp=pcu*MeanPrimaryLengthperTurn*Np/PrimaryWireSize;
%%
% Secondary resistance is calculated.
Rs=pcu*MeanSecondaryLengthperTurn*Ns/(SecondaryWireSize);
%%
% Copper loss is calculated.
CopperLoss=Rp*Ip^2+Rs*Is^2;
%%
% Total loss is calcualated.
Loss=CoreLoss+CopperLoss;
%%
% Actual efficiency is calculated.
eff=Pout/(Loss+Pout);
%%
% Magnetizing inductance value is calculated by using reluctance.
Lmagpri=Np^2*u*(Ac/MeanCoreLength/100);

Ac
MeanCoreLength
WeightCore
Hwinding
Wwinding
Aw
Cost
CopperLoss
CoreLoss
Loss
eff
Rp
Rs
Lmagpri
