%given parameters
Pout = 215; %[kW]
Torque_rated = 220; %[Nm]
rated_speed = 6000; %[rpm]
m = 3; % [-] three phase
Is1 = 350; % [A] driver rated phase current
% assumed
neff = 0.96; %[-] efficiency
powerfactor = 0.88; %[-] power factor

%main dimensions
p1 = 2; %[-] pole pair
Pmech = Pout; %[kW] mechanical power 
Pmech_pp = Pmech / (2*p1); %[kW] mechanical power per pole
Cmech = 220; %[kWs/m^3] from graph
f1 = rated_speed*2*p1/120; %[Hz] fund. freq.
nysn_mech = f1 / p1; % [Hz] synchronous mech. freq. 
aspect_ratio = pi*p1^(1/3)/(2*p1); %[-] aspect ratio x = L / Dis
Dis = (Pmech/(Cmech*aspect_ratio*nysn_mech))^(1/3); %[m] inner stator diameter
L = aspect_ratio*Dis; %[m] length of the motor
Ftan = Torque_rated/(Dis/2); %[N] tangential force
stress_tan = Ftan / (pi*Dis*L); %[N/m^2] pascal tangential stress
out_in_ratio = 1.88; %[-] for 4pole m/c Dout/Dis
Dout = Dis*out_in_ratio; %[m] outer diameter of the stator
air_gap = 0.18+0.006*(Pmech*10^3)^0.4; %[mm]
safety_factor = 1.2;    %[-]
air_gap = air_gap*safety_factor; %[mm]

%stator winding
min_slot_pitch = 0.007; %[mm] recommended min. slot pitch for induction m/c
max_slot_pitch = 0.045; %[mm] recommended max. slot pitch for induction m/c
Qs_max = pi*Dis/(min_slot_pitch); %[-] max. possible stator number
Qs_min = pi*Dis/(max_slot_pitch); %[-] min. possible stator number
pitch_ratio = 5/6; %[-] pitch ratio to supress 5th and 7th harmonics
Qs = 48; %[-] stator slot number should be multiple of 2*p1*m
q = Qs / (2*p1*m); %[-] slots per pole per phase
lambda = pitch_ratio*180; %[°] pitch angle
kp1 = sind(lambda/2); %[-] pitch factor
alpha = 180/(Qs/(2*p1)); % [°] slot angle
kd1 = sind(q*alpha/2)/(q*sind(alpha/2)); %[°] distribution factors
kw1 = kp1*kd1; %[-] winding factor

Bg = 0.8; %[T] air gap initial set tesla peak value
fluxg_pp = Bg*(2/pi)*pi*Dis*L/(2*p1); %[weber] airgap flux per pole

Pin = Pout / neff; %[kW] input power
Vph = Pin*10^3 / (m*Is1*powerfactor); %[V] phase voltage in rms
Nph_req = sqrt(2)*Vph /(kw1*2*pi*f1*fluxg_pp); % [-] req. number of turn phase

turns_coil = 1; %[-] number of turns per coil
Nph = p1*q*turns_coil*2; %[-] min. turn per phase
Bg_res = Bg*Nph_req/Nph; %[T] air gap result with Nph
fluxg_pp_res = Bg_res*pi*Dis*L/(2*p1); %[weber] airgap flux per pole


J = 3.25; %[A/mm^2] current density
Ac = Is1/J; %[mm^2] copper area
dco = sqrt(4*Ac/pi); %[mm] diameter of the copper
ap = 4; % [-] number of strand
dco_ap = sqrt(4*Ac/(pi*ap));
% lets use AWG4 size where diameter is 5.19mm

% stator slot sizing
kfill = 0.4; %[-] slot fill factor
Aslot = pi*(dco_ap^2)*ap/4*turns_coil*2*(1/kfill); %[mm^2]requiered slot area

%stator tooth flux density
Bts = 1.625; %[Tesla] stator tooth flux density
slot_pitch = pi*Dis/Qs; %[m] slot pitch 
L_eff = L + (2*air_gap*10^-3); %[m] effective air gap
kfe = 0.95; %[-] stacking factor
bts = Bg_res*slot_pitch*L_eff/(Bts*L*kfe); %[m] stator tooth width

%stator back core flux density
Bcs = 1.55; %[Tesla] stator back core flux density
hcs = (fluxg_pp_res/2)/(Bcs*kfe*L); %[m] stator back core height

%roughly estimate stator slot size
safety_back_core = 1.0;
hs = (Dout-Dis)/2 - hcs*safety_back_core; %[m] stator slot height
bs = (Dis/2+hs/2)*2*pi/Qs-bts; %[m] stator slot width (top+bottom/2, mid value)
As_res = hs*bs*10^6; %[mm^2] slot area result
kfill_res = Aslot/As_res*kfill; %[-]

%rotor slots
Qr = Qs + 2*2*p1; %[-] rotor slot number by assuming 1 skew slot at rotor
Ib = 2*m*Nph*kw1*Is1/Qr; %[A] bar current
Jb = 3.42; %[A/mm^2] current density of the bar
Ab = Ib/Jb; %[mm^2] bar area i.e. rotor slot area

%rotor tooth flux density
Btr = 1.675; %[Tesla] rotor tooth flux density
rotor_pitch = pi*(Dis-2*air_gap*10^-3)/Qr; %[m] rotor pitch
btr = Bg_res*rotor_pitch*L_eff/(Btr*kfe*L); %[m] rotor tooth width

%rotor back core flux density
Bcr = 1.5; %[Tesla]rotor back core flux density
hcr = (fluxg_pp_res/2)/(Bcr*kfe*L); %[m] rotor back core height

%roughly rotor slot sizes
safety_rotor_area = 1.0;
br = rotor_pitch - btr; %[m] rotor slot width
hr = Ab*safety_rotor_area*10^-6/br; % [m] rotor slot height

%shaft diameter
dshaft = Dis-(2*air_gap*10^-3)-(2*hr)-(2*hcr); %[m] shaft diameter

%end ring
Jer = 0.75*Jb; %[A/mm^2] end ring current density
Ier = Ib / (2*sind(180*p1/Qr)); %[A]end ring current
Aer = Ier / Jer; %[A/mm^2] end ring cross section
b = (hr+br)*10^3; %[mm] height of the Aer
a = Aer/b; %[mm] width of the Aer

