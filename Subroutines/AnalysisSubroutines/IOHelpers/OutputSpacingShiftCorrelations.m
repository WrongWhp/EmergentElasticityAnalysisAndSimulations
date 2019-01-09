%Looking for an effect we saw in simulations relating the half-integerness
%to the wall ize. Northing really.
close all;
for data_ind = maps_to_do
    [np_x, np_y] = pol2cart(rate_map_mega_struct.neighbor_posits{data_ind}.theta(2:7), rate_map_mega_struct.neighbor_posits{data_ind}.r(2:7));
    scatter(np_x, np_y, 'b');
    max_np_y(data_ind) = max(np_y);
    max_np_x(data_ind) = max(np_x);
    np_theta = rate_map_mega_struct.neighbor_posits{data_ind}.theta(2:7);
    
    [~, min_theta_ind]  = min(abs(np_theta-((pi/2 * 1) -.15 * .3)));
    np_theta_to_use(data_ind) = np_theta(min_theta_ind) - (pi/2);
%    np_theta_to_use(data_ind) = np_x(min_theta_ind) - (pi/2);
    np_max_x(data_ind) = max(np_x);
    np_max_y(data_ind) = max(np_y);

    hold on;
    
%    scatter(sin(np_theta_to_use(data_ind)), cos(np_theta_to_use(data_ind)));
    scatter(np_x(min_theta_ind), np_y(min_theta_ind), 'k');
    
end

pause;



for path_cond_type_ind = ap.path_cond_type_list
    close all
    
    if(0)
        %Parallel stuff
        if(0)
            a1 = 38./max_np_y;
            a2 = (v1_v2_diff{path_cond_type_ind}{3}{2});
%            a2 = (v1_v2_diff{path_cond_type_ind}{3}{2})./a1;
            
            
        elseif(0)
            
            a1 = 38./max_np_x;
                a2 = v1_v2_diff{path_cond_type_ind}{1}{1};
            
        else
            a1 = np_max_y./np_max_x;
            a2 =  -(v1_v2_diff{path_cond_type_ind}{3}{2} -  v1_v2_diff{path_cond_type_ind}{1}{1});
        end
        
    else
    
        %Ortho stuff-Comparing angle to shift
        if(0)
%            ok_ind = abs(np_theta_to_use)<pi/12;
            a2 = (v1_v2_diff{path_cond_type_ind}{3}{1});
            a1 = (np_theta_to_use).^2;
        else
                a1 = np_theta_to_use;
            a2 = (v1_v2_diff{path_cond_type_ind}{1}{2});
        end        
    end        
        
        %    a2 = v1_v2_diff{path_cond_type_ind}{1}{1};
        %    a2 = v1_v2_diff{path_cond_type_ind}{1}{1};
        
        %        a2 = v1_v2_diff{path_cond_type_ind}{3}{2};
        
        [a1_a2_corr, a1_a2_corr_p_values] = CorrPValue(a1, a2, 'spearman');
        scatter(a1, a2);
        title(sprintf('%s (x) vs. \n %s (y) \n Corr is %f With PValue of %f', 'NSpacings' , path_condition_array{path_cond_type_ind}{3}.name, a1_a2_corr, a1_a2_corr_p_values));
        output_path = sprintf('%s/OutputScatter/ShiftShiftcorrelation/%s.png', ap.output_path, path_condition_array{path_cond_type_ind}{1}.name)
        MakeFilePath(output_path);
        saveas(1, output_path);
        saveas(1, strrep(output_path, '.png', '.fig'));
        
    end
