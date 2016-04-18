Vin = 417;
Vout = 12500;
Pout = 30000;
Bm=0.3;
ur=2500;
u0=4*pi*10^-7;
u=ur*u0;
f=100000;
eff=0.95;
dCopper=8.96; %g/cm^3;
dCore=5; %g/cm^3;
pcu=100*1.68*10^(-8);%Ohm.cm
%skin depth of copper at 100kHz=0.206mm
FoilCoilThickness=0.206/10; %cm
PrimaryIsolationLength=0.3;
IsolationLengthat12500V=6.4;
counter=1;
showpltxu=0;
showpltyu=0;
showpltzu=0;
showpltwu=0;
showpltmu=0;



Ac=0.5;
while(Ac<12)
Np=ceil(Vin*10^4/(4*Bm*Ac*f));  %Ac cm^2 girilmeli
Ns=Np*Vout/Vin;
J=200; %A/cm^2
Ip=Pout/eff/Vin;
PrimaryWireSize=Ip/J; %cm^2
PrimaryFoilCoilWidth=PrimaryWireSize/FoilCoilThickness; %cm
Hwinding=PrimaryFoilCoilWidth*1.1;
Is=Pout/Vout;
SecondaryWireSize=Is/J; %cm^2
SecondaryFoilCoilWidth=SecondaryWireSize/FoilCoilThickness;
SecondaryLayerLevel=Ns/(PrimaryFoilCoilWidth/SecondaryFoilCoilWidth);
SecondaryVoltageLevelperlayer=Vout*2/SecondaryLayerLevel;
SecondaryIsolationDistance=SecondaryVoltageLevelperlayer*6.4/12500;
Wwindingprimary = Np*(FoilCoilThickness+PrimaryIsolationLength);
Wwindingsecondary = SecondaryLayerLevel*(FoilCoilThickness+SecondaryIsolationDistance);
Wwindingprisec= IsolationLengthat12500V;
Wwindigcore= sqrt(Ac)*sqrt(2);
Wwinding=Wwindingprimary + Wwindingsecondary + Wwindingprisec + Wwindigcore;
Aw=Hwinding*Wwinding;
MeanPrimaryLengthperTurn=((sqrt(Ac)/sqrt(2)+Np/2*(FoilCoilThickness+PrimaryIsolationLength))*2*pi);
WeightCopperPrimary=Np*FoilCoilThickness*PrimaryFoilCoilWidth*MeanPrimaryLengthperTurn*dCopper; %g
MeanSecondaryLengthperTurn=((sqrt(Ac)/sqrt(2)+SecondaryLayerLevel/2*(FoilCoilThickness+SecondaryIsolationDistance))*2*pi);
WeightCopperSecondary=Ns*FoilCoilThickness*SecondaryFoilCoilWidth*MeanSecondaryLengthperTurn*dCopper; %g
WeightCopper=WeightCopperPrimary+WeightCopperSecondary;
MeanCoreLength=2*(Hwinding+sqrt(Ac)+Wwinding+sqrt(Ac));
CoreVolume=Ac*MeanCoreLength;
WeightCore=CoreVolume*dCore;
CopperCost=34*WeightCopper/1000+4.5;
CoreCost=WeightCore*5.5/1000;
Cost=CopperCost+CoreCost;
Ac=Ac+0.1;
CoreLoss=CoreVolume*1.05;
Rp=pcu*MeanPrimaryLengthperTurn*Np/PrimaryWireSize;
Rs=pcu*MeanSecondaryLengthperTurn*Ns/(SecondaryWireSize);
CopperLoss=Rp*Ip^2+Rs*Is^2;
Loss=CoreLoss+CopperLoss;
eff=Pout/(Loss+Pout);
Lmagpri=Np^2*u*(Ac/MeanCoreLength/100);
showpltxu(counter)=Ac;
showpltyu(counter)=Cost;
showpltzu(counter)=CoreLoss;
showplttu(counter)=CopperLoss;
showpltmu(counter)=Loss;
counter=counter+1;

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
Np
Ns

end
figure;
plot(showpltxu,showpltyu,'b.-',showpltxu,showpltmu,'r.-')
XLABEL('Ac(cm^2)');
YLABEL('Cost(€)(Blue)    Loss(W)(Red)');
