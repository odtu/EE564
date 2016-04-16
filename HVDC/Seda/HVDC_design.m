%% HVDC Transformer Design
clc; clear all; close all;
% Design a Transformer with the following specifications:
% Operating Temp: 110, Cooling: ONAN
% In this spec. commonly used oil type transformer
% Design Steps:
% Choose Initial Material,
% Choose Operating Flux Density,
% Determine Core Dimensions & Number of turns,
% Determine Core Losses and Copper Losses,
% Determine operating temp.
% Determine mass, cost etc.
S=6.5*10^6; % VA % Single Phase
Vp=3000; % V;
Vs=300000; % V 
 f=500; % Hz
 w=2*pi*f;
 u=4*pi*10^-7;
turn_ratio=Vp/Vs;
%%  First Step: Choose Initial Material
% For the core material 0.23 mm M3 C type is choosen since losses should be low  when we consider high
% frequency , other material losses are very high.
% Magnetic field intensity calculation
% relative permeability figure
pic = imread('magnetization.png');
figure;
imshow(pic);
B=1.2;  % to decrease the losses flux density is choosen low
Ip=S/Vp; % primary current 
Is=S/Vs; % secondary current 
Np=20; %primary turn number
Ns=Np*100*105/100; %secondary turn number we cross 0.05 because of the voltage drop


%% Calculation of thickness of core leg 
% Vp=E=4.44*f*N*kw*B*Acore  and E=Vt*N so:
kw=0.94; % core stacking factor
Ac=Vp/(4.44*f*Np*kw*B); %m^2
% Acore=2*D(width of core leg)*Eu(thickness of the core leg)
D=0.1; %m^2
Eu=Ac/(2*D); % the factor 1/2 appears because the assembling of every winding of shell type transformer require two cores
core_shape = imread('shell_type_transformer.png');
figure;
imshow(core_shape);

%% wire selection
J=3; % current density
Ap=Ip/J; %mm^2
As=Is/J; %mm^2

%% Skin depth calculation
q=1.68*10^-8; % resistivity of the copper for 20C
Tc=0.0386; % temperature coefficient
skin_dept=sqrt((2*q)/(u*w))*1000;


%% Primary side winding
% it is used 12*6 mm^2 copper stripes it is needed very big area so ý used paralel branch
% and for dimension ý select as 2x-x
% paralel branch 0.5 mm insulation. 0.5*3=1.5mm
copper_area_p=12*6;
paralel_branch=round(Ap/copper_area_p);
core_window_primary=copper_area_p*paralel_branch*Np;  %mm^2


%% Secondary side winding
% awg#8 is enough for secondary side of the transformer
copper_area_s=8.37;
core_window_secondary=copper_area_s*Ns;  %mm^2


%% Window area
% For the window area it is considere primar and seconder winding distance
% for the insulation so there is a constant like ki=0.25
window_area=(core_window_primary+core_window_secondary)/0.25;

% After finding total window area we can take a square core so it can be
% say G=F2

G=round(sqrt(window_area)) %mm
F2=G


%% Loss Calculation









