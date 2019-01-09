close all
clear all

x_range = (0:.05:2*pi) * 6;
x_range = x_range - mean(x_range);
y_range = x_range;


[x, y] =  meshgrid(x_range, y_range);
y = y + x/3;
x = x/ 1.4;


ax1 = x;
ax2 = (x/2) + y * sqrt(3)/2;
ax3 = -(x/2) + y*sqrt(3)/2;

firing_rate =(1 + cos(ax1)) .* (1 + cos(ax2)) .* ( 1 + cos(ax3));
%firing_rate = firing_rate + .000001 * randn(size(firing_rate));%Get rid of any sort of deneneracy

subplot(2, 1, 1);
imagesc(firing_rate);
colorbar;


subplot(2,1 , 2);

%firing_rate = cos(x) .* cos(y);

%firing_rate = cos(x).^2;

meanized_firing_rate = mean(firing_rate(:)) * ones(size(firing_rate));



cross_corr = (xcorr2(firing_rate) - xcorr2(meanized_firing_rate))./xcorr2(ones(size(firing_rate))); 
%Need to normalize so things don't get blurred out farther away. These have
%a smaller "Sample Size", so we've gotta deal with that somehow.


%cross_corr = (xcorr2(firing_rate) - xcorr2(meanized_firing_rate));
cropped_image = cross_corr;
%cropped_image = cross_corr(50:400, 50:400);
local_maxima = imregionalmax(cropped_image);

imagesc(cropped_image);
colorbar;
hold on;


[jj ii] = find((local_maxima));
scatter(ii,jj,'ok','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0 0 0],'LineWidth',1,'SizeData',30)

j_center = 1 +  (size(cropped_image, 1) -1)/2;
i_center = 1 +  (size(cropped_image, 2) -1)/2;





peak_to_center_distance = sqrt((jj - j_center).^2 + (ii - i_center).^2);
[~, shortest_inds] = sort(peak_to_center_distance);




neighbor_jj_candidates = jj(shortest_inds);
neighbor_ii_candidates = ii(shortest_inds);

neighbor_repulsion = 10; %If we get two nearby peaks, we only use one of them
super_window_width = 3;%Super-resolution window_width 

neighbor_jj = [j_center];
neighbor_ii = [i_center];

[iX_mesh, iY_mesh] = meshgrid(1:size(cropped_image,1), 1:size(cropped_image,2));

cur_candidate_ind = 2;
while(length(neighbor_jj) <7)
    proposed_jj = neighbor_jj_candidates(cur_candidate_ind);
    proposed_ii = neighbor_ii_candidates(cur_candidate_ind);
    
    distance_from_neighbors = sqrt((neighbor_jj - proposed_jj).^2 + (neighbor_ii - proposed_ii).^2);    
    
    if(min(distance_from_neighbors) > neighbor_repulsion)
        neighbor_jj(length(neighbor_jj) + 1) = proposed_jj;
        neighbor_ii(length(neighbor_ii) + 1) = proposed_ii;        
        %TODO-Add SuperResolution?
    end
    
    cur_candidate_ind = cur_candidate_ind + 1;
end




%scatter(neighbor_ii, neighbot
scatter(neighbor_ii(2:7),neighbor_jj(2:7),'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'LineWidth',1,'SizeData',170)

%scatter(neighbor_ii_candidates,neighbor_jj_candidates,'ok','MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[1 0 1],'LineWidth',1,'SizeData',170)

delta_ii = neighbor_ii - i_center;
delta_jj = neighbor_jj - j_center;

delta_position = [ delta_ii; delta_jj];
cov_matrix = (delta_position * delta_position')/6.;
[theta, r] = cart2pol(delta_ii, delta_jj);

ellipse_handle = error_ellipse(cov_matrix * 2, [i_center j_center]); %Need to multiply the covariance by two because the covariance of a unit circle is only (1/2)
%    ERROR_ELLIPSE(C,MU) - Plot the ellipse, or ellipsoid, centered at MU,
%    a vector whose length should match that of C (which is 2x2 or 3x3).


neighbor_distances = sqrt(delta_ii.^2 + delta_jj.^2);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [6 12]);
cur_position = get(gcf, 'Position');
cur_position(3:4) = [700 400];
set(gcf, 'Position', cur_position);

%set(gca, 'Position', 'on');
saveas(1, 'foo.png');




