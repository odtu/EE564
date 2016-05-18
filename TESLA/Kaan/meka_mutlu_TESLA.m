%% EE564 First Project II: TESLA Model S Induction Motor
%% ID
%%
% *NAME :* Mehmet Kaan Mutlu
%  
% *STUDENT NUMBER :* 2121408
%  
% *E-mail :* kaan.mutlu@metu.edu.tr

function []=meka_mutlu_TESLA()

%% Specifications 
%%
% In this project, design of the induction motor that is used in *Tesla
% Model S*. Normally it has different variations, to  keep things simple;
% *RWD 85 Model* will be used that has the following specs: 
%  
% * *Maximum Power:* 270 kW
Pmax = 270*10^3; % [W]
%%
% * *Maximum Torque:* 441 Nm
% * *Top Speed:* 225 km/h  

%%
% Except for these given specs, these are also found from internet:
%  
% * *Number of poles:* 4
p = 4/2; %pole_pairs
%%
% * Maximum RPM value of our motor is 21848 RPM. This value is calculated
% by considering Tesla Model S has 21' tires and 9.73 to 1 gear ratio.
Spd_rpm_max = 21848; %[RPM]
%%
%  
% If we assume average speed is 85 km/h. Then rated RPM value of motor will
% be 7960 RPM.
Spd_rpm_rated = 7960; %[RPM]
f_rated = round(Spd_rpm_rated*p/60);
fprintf('In this case supply frequency will be %d Hz.',f_rated)
%%
% * *Number of phases:* 3
m = 3;
%%
% * *Line supply voltage:* 400 V
Vline = 400;
%%
% * *Rated Power:* 185 kW
Prated = 185*10^3; % [W]

%% Main Dimensions of Stator Core

%%
% Boldea's The Induction Machine Handbook is going to be used to determine
% parameters and dimensions of motor. In Chapter 15, it is explained that
% $D_{is}^2L$ output constant concept will be used. For internal stator
% diameter formula below will be used:
%  
% $D_{is}^{3} = \frac{2pp_1S_{gap}}{\pi \lambda fC_0}$
%  
% To be able to calculate $D_{is}$, airgap power is needed.
Aimed_eff = 0.95;
Aimed_pf = 0.89;
fprintf('At this point targeted efficiency is taken as %2.0f %%.',Aimed_eff*100)
%% 
fprintf('Power factor is taken as %0.2f %.',Aimed_pf)

%%
% Another required parameter to be able to calculate airgap power is Ke
% that is defined as E1 to Vin ratio in equation 14.8.
%  
% $K_E \approx 0.98 -0.005p_1$
%
Ke = 0.98- 0.005*p;

%%
% Now everything is ready for airgap apparent power:
%  
% $S_{gap} =\frac{K_EP_n}{\eta_ncos\Phi}$
% 
Sgap = Ke*Prated/(Aimed_eff*Aimed_pf);
fprintf('Airgap power is calculated as %3.1f KVA.',Sgap/1000)

%%
% After this calculation, missing parameters are stack aspect ratio and
% Esson's constant Co.
% Stack aspect ratio is selected from table below:
% 
% <<stack_aspect_ratio.PNG>>

stck_asp_ratio = 1.5;
fprintf('It is selected as %1.1f.',stck_asp_ratio)
%%
% Esson's constant is selected using Figure 14.14. 
% 
% <<Essons_constant.PNG>>
%  
% Because our calculated airgap power is out of figure's range it isn't 
% possible to read a certain value but for two pole-pairs after 60 kVA 
% Esson's constant starts to saturate and for our airgap apparent power 
% this value is taken as 240 J/dm^3.

Co=240*10^3; %[J/m^3]
%%
% Now we are ready to calculate internal stator diameter:

Dis = ((2*p*p*Sgap)/(pi*stck_asp_ratio*f_rated*Co))^(1/3);
fprintf('Internal diameter of stator is calculated as %2.3f cm.',Dis*100)
%% 
Dis = (ceil(Dis*1000))/1000;
fprintf('For realistic dimensions it is going to be taken as %2.1f cm.',Dis*100)
%%
% Now we can calculate stack length, deriving its formula from equation
% 15.2:
% 
% $L = \frac{\lambda \pi D_{is}}{2p}$

L = stck_asp_ratio*pi*Dis/(2*p);
fprintf('Stack length L is %2.2f cm.',L*100)
%%
L = (ceil(L*1000))/1000; %[m]
fprintf('For being realistic it is going to be taken as %2.1f cm.',L*100)
%%
% By using equation 14.14 it is possible to calculate the pole pitch:
%  
% $\tau = \frac{\pi D_{is}}{2p}$

pole_pitch = pi*Dis/(2*p); %[m]
fprintf('Pole pitch is %2.2f cm.',pole_pitch*100)
%%
% Next step is deciding external stator diameter. For its calculation,
% table below will be used.
% 
% <<Dout_ratio.PNG>>
% 
% It gives us information about ratio of internal and external stator
% diameters. For 4 poles this ratio will be taken as 0.61.

Kd = 0.61;
Dout = Dis / Kd;
fprintf('External diameter of stator is calculated as %2.3f cm.',Dout*100)
%%
Dout = (ceil(Dout*1000))/1000;
fprintf('For realistic dimensions it is going to be taken as %2.1f cm.',Dout*100)
%%
% For suitable airgap calculation book's equation of 14.38 may be used as
% well as the equation defined during the EE564 lecture of 6th April. Here
% it is important to remind that the minimum airgap is 0.2 mm.
%  
% Formula discussed in the lecture is as follows:
%  
% $airgap =0.18 + 0.006P^{0.4} mm$
%  
% Book equation of 14.38 is
%  
% $airgap =0.1+ 0.012P^{\frac{1}{3}} mm$
%  
% As known, too small airgap would produces large space airgap field
% harmonics and additional losses while a too large one would reduce the
% power factor and efficiency. Therefore, average of these two calculated
% airgap values will be used as actual airgap value.
g_lecture = (0.18 + 0.006*Prated^0.4)*10^-3;
g_book = (0.1 + 0.012*Prated^(1/3))*10^-3;
g=(g_lecture+g_book)/2;
fprintf('Airgap is calculated as %0.4f mm.',g*1000)
%%
g=(ceil(g*10^5))*10^-5;
fprintf('For being realistic it is going to be taken as %0.2f mm.',g*1000)
%% The Stator Winding

%%
% Following James Hendershot's lecture notes, for 4 poles and 185 kW of
% rated power Stator slot number will be selected. Our rated power is
% nearly 250 HP and from table below, it is advised to choose 58 stator
% slots for our case.
%  
% <<Ns.PNG>>
%  
% Here we should remember that the total number of slots per stator should
% be divisible by the number of phases. So it should be a number that is
% multiple of 3.
%  
% $q = \frac{N_s}{2pm}$ 
%  
% If we think about its formula above (taken from book; 4.7), it is 
% possible to see that choosing Ns/m integer doesn't guarantee that q is 
% an integer. In fact it doesn't have to be an integer and may be selected 
% as a fraction. But in most induction machines, q is an integer to 
% provide complete (pole to pole) symmetry for the winding. So in our case 
% Ns must be multiple of 2pm=12. Advised number is 58, so Ns would be taken 
% as 60. It was tried and seen that number of conductors, flux density and 
% other parameteres don't meet the expectations. So it is going to be taken
% as 48.
Ns = 48;
q = Ns/(2*p*m);
fprintf('Number of slots per pole per phase is %d .',q)
%%
% Now we should decide pitch factor. It can be selected as 5/6 to reduce
% 5th harmonic and reduce 7th harmonics. So two layered winding  with 
% chorded coils will be used.
pitch_factor = 5/6;
ang_pitch = pitch_factor*180; % [degree]
ang_pitch_rad = pitch_factor*pi; % [radian]
fprintf('Selected pitch angle is %d degree .',ang_pitch)
%%
% It is possible to calculate the electrical angle between emfs in 
% neighboring slots $\alpha_{ec}$
%  
% $\alpha_{ec}=\frac{2 \pi p}{N_s}$
ang_electrcl_rad = 2*pi*p/Ns;
ang_electrcl_deg = ang_electrcl_rad/pi*180;
fprintf('It is %0.3f radian means %d degree.',ang_electrcl_rad,ang_electrcl_deg)
%%
% Now we can calculate pitch factor. Due to chorded coils of stator,induced 
% voltage will drop but by means of harmonics we will have better results.
%  
% $k_p = sin(\frac{\lambda}{2})$
%  
kp = sin(ang_pitch_rad/2);
fprintf('Pitch factor is calculated as %0.2f .',kp)
%%
% Using formula below it is possible to calculate distribution factor.
%  
% $k_d = \frac{sin(q\frac{\alpha}{2})}{qsin\frac{\alpha}{2}}$
%  
kd = sin(q*ang_electrcl_rad/2)/(q*sin(ang_electrcl_rad/2));
fprintf('Distribution factor is calculated as %0.2f .',kd)
%%
% Multiplicaiton of distribution and pitch factors are called as winding
% factor.
kw = kp * kd;
fprintf('Winding factor is calculated as %0.2f .',kw)
%%
% Using recommended intervals given in 15.11, it is possible to select the
% airgap flux density. For 4 poles suggested interval is 0.65 to 0.78
% Tesla. To decrease iron losses minimum of this interval will be taken as
% airgap flux density.
Bg = 0.7; %[T]
%%
% The pole coefficient $\alpha_i$ and form factor Kf depend on the tooth 
% saturation factor 1+Kst. If 1+Kst is taken as 1.4 than Kst is 0.4.
Kst = 0.4;
%%
% Using this value and graph below, it is possible to select form factor
% and flux density shape factor.
%  
% <<kf_alphai.PNG>>
%  
alpha_i = 0.729;
kf = 1.085;
fprintf('Form factor is selected as %1.3f .',kf)
%%
fprintf('Flux density shape factor is selected as %0.3f .',alpha_i)
%%
% Using these coefficients it is possible to calculate pole flux.
%  
% $\phi = \alpha_i \tau L B_g$
% 
pole_flux=alpha_i*pole_pitch*L*Bg; % [Wb]
fprintf('Pole flux is calculated as %1.3f mWb.',pole_flux*1000)
%%
% The number of per phase can be calculated using formula below given with
% (15.12).
%  
% $N_{ph} = \frac{K_EV_{ph}}{4K_fK_wf\phi}$
% 
Nph = Ke*(Vline/(sqrt(2)))/(4*kf*kw*f_rated*pole_flux);
fprintf('The number of turns per phase is calculated as %3.1f turns/phase.',Nph)
%%
% The number of conductors per slot ns can be calculated using formula
% below:
%  
% $n_s = \frac{a_1N_{ph}}{p_1q}$
%  
% Here a1 ise the number of current paths in parallel and will be taken as
% 1 for our case.
ns = Nph/(p*q);
fprintf('It is calculated as %1.2f .',ns)
%%
% It should be an even number as there are two distinct coils per slot in a
% double layer winding. So ns is selected as 2.
ns = 2;
%%
% If we turn back and recalculate the actual airgap flux density:
Bg = Bg*Nph/(ns*p*q);
fprintf('Recalculated airgap flux density is %1.3f T .',Bg)
%%
% Now we can calculate rated current. 15.16 formula will be used:
%  
% $I_{in} = \frac{P_n}{\eta cos\phi_n \sqrt{3}V_1}$
Iin_rated = Prated/(Aimed_eff*Aimed_pf*sqrt(3)*Vline);
fprintf('Rated phase current is calculated as %3.1f A .',Iin_rated)
%% 
% To be able to calculate wire cross section, current density will be
% selected first. Here, recommendation 15.17 will be followed and for 4
% poles current density will be taken as 6 A/mm^2.
Jcos = 6;
%%
% 
% $A_{co} = \frac{I_{in}}{J_{cos}}$
Aco = Iin_rated/Jcos; % [mm^2]
fprintf('Magnetic cross section area is calculated as %3.2f mm^2.',Aco)
%%
% Using cross-sectional wire area information it is possible to calculate
% the diameter wire gauge.
%  
% $d_{co} = \sqrt{\frac{4A_{co}}{\pi}}$
%  
dco = sqrt(4*Aco/pi); %[mm]S
fprintf('Wire gauge diameter is %3.2f mm.',dco)
%%
% Because this diameter is not small, 30 conductors will be paralleled to
% decrase the diameter of each conductor.
ap = 30;
dco = sqrt(4*Aco/(ap*pi)); %[mm]S
fprintf('New wire gauge diameter is %3.2f mm.',dco)
%%
% By using table 15.3, it is possible to jump from wire diameter to
% insulated wire diameter.
dco_ins = 1.53*10^-3; % [m]
fprintf('Insulated wire gauge diameter is %3.2f mm.',dco_ins*10^3)
%% Stator Slot Sizing

%% 
% Since we know wire diameter, number of conductors in parallel and number
% of turns per slot, it is possible for us to calculate the slot area. Only
% missing parameter is fill factor selection. For round wire and at our
% rated power level it is advised to be taken between 0.4 and 0.44. So it
% is selected as 0.44. For useful area calculation formula (15.21) will be
% used:
%  
% $A_{su} = \frac{\pi d_{co}^{2} a_p n_s}{4K_{fill}}$
%  
Kfill = 0.44;
A_slot = pi*(dco^2)*ap*ns/(4*Kfill); %[mm^2]
fprintf('Calculated useful slot area is %3.3f mm^2.',A_slot)
%%
% There are two recommended stator slot shapes in the book as follows:
%  
% <<stator_slot_shape.PNG>>
%  
% For ease of calculation and to be able to use explained slot geometry,
% left-hand side of stator slot shape is selected.
%  
% For this shape, explained lengths and are as in the figure below:
%  
% <<selected_slot_shape.PNG>>
%  
% Here, some parameters will be selected via following books' suggestions
% and some of them will be calculated.
%  
% Suggested variables are bos, hos and hw. bos can be defined as slot
% opening length and it is selected as 2 mm. hos is the height of slot
% opening and it is taken as 1 mm. hw is wedge height and it is selected
% as 3 mm.
b_os = 2*10^-3; %[m]
h_os = 10^-3; %[m]
h_w = 3*10^-3; %[m]
%%
% Assuming that all the airgap flux passes through stator teeth:
% 
% $B_g \tau_s L \approx B_{ts} b_{ts} L K_{Fe}$
%%
% Here, Kfe is a constant to include lamination insulation's effect and 
% suggested to be defined as 0.96. It is suggested to have a tooth flux 
% density between 1.5 and 1.65 T. Let us take it as 1.6 T and determine bts:
Kfe = 0.96;
B_ts = 1.6;
%%
% Slot pitch isn't calculated yet, it is possible to use equation (15.3)
% for it.
%  
% $\tau_s = \frac{\tau}{3q}$
slot_pitch = pole_pitch/(3*q);
fprintf('Slot pitch is %3.3f mm.',slot_pitch*1000)
%%
b_ts = Bg*slot_pitch/(B_ts*Kfe); %[m]
fprintf('Tooth width is %3.3f mm.',b_ts*1000)
%%
b_ts = (floor(b_ts*10000))/10000;
fprintf('It is better to take it as %1.1f mm.',b_ts*1000)
%% 
% For this value let us recalculate flux density of tooth:
Bts = Bg*slot_pitch/(b_ts*Kfe); %[m]
fprintf('Recalculated tooth-flux density is %1.2f Tesla.',Bts)
%%
% This value is still inside the suggested range.
%  
% With the variables we know, using equation (15.23) it is possible to
% calculate the slot lower width:
%  
% $b_{s1} = \frac{\pi (D_{is} + 2h_{os} +2h_w)}{N_s} - b_{ts}$
% 
b_s1 = (pi*(Dis + 2*h_os + 2*h_w))/Ns - b_ts;
b_s1 = (round(b_s1*10000))/10000;
fprintf('Lower slot width is %1.1f mm.',b_s1*1000)
%%
% At this point missing variables are slot height and upper slow width. If
% slot area's round corners are ignored and area is taken as a trapezoid,
% its are would be;
%  
% $A_{su} = h_s\frac{b_{s1} + b_{s2}}{2}$
%  
% Also, we have(15.25) formula as follows:
%  
% $b_{s2} \approx b_{s1} +2h_stan\frac{\pi}{N_s}$
%  
% From these 2 equations;
%  
% $b_{s2} = \sqrt{4A_{su}tan\frac{\pi}{N_s} + b_{s1}^{2}}$
b_s2 = sqrt(4*A_slot*(10^-6)*tan(pi/Ns)+(b_s1^2));
b_s2 = (round(b_s2*10000))/10000;
fprintf('Upper slot width is %1.1f mm.',b_s2*1000)
%%
% 
% $h_s = \frac{2A_{su}}{b_{s1} + b_{s2}}$
hs = 2*A_slot*(10^-6)/(b_s1+b_s2);
hs = (round(hs*10000))/10000;
fprintf('Slot height is %1.1f mm.',hs*1000)
%%
% Now we can proceed in calculating mmf of airgap and teeth. The airgap mmf
% is:
%  
% $F_{mg} \approx K_c*g*\frac{B_g}{\mu_0}$
%  
% Here, Kc is the Carter's cofficient and it helps us to consider airgap
% surface as smooth and make our calculations directly. It is expected that 
% it is greater but close to 1; its formula is:
%  
% $K_c = \frac{\tau_s}{\tau_s-b_e}$
%  
% $b_e = Kb_{os}$
%  
% $K = \frac{\frac{b_{os}}{g}}{5 + \frac{b_{os}}{g}}$
K = (b_os/g)/(5+b_os/g);
be = K*b_os;
Kc = slot_pitch/(slot_pitch-be);
fprintf('Carter coefficient is calculated as %1.2f .',Kc)
%%
% Now airgap mmf may be calculated:
mu_0 = 4*pi*10^-7;
F_mg = Kc*g*Bg/mu_0;
fprintf('The airgap mmf is %3.3f Aturns.',F_mg)
%%
% Using tooth flux density and tooth's related heights we may calculate
% also mmf of stator tooth. Its formula is given with (15.30) and as
% follows:
%  
% $F_{mts} = H_{ts}(h_s + h_{os} + h_w)$
%  
% Only missing parameter is H of stator tooth and its value will be taken
% from table 15.4 of lamination magnetization curve.
Hts = 2960; %[A/m]
fprintf('H of stator tooth is selected as %d A/m for %1.2f Tesla.',Hts,Bts)
%%
F_mts = Hts*(hs + h_os + h_w);
fprintf('So the stator tooth mmf is %3.3f Aturns.',F_mts)
%%
% Using formula given in (15.29) it is possible to calculate rotor tooth
% mmf since we take 1 + Kst value as 1.4 at the earlier part of design.
%  
% $1+K_{st} = 1 + \frac{F_{mts} + F_{mtr}}{F_{mg}}$
F_mtr =(Kst*F_mg)-F_mts;
fprintf('Rotor tooth mmf is found as %3.3f Aturns.',F_mtr)
%%
% As this value is only slightly larger than that of stator tooth, we may
% go on with the design process.
%  
% Only missing dimension for stator side is its back core and this value
% may be calculated with the formula below (15.32):
%  
% $h_{cs} = \frac{D_{out} - (D_{is} + 2(h_s + h_{os} + h_w))}{2}$
h_cs = (Dout -(Dis+2*(hs + h_os + h_w)))/2;
fprintf('Back core is calculated as %1.1f cm.',h_cs*100)
%%
% Here, we should take a look at to the flux density to avoid a saturation.
%  
% $B_{cs} = \frac{\phi}{2Lh_{cs}}$
B_cs = pole_flux/(2*L*h_cs);
fprintf('Back core flux density is %1.2f Tesla.',B_cs)
%%
% This is an acceptable value, therefore outer diameter won't be changed.
%% Rotor Slots

%% 
% First step of designing rotor slots might be deciding the number of rotor
% slots. An arbitrary selection isn't possible because all stor and rotor
% slot combinations aren't possible. At this point there are so many
% resources that suggest the most adequate combination.
%  
% Once EE565 lecture notes are reviewed, suggestions are found as :
%  
% <<NsNr.PNG>>
%  
% From the textbook, suggestions are as follows:
%  
% <<NsNr2.PNG>>
%  
% For fair play, their intersection number 44 was selected as number of 
% rotor slots at first. But then it couldn't be possible to design rotor
% slot for our rated power. So this number is selected as 56 in the second
% attempt. But that one also couldn't be enough. Then 84 is selected and it
% is OK.
Nr = 84;
%%
%  
% <<RotorShapes.PNG>>
%  
% As we did for stator shape selection, for ease of area calculation
% textbook's selection will be followed and option c will be selected among
% suggested options.
%  
% We can go on the design with calculating the bar current:
%  
% $I_b = K_I \frac{2m N_s k_w}{N_r} I_{in}$
%  
% Here Ký will be calculated with the formula below:
%  
% $K_I \approx 0.8cos\phi_{ln} + 0.2$
K_I = 0.8*Aimed_pf+0.2;
fprintf('This constant calculated as %0.3f .',K_I)
%%
Ib = K_I*2*3*Nph*kw*Iin_rated/Nr;
fprintf('Bar current is %3.1f A.',Ib)
%%
% For high efficiency, the rotor current density in the rotor bar is
% selected as 3.42A/mm^2. Using this value, rotor slot area may be
% calculated.
%  
% $A_b = \frac{I_b}{J_b}$
%
Jb = 3.42*10^6; %[A/m^2]
A_b = Ib/Jb;
fprintf('The rotor slot area is %3.2f mm^2.',A_b*10^6)
%%
% Since we have calculated bar current, it is possible to calculate also
% end ring current using formula below (15.37)
%  
% $I_{er} = \frac{I_b}{2 sin \frac{\pi p}{N_r}}$
Ier = Ib/(2*sin(pi*p/Nr));
fprintf('End ring current is %3.1f A.',Ier)
%%
% Current density of end ring is less than 75 to 80 % of the bar. The
% middle point will be selected as the multiplier.
Jer = 0.775*Jb;
fprintf('77,5 %% of the bar current density is taken and it is %3.2f A/mm^2.',Jer*10^-6)
%%
% With this variables it is possible to calculate the end ring cross
% section area:
%  
% $A_{er} = \frac{I_{er}}{J_{er}}$
A_er = Ier/Jer; % [m^2]
fprintf('The rotor end ring area is %3.2f cm^2.',A_er*10^4)
%%
% We may now proceed to rotor slot sizing based on the variables defined on
% figure below: 
%  
% <<RotorDetailed.PNG>>
%  
% Let us calculate the rotor slot pitch using formula below (15.39)
%  
% $\tau_r = \frac{\pi(D_{is}-2g)}{N_r}$
slot_pitch_r = pi*(Dis-2*g)/Nr;
fprintf('The rotor slot pitch is %3.2f mm.',slot_pitch_r*1000)
%%
% Rotor tooth flux density can be selected as 1.65 Tesla. Than it is
% possible to calculate the tooth width:
Btr = 1.65;
%%
% 
% $b_{tr} \approx \frac{B_g}{K_{Fe} B_{tr}} \tau_r$
b_tr = Bg/(Kfe*Btr)*slot_pitch_r;
b_tr = (round(b_tr*10000))/10000;
fprintf('Rotor tooth width width is %1.1f mm.',b_tr*1000)
%%
% Now d1 diameter may be calculated using formula (15.42)
%  
% $d_1 = \frac{\pi (D_{re} -2h_{or}) -N_rb_{tr}}{\pi + N_r}$
h_or = 0.4*10^-3; %[m]
Dre = Dis - g;
d1 = (pi*(Dre-2*h_or)-Nr*b_tr)/(pi+Nr);
d1 = (ceil(d1*10000))/10000;
fprintf('This diameter is %1.1f mm.',d1*1000)
%%
% To completely define the rotor slot geometry, it is needed to use slot
% area equations (15.43) and (15.44)
%  
% $A_b = \frac{\pi}{8}(d_1^2 + d_2^2) + \frac{(d_1 + d_2)h_r}{2}$
%  
% $d_1 - d_2 = 2 h_r tan \frac{\pi}{N_r}$
%  
% From the second equation it is found that d2 is equal to 3.5-0.0374hr .
% It will be substated in the first equation.
h_r =29.8*10^-3; %[m]
fprintf('By this way hr is found as %2.1f mm.',h_r*1000)
%%
d2 = d1 - 2*tan(pi/Nr)*h_r; %[m]
fprintf('So d2 diameter is %2.1f mm.',d2*1000)
%%
% Now let's verify the rotor teeth mmf for Btr is 1.65 Tesla and H of rotor
% tooth is 3460 A/m.
Htr = 3460;
%%
% 
% $F_{mtr} = H_{tr}(h_r + h_{or} + \frac{d_1 + d_2}{2})$
F_mtr2 = Htr*(h_r+h_or+(d1+d2)/2);
fprintf('Rotor tooth mmf is recalculated as %3.3f Aturns.',F_mtr2)
%%
fprintf('Previous calculation was %3.3f and it is acceptable.',F_mtr)
%%
% Now we can calculate a rotor back core allowing a flux density between
% 1.4 and 1.7. It is taken as 1.7 T.
B_cr = 1.7;
%%
% 
% $h_{cr} = \frac{\phi}{2 L B_{cr}}$
h_cr = pole_flux/(2*L*B_cr);
h_cr = (floor(h_cr*10000))/10000;
fprintf('Rotor back core is %2.1f mm.',h_cr*1000)
%%
% For rotor, missing part is shaft diameter and its details. The maximum
% shaft diameter is:
%  
% $(D_{shaft})_{max} \leq D_{is} -2g-2(h_{or} + h_r + h_{cr} + \frac{d_1 + d_2}{2})$
%  
d_shaft_max = Dis-2*g-2*(h_or+h_r+h_cr+(d1+d2)/2);
fprintf('So this maximum value is %2.1f mm.',d_shaft_max*1000)
%%
% For end ring detail, two extra lengths will be defined and their
% explanations are in the figure below:
%  
% <<EndRing.PNG>>
%  
% $b = 1.1(h_r + h{or} +\frac{d_1 + d_2}{2})$
b = 1.1*(h_r+h_or+(d1+d2)/2);
a = A_er/b;
b = (floor(b*10000))/10000;
a = (floor(a*10000))/10000;
fprintf('a and b are calculated as %2.1f and %2.1f mm.',a*1000, b*1000)
%% The Magnetization Current

%% 
% The magnetization mmf Flm is
%  
% $F_{lm} = 2(K_c g \frac{B_g}{\mu_0} + F_{mts} + F_{mtr} + F_{mcs} + F_{mcr})$
%  
% To be able to calculate unknown mmfs in this equation, again Carter's
% coefficient wil be used. Its first multiplier was already calculated.
% Here its second part that is related with the rotor will be calculated.
%  
b_or = 1.5*10^-3;
fprintf('Rotor slot opening is %1.1f  mm.',b_or*1000)
%%
% 
% $K_{c2} = \frac{\tau_r}{\tau_r-b_e}$
%  
% $b_e = Kb_{or}$
%  
% $K = \frac{\frac{b_{or}}{g}}{5 + \frac{b_{or}}{g}}$
%  
fprintf('Carter coefficient was calculated as %1.2f.',Kc)
%%
be = K*b_or;
Kc2 = slot_pitch_r/(slot_pitch_r-be);
Kc1 = Kc;
Kc = Kc1*Kc2;
fprintf('Now its total recalculated value is %1.2f.',Kc)
%% 
% Since these values are close to each other, new value will be used in
% next calculations.
%  
% For calculating back core mmfs, another missing parameter is subunitary
% empirical coefficient that defines an average length of flux path in the
% back core. Formula (15.60) will be used for its calculation:
%  
% $C_{cs,r} \approx 0.88{e^{-0.4B_{cs,r}}}^2$
Cc_s = 0.88*exp((-0.4*B_cs)^2);
Cc_r = 0.88*exp((-0.4*B_cr)^2);
%%
% For back core calculations, formula below will be used:
%  
% $F_{mcs,r} = C_{cs,r} \frac{\pi(D_{out,shaft} - h_{cs,r})}{2p}H_{cs,r}$
fprintf('Bcs and Bcr were %1.2f and %1.2f Tesla.',B_cs,B_cr)
%%
H_cs = 905; 
H_cr = 4800;
fprintf('From table 15.4 corresponding H values are %d and %d',H_cs,H_cr)
%%
% 
F_mcs = Cc_s*pi*(Dout-h_cs)/(2*p)*H_cs;
F_mcr = Cc_r*pi*(d_shaft_max-h_cr)/(2*p)*H_cr;
fprintf('Back core mmfs are %3.1f and %3.1f Aturns',F_mcs,F_mcr)
%%
% Now we can calculate magnetization mmf:
F_lm = 2*(Kc*g*Bg/mu_0 + F_mts + F_mtr + F_mcs + F_mcr);
fprintf('It is calculated as  %4.0f Aturns',F_lm)
%%
% For magnetization current formula (15.62) will be used:
%  
% $I_{\mu} = \frac{\pi p (f_{lm} / 2 )}{3\sqrt{2}N_{ph}k_w}$
I_mu = pi*p*F_lm/(6*sqrt(2)*Nph*kw);
fprintf('The magnetization current is calculated as %3.1f A',I_mu)
%%
fprintf('Its (p.u.) value is %0.2f ',I_mu/Iin_rated)
%% Resistances and Inductances

%% 
% For stator phase resistance formula (15.63) will be used.
%  
% $R_s = \rho_{Co}\frac{l_c N_{ph}}{A_{co}a_1}$
%  
% Here coil length includes the active part 2L and the end connection part
% 2lend
%  
% $l_c = 2(L + l_{end})$
%  
% End connection length depends on the coil span, number of poles, shape of
% coils and number of layers in the winding. For its calculation formula
% (15.65) will be used.
%  
% $l_{end} = 2y - 0.02$
%  
% Here, y is the coil span and can be calculated as
%  
% $y = \beta \tau$
%  
% In coil span formula, beta is chording factor and it is already selected
% as 5/6.
y = pitch_factor*pole_pitch;
l_end = 2*y-0.02;
fprintf('The end connection length is %2.1f cm',l_end*100)
l_c = 2*(L + l_end);
%%
fprintf('So the coil length is %2.1f cm',l_c*100)
%%
% Another consideration for stator resistance is the copper resistivity. At
% room temperature its value is $1.78 10^{-8} \Omega m$ and at 115 degree
% it increases 37%. Because we don't know the rated temperature yet and
% this value will be taken for 90 degrees.
Resist_Cu = 2.2364*10^-8;
Rs = Resist_Cu*l_c*Nph/(Aco*10^-6);
fprintf('The stator resistance is %1.3f mohm',Rs*1000)
%%
% Now we can continue with rotor/end ring segment equivalent resistance.
% Its value will be calculated using formula (15.70)
%  
% $R_{be} = \rho_{Al}[\frac{LK_R}{A_b} + \frac{l_{er}}{2A_{er}sin^{2}(\frac{\pi p}{N_r})}]$
%  
l_er = pi*(Dis-2*g-b)/Nr;
fprintf('Here, end ring segment length is %2.1f mm',l_er*1000)
%%
% Here using formulas (15.72) and (15.73) skin effect resistance
% coefficient is calculated.
Resist_Al_20 = 3.1*10^-8;
beta_s = sqrt(2*pi*f_rated*mu_0/(2*Resist_Al_20));
Kr = beta_s*h_r;
fprintf('It is %2.2f ',Kr)
%%
% If we consider the same temperature again;
Resist_Al_90 = Resist_Al_20*(1-(90-20)/273);
Rbe = Resist_Al_90*(L*Kr/A_b+l_er/(2*A_er*((sin(pi*p/Nr))^2)));
fprintf('Rbe is calculated as%1.3f mohm',Rbe*1000)
%%
% In the equivalent circuit we use referred rotor resistance. Therefore its
% referred value is going to be calculated using formula (15.74)
%  
% $R_r' = \frac{4m}{N_r}(N_{ph}k_w)^{2}R_{be}$
Rr = 4*m*((Nph*kw)^2)*Rbe/Nr;
fprintf('Referred rotor resistance is %2.2f mohm',Rr*1000)
%%
% For calculating stator phase leakage reactance, slot differential and end
% ring connection coefficients are going to be calculated first.
lambda_s = ((2/3)*hs/(b_s1+b_s2)+2*h_w/(b_os+b_s1)+h_os/b_os)*(1+3*pitch_factor)/4;
Cs = 1-0.033*(b_os^2)/(g*slot_pitch);
theta1 = pi*(6*pitch_factor-5.5);
sigma_ds = (0.14*sin(theta1)+0.76)*10^-2;
lambda_ds = 0.9*slot_pitch*((q*kw)^2)*Cs*sigma_ds/(Kc*g*(1+Kst));
lambda_ec = 0.34*q*(l_end-0.64*pitch_factor*pole_pitch)/L;
Xsl = 2*mu_0*2*pi*f_rated*L*(Nph^2)*(lambda_s+lambda_ds+lambda_ec)/(p*q);
fprintf('The stator phase reactance is %2.2f mohm',Xsl*1000)
%%
% For calculating equivalent rotor bar leakage reactance formula (15.80)
% will be used and required coefficients will be calculated.
lambda_r = 0.66+2*h_r/(3*d1+3*d2)+h_or/b_or;
sigma_dr = 9*((6*p/Nr)^2)*10^-2;
lamda_dr = 0.9*slot_pitch_r*sigma_dr*((Nr/(6*p))^2)/(Kc*g);
lambda_er = 2.3*(Dis-2*g-b)/(Nr*L*4*(sin(pi*p/Nr))^2)*log10(4.7*(Dis-2*g-b)/(b+2*a));
Kx = 1.5*Kr;
Xbe = 2*pi*f_rated*mu_0*L*(lambda_r*Kx+lamda_dr+lambda_er);
fprintf('The rotor bar leakage reactance is %2.2f mohm',Xbe*1000)
%%
% Rotor leakage reactance is calculated over rotor bar leakage reactance.
% Its formula is given with (15.85).
Xrl = 4*m*((Nph*kw)^2)*Xbe/Nr;
fprintf('The rotor leakage reactance is %2.2f mohm',Xrl*1000)
%%
% Another important parameter is magnetizing inductance and it is going to
% be calculated using formula (15.88)
Xm = sqrt((((Vline/sqrt(3))/I_mu)^2)-Rs^2)-Xsl;
fprintf('The magnetizing reactance Xm is %2.2f ohm',Xm)
%%
% At rated speed rotor resistances are changed due to the slip. There, both
% skin and leakage saturation effects have to be eliminated.
Kr = 1;
Rbe_sn = Resist_Al_90*(L*Kr/A_b+l_er/(2*A_er*((sin(pi*p/Nr))^2)));
Rr_sn = Rr*Rbe_sn/Rbe;
fprintf('Rotor resistance at rated speed is calculated as %1.3f mohm',Rr_sn*1000)
%% Losses and Efficiency

%% 
% Efficiency is the rate of output power to the input power. It is possible
% to describe input power as ouput+losses. So calculation the losses will
% hep us to calculate efficiency.
%  
% Let us start with stator winding losses.
% $P_{co} = 3R_s I_{in}^{2}$
P_co = 3*Rs*Iin_rated^2;
fprintf('Stator winding losses are calculated as %1.2f kW',P_co/1000)
%%
% We have also losses at rotor cage at rated speed.
% $P_{Al} = 3R_r I_{in}^{2}$
P_al = 3*Rr_sn*(K_I*Iin_rated)^2;
fprintf('Rotor cage losses are calculated as %1.2f kW',P_al/1000)
%%
% Mechanical and ventilation losses are considered as 1.2% of rated power.
P_mech = Prated*0.012;
fprintf('Mechanical losses are taken as %1.2f kW',P_mech/1000)
%%
% For stray losses 1% of rated power will be taken as standard value.
P_stray = Prated*0.01;
fprintf('Stray losses are taken as %1.2f kW',P_stray/1000)
%%
% Remaining losses are core losses made of fundamental and additional
% (harmonic) iron losses. The fundamental core losses occur only in the
% teeth and back iron of the stator as the rotor frequency is low. Stator
% teeth fundamental losses are going to be calculated using formula (15.98)
density_iron = 7800;
G_ts = density_iron*Ns*b_ts*(hs+h_w+h_os)*L*Kfe;
fprintf('Stator tooth weight is %2.2f kg',G_ts)
%%
% 
p10 = 2.5;
Kt = 1.6;
P_tl = Kt*p10*((f_rated/50)^1.3)*(B_ts^1.7)*G_ts;
fprintf('Stator teeth fundamental lose is %2.2f W',P_tl)
%%
% In a similar way, using (15.100) stator back iron fundamental losses are
% going to be calculated.
Ky = 1.6;
G_yl = density_iron*(pi/4)*((Dout^2)-(Dout-2*h_cs)^2)*L*Kfe;
fprintf('Yoke weight is %2.2f kg',G_yl)
%%
P_yl = Ky*p10*((f_rated/50)^1.3)*(B_cs^1.7)*G_yl;
fprintf('Stator back core fundamental lose is %2.2f W',P_yl)
%%
fprintf('So the fundamental iron losses is %2.2f W',P_yl+P_tl)
%%
% The tooth flux pulsation core loss constitutes the main components of
% stray losses.
G_tr = density_iron*L*Kfe*Nr*(h_r+(d1+d2)/2)*b_tr;
fprintf('Rotor teeth weight is %2.2f kg',G_tr)
%%
% 
Kps = 1/(2.2-B_ts);
Kpr = 1/(2.2-Btr);
Bps = (Kc2-1)*Bg;
Bpr = (Kc1-1)*Bg;
P_irons = 0.5*(10^-4)*(((Nr*f_rated*Kps*Bps/p)^2)*G_ts+((Ns*f_rated*Kpr*Bpr/p)^2)*G_tr);
fprintf('Total iron loss is %2.2f kW',(P_irons+P_yl+P_tl)/1000)
%%
P_loss_total = P_tl+P_stray+P_mech+P_al+P_co+P_yl+P_irons;
fprintf('Total loss of the motor is %2.2f kW',P_loss_total/1000)
%%
Eff_calc = Prated/(Prated+P_loss_total);
fprintf('Calculated efficiency is %2.2f %%.',Eff_calc*100)
%%
fprintf('Targeted efficiency was %2.2f %% and they are close to each other.',Aimed_eff*100)
%% Operation Characteristics

%% 
% The operation characteristics are defined here as active no load current,
% rated slip and rated shaft torque.

Ioa = (P_irons+P_yl+P_tl+P_mech+3*Rs*I_mu^2)/(3*Vline/sqrt(3));
fprintf('Active no load current is %2.2f A.',Ioa)
%%
Sn = P_al/(Prated+P_al+P_mech+P_stray);
fprintf('Rated slip is %0.4f.',Sn)
%%
T_rated = Prated/(2*pi*f_rated*(1-Sn)/p);
fprintf('Rated shaft torque is %2.2f Nm.',T_rated)
%%
pf_rated = Prated/(3*(Vline/sqrt(3))*Iin_rated*Eff_calc);
fprintf('Calculated power factor is %0.3f.',pf_rated)
%%
fprintf('Targeted power factor was %0.2f % and they are close to each other.',Aimed_pf)
%% Thermal Design

%% 
% Tesla Motors has the patent about liquid motor cooling.
%  
% http://www.google.com/patents/US7489057
%  
% First the temperature differential between the conductors in slots and
% the slot wall is calculated. In the book equation (15.123) suggests some
% convection coefficients but these are for selfventilators and power range
% isn't enough for us. Because Tesla Motors company prefers liquid cooling
% design will be considered in that decision.
%  
% http://www.engineeringtoolbox.com/overall-heat-transfer-coefficients-d_284.html
%  
% Once this website is checked, it is seen that for water cooling,
% convection coefficient may be taken as 400 W/m^2K.
conv_coef = 400;
%%
% Another required coefficient is about conductivity. Following equation
% (15.24) it is taken as 822 W/m^2K.
cond_coef = 833;
%%
% Let us calculate the stator slot lateral area
%  
% $A_{ls} \approx (2h_s + b_{s2})LN_s$
A_ls = (2*hs+b_s2)*L*Ns;
fprintf('It is calculated as %0.3f m^2.',A_ls)
%%
% If we take finn constant from equation (15.126) as 3;
K_fin = 3;
A_frame = pi*Dout*(L+pole_pitch)*K_fin;
fprintf('Frame area calculated as %0.3f m^2.',A_frame)
%%
% Now we may calculate the temperature difference between conductors and
% slow wall:
delta_co = P_co/(cond_coef*A_ls);
fprintf('This temperature change is %1.2f degree.',delta_co)
%%
% Supposing the ambient temperature as 40 degree, now we may calculate the
% winding temperature:
delta_frame = P_loss_total/(conv_coef*A_frame);
fprintf('Winding temperature change is %2.2f degree.',delta_frame)
%%
fprintf('In this case maximum temperature is %2.2f degree.',delta_frame+delta_co+40)
%%
% This value is acceptable since design is made for 80 degree maximum.
%% Mass Calculation

%% 
% Some of the weights are calculated to be able to calculate iron losses
% and missing ones will be calculated in this part to be able to predict
% motor's total weight.
%  
% Calculated weights are:
fprintf('Stator teeth weight is %2.2f kg',G_ts)
%%
fprintf('Stator back iron weight is %2.2f kg',G_yl)
%%
fprintf('Rotor teeth weight is %2.2f kg',G_tr)
%%
% We can also calculate the rotor back core weight;
G_yr = density_iron*(pi/4)*(((Dis-2*h_cr)^2) - d_shaft_max^2)*L*Kfe;
fprintf('It is %2.2f kg',G_yr)
%%
% We can also calculate shaft weight:
G_shaft = density_iron*(pi/4)*(d_shaft_max^2)*Kfe*(L+0.1);
fprintf('That one is %2.2f kg',G_shaft)
%%
G_iron = G_ts + G_yl + G_tr + G_yr +G_shaft;
fprintf('So the total iron weight is %2.2f kg',G_iron)
%%
% It is also possible for us to calculate wire weight;
density_Cu = 8960; % kg/m^3
G_wire = density_Cu*m*Nph*l_c*Aco*10^-6;
fprintf('Wire mass is %2.2f kg',G_wire)
%%
% Lastly, let us calculate the Aliminium bar weight of rotor:
density_Al = 2700; % kg/m^3
G_bar = density_Al*(l_er*A_er+L*A_b)*Nr;
fprintf('Al bar weight is %2.2f kg',G_bar)
%%
% In this case total mass of the motor is
fprintf('In this case total mass of the motor is is %2.2f kg',G_bar+G_wire+G_iron)
%% Motoranalysis Drawings

%%
% Here are the motoranalysis figures generated by motoranalysis tool.
% 
% <<Drawing.PNG>>
%  
% <<Drawing_stator.PNG>>
%  
% <<Drawing_rotor.PNG>>
%  
% <<windings.PNG>>
%  
% <<BH_15.4.PNG>>
%  
end