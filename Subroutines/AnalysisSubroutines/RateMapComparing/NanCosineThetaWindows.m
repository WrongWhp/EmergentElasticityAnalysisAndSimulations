function [cos] = NanCosineThetaWindows(vec1, vec2)

window_offset = [-1 0 1];
n_windows = 0;
accum = 0;

for iY = (1 - min(window_offset)):(size(vec1, 1) - max(window_offset))
    for iX =  (1 - min(window_offset)):(size(vec1, 2) - max(window_offset))
        iX_window = iX + window_offset;
        iY_window = iY + window_offset;
                
        
        sub_1 = vec1(iY_window, iX_window);
        sub_2 = vec2(iY_window, iX_window);
        
        should_add = sum(isnan(sub_1(:) + sub_2(:))) ==0;
        if(should_add)
            accum =accum +  NanCosineTheta(sub_1, sub_2);
            if(isnan(NanCosineTheta(sub_1, sub_2)))
               sub_1
               sub_2
                pause;
            end
            n_windows = n_windows + 1;
        end
        
    end
end

cos = accum./n_windows;


if(~isfinite(cos))
    fprintf('N Windows is %f, accum is %f cos is %f \n', n_windows, accum, cos);
end