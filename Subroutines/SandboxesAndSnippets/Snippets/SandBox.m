for i = 1:length(all_data_paths)
    cur_path = all_data_paths{i}.spike_path;    
    [a b c] = fileparts(cur_path);    
     n1 =   sprintf('%s%s', b, c);     
     
    cur_path = all_data_paths{i}.pos_path;    
    [a b c] = fileparts(cur_path);    
     n2 =   sprintf('%s%s', b, c);     
     
     
     fprintf(f, '%s, \t %s \n', n2, n1);
end









for i = 1:length(rate_map_mega_struct.trajectories)
    cur_traj = rate_map_mega_struct.trajectories{i};
    
end



ratio_list = []
i = 1;
for x = 0:1:5 %Observed
    for y = 1:1:20 %Expected
        ratio = exp(LogPoissPdf(x, y))/poisspdf(x,y);
        %       fprintf('Ratio is %f \n', ratio);
        ratio_list(i) = ratio;
        i = i+1;
    end
    
end









%% Prob dont need this, prob redundant with what i have


rate_map_1 = max(cond_rate_map_struct.stens_firing_rate, 0);%Fill in nan with 0
rate_map_2 = max(opp_cond_rate_map_struct.stens_firing_rate, 0);
cur_x_corr = xcorr2(rate_map_1, rate_map_2);
x_corr_array{data_ind}{path_cond_type_ind}{path_cond_dir_ind} = cur_x_corr;
foo  = cur_x_corr;

jj =(size(foo, 1) + 1)/2;
ii =(size(foo, 2) + 1)/2;
imagesc(foo);
hold on;

scatter(jj,ii,'ok','MarkerEdgeColor', 0 * [1 1 1],'LineWidth',2,'SizeData',100)
pause
close all;
