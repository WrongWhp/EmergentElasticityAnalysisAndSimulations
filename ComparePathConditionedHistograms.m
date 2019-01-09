close all
clear all
global ap;%%Short for analysis parameters

addAllPaths;
%ap.data_dir_path = '../../AllGridCellData/PartialData/';ed
ap.data_dir_path = '../../../AllGridCellData/TrimmedPlusOppHem/'
%ap.data_dir_path = '../../AllGridCellData/LisasRatData/Frodo/';
%ap.data_dir_path = '../../AllGridCellData/FakeData/FakeDataHeadParr/';
%ap.data_dir_path = '../../AllGridCellData/FakeData/FakeDataPathParr/';
%ap.data_dir_path = '../../AllGridCellData/Sargolini2006/all_data/';

%ap.data_dir_path = '../../AllGridCellData/PartialData/';
all_data_paths = TraverseFreeRoamingData(ap.data_dir_path);
ap.output_path = [ap.data_dir_path  '/Aug2018SpikeGatherAnalysisOutput/'];

%%%%Decides which path conditions we're going to use
%path_cond_type_ind_list = [1 4 12 13];
%path_cond_type_ind_list = 1:11;

path_cond_type_ind_list = 1:4
ap.past_cond_time_delay = 10;
ap.future_cond_time_offset = 10;
ap.min_cond_dist = 0;
ap.has_hit_wall_thresh = .1;


makeDirectionConditions;
data_inds_to_do = 1:length(all_data_paths);
%data_inds_to_do  = 1:3;


all_data_path = [ap.output_path 'all_data.mat'];

if(exist(all_data_path))
    fprintf('Loading previously constructed all_data struct...');
    load(all_data_path, 'all_data');
    fprintf('Done! \n');    
else    
    LoadModifyAndPlotTrajectories
    CalculateFiringFieldCOMS
end
%return;

SortSpikeAndMousePositionsByFiringFieldAndCond

gatherSpikePositions
calculateAndPlotMoments
OutputShiftShiftCorrelations
%return;
%% Calculates moments
max_x_diff = 0;
max_y_diff = 0;

for path_cond_type_ind = path_cond_type_ind_list
    
    fprintf('************** \n');
    for path_cond_dir_ind = 1:4;
        cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
        
        x_accum = 0;
        y_accum = 0;
        count_accum = 0;
        
        for data_ind = data_inds_to_do
            cur_com_struct = spike_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            
            [x, y, count] = MomentFromCOM(cur_com_struct);
            if(count>0 && isfinite(x*y*count))
                
                x_accum = x_accum + x;
                y_accum = y_accum + y;
                count_accum = count_accum + count;
                diff_x = cur_com_struct.x - cur_com_struct.base_x;
                max_x_diff = max(max_x_diff, max(abs(diff_x)));
                
                diff_y = cur_com_struct.y - cur_com_struct.base_y;
                max_y_diff = max(max_y_diff, max(abs(diff_y)));
                x_spike_list(data_ind) = x/count;
                y_spike_list(data_ind) = y/count;
            end
        end
        fprintf('Offset for %s (Spike) is (%f,%f) \n', cur_cond.name, x_accum/count_accum, y_accum/count_accum);
        x_accum = 0;
        y_accum = 0;
        count_accum = 0;
        
        for data_ind = data_inds_to_do
            cur_com_struct = mouse_com_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            
            [x, y, count] = MomentFromCOM(cur_com_struct);
            if(count>0 && isfinite(x*y*count))
                x_accum = x_accum + x;
                y_accum = y_accum + y;
                count_accum = count_accum + count;
                diff_x = cur_com_struct.x - cur_com_struct.base_x;
                max_x_diff = max(max_x_diff, max(abs(diff_x)));
                
                diff_y = cur_com_struct.y - cur_com_struct.base_y;
                max_y_diff = max(max_y_diff, max(abs(diff_y)));
                x_mouse_list(data_ind) = x/count;
                y_mouse_list(data_ind) = y/count;
                
            end
            
        end
        
        close all;
        hist(x_spike_list - x_mouse_list, 20);
        title(sprintf('X List %s with mean of %f, p = %f', cur_cond.name, nanmean(x_spike_list- x_mouse_list), signFlipPValue(x_spike_list- x_mouse_list)));
        pause;
        
        close all;
        hist(y_spike_list - y_mouse_list, 20);
        title(sprintf('Y List %s with mean of %f, p = %f', cur_cond.name, nanmean(y_spike_list- y_mouse_list), signFlipPValue(x_spike_list- x_mouse_list)));
        pause;
        
        fprintf('Offset for %s (Mouse) is (%f,%f) \n', cur_cond.name, x_accum/count_accum, y_accum/count_accum);
    end
    
end

return;

%%
for data_ind = data_inds_to_do
    fprintf('Outputting spike positiions for data ind %d \n', data_ind);
    traj = all_data{data_ind}.traj;
    
    %  traj = LoadTrajectoryYNorthXEast(all_data_paths{data_ind}.pos_path);
    %   load(all_data_paths{data_ind}.spike_path);
    
    
    
    for path_cond_type_ind = path_cond_type_ind_list
        for path_cond_dir_ind = [1 3];
            cur_cond_spike_positions = spike_pos_structs{data_ind}{path_cond_type_ind}{path_cond_dir_ind};
            opp_cond_spike_positions = spike_pos_structs{data_ind}{path_cond_type_ind}{oppositeDirectionInd(path_cond_dir_ind)};
            
            cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
            opp_cond = path_condition_array{path_cond_type_ind}{oppositeDirectionInd(path_cond_dir_ind)};
            
            scatter(cur_cond_spike_positions.x, cur_cond_spike_positions.y, 'r.');
            hold on;
            scatter(opp_cond_spike_positions.x, opp_cond_spike_positions.y, 'g.');
            
            scatter(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y,'MarkerEdgeColor',0 * [1 1 1],'MarkerFaceColor',[0 0 0] ,'LineWidth',2,'SizeData',100);
            
            
            cond_com = ConditionalCOM(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y, cur_cond_spike_positions.x, cur_cond_spike_positions.y);
            opp_cond_com = ConditionalCOM(all_data{data_ind}.fcom_X, all_data{data_ind}.fcom_Y, opp_cond_spike_positions.x, opp_cond_spike_positions.y);
            
            scatter(cond_com.x, cond_com.y, 'MarkerEdgeColor',0 * [1 1 1],'MarkerFaceColor','r','LineWidth',2,'SizeData',100);
            scatter(opp_cond_com.x, opp_cond_com.y, 'MarkerEdgeColor',0 * [1 1 1],'MarkerFaceColor','g','LineWidth',2,'SizeData',100);
            
            
            
            
            title(sprintf('%s vs. %s', cur_cond.name, opp_cond.name));
            output_file_path = sprintf('Outputs/SpikePos/%s/Dir%d/Cell%d%s.png', cur_cond.name,   path_cond_dir_ind, data_ind , cur_cond.name);
            output_file_path = strrep(output_file_path, ' ', '');
            output_file_path = strrep(output_file_path, '(', '_');
            output_file_path = strrep(output_file_path, ')', '_');
            
            MakeFilePath(output_file_path);
            saveas(1, output_file_path);
            
            close all;
            
        end
    end
end

