Vin= 417;
Vout = 12500;
Pout = 30000;
Iout = Pout/Vout;
Bm=0.3;
Ku=0.4;
Kj=366;
f=100000;
eff=0.9;
dCopper=8.96; %g/cm^3;
dCore=5; %g/cm^3;
%skin depth of copper at 100kHz=0.206mm
FoilCoilThickness=0.206/10; %cm
PrimaryIsolationLength=0.3;
IsolationLengthat12500V=6.4;
%SecondaryIsolationLengthat6250V=3.2;
%SecondaryIsolationLengthat3125V=1.6;




Pt=Pout*(1+1/eff);
Ap=((Pt*10^4)/(4*Bm*f*Ku*Kj))^1.16;  %cm^2
Ac=Ap^(0.5);
Np=Vin*10^4/(4*Bm*Ac*f);  %Ac cm^2 girilmeli
Ns=Np*Vout/Vin;
%J=Kj*Ap^(-0.14); %A/cm^2
J=200; %A/cm^2
Ip=Pout/eff/Vin;
PrimaryWireSize=Ip/J; %cm^2
PrimaryFoilCoilLength=PrimaryWireSize/FoilCoilThickness; %cm
Is=Pout/Vout;
SecondaryWireSize=Is/J; %cm^2
SecondaryFoilCoilLength=SecondaryWireSize/FoilCoilThickness;
SecondaryLayerLevel=Ns/(PrimaryFoilCoilLength/SecondaryFoilCoilLength);
SecondaryVoltageLevelperlayer=Vout*2/SecondaryLayerLevel;
SecondaryIsolationDistance=SecondaryVoltageLevelperlayer*6.4/12500;
Hwinding=PrimaryFoilCoilLength*1.1;
Wwinding=Np*(FoilCoilThickness+PrimaryIsolationLength)/Ku+SecondaryLayerLevel*(FoilCoilThickness+SecondaryIsolationDistance)+IsolationLengthat12500V;
MeanPrimaryLengthperTurn=((sqrt(Ac)/sqrt(2)+Np/2*(FoilCoilThickness+PrimaryIsolationLength))*2*pi);
WeightCopperPrimary=Np*FoilCoilThickness*PrimaryFoilCoilLength*MeanPrimaryLengthperTurn*dCopper; %g
MeanSecondaryLengthperTurn=((sqrt(Ac)/sqrt(2)+SecondaryLayerLevel/2*(FoilCoilThickness+SecondaryIsolationDistance))*2*pi);
WeightCopperSecondary=Ns*FoilCoilThickness*SecondaryFoilCoilLength*MeanSecondaryLengthperTurn*dCopper; %g
WeightCopper=WeightCopperPrimary+WeightCopperSecondary;
MeanCoreLength=2*(Hwinding+sqrt(Ac)+Wwinding+sqrt(Ac));
CoreVolume=Ac*MeanCoreLength;
WeightCore=CoreVolume*dCore;
CopperCost=34*WeightCopper/1000+4.5;
CoreCost=WeightCore*5.5/1000;
Cost=CopperCost+CoreCost;

