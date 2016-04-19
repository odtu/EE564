%% EE564 First Project: Transformer Design a for X-Ray Device
%% ID
%%
% *NAME :* Mehmet Kaan Mutlu
%  
% *STUDENT NUMBER :* 2121408
%  
% *E-mail :* kaan.mutlu@metu.edu.tr

function []=meka_mutlu_XRAY()

%% Specifications 
%%
% 
% * *Single Phase, High Frequency High Voltage Transformer*
% * *Primary Winding Voltage:* ± 417 V (peak to peak 834 V for pulsing)
% * *Secondary Winding Voltage:* ± 12.5 kV (peak to peak 25 kV for pulsing) 
% * *Rated Power:* 30 kW (for maximum 100 millisecond) 
% * *Switching Frequency:* Minimum 100 kHz
% * *Ambient Temperature:* 0-40 °C
Prated      = 30e3; % Rated power [W]
fs          = 100e3; % switching frequency [Hz]
%%
Vp_peak     = 417; % Primary side peak voltage [V]
Vp_fund_peak= Vp_peak*4/pi; % Peak of fundamental of primary voltage [V]
Vp_f_rms    = Vp_fund_peak/sqrt(2); % RMS value of fundamental [V]
%%
Vs_peak     = 12.5e3; % Secondary side peak voltage [V]
Vs_fund_peak= Vs_peak*4/pi; % Peak of fundamental of secondary voltage [V]
Vs_f_rms    = Vs_fund_peak/sqrt(2); % RMS value of fundamental [V]
%%
Ip_rms      = Prated/Vp_f_rms; % Primary side RMS current [A]
Is_rms      = Prated/Vs_f_rms;  % Secondary side RMS current [A]
fprintf('The RMS value of primary side current is %2.2f A.',Ip_rms)
%% 
fprintf('The RMS value of secondary side current is %1.2f A.',Is_rms)

%% Choosing Initial Material

%%
% First step of transformer design is selecting an appropriate core
% material. After some researches on internet and company application 
% guides, it is decided to use a ferrite material for XRAY transformer 
% application at 100kHz switching frequency.
%  
% After this decision, Magnetics' ferrite catalog is read and different
% types of materials are compared. In that comprasion, power losses of
% materials at 25°C and 100kHz is used as basic elimination parameter and
% it is decided to use T material. It is possible to find its parametets
% below:
%
% <<Tmaterial.PNG>>

%% Choosing Operation Flux Density

%%
% For the second phase of design, it is going to be choosen operation flux
% density. T material's saturation flux density is 470mT for this project's
% defined temperature range. Our value should be smaller than saturation
% point. But how much? Let's consider over the formula below:
% 
% $e = -\frac{2*\pi}{\sqrt{2}}N2{\pi}fB_{peak}*A$
% 
% If only selectable parameters are considered, it is possible to see the
% trade-off between number of turns, flux density and area. Selecting high 
% number of turns come with dificulties of cabling and copper losses. Cable
% size is decided over current values so it is constant in this discussion.
% Area is important for transformer's size and weight values. It also
% effects cable length and core loss (over volume). Flux density is
% directly related with core losses. 
%  
% As B is increased, core loss is increased (nonlinearly). If we take BxA 
% value constant, then increasing B will decrease A and therefore volume 
% and weight will be less and it means less core loss. So here, by assuming 
% area and volume are proportional, an optimization will be made over core 
% loss.

B_opr = optimize_B(); %[T]
fprintf('The operation point of flux density is selected as %d mT.',B_opr*10^3)

%%
% Flux density vs core loss graphic has some missing points due to its
% nonlinearity. To be able to find required missing points Lagrange
% polynomial method is used (Function used in this project was written by 
% me during my 3rd class undergraduate studies). After completion is done, 
% assuming area effects volume proportionally, a basic multiplication is 
% made. In coreloss plot unit and magnitude aren't considered but result 
% shows how core loss changes as operation point of flux density is 
% increased. 
plot(B_req, Coreloss);
set(gca,'FontSize',12);
xlabel('Flux Density [mT]');
ylabel('Core loss [W]');
title('W_{Core loss} spread over B');
%%
% This plot shows us selecting an arbitrary operation point may result bad
% efficiecny. Selecting the 2nd minimum point 210mT may be an advantage to
% not have a bigger transformer and still have less core lose. But if the
% absolute minimum point is considered and 80mT is selected, than core loss
% will be 85% smaller. It may mean having 2.5 times bigger transformer but
% it is going to be possible to compansate this value by changing number of
% turns. Also here, it is needed to be asked: "Should it be really small?". 
% Perhaps this XRAY machine will be put in somewhere and stay there until 
% someone needs to clean under it. A small research is done about 
% "portable" XRAY machines. Here is the smallest result:
%
% <<Portable_XRAY1.PNG>>
%
% This XRAY machine is for dentists and just 60W. So our transformer is 
% used for something bigger:
%
% <<Portable_XRAY2.PNG>>
%
% This one's specs are given and when maximum points of voltage and current
% are multiplied result is 24kW and still smaller than our application. In
% such big machines, size of transformer may be ignored, its weight is also
% not so dominant. To be able to operate in a condition with less core loss 
% 80mT is selected as operation flux density. 

%% Determination of Core Dimensions & Number of turns

%%
% Independetly from core dimensions and number of turns, diameter of cable
% might be determined. Because of skin effect, ac current tends to flow on 
% the outside of a conductor.  On a wire the current density looks like a
% hollow tube.  Since the inside isn't used for AC current flow, it makes
% sense to eliminate as much of the hollow part as possible. 
%  
% Here is a practical AWG calculator : <http://daycounter.com/Calculators/SkinEffect/Skin-Effect-Calculator.phtml>
%  
% It suggests "AWG 25" for our application at 100 kHz but because it isn't
% so easy to find odd AWG numbered cables, AWG 24 will be used.

A_awg24 = 0.205*10^-6; %[m^2]
fprintf('Cross-section area of a AWG 24 wire is %0.3f mm^2.',A_awg24*10^6)

%%
% But how many parallel cables? For this purpose, Adiabatic equation will 
% be used. Detailed derivations about this process may be found at
% <http://www.openelectrical.org/wiki/index.php?title=Adiabatic_Short_Circuit_Temperature_Rise>
% The resultant formula is given below:
% 
% $A = \frac{\sqrt{{i^2}t}}{k}$
% 
% In this formula, A is the minimum cross-sectional area of conductor in
% $mm^2$ and k is the Adiabatic constant that might be calculated by 
% formula below.
% 
% $k = {\sqrt{\frac{{c_p}{\rho_d}{\delta}T}{\rho_r}}}$
% 
% Luckily, at the same website another formula is exist for Adiabatic 
% constant for only copper conductors:
% 
% $k = 226\sqrt{ln(1+\frac{T_f - T_i}{234.5 + T_i})}$
% 
% Here, only required part is initial and final temperatures. If we take
% initial value as 25 and let it rise 0.5 degrees,
% 
k_adb = 226*sqrt(log(1+(25.5-25)/(234.5+25)));
fprintf('than Adiabatic constant will be : %1.2f',k_adb)
A_cbl_p = (sqrt((Ip_rms^2)*0.1)/k_adb)*(10^-6);
A_cbl_s = (sqrt((Is_rms^2)*0.1)/k_adb)*(10^-6);

%% 
% From calculated cross-section area of cable we understand that how many
% parallel cables need to be used for desired temperature rise:
% 
N_cbl_prl_p = ceil(A_cbl_p/A_awg24);
N_cbl_prl_s = ceil(A_cbl_s/A_awg24);

fprintf('%d parallel cables for primary and %d for secondary side will be OK.',N_cbl_prl_p,N_cbl_prl_s)

%% 
% Normally AWG 24 has much less current capability but for 100 miliseconds 
% of operation, it will be fine. 
%  
% Here, using induced voltage formula, it is needed to decide number of
% turns and core dimensions together considering the minimum loss. Core 
% material was already seleted as T material from Magnetics' ferrite 
% catalog. Following that decision and considering different types of 
% cores, 5 types of core geometries are selected as candidates. Best one 
% for total of copper and core losses will be selected as the final one. 
% Candidates are:
%  
% * OT44022EC
% * OT45724EC
% * OT45528EC 
% * OT45530EC 
% * OT46527EC
% 
Cores =['OT44022EC';'OT45724EC';'OT45528EC';'OT45530EC';'OT46527EC'];
%%  
% Their cross-section and core volume, length of cable path and core-flux 
% path parameters are calculated and will be used for coreloss calculations.
% Volume and window areas are multiplied by 2 because it is planned to use 
% two cores as a couple without airgap. Also their window areas are 
% calculated to be able to see if we will be able to have enough space for 
% selected wires with selected number of turns.

Ae_T = [233 337 353 420 540]*10^-6; %[m^2]
Ve_T = [227 360 440 520 790]*2*10^(-7); %[m^3]
Aw_T = [14.8*8.65 14.6*9.03 18.5*10.15 18.5*10.15 22*12.72]*2*10^-6; %[m^2]
Lp_T = [12.2+20 18.8+18.8 17.2+21 17.2+24.61 20+27.4]*2*10^-3; %[m]
Le_T = [97 107 124 123 147]*10^-3; %[m]
Masses = [114 179 212 255 410]*2; %[g]
%%
% Now we have possible values for cross-section are and from here it is
% possible to jump corresponding number of turns values. Following 
% "Fundamentals of Power Electronics, Chapter:14" from University of 
% Colorado fill factor is taken as 0.5 for our application.
% <http://ecee.colorado.edu/~ecen5797/course_material/Ch14slides.pdf>
% 
Ku = 0.5;

%% 
% By considering all parameters, core geometry will be choosen to have the
% minimum copper lose. 
% 
Selected_core = Core_selection();
N_turn_p = N_turns_p(Selected_core);
N_turn_s = N_turns_s(Selected_core);
Cu_loss = Cu_losses(Selected_core);
Core_loss = Corelosses(Selected_core);

fprintf('For the best efficiency %s is selected.',Cores(Selected_core,:))
%%
fprintf('This core has %d mm^2 cross-sectional and %3.2f mm^2 window area.',Ae_T(Selected_core)*10^6,Aw_T(Selected_core)*10^6)
%%
fprintf('Its flux path length is %d mm.',Le_T(Selected_core)*10^3)
%%
fprintf('With this selection %d primary and %d secondary turns are determined.',N_turn_p,N_turn_s)
%%
fprintf('For these wires and turns %1.2f W is our copper loss.',Cu_loss)
%%
fprintf('For two of selected cores, %1.2f W will be our core loss.',Core_loss)
%%
%% Determination of efficiency, mass and cost

%%
% Sum of copper and core losses is our total loss.
Total_loss = Cu_loss+Core_loss;
Eff = (Prated)/(Prated+Total_loss)*100;
fprintf('For %1.2f W total loss, efficiency is %2.2f %%.',Total_loss,Eff)

%%
% For selected core, let us calculate the total mass:
Core_mass = Masses(Selected_core); %[g]
fprintf('Selected core mass is %d grams.',Core_mass)
%%
L_wire_p = N_turn_p*N_cbl_prl_p*(1/Ku)*Lp_T(Selected_core); %[m]
V_wire_p = L_wire_p*A_awg24; %[m^3]
L_wire_s = N_turn_s*N_cbl_prl_s*(1/Ku)*Lp_T(Selected_core); %[m]
V_wire_s = L_wire_s*A_awg24; %[m^3]
L_wire = L_wire_p + L_wire_s; %[m]
Cu_density = 8.94*10^3; %[g/m^3]
fprintf('Copper density is known and it is %1.2f kg/m^3.',Cu_density*10^-3)
%%
Copper_mass = (V_wire_p+V_wire_s)*(Cu_density);
Total_mass = Copper_mass + Core_mass;
fprintf('For %2.1f m cable, our total copper mass is %3.2f miligrams.',L_wire, Copper_mass*10^3)
%%
fprintf('Calculated total mass of transformer is %3.0f grams.',round(Total_mass))
%%
fprintf('With aditional materials we may take it as %3.0f grams.',round(Total_mass*1.2))

%%
% Unit copper price is about 4.7 $/kg and selected cores cost more or less
% 3.5 $/set. Because two sets are used in each transformer:
% 
Price_Cu = 4.7*Copper_mass/1000; %[$]
Price_total = ceil(Price_Cu+7); %[$]
fprintf('Total cost of transformer is %2.2f dolars.',Price_total)
%% Calculation of Electrical Parameters
%%
% Using wires' information resistances of both sides will be calculated
% with resistance formula:
% 
% $R = \frac{{\rho}l}{A}$
R_p = rho_Cu*Lp_T(Selected_core)*(1/Ku)*N_turn_p/(N_cbl_prl_p*A_awg24);
R_s = rho_Cu*Lp_T(Selected_core)*(1/Ku)*N_turn_s/(N_cbl_prl_s*A_awg24);
R_core = (Vp_f_rms^2)/Core_loss;
%%
fprintf('Primary side resistance is %2.2f miliohm.',R_p*10^3)
%%
fprintf('Secondary side resistance is %2.2f ohm.',R_s)
%%
fprintf('Core resistance is %2.2f kiloohm.',R_core*10^-3)
%% 
% To be able to calculate magnetizing inductance, ratio of primary side
% fundamental rms voltage to magnetizing current will be used. For
% magnetizing current calculations:
%
% $I_{mag}=\frac{Hl_E}{N_pri}$
mu = 3000*4*pi*10^-7;
H = B_opr/mu; 
I_mag = H*Le_T(Selected_core)/N_turn_p;
Zmag = Vp_f_rms/I_mag;
Xmag = sqrt((Zmag^2)-(R_core^-2));
Lmag = Xmag/(2*pi*fs);
fprintf('Magnetizing inductance is %2.2f miliHenry.',Lmag*10^3)

%% Conclusion

%%
% During all design steps maximum efficiency is taken as main
% consideration. Operation flux density is selected for the least core loss
% point. Initial material is also selected because its low core loss
% coefficient property for operationg switching frequency and temperature.
% Skin effect limits the conductor's effective cross-sectional area so the
% most appropriate option is selected for the optimal result. After that
% selection, it is decided to how many conductors will be paralleled in
% both sides. Considering their temperature rise and conductor thicknisses
% these numbers are choosen. Next step was deciding core dimensions and 
% number of turns. At that point, considering core volume and corresponding
% core loss among with number of turns and copper losses the most optimum
% couple is selected. During this optimization it is also checked if window
% area of core is enough for this combination. Mass and cost are calculated
% and electical parameters are defined. There are missing parts and some
% assumptions throughout the design but efficiency is satisfaying.

%% Project Outcomes

%%
% * *Design specifications of the core:*
fprintf('Selected core is %s and it is %s material.',Cores(Selected_core,:), Cores(Selected_core,2))
%%
fprintf('This core has %d cross-sectional and %3.2f mm^2 window area.',Ae_T(Selected_core)*10^6,Aw_T(Selected_core)*10^6)
%%
fprintf('Its flux path length is %3.2f mm.',Le_T(Selected_core)*10^3)
%%
% * *Coil dimensions:*
fprintf('With this selection %d primary and %d secondary turns are determined.',N_turn_p,N_turn_s)
%%
fprintf('Both side wires are AWG 24 and its thickness is %0.3f mm^2.',A_awg24*10^6)
%%
fprintf('%d parallel cables for primary and %d for secondary side will be used.',N_cbl_prl_p,N_cbl_prl_s)
%%
fprintf('It is used %1.2f m of wire.',L_wire)
%%
% * *Efficiency data:*
fprintf('For selected wires and turns %1.2f W is our copper loss.',Cu_loss)
%%
fprintf('For two of selected cores, %1.2f W will be our core loss.',Core_loss)
%%
fprintf('For %1.2f W total loss, efficiency is %2.2f %%.',Total_loss,Eff)
%%
% * *Electrical parameters:*
fprintf('Primary side resistance is %2.2f miliohm.',R_p*10^3)
%%
fprintf('Secondary side resistance is %2.2f ohm.',R_s)
%%
fprintf('Core resistance is %2.2f kiloohm.',R_core*10^-3)
%%
fprintf('Magnetizing inductance is %2.2f miliHenry.',Lmag*10^3)
%%

%% 
    function [output] = optimize_B()   
        B_given = [80 90 100 200 300]; % [mT]
        Coreloss_coef = [25 32 45 120 900]*1.2*10^-3; % [W/cm^3]
% 1.2 multiplier is added due to difference between 100 degree and room
% temperature.
        B_req = 80:10:300; %[mT]
        for i=1:length(B_req)
            Coreloss_coef2(i)=lagrange(B_given, Coreloss_coef, B_req(i));
            Coreloss(i) = Coreloss_coef2(i)*B_req(1)/B_req(i);        
        end;
        
        output = B_req(find(Coreloss==min(Coreloss)))*10^-3; % [T]
    end
%% 
    function L=lagrange(x,y,k)
        n=length(x);
        l=1;
        L=0;
        for i=1:n
            for j=1:n
                if i~=j
                    l=l*(k-x(j))/(x(i)-x(j));
                end;
            end;
            L=L+l*y(i);
            l=1;
        end; 
    end; 
%% 
    function [output] = Core_selection()
        Corelosses = Ve_T.*10^6*25*1.2*10^-3; % [W]
        rho_Cu = 1.678*10^-8;
        for i=1:length(Ae_T)
            N_turns_p(i) = ceil(Vp_f_rms/((4.44)*2*pi*fs*B_opr*Ae_T(i)));
            N_turns_s(i) = ceil(Vs_f_rms/((4.44)*2*pi*fs*B_opr*Ae_T(i)));
            Area_max(i) = 0.5*Ku*Aw_T(i);
            Area_used(i) = ((N_cbl_prl_p*N_turns_p(i))+(N_cbl_prl_s*N_turns_s(i)))*A_awg24;
            if(Area_used(i)>Area_max(i))
                Cu_losses(i) = 2142;  %for elimination
            else;
            Cu_losses(i) = (Ip_rms^2)*rho_Cu*N_turns_p(i)*Lp_T(i)*(1/Ku)/(A_awg24*N_cbl_prl_p);
            Cu_losses(i) = (Cu_losses(i)+((Is_rms^2)*(rho_Cu*N_turns_s(i)*Lp_T(i)*(1/Ku)/(A_awg24*N_cbl_prl_s))))*1.0344;
            end;
            Total_loss(i) = Corelosses(i) + Cu_losses(i);
        end;
        output =find(Total_loss==min(Total_loss));
    end;       
%%
end