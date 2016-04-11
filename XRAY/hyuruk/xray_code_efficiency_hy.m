% efficiency will be calculate as follows
% neff = 100 * Po / (Po + Total_Loss) [%]
% Total loss includes copper and core losses

tot_loss = core_loss + tot_loss_copper;     %[W]
neff_res = 100* Po / (Po + tot_loss);       %[%]
%%%%%%


