


load('CondRateMaps.mat');

addAllPaths
trans_amount = 1;

trunc_cond_maps = {};


for data_ind = 1:length(cond_rate_maps);
   cur_list = cond_rate_maps{data_ind}
   ok_sized_maps = 1;
   
   for cond_ind = [1 3]
      cur_size = size(cur_list{cond_ind}) 
      ok_sized_maps = and(ok_sized_maps, prod(cur_size) == prod([38 38]));
   end
   ok_sized_maps
   ok_list(data_ind) = ok_sized_maps
   
   if(ok_sized_maps)
      trunc_cond_maps{length(trunc_cond_maps) + 1} = cur_list;       
   end
      
end


window_inds = 10:28;


for trunc_ind = 1:length(trunc_cond_maps)
    
    base_map = trunc_cond_maps{trunc_ind}{1};
    cond_map = trunc_cond_maps{trunc_ind}{3};
    
    
    
    left_trans_cos(trunc_ind) = CosineTheta(base_map(window_inds, window_inds), cond_map(window_inds, window_inds -trans_amount));
    right_trans_cos(trunc_ind) = CosineTheta(base_map(window_inds, window_inds), cond_map(window_inds, window_inds +trans_amount));
    
    
end

scatter(left_trans_cos, right_trans_cos);
hold on;
min_cos = min([left_trans_cos right_trans_cos]);
max_cos = max([left_trans_cos right_trans_cos]);
plot([min_cos max_cos],  [min_cos max_cos]);


