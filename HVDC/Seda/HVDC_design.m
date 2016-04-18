%%  HVDC Transformer Design

%% Specification
S=6.5*10^6; % VA % Single Phase
Vp=3000; % V;
Vs=300000; % V 
 f=500; % Hz
 w=2*pi*f;
 u=4*pi*10^-7;
turn_ratio=Vp/Vs;
lamination_factor=0.94;
winding_factor=0.25;
%%  Choose Initial Material
% For the core material 0.23 mm M3 C type is choosen since losses should be low  when we consider high
% frequency , other material losses are very high.
% Magnetic field intensity calculation
% relative permeability figure

pic = imread('magnetization.png');
figure;
imshow(pic);

B=1.2;  % to decrease the losses flux density is choosen low
mass_density=7.65 %kg/dm^3
Ip=S/Vp; % primary current 
Is=S/Vs; % secondary current 
Np=20; %primary turn number
Ns=Np*100*105/100; %secondary turn number we cross 0.05 because of the voltage drop

%% Calculation of Thickness of Core Leg 
% Vp=E=4.44*f*N*kw*B*Acore  and E=Vt*N so:
kw=0.94; % core stacking factor
Ac=Vp/(4.44*f*Np*kw*B); %m^2
% Acore=2*D(width of core leg)*Eu(thickness of the core leg)
D=0.1; %m^2
Eu=Ac/(2*D); 

% The factor 1/2 appears because the assembling of every winding of shell type transformer require two cores

core_shape = imread('shell_type_transformer.png');
figure;
imshow(core_shape);

%% Wire Selection
J=3; % current density
Ap=Ip/J; %mm^2   primary conductor area
As=Is/J; %mm^2    secondary conductor area

%% Skin depth calculation
q=1.68*10^-8; % resistivity of the copper for 20C
Tc=0.0386; % temperature coefficient
skin_dept=sqrt((2*q)/(u*w))*1000;

%% Primary side winding
% it is used 12*6 mm^2 copper stripes it is needed very big area so ý used paralel branch and for dimension ý select as 2x-x paralel branch 0.5 mm insulation.
copper_area_p=12*6;
paralel_branch=round(Ap/copper_area_p);
copper_window_primary=copper_area_p*paralel_branch*Np;  %mm^2


%% Secondary side winding
% awg#8 is enough for secondary side of the transformer
copper_area_s=8.37;
copper_window_secondary=copper_area_s*Ns;  %mm^2
diameter_secondary_winding=sqrt(As*4/pi)

%% Window area
% For the window area it is considere primar and seconder winding distance for the insulation so there is a constant like fill factor=0.25
window_area=(copper_window_primary+copper_window_secondary)/winding_factor;

% After finding total window area we can take a square core so it can be say G=F2

G=round(sqrt(window_area)); %mm

F2=G;

winding_pitch_primary=G+[(Eu*1000)*(copper_window_primary/window_area)];

winding_pitch_secondary=G+[(Eu*1000)*(copper_window_secondary/window_area)];

%% Resistance of the primary and secondary conductors
L_primary=pi*winding_pitch_primary*Np
R_p=0.6;
R1=[(R_p*L_primary)/1000]/paralel_branch; %mohm


L_secondary=pi*winding_pitch_secondary*Ns
R_s=2.061;
R2=(R_s*L_secondary)/1000 %mohm

%% Magnetizing and Leakage Inductance 

% for this part we use B-H curve shown in figure1 to calculate permeability
% (mu). From the datasheet for the B=1.2T match up to H=22 A/m mu=0.058
permeability=0.058;
L=[2*(F2+G+2*Eu*1000)]/1000; %length
reluctance=L/(permeability*Ac);
Lm=Np^2/reluctance;  %H
Xm=2*pi*f*Lm;


%% Core Mass
core_volume=Ac*4*((F2/1000)+Eu) %m^3

Mc=core_volume*mass_density*1000 %kg


%% Loss Calculation

% To calculate core loss Steinmetz'e equation (Pcore=k*(f^a)*(B^b)) is used
% from the catalog 100 Hz and 200 Hz core loss value is chosen and by using
% this value 'a' is found.

% core loss:
P_core_100=1.2  %W/kg

P_core_200=3.4  %W/kg

a=[log(P_core_100/P_core_200)]/[log(100/200)];

P_core_500=((500/100)^a)*P_core_100 % W/kg

% copper loss:

copper_loss_p=R1*Ip^2/1000
copper_loss_s=R2*Is^2/1000

total_copper_loss=copper_loss_p+copper_loss_s

total_loss=total_copper_loss+P_core_500;

%% Efficiency

P_out=S*0.96
efficiency=P_out/(P_out+total_loss);



