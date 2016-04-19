%%  EM564 FIRST PROJECT:HVDC TRANSFORMER DESIGN
%% ID
%%
% *NAME :* Seda KÜL
%  
% *E-mail :* sedakul@gazi.edu.tr

%% Specification
%
% This project is relevant to design single phase high voltage frequency transformer.
%
% The main idea of transformer design is to obtain the dimensions of all parts of the transformer in order to supply these data to the manufacturer. The transformer design should be carried out based on the specification given, using available materials
% 
% Specification of the transformer is shown below:
%
% *Power: 6.5 MVA 
%
% *Operating Frequency: 500 Hz
%
% *Input voltage: 3 kV
%
% *Output voltage: 300 kV
%
% *Operating temprature: 110 °C


S=6.5*10^6;
Vp=3000; 
Vs=300000;
f=500; 
w=2*pi*f;
mu=4*pi*10^-7;
turn_ratio=Vp/Vs;
lamination_factor=0.94;
winding_factor=0.25;
kw=0.94; 

%%  Choose Initial Material
%
% Generally, the name associated with the construction of a transformer is dependant upon how the primary and secondary windings are wound around the central laminated steel core.
% The two most common and basic designs of transformer construction are the Closed-core Transformer and the Shell-core Transformer.
% In the “closed-core” type (core form) transformer, the primary and secondary windings are wound outside and surround the core ring. In the “shell type” (shell form) transformer, the primary and secondary windings pass inside the steel magnetic circuit 
%
% Choosen correctly dimension and type of the core is important. Because diameter of the core is increased, the number of turns in the transformer winding reduced.
% Reduction of number of turns, reduction in height of the core legs in-spite of reduction of core legs height increased in core diameter, results increase in overall diameter of magnetic core of transformer. 
% This increased steel weight ultimately leads to increased core losses in transformer. Increased diameter of the core leads to increase in the main diameter on the winding. 
% In – spite of increased diameter of the winding turns, reduced number of turns in the windings, leads to less copper loss in transformer. So, we go on increasing diameter of the transformer core, losses in the transformer core will be increased but at the same time, load loss or copper loss in transformer is reduced. 
% On the other hand, if diameter of the core is decreased, the weight of the steel in the core is reduced; which leads to less core loss of transformer, but in the same time, this leads to increase in number of turns in the winding, means increase in copper weight, which leads to extra copper loss in transformer.
%
% For this project 0.23 mm M3 shell type core is selected the reason of this is operating frequency. If other core material is selected, core
% loss can be very high. Due to same reason flux density should be low to
% decrease the losses, from the datasheet it can be seen 
%
% While determining the secondary turn number  cross 0.05 because of the voltage drop

B=1.2; 

core_density=7.65; 
 
Np=20; 

Ns=(Np/turn_ratio)*105/100; 

pic = imread('magnetization.png');
figure;
imshow(pic);

%% Calculation of Thickness of Core Leg 
%
% Where kw is the core stacking factor, D (mm) is the width of core leg and Eu (mm) is the thickness of the core leg. 
% The core stacking factor expresses the net cross-section area of the
% magnetic flux. Necessary equation is:
% 
% Vp=E=4.44*f*N*kw*B*Acore  and E=Vt*N 
%
% and 
%
% Acore=2*D(width of core leg)*Eu(thickness of the core leg)
% 
% The factor 1/2 appears because the assembling of every winding of shell type transformer require two cores

Ac=Vp/(4.44*f*Np*kw*B); 
D=0.1; 
Eu=Ac/(2*D); 

core_shape = imread('shell_type_transformer.png');
core_dimension = imread('transformer_dimension.png');
figure;
subplot(1, 2, 1),
imshow(core_shape)
subplot(1, 2, 2),
imshow(core_dimension);

%% Wire Selection
%
% Selecting the wrong size or type of cable can result in, at best, a
% system that does not operate correctly or as desired. The first rule is that the cable must be of the correct type for the voltage. This is related to the insulation breakdown voltage.
% 
% The 2nd rule is even simpler. This relates to the physical strength and durability of the cable.This rules are slighly more complicated and are related to the actual size of the conductor.
% This defines how much current the cable can safely carry.
%
% The third rule is that the cable must be able to safely handle the current without overheating the cable and/or it's insulation.
% This specification can be calculated from the current through the cable and the resistance of the cable
% 

Ip=S/Vp; 
Is=S/Vs; 
J=3; 
Ap=Ip/J; 
As=Is/J; 

%% Skin Depth Calculation
%
% Sinusoidal currents in good conductors are not distributed uniformly over
% their cross section. Rather as frequency increases, the current tends to
% concentrate near the conductor surface, a phenomenon known as the skin
% effect. At very high frequency, the skin effect is so pronounced that
% current exist only over a very thin layer of any good conductor. 

copper_mu=1.256629*10^-6;
q=1.68*10^-8; % resistivity of the copper for 20C
skin_dept=sqrt((2*q)/(copper_mu*w))*1000;

%% Primary Side Winding
%
% While the conductor area is calculating, current density is take into
% acount and it is generally J=4-4.5, but in this application beccause of the high frequency and losses it is choosen a bit lower.
%
% the other issue is to decide wire type and area. For the primary side the
% area is very big so to get correct area conductor use paralel strip conductor as
% known litz. Litz wire reduces the degree of the skin effect so it is
% preferred. 
% It is used 12*6 mm^2 copper stripes and the edge is selected as 2x-x 
copper_area_p=12*6;
paralel_branch=round(Ap/copper_area_p);
copper_window_primary=copper_area_p*paralel_branch*Np;  


%% Secondary Side Winding
% 
% For the secondary side area is low so awg#8 is enough 
copper_area_s=8.37;
copper_window_secondary=copper_area_s*Ns;  
diameter_secondary_winding=sqrt(As*4/pi);

wire = imread('AWG size.png');
figure;
imshow(wire);

%% Window Area
% When operating at high frequencies, the window fill factor, has to be taken into account
% For the window area it is considered primar and seconder winding distance for the insulation so there is a constant like fill factor=0.25
% After finding total window area it can be thought a square core so it can be say G=F2

window_area=(copper_window_primary+copper_window_secondary)/winding_factor;

G=round(sqrt(window_area)); 

F2=G;

winding_pitch_primary=G+[(Eu*1000)*(copper_window_primary/window_area)];

winding_pitch_secondary=G+[(Eu*1000)*(copper_window_secondary/window_area)];


%% Resistance of the Primary and Secondary Conductors

L_primary=pi*winding_pitch_primary*Np; 
R_p=0.6;
R1=R_p*L_primary/1000/paralel_branch; 
R1_70=R1*(1+0.003862*(70-20));

L_secondary=pi*winding_pitch_secondary*Ns;
R_s=2.061;
R2=(R_s*L_secondary)/1000; 
R2_70=R2*(1+0.003862*(70-20));


%% Magnetizing and Leakage Inductance 
%
% For this part we use B-H curve shown in figure1 to calculate permeability
% (mu). From the datasheet for the B=1.2T match up to mu=0.058
% to obtain primary and secondary leakage reactance 0.05 pu assume  and
% X1=X2p for primary side

permeability=0.058;
L=[2*(F2+G+2*Eu*1000)]/1000; 
reluctance=L/(permeability*Ac);
Lm=Np^2/reluctance;  
Xm=2*pi*f*Lm;

Xes=0.05*Vp^2/S; 
X1=Xes/2;
L1=X1/(2*pi*f); 

X2p=X1;
X2=X2p/turn_ratio;
L2=X2/(2*pi*f);  

%% Voltage Drop
%
% For full load operation output voltage is calculated using circuit
% parameters.

Vp_drop=((R1*10^-3+j*X1)*Ip);

Ep=abs(Vp-Vp_drop);

Vs_drop=Ep/turn_ratio;

%% Loss Calculation
%
% To calculate core loss Steinmetz'e equation (Pcore=k*(f^a)*(B^b)) is used
% from the catalog 100 Hz and 200 Hz core loss value is chosen and by using
% this value 'a' is found.
%
loss = imread('core_loss.png');
figure;
imshow(loss);
%% 
% Core loss:
P_core_100=1.2;  

P_core_200=3.4;  

a=[log(P_core_100/P_core_200)]/[log(100/200)];

P_core_500=((500/100)^a)*P_core_100; 

core_volume=Ac*4*((F2/1000)+Eu); 

Mc=core_volume*core_density*1000; 

core_loss=P_core_500*Mc;  

Rc=Vp^2/core_loss;

equivalent = imread('equivalent circuit.png');
figure;
imshow(equivalent);

%%
% Copper loss:

copper_loss_p=R1*Ip^2/1000;

copper_loss_s=R2*Is^2/1000;

total_copper_loss=copper_loss_p+copper_loss_s;

%%
%Full load copper loss

load_copper_loss_p=R1_70*Ip^2/1000;

load_copper_loss_s=R1_70*Is^2/1000;

total_load_copper_loss=load_copper_loss_p+load_copper_loss_s;

total_loss=total_copper_loss+core_loss+total_load_copper_loss;

%% Efficiency

P_out=S*0.96;

efficiency=P_out/(P_out+total_loss)*100;

%% Core- Copper Mass & Cost
%
% For the cost calculation prize take from the http://www.lme.com/ website
% and approximately convert TL value

core_cost=15*Mc;

copper_density=8.94*10^3;  %g/m^3

V_wire=(L_primary*Ap*paralel_branch)+(L_secondary*As); 

copper_mass=V_wire*10^-9*copper_density;  

copper_cost=25*copper_mass/1000;

total_cost=core_cost+copper_cost;


%% Outputs
% After complaining the design, this values are obtained:

fprintf('Primer turn number: %d\n',Np)
fprintf('Seconder turn number: %d\n',Ns)

%%
% Core Parameters
fprintf('Weigth of the core leg: %f mm\n',D*1000)
fprintf('Thickness of the core leg:%f mm\n',Eu*1000)
fprintf('Width of the core leg:%f mm\n',F2)
fprintf('Heigth of the core leg:%f mm\n',G)
fprintf('core cross section area:%f mm^2\n',Ac*10^6)
fprintf('core resistance:%f ohm\n',Rc)
fprintf('Lmagnetixation:j%f ohm\n',Xm)
fprintf('Core mass:%f kg\n',Mc)
fprintf('Core volume:%f m^3\n',core_volume)
fprintf('Core loss:%f W\n',core_loss)
fprintf('Stacking factor:%f \n',kw)
fprintf('Winding factor:%f \n',winding_factor)
fprintf('Core density:%f kg/dm^3 \n',core_density)
fprintf('Flux density:%f  T\n',B)

%%
% Primary Side
fprintf('Primary voltage:%f kV\n',Vp/1000)
fprintf('Current density:%f A/mm^2\n',J)
fprintf('Primary current:%f A\n',Ip)
fprintf('Primary conductor area:%f mm^2\n',Ap)
fprintf('Primary resistance:%f*10^-3 ohm\n',R1)
fprintf('L1:%f H\n',L1)
fprintf('Primary inductance:j%f ohm\n',X1)
fprintf('Paralel conductor number:%d\n',paralel_branch)
fprintf('Primary copper loss:%f W\n',copper_loss_p)
fprintf('Primary coil average distance:%f mm\n',winding_pitch_primary)


%%
% Secondary Side
fprintf('Secondary voltage:%f kV\n',Vs/1000)
fprintf('Secondary current:%f A\n',Is)
fprintf('Secondary conductor area:%f mm^2\n',As)
fprintf('Secondary resistance:%f*10^-3  ohm\n',R2)
fprintf('L2:%f H\n',L2)
fprintf('Secondary inductance:j%f ohm\n',X2)
fprintf('Secondary copper loss:%f W\n',copper_loss_s)
fprintf('Secondary coil average distance:%f mm\n',winding_pitch_secondary)

%%
% Losses
fprintf('Total copper loss:%f W\n',total_copper_loss)
fprintf('Core loss:%f W\n',core_loss)
fprintf('Full load copper loss:%f W\n',total_load_copper_loss)
fprintf('Total loss:%f W\n',total_loss)

%%
% Efficiency
fprintf('Efficiency:%f \n',efficiency)

%% 
% Cost
fprintf('Copper mass:%f  gr\n',copper_mass)
fprintf('Copper cost:%f  TL\n',copper_cost)
fprintf('Core cost:%f TL \n',core_cost)
fprintf('Total cost:%f TL \n',total_cost)










