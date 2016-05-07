%% EE564 - Design of Electrical Machines
%% Project-2: Traction Motor Design
%% Name: Mesut Uður
%% ID: 1626753

%%
% Specifications
%%
% Traction asynchronous squirrel cage induction motor
%%
% Rated Power Output: 1280 kW
%%
% Line-to-line voltage: 1350 V
%%
% Number of poles: 6
%%
% Rated Speed: 1520 rpm (72 km/h) (driven with 78 Hz inverter)
%%
% Rated Motor Torque: 7843 Nm
%%
% Cooling: Forced Air Cooling
%%
% Insulating Class: 200
%%
% Train Wheel Diameter: 1210 mm
%%
% Maximum Speed: 140 km/h
%%
% Gear Ratio: 4.821
%%
% Duty: ?
%%
% Enclosure: ?
%%
% Efficiency: IE3, premium efficiency: 96 %
%%
% Efficiency: IE4, super premium efficiency: 97 %
%%
% Power factor: ?
%%
% IP54??
%%
% Class 200
%%
% N
%%
% Average winding temp rise: 130 degree C
%%
% Hot spot temp rise: 160 degree C
%%
% Maximum winding temp: 200 degree C

%%
% Design Inputs
Prated = 1280e3; % watts
pole = 6;
pole_pair = pole/2;
phase = 3;
Vrated = 1350; % volts line-to-line
Nrated = 1520; % rpm
frated = 78; % Hz
vrated = 72; % km/h
vmax = 140; % km/h
Trated = 7843; % Nm
wheel_dia = 1.21; % m
gear_ratio = 4.821;
power_factor = 0.86; % assumed (not a given data)
efficiency = 0.965; % assumed (not a given data)

Nsync = 120*frated/pole;
wrated = Nrated*2*pi/60; % rad/sec
torque = Prated/wrated; % Nm
% cmech is between 310 and 250
Cmech = 300; % kWs/m^3
fsync = 2*frated/pole; % Hz
d2l = Prated*1e-3/(Cmech*fsync); % m^3
aspect_ratio = (pi/pole)*(pole_pair)^(1/3);
inner_diameter = (d2l/aspect_ratio)^(1/3); % m
length = inner_diameter*aspect_ratio; % m
inner_radius = inner_diameter/2; % m
Ftan = torque/inner_radius; % N
surface_area = pi*inner_diameter*length; % m^2
sheer_stress = 1e-3*Ftan/surface_area; % kPa
outer_diameter = 1.87*inner_diameter; % for 6 pole
% %60 increase for heavy duty
air_gap_distance = 1.6*(0.18+0.006*Prated^0.4); % mm
circumference = pi*inner_diameter; % m

magnetic_loading = 0.9; % T
electric_loading = sheer_stress/magnetic_loading; % kA/m

% Electrical loading is checked from Table 6.2 of book
% Tangential stress is checked from Table 6.3 of book


%%
% Choose:
inner_diameter = 0.6; % m
outer_diameter = 1.12; % m
length = 0.45; % m
air_gap_distance = 3; % mm
surface_area = pi*inner_diameter*length; % m^2
inner_volume = inner_diameter^2*length*pi/4; % m^3
circumference = pi*inner_diameter; % m

%%
% Check
Ftan = torque/inner_radius; % N
tan_stress = Ftan/surface_area; % p
Cmech = Prated*1e-3/(inner_diameter^2*length*fsync); % kWs/m^3

%%
% Slot number selection:
% slot_pitchs are 7-45 mm for asynchronous m/cs
maximum_slot = circumference/0.007;
minimum_slot = circumference/0.045;

integer_multiple = phase*pole;
for k = 1:10
    Qs = integer_multiple*k;
    qs = Qs/(pole*phase);
    if Qs<maximum_slot && Qs>minimum_slot 
        fprintf('%d number of stator slots is available, qs = %d\n',Qs,qs);
    end
end

% Select Qs = 72 for the first iteration
Qs = 72;
qs = Qs/(pole*phase);
stator_slot_pitch = circumference/Qs; % m

% stator will be double layer for harmonic elimination
stator_layer = 2;
% Select pitch factor as 4/5pi electrical for 5th harmonic elimination
pitch_angle = 4*pi/5; % radians electrical
slot_angle = pi/qs/phase; % radians electrical

%%
% Stator winding factor (fundamental)

[kd,kp,kw] = winding_factor_calc(slot_angle,qs,pitch_angle);
kd1 = kd(1);
kp1 = kp(1);
kw1 = kw(1);

%%
% selected flux densities (book, page: 283)
Bgap = 0.9; % T
Bsyoke = 1.6; % T
Bstooth = 1.9; % T
Bryoke = 1.6; % T
Brtooth = 2.0; % T

%%
% stator slot current
Iu = stator_slot_pitch*electric_loading*1000; % amps
% number of turns per phase
Erms = Vrated/sqrt(2); % volts
flux_per_pole = 4*inner_radius*length*Bgap/pole; % weber
Nph = Erms/(4.44*frated*flux_per_pole*kw1);
Nph_min = qs*pole*stator_layer/2;
% if 24 turns per phase is used, either of l,r or Bgap should be increased
% if 48 turns per phase is used, either of l,r or Bgap should be decreased
% in the first design, Nph = 48 is selected
Nph = 48; % turns
flux_per_pole = Erms/(4.44*frated*Nph*kw1);
Bgap = flux_per_pole*pole/(4*inner_radius*length); % weber

% stator number of turns per slot
zQ = 2*Nph/(qs*pole*stator_layer); % turns


%%
% Rotor slot number

Qr = (6*qs+4)*pole_pair; % eqn 7.115 of the book
avoid_rotor_slot(Qr,Qs,pole_pair);
for k = 1:10
    Qr = k*pole*phase;
    a = avoid_rotor_slot(Qr,Qs,pole_pair);
    if a == 1
        fprintf('%d rotor slot number is usable\n',Qr);
    end
end

% In the book, 96,90,84 and 54 are suggested with one stator slot skew
% Table 7.5
Qr = 90;
qr = Qr/(pole*phase);
% harmful synchronous torque at steady state


%%
% stator winding selection
fmax = vmax/vrated*frated; % Hz
% Normally, since the motor is to be driven by an inverter, the switching
% frequency and corresponding harmonics should be taken into account for
% skin effect. In this 1st iteration, only fundamental frequency will be
% considered.
Pin = Prated/efficiency; % watts
Irated = Pin/(sqrt(3)*Vrated*power_factor); % amps
% from awg wire table: AWG gauge starting from 000 is suitable considering
% the frequency constraint (skin effect)
% Select AWG wire gauge 000 which has a current rating of 239 amps
wire_current = 239; % amps
wire_diameter = 10.404; % mm
stator_strand = ceil(Irated/wire_current);
% three strands are required
wire_area = (wire_diameter/2)^2*pi; % mm^2
stator_current_density = Irated/wire_area; % A/mm^2
% for a 6-pole machine, J = 7.76 is in the acceptable limits


%%
% Stator slot sizing
stator_fill_factor = 0.44; % selected from the design example notes
useful_slot_area = wire_area*stator_strand*zQ*stator_layer; % mm^2
stator_slot_area = useful_slot_area/stator_fill_factor; % mm^2
stator_stacking_factor = 0.96;
Bteeth = 1.6; % Tesla
stator_slot_thickness = 1e3*(Bgap*stator_slot_pitch)/(Bteeth*stator_stacking_factor); % mm
Tus = stator_slot_pitch*1e-3; % mm 
bts = stator_slot_thickness; % mm
bos = 4; % mm
hos = 2; % mm
hw = 3; % mm
bs1 = pi*(inner_diameter*1e3+2*hos+2*hw)/Qs-bts; % mm
bs2 = sqrt(4*useful_slot_area*tan(pi/Qs)+bs1^2); % mm
hs = 2*useful_slot_area/(bs1+bs2); % mm
hcs = (1e3*outer_diameter-(1e3*inner_diameter+2*(hos+hw+hs)))/2; % mm
Bcs = flux_per_pole/(2*length*hcs*1e-3); % T
Bcs_new = 1.45; % Tesla
hcs_new = flux_per_pole/(2*length*Bcs_new)*1e3; % mm
outer_diameter_new = (2*hcs_new+(1e3*inner_diameter+2*(hos+hw+hs)))*1e-3; % m


%%
% Rotor slots
KI = 0.8*power_factor+0.2;
rotor_bar_current = KI*2*phase*Nph*kw1*Irated/Qr; % amps
Jrotor = 6; % A/mm^2
rotor_slot_area = rotor_bar_current/Jrotor; % mm^2
end_ring_current = rotor_bar_current/(2*sin(2*pi/Qr)); % A
Jer = 0.78*Jrotor; % A/mm^2
end_ring_area = end_ring_current/Jer; % mm^2
rotor_slot_pitch = pi*(1e3*inner_diameter-2*air_gap_distance)/Qr; % mm
Btrotor = 1.6; % T
KFE = stator_stacking_factor;
btr = Bgap*rotor_slot_pitch/(KFE*Btrotor); % mm

hor = 1; % mm
bor = 3; % mm
d1 = (pi*(1e3*inner_diameter-2*air_gap_distance-2*hor)-Qr*btr)/(pi+Qr); % mm
d2 = d1/4; % mm
hr = 4*d1; % mm


% Dimensions

%rotor_slot_number
%slot_teeth_dimension
% stator_slot_height
%slot_teeth_dimension
% rotor_slot_height
%winding_diagram

