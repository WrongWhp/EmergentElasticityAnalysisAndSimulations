%Prints the conditional distribution of attractor states in the center of
%the box. Simple way to quantify path-dependent shifts. 

center_iY = round(sysparams.array_height/2);
center_iX = round(sysparams.array_width/2);





for cur_cond = 1:8    
    output_file_path = sprintf('%s/Rh/CondCenterOfBox/RHCond_Run%dCond%d.png', sysparams.folder_path, run_num, cur_cond);
    cond_rh_slice = system.cond_rh_accum(center_iY, center_iX, :, :, cur_cond);
    permuted_conds = permute(cond_rh_slice, [3 4 1 2]);    
    if(sum(permuted_conds(:)) > 0)
    im_to_write = RhDistImage(permuted_conds);
    imwriteWithPath(imresize(im_to_write, 3, 'nearest'), output_file_path);
    
    
    end
end



