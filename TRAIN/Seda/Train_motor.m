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
 Nsyn=f/(p/2); % synchronous rotor speed in hertz
 Tr=7843;
 Ns=120*f/(p);
s=(Ns-Nr)/Ns;
efficiency=0.95; % Since January 1, 2015: The legally specified minimum efficiency IE3 must be maintained for power ratings from 7.5 kW to 375 kW or an IE2 motor plus frequency inverter. 
power_factor=0.85;

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
B=0.8 %Magneticloading
Cmec=350; 
x=(pi*(pole_p^(1/3)))/pole;
Din=((P/1000)/(Cmec*Nsyn*x))^(1/3); %m
L=x*Din;  %m
Dout=1.78*Din;
pole_pitch=pi*Din/pole; %m
slot_pitch=pole_pitch/(3*q);
Qs=q*m*pole;
Ftan=Tr/(Din/2);
surface_area=pi*Din*L; %m^2
sheer_stress=Ftan/surface_area; %N/m^2
electric_loading=sheer_stress/B;
airgap=(0.1+0.012*(P^(1/3)))/1000; %m

%% Stator Winding

