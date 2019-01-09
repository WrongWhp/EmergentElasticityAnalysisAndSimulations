function [cov_matrix output_neighbors] = CrossCorrAndShear(rate_map, param_struct);
close all

subplot(2, 1, 1);
imagesc(rate_map);
axis square
colorbar;
if(isfield(param_struct, 'title'))
    title(param_struct.title);
end


%mean_subtracted_rate_map = mean(rate_map(:)) * ones(size(rate_map));
cross_corr = (xcorr2(rate_map - mean(rate_map(:))))./xcorr2(ones(size(rate_map)));
%Need to normalize so things don't get blurred out farther away. These have
%a smaller "Sample Size", so we've gotta deal with that somehow. I do that
%by normalizing by the crosscorrelation of a uniform matrix.

local_maxima = imregionalmax(cross_corr);
[jj ii] = find((local_maxima));




j_center = 1 +  (size(cross_corr, 1) -1)/2;
i_center = 1 +  (size(cross_corr, 2) -1)/2;





peak_to_center_distance = sqrt((jj - j_center).^2 + (ii - i_center).^2);
[~, shortest_inds] = sort(peak_to_center_distance);




neighbor_jj_candidates = jj(shortest_inds);
neighbor_ii_candidates = ii(shortest_inds);

neighbor_repulsion = 4; %If we get two nearby peaks, we only use one of them


neighbor_jj = [j_center]; %Add the center to the list, because we want a zone of repulsion around the center.
neighbor_ii = [i_center];
%[iX_mesh, iY_mesh] = meshgrid(1:size(cross_corr,1), 1:size(cross_corr,2));


%Look for peaks in the cross correlation matrix that are close to the
%center without being too close to the center or each other.
cur_candidate_ind = 2;
while(length(neighbor_jj) <7)
    proposed_jj = neighbor_jj_candidates(cur_candidate_ind);
    proposed_ii = neighbor_ii_candidates(cur_candidate_ind);
    distance_from_neighbors = sqrt((neighbor_jj - proposed_jj).^2 + (neighbor_ii - proposed_ii).^2);
    
    
    if(0)
        parab_fit_range = [-1 0 1];
        neighbor_peak = parabolicFit(cross_corr(proposed_jj + parab_fit_range, proposed_ii + parab_fit_range));
        center_peak = parabolicFit(cross_corr(j_center + parab_fit_range, i_center + parab_fit_range));
        peak_size_ratio = neighbor_peak.peak_width/center_peak.peak_width;
    else
        peak_size_ratio = 1;
    end
    
    %    neighbor_height = cross_corr(proposed_jj, proposed_ii)
    %    center_height = cross_corr(j_center, i_center)
    
    
    %    fraction_of_center_height = neighbor_height/center_height;
    %    fraction_of_center_height = cross_corr(neighbor_jj, neighbor_ii)/cross_corr(j_center, i_center)
    cross_corr_size  = size(cross_corr);
    if(and(min(distance_from_neighbors) > neighbor_repulsion, peak_size_ratio>.2))
        neighbor_jj(length(neighbor_jj) + 1) = proposed_jj;
        neighbor_ii(length(neighbor_ii) + 1) = proposed_ii;
        %TODO-Add SuperResolution?
    end
    
    cur_candidate_ind = cur_candidate_ind + 1;
end



%scatter(neighbor_ii_candidates,neighbor_jj_candidates,'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'LineWidth',1,'SizeData',170)

delta_ii = neighbor_ii - i_center;
delta_jj = neighbor_jj - j_center;

delta_position = [ delta_ii; delta_jj];
cov_matrix = (delta_position * delta_position')/6.;
[neighbor_theta, neighbor_r] = cart2pol(delta_ii, delta_jj);



neighbor_distances = sqrt(delta_ii.^2 + delta_jj.^2);



%Plot the cross-correlation matrix, the local maxima, and the ones that
%were actually chosen.
subplot(2, 1 , 2);
imagesc(cross_corr, abs(cross_corr(j_center, i_center)) * [- 1 1]);
axis square

colorbar;
hold on;
[jj ii] = find((local_maxima));
scatter(ii,jj,'ok','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0 0 0],'LineWidth',1,'SizeData',30)
scatter(neighbor_ii(2:7),neighbor_jj(2:7),'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'LineWidth',1,'SizeData',60)
ellipse_handle = error_ellipse(cov_matrix * 2, [i_center j_center]); %Need to multiply the covariance by two because the covariance of a unit circle is only (1/2)

set(ellipse_handle, 'Color', [1 .8 1]);
set(ellipse_handle, 'LineWidth', 2);

%    ERROR_ELLIPSE(C,MU) - Plot the ellipse, or ellipsoid, centered at MU,
%    a vector whose length should match that of C (which is 2x2 or 3x3).


set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 12]);
cur_position = get(gcf, 'Position');
cur_position(3:4) = [700 400];
set(gcf, 'Position', cur_position);

%set(gca, 'Position', 'on');
MakeFilePath(param_struct.output_path);
saveas(1, param_struct.output_path);

output_neighbors.theta = neighbor_theta;
output_neighbors.r = neighbor_r;



