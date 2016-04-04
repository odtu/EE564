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
Vt=15; % volts per turn
Np=round(Vp/Vt); %primary turn number
Ns=round(Vs/Vt); %secondary turn number


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






