



%% Calculate Firing Field COM
for data_ind = data_inds_to_do
    fprintf('Calculating Firing Fields for data ind %d \n', data_ind);
    %[smoothMap posPDF, aRowAxis, aColAxis] = SamMakeAdSmoothedRateMap(all_data_paths{i}.pos_path, all_data_paths{i}.spike_path,100);
    %[smoothMap posPDF, aRowAxis, aColAxis] = SamMakeAdSmoothedRateMap(all_data_paths{i}.pos_path, all_data_paths{i}.spike_path,100);
    traj = all_data{data_ind}.traj;
    posfile = all_data_paths{data_ind}.pos_path;
    spikefile = all_data_paths{data_ind}.spike_path;
    boxSize = 100;
    SamMakeAdSmoothedRateMap
    all_smoothed_rate_maps{data_ind} = smoothMap;
    %
    %        lowestFieldRate = 1;%THe max rate needs to be higher than this number
    
    lowestFieldRate = max(.4, prctile(smoothMap(:), 85));%THe max rate needs to be higher than this number
%    fieldThreshold = .8 * prctile(smoothMap(:), 92);;%Minimum number for cell to be considered part of firing field
    fieldThreshold = 1. * prctile(smoothMap(:), 85);;%Minimum number for cell to be considered part of firing field
    
    minNumBins = 5; %Was 5 before. There's a tradeoff with the field threshold
    colAxis = aColAxis;
    rowAxis = aRowAxis;
    [nFields,fieldProp,fieldBins,comXvec,comYvec,avgRate,peakRate,FFsize] = placefield(smoothMap,lowestFieldRate,fieldThreshold, minNumBins, colAxis,rowAxis);
    
    
    nanned_smooth_map = smoothMap;
    for field_bin_ind = 1:size(fieldBins, 1);
        v1 = fieldBins(field_bin_ind, 1);
        v2 = fieldBins(field_bin_ind, 2);
        
        v1 = v1{1};
        v2 = v2{1};
        for j = 1:length(v1);
            
            nanned_smooth_map(v1(j), v2(j)) = nan;
        end
    end
    
    %    spitOutImageScFlipped(nanned_smooth_map, sprintf('OutputMaps/foo%dnan.png', i));
    %    spitOutImageScFlipped(smoothMap,  sprintf('OutputMaps/foo%d.png', i));
    map_output_file = sprintf('%s/OutputMaps/%s_MapAndCorr.png', ap.output_path, FileNameFromPath(all_data_paths{data_ind}.spike_path));
    spitOutImageScFlipped(smoothMap,  map_output_file, struct('make_dots', isnan(nanned_smooth_map)));
    all_data{data_ind}.fcom_X = comXvec;
    all_data{data_ind}.fcom_Y = comYvec;
end
MakeFilePath(all_data_path);
save(all_data_path, 'all_data');

