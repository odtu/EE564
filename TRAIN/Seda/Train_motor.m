%% TRAIN MOTOR DESIGN
%% ID
%%
% *NAME :* Seda KÜL
%  
% *E-mail :* sedakul@gazi.edu.tr

%% Specification and Design Parameter
%
% This project is relevant to design is a traction asynchronous squirrel cage induction motor with the following specifications:
%
% *Rated Power Output: 1280 kW
%
% *Line-to-line voltage: 1350 V
%
% *Number of poles: 6
%
% *Rated Speed: 1520 rpm (72 km/h) (driven with 78 Hz inverter)
%
% *Rated Motor Torque: 7843 Nm
%
% *Cooling: Forced Air Cooling
%
% *Insulating Class: 200
%
% *Train Wheel Diameter: 1210 mm
%
% *Maximum Speed: 140 km/h
%
% *Gear Ratio: 4.821
%
% The main idea of design motor is to obtain the dimensions of all parts of
% the motor in order to supply these data to the manufacturer. The outcomea
% of the project are like this:
%
% *Material Properties, Frame size etc.
%
% *Magnetic Circuit Details (flux density calculations at various points: air-gap, teeth, back-core etc, magnetic loading)
%
% *Electric Circuit (Winding selection, electric loading, fill factor, phase resistance, winding factors (for fundamentalsn and for harmonics))
%
% *Rough thermal calculations (cooling method, operating temperature, ways to improve cooling)
%
% *Efficiency, current, torque characteristics
%
% *Mass Calculations (structural mass, copper mass, steel mass etc)
%
P=1280000;
V=1350;
 pole=6;
 pole_p=pole/2;
 m=3; % phase number
 q=4;
 Nr=1520;
 f=78;
 Nsyn=f/(pole/2); % synchronous rotor speed in hertz
 Tr=7843;
 Ns=120*f/(pole);
s=(Ns-Nr)/Ns;
efficiency=0.91; % Since January 1, 2015: The legally specified minimum efficiency IE3 must be maintained for power ratings from 7.5 kW to 375 kW or an IE2 motor plus frequency inverter. 
power_factor=0.85;

eff = imread('efficiency_table.png');
figure;
imshow(eff);

% Define the magnetic loading and electric loading
% 
% Define the Diameter and axial length
% 
% Define the Airgap
% 
% Winding Type and number of coils
% 
% Determination of other dimensions (slot, tooth etc.)
% 
% Calculation of machine performance
% 
% Lots of iteration/optimization

%% Main Dimension of Stator Core

cmec = imread('Cmech.png');
figure;
imshow(cmec);

Cmec=350; 
x=(pi*(pole_p^(1/3)))/pole;
Din=((P/1000)/(Cmec*Nsyn*x))^(1/3); %m
L=x*Din;  %m

ratio = imread('Do_Di_ratio.png');
figure;
imshow(ratio);

Dout=1.78*Din;
Qs=q*m*pole;
Ftan=Tr/(Din/2);
surface_area=pi*Din*L; %m^2
sheer_stress=Ftan/surface_area; %N/m^2
B=0.8 %Magneticloading
electric_loading=sheer_stress/B;
% airgap=1.6*(0.1+0.012*(P^(1/3)))/1000; %m

% For converter driven motors airgap can be increased by 60 % to reduce rotor surface losses. (from the leture notes)
airgap=1.6*(0.18+0.006*P^(0.4))

%% Stator Winding

slot_number = imread('stator and rotor slot number.png');
figure;
imshow(slot_number);

Qs=q*m*pole;

electrical_angle=(2*pi*pole_p)/Qs
format rat
electrical_angle_rad=electrical_angle/pi
format short

%%
% Winding Factor
%
% Total winding factor (kw) consist of distribution factor (kd) and pitch
% factor (kp). To eliminate 9.harmonik chording factor is selected 7/9
chording_factor=7/9;
Kd=sin(pi/(2*m))/(q*sin(pi/(2*m*q)));
Kp=sin((pi/2)*chording_factor);   
Kw=Kd*Kp;

pole_pitch=pi*Din/pole; %m
slot_pitch=pole_pitch/(3*q);
%% Outputs

