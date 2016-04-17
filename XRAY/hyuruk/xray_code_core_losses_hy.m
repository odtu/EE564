% core losses will be calculated as follows
% volume of the core: 
% Volume = ((A*2B*C) - (2*2D*M*C)) * 10^-3  [cm^3]
% core loss mW/cm^3 will be determined 
% @operating B, @operating f, @operating temperature

core_loss = Vol_eff * graph_core_loss_40deg * 10^-3;   %[W]
%%%%%%


