% efficiency will be calculate as follows
% neff = 100 * Po / (Po + Total_Loss) [%]
% Total loss includes cupper and core losses

tot_loss = core_loss + tot_loss_cupper;     %[W]
neff_res = 100* Po / (Po + tot_loss);       %[%]
%%%%%%


