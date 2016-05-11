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

mag_flux= imread('magnetic_flux_value.png');
figure;
imshow(mag_flux);

matris=[];

for Bg=0.7:0.01:0.9

% the lengthening of the machine caused by the edge field can be approximated by the equation l' ? l + 2?.
Le=L+(2*airgap)/1000;
area_of_one_pole=pi*Din*Le/pole;  %m^2

%inductionmotors, both the stator and rotor teeth are saturated at the peak value of the flux density.
% This leads to a higher reluctance of these teeth when compared with other teeth, and thus
% ?i takes notably higher values than the value corresponding to a sinusoidal distribution. The
% factor ?i (2/pi)has to be iterated gradually to the correct value during the design process. The value
% ?i = 0.64 of an unsaturated machine can be employed as an initial value, unless it is known
% at the very beginning of the design process that the aim is to design a strongly saturating machine,
% in which case a higher initial value can be selected.

fundamental_magnetic_flux=(2/pi)*Bg*Le*area_of_one_pole; %Wb
flux=pole_pitch*Le*Bg
alfa_u=pole*pi/Qs

format rat
alfa_u_rad=alfa_u/pi
format short

%from the E=4.44*f*N*kw*magnetic_flux we can find turn number

N=(V/3^(1/3))/(4.44*Kw*f*fundamental_magnetic_flux);

a1=1  %number of current path in parallel
conductor_per_slot=N/(pole_p*q);
number_of_conductor_per_slot=ceil(conductor_per_slot);

N_new=number_of_conductor_per_slot*pole_p*q

Bg_new=Bg*(N/N_new)
    matris=[matris Bg_new]

if Bg_new>0.7
    break; 
end

end

Irated=P/(efficiency*power_factor*V*3^(1/3));

% J=5-8 A/mm^2 for 2p=6,8

J=7;

Ac=Irated/J;
d_copper=sqrt(4*Ac/pi);

% because of the skin effect we use paralel conductors. 
parallel_branch=12;

d_copper_new=sqrt(4*Ac/(pi*parallel_branch)); % after recalculated diameter of the wire 
% awg#11 is enough for size
awg_size=[107,85,67.4,53.5 42.4,33.6,26.7,21.2,16.8,13.3,10.6,8.37,6.63,5.26,4.17,3.31,2.63,2.08,1.65,1.31,1.04,0.82,0.653,0.518]%tablo
fark=d_copper_new-awg_size% fark dizisi
[minimum,indis]=min(farklar)% farklarýn en yakinireferansa en yaki
deger=awg_size(indis)



%% Outputs

