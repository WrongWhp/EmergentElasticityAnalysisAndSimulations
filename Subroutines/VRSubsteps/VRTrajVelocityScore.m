function [velocity_score] = VRTrajVelocityScore(posx)
%60 Frames per second
pos_x_filtered = imfilter(posx, fspecial('gaussian', [25 1], 5), 'replicate');

if(0)
    close all
    plot(posx)
    hold on;
    plot(pos_x_filtered);
    pause;
    
    close all
    plot(diff(posx));
    hold on;
    plot(diff(pos_x_filtered))
end

hist_counts = histcounts(pos_x_filtered, 100);

velocity_score = mean(1./hist_counts) * 60 * 4; %60 FPS times 4 cm/bin. This is the average velocity weighted over distance rather than over time