function [firing_rate] =  CenterOfMassSmoothing(mouse_count, spike_count);
%clear all
%close all

%mouse_count = double(rand(10));

%mouse_count = ones(5);
%mouse_count(1, 1:5) = 1.1;
%spike_count = x_mesh .* mouse_count;

[x_mesh, y_mesh] = meshgrid(1:size(mouse_count, 2), 1:size(mouse_count, 1));


mouse_count_times_x = mouse_count .*x_mesh;
mouse_count_times_y = mouse_count .* y_mesh;


if(1)
    filter_0 =[0 1 0; 1 4 1; 0 1 0];
    filter_0 = filter_0/sum(filter_0(:));
else
    filter_0 = ...
        [0.0025 0.0125 0.0200 0.0125 0.0025;...
        0.0125 0.0625 0.1000 0.0625 0.0125;...
        0.0200 0.1000 0.1600 0.1000 0.0200;...
        0.0125 0.0625 0.1000 0.0625 0.0125;...
        0.0025 0.0125 0.0200 0.0125 0.0025];
end
[filter_x_mesh, filter_y_mesh] = meshgrid(1:size(filter_0, 2), 1:size(filter_0, 1));
filter_x_mesh = filter_x_mesh - mean(filter_x_mesh(:));
filter_y_mesh = filter_y_mesh - mean(filter_y_mesh(:));

filter_x = filter_0 .* filter_x_mesh;
filter_y = filter_0 .* filter_y_mesh;




smoothed_mouse_count_00 = imfilter(mouse_count, filter_0, 0); %Weight using base filter
smoothed_mouse_count_x0 = imfilter(mouse_count_times_x, filter_0); %X * weight using base filter
smoothed_mouse_count_y0 = imfilter(mouse_count_times_y, filter_0); %Y * weight using base filter

smoothed_mouse_count_0x = imfilter(mouse_count, filter_x); %Weight using X filter
smoothed_mouse_count_xx = imfilter(mouse_count_times_x, filter_x); %X * weight using X filter
smoothed_mouse_count_yx = imfilter(mouse_count_times_y, filter_x); %Y * weight using X filter



smoothed_mouse_count_0y = imfilter(mouse_count, filter_y); %Weight using Y Filter
smoothed_mouse_count_xy = imfilter(mouse_count_times_x, filter_y);%X * Weight using Y Filter
smoothed_mouse_count_yy = imfilter(mouse_count_times_y, filter_y);%Y * Weight using Y filter



base_coeffs = zeros(size(mouse_count));
x_coeffs = zeros(size(mouse_count));
y_coeffs = zeros(size(mouse_count));

too_skewed = logical(zeros(size(mouse_count)));


iY_range = 2:(size(mouse_count, 1) - 1);
iX_range = 2:(size(mouse_count, 2) - 1);

for iY = iY_range
    for iX = iX_range
        
        
        %Entry i, j is how weight i is affected by filter j
        solving_matrix(1,1) = smoothed_mouse_count_00(iY, iX);
        solving_matrix(1,2) = smoothed_mouse_count_0x(iY, iX);
        solving_matrix(1,3) = smoothed_mouse_count_0y(iY, iX);
        
        solving_matrix(2,1) = smoothed_mouse_count_x0(iY, iX);
        solving_matrix(2,2) = smoothed_mouse_count_xx(iY, iX);
        solving_matrix(2,3) = smoothed_mouse_count_xy(iY, iX);
        
        solving_matrix(3,1) = smoothed_mouse_count_y0(iY, iX);
        solving_matrix(3,2) = smoothed_mouse_count_yx(iY, iX);
        solving_matrix(3,3) = smoothed_mouse_count_yy(iY, iX);
        
%        solving_matrix = solving_matrix';%Think i need this
        
        target_vector = [1; iX; iY];
        
        
        is_singular = double(rcond(solving_matrix) < 10^-10);
        
        %If the matrix is singular, we want the coeff to be nan, but we
        %don't want to use an if statement. 
        
        solving_matrix = solving_matrix * (1- is_singular) + eye(3) * is_singular;
        
        coeff_vector = solving_matrix\target_vector;
        
        one_nan_array = [1 nan];
        nan_if_singular = one_nan_array(is_singular + 1);
        
        
        
        base_coeffs(iY, iX) = coeff_vector(1) * nan_if_singular;
        x_coeffs(iY, iX) = coeff_vector(2) *nan_if_singular;
        y_coeffs(iY, iX) = coeff_vector(3) * nan_if_singular;
        
        
        total_filter = coeff_vector(1)*filter_0 + coeff_vector(2) * filter_x + coeff_vector(3) * filter_y;
        %The total filter to be applied at this point
        
        too_skewed(iY, iX) = min(total_filter(:)) < 0;
        
        iX;
        iY;
        solving_matrix;
%        pause;
        
        
    end
end
%smoothed_mouse_count_x0 =

base_filtered_mouse_count = imfilter(mouse_count, filter_0, 0);
x_filtered_mouse_count = imfilter(mouse_count, filter_x, 0);
y_filtered_mouse_count = imfilter(mouse_count, filter_y, 0);


total_filtered_mouse_count = base_filtered_mouse_count.*base_coeffs + x_filtered_mouse_count.*x_coeffs + y_filtered_mouse_count.*y_coeffs;



base_filtered_spike_count = imfilter(spike_count, filter_0, 0);
x_filtered_spike_count = imfilter(spike_count, filter_x, 0);
y_filtered_spike_count = imfilter(spike_count, filter_y, 0);


total_filtered_spike_count = base_filtered_spike_count.*base_coeffs + x_filtered_spike_count.*x_coeffs + y_filtered_spike_count.*y_coeffs;
firing_rate = total_filtered_spike_count;

firing_rate(total_filtered_mouse_count ==0) = nan;
%firing_rate(abs(x_coeffs./base_coeffs) > 1) = nan;
%firing_rate(abs(y_coeffs./base_coeffs) > 1) = nan;
firing_rate(too_skewed) = nan;