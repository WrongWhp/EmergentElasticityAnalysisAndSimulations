function [estimated_peak] = superResolutionYCenter(array_to_use)

%Finds the global maximum, then does a parabolic fit around it.

[iY, iX] = TwoDArrayMax(array_to_use);

center_iY = (size(array_to_use, 1) +1)/2
center_iX = (size(array_to_use, 2) +1)/2


parab_fit_range = [-1 0 1];
iY_range = iY + parab_fit_range;
iX_range = iX + parab_fit_range;







if(min(iY_range)>0 && max(iY_range)<=size(array_to_use, 1) && min(iX_range)>0 && max(iX_range)<=size(array_to_use, 2))
    
    sub_array = array_to_use(iY_range, iX_range);
    
    
    
    
    y_heights = mean(sub_array, 2);
    poly_fit_y = polyfit( iY_range - center_iY, y_heights', 2);
    estimated_peak.y = -(1/2)  * poly_fit_y(2)/poly_fit_y(1);%Linear Component/Quadratic Component
    
    x_heights = mean(sub_array, 1);
    poly_fit_x = polyfit( iX_range - center_iX, x_heights, 2);
    estimated_peak.x = -(1/2)  * poly_fit_x(2)/poly_fit_x(1);%Linear Component/Quadratic Component
else

    estimated_peak.x = nan;
    estimated_peak.y = nan;
end
    