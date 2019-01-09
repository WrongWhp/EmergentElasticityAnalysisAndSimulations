close all
clear all

addAllPaths;
%ap.data_dir_path = '../../AllData/BorderCellDataTrimmed/';
%ap.data_dir_path = '../../AllData/MalcolmBorderCells/';

ap.data_dir_path = '../../AllData/MalcolmTrimmedBorderCells/';


all_data_paths = TraverseFreeRoamingData(ap.data_dir_path);
path_cond_type_ind_list = 4;

%path_cond_type_ind_list = 1:11;
%path_cond_type_ind_list = 1:4
ap.output_path = [ap.data_dir_path  '/SpikeGatherAnalysisOutput/'];
global ap;

%ap.head_rotations_to_try = [1 3];
%ap.head_rotations_to_try = [2 4];
ap.past_cond_time_delay = 10;
ap.future_cond_time_offset = 10;
ap.min_cond_dist = 0;
ap.has_hit_wall_thresh = .1;


makeDirectionConditions;
data_inds_to_do = 1:length(all_data_paths);
%data_inds_to_do  = 1:3;
%data_inds_to_do = 1:50;
%data_inds_to_do = 30:45;
%data_inds_to_do = 41:42;

%% Load And Modify All Trajectories.

for data_ind = data_inds_to_do
    fprintf('Making spike positiions for data ind %d \n', data_ind);
    traj = LoadTrajectoryYNorthXEast(all_data_paths{data_ind}.pos_path);
    if(1)
        theta = calculateHDTiltBestProjection(traj);
        traj.head_vel_angle = theta;
        traj = tiltHDByAngle(traj, -theta);
        %        pixel_shift = 3 * 0;
        pixel_shift = 4;
        %        traj = shiftPositionByHD(traj, pixel_shift);
        
        fprintf('Old angle was %f, New angle is %f \n',theta,  calculateHDTiltBestProjection(traj));
        traj = shiftPositionByHD(traj, pixel_shift);
        traj = NormalizeToCentimeters(traj, 100);
    end
    all_data{data_ind}.traj = traj;
end




%% Calculates spike positions
firing_rate_accum = (0:50)' * 0;
for data_ind = data_inds_to_do
    fprintf('Making spike positiions for data ind %d \n', data_ind);
    
    traj = all_data{data_ind}.traj;
    
    
    load(all_data_paths{data_ind}.spike_path);
    %    opp_cond_dir_ind = oppositeDirectionInd(path_cond_dir_ind);
    
    %cur_cond = path_condition_array{path_cond_type_ind}{path_cond_dir_ind};
    %satisfies_cond_inds = pathConditionSwitchboard(traj, cur_cond);
    %cond_not_satisfied = setdiff(1:length(traj.posx), satisfies_cond_inds);
    
    posx = traj.posx;
    posy = traj.posy;
    
    cond_nanned_posx = posx;
    %    cond_nanned_posx(cond_not_satisfied) = nan;
    cond_nanned_posy = posy;
    %    cond_nanned_posy(cond_not_satisfied) = nan;
    
    
    [spkx, spky] = SamSpikePos(cellTS, cond_nanned_posx, cond_nanned_posy, traj.post);
    
    
    
    
    mouse_dist_from_wall = DistanceFromAnyWall(posx, posy, [-50 50], [-50 50]);
    spike_dist_from_wall = DistanceFromAnyWall(spkx, spky, [-50 50], [-50 50]);
    
    
    mouse_hist = histc(mouse_dist_from_wall, 0:50);
    spike_hist = histc(spike_dist_from_wall, 0:50)';
    
    blur_filter = fspecial('gaussian', [15 15], 2);
    
    firing_rate = imfilter(spike_hist, blur_filter)./ imfilter(mouse_hist, blur_filter);
    close all;
    plot(firing_rate);
    output_path = sprintf('BorderRates/DataInd%dDistFromWallRate.png', data_ind);
    MakeFilePath(output_path);
    saveas(1, output_path);
    %    pause;
    
    
    firing_rate_accum = firing_rate_accum + firing_rate;
    
    %    firing_rate_accum = firing_rate_accum + firing_rate/sum(firing_rate);
    %%%
    
    if(1)
        traj = all_data{data_ind}.traj;
        posfile = all_data_paths{data_ind}.pos_path;
        spikefile = all_data_paths{data_ind}.spike_path;
        boxSize = 100;
        SamMakeAdSmoothedRateMap
        
        
        
        
        map_output_file = sprintf('BorderRates/DataInd%dAdSmoothed.png', data_ind)
        nanned_smooth_map = smoothMap;
        
        spitOutImageScFlipped(smoothMap,  map_output_file, struct('make_dots', isnan(nanned_smooth_map)));
        
        [a, b, c] = fileparts(all_data_paths{data_ind}.spike_path);
        other_map_output_file = sprintf('BorderRates/%s.png', b)
        spitOutImageScFlipped(smoothMap,  other_map_output_file, struct('make_dots', isnan(nanned_smooth_map)));
    end
    %    sc_posx = posx +50;
    %    sc_posy = posy + 50;
    %    sc_spkx = spkx + 50;
    %    sc_spky = spky + 50;
    
    
    
end

if(1)
    
    close all
    norm_firing_accum = firing_rate_accum * 50./11.;
    
    
    plot(0:50, norm_firing_accum, 'LineWidth', 2);
    
    f = fit((0:50)', norm_firing_accum, 'exp1');
    hold on;
    plot(0:50, f(0:50), 'LineWidth', 2, 'LineStyle', '--');
    set(gca, 'FontSize', 33);
    xlabel('Distance From Wall (cm)');
    ylabel('Firing Rate(hz)');
    xlim([0 50]);
    
    output_path = sprintf('BorderRates/AveragedBorderRates.png');
    MakeFilePath(output_path);
    saveas(1, output_path);
    
end




