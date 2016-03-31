% X-ray transformer design
% Single-phase, high frequency (100 kHz), high voltage
% Primary Winding Voltage: ± 417 V (peak to peak 834 V for pulsing)
% Secondary Winding Voltage: ± 12.5 kV (peak to peak 25 kV for pulsing)
% Rated Power 30 kW (for maximum 100 millisecond)
% Switching Frequency: Minimum 100 kHz
% Ambient Temperature: 0-40 °C


% Inputs

Vin = 417;
Vp_peak = Vin*4/pi;
Vp_rms = Vp_peak/sqrt(2);
Vout = 12500;
Vs_peak = Vout*4/pi;
Vs_rms = Vs_peak/sqrt(2);
Pout = 30000;
Ip=Pout/Vin;
Isec=Pout/Vout;
Ip_rms = Pout/Vp_rms;
Is_rms = Pout/Vs_rms;
freq=100000;
eff=0.9;
reg=0.05;
Bac=0.32;
Ku=0.4;

%formulas

%skin depth
skin_depth=6.62/sqrt(freq);
% Wire diameter
Daw= 2*skin_depth;
%wire area
Aw=(pi*(Daw)^2)/4;
%Input power
Pin=Pout/eff;
%total power
Ptot=Pin+Pout;
%electrical condition
Kf=4;  %for square wave
Ke=0.145*(Kf)^2*(freq)^2*(Bac)^2*(10^-4);
%core geometry
Kg=Ptot/(2*Ke*reg);
Kg_new = Kg*1.35;
%core is selected
% ETD59, N87 ungapped
%core data
Ac=3.68;
Ap=19.07;
MLT= 12.9;
Wtfe=260;
At=163.1;
%primary number of turns
Np_old=(Vin*10^4)/(Kf*Bac*freq*Ac);
Np=ceil(Np_old);
%Current density
J=(Ptot*10^4)/(Kf*Ku*Bac*freq*Ap);
%Input current
Iin=(Pout)/(Vin*eff);
%Bare wire area
Dmax=0.5;
Awp_B= (Iin*sqrt(Dmax))/J;
%Primary strand
Copper_bare_area = 0.00128;
Snp=Awp_B/Copper_bare_area;
%microohm per centimeter
mic_ohm_per_cm = 1345;
new_mic_ohm_per_cm = mic_ohm_per_cm /Snp ;
%Primary resistance 
Rp=MLT*Np*new_mic_ohm_per_cm*(10^-6);
%Primary copper loss
Pp=Ip^2*Rp;
%Secondary number of turns
Ns_old = ((Np)*(Vs_peak)*(1+(reg/100)))/(Vin);
Ns=ceil(Ns_old);
%Secondary bare wire area
Aws_1=(Isec)*(sqrt(Dmax))/J;
%secondary strands
Sns=Aws_1/Copper_bare_area ;
new2_mic_ohm_per_cm = mic_ohm_per_cm /Sns;
%Secondary resistance
Rs1=(MLT)*Ns*new2_mic_ohm_per_cm*10^-6;
%secondary copper loss
Ps=(Isec)^2*Rs1;
%Total copper loss
Pcu=Pp+Ps;
%transformer regulation
alfa=(Pcu/Pout)*100;
%milliwatts per gram
miliwatts_per_gr=0.000318*(freq)^1.51*(Bac)^2.747;
%core loss
Pfe=miliwatts_per_gr*Wtfe*10^-3;
%total loss
Pfinal=Pcu+Pfe;
%watts per unit area
watts_per_unit_area=Pfinal/At;
%temperature rise
Tr=450*(watts_per_unit_area)^0.826;
