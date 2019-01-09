function [colored_image] = KirumotoLandmarkAndPhasess(landmark_phase, attract_phases, size, show_lm_bar, show_attract_ball)

landmark_angle = landmark_phase;

base_color = [1 1 1];

image_to_make = zeros(size, size, 3);

image_to_make = image_to_make + 1; %Start off white

center = (.5 * size) * [1 1];
offset = .5 * (size -1) * [cos(landmark_angle), - sin(landmark_angle)];

ring_color = [.3 .3 .3] * .3;
%ring_color = [.3 .3 .3];
image_to_make = ColorDot(image_to_make, center(1), center(2), (.85 * (size/2) -2), ring_color);
image_to_make = ColorDot(image_to_make, center(1), center(2), (.85 * (size/2) -4), base_color);

%bar_color = [.2 1 1];
bar_color = [27 116 187]/255.; %From Malcolm Paper

attract_color = [1 1 1] * 0;
%com_color = [1 0 0];
com_color = [237 53 57]/255.; %From Malcolm Paper


if(abs(landmark_phase)>0)
    
    for i =1:length(attract_phases)
        cur_dot_offset = .5 * (size -1) * [sin(attract_phases(i)) -cos(attract_phases(i))];
        cur_dot_posit = center + .9 * cur_dot_offset;
        
        if(show_attract_ball)
            image_to_make = ColorDot(image_to_make, cur_dot_posit(1), cur_dot_posit(2), max(size/100, 2), attract_color);
        end
    end
    
    [x, y] = meshgrid(1:size, 1:size);
    clock_mask = ClockMask(x, y, landmark_angle);
    %        clock_mask
    
    %        image_to_make
    %        size(clock_mask)
    
    cur_com_offset = .5 * (size -1) * [mean(sin(attract_phases)) -mean(cos(attract_phases))];
    cur_com_posit = center + .82 * cur_com_offset;
    
    if(show_lm_bar)
        image_to_make = colorAllRegions(image_to_make, clock_mask, bar_color);
    end
    if(show_attract_ball)
        image_to_make = ColorDot(image_to_make, cur_com_posit(1), cur_com_posit(2),  4 * max(size/100, 2), com_color);
    end
end

cross_mask = zeros(size, size);
cross_mask(round(size/2 + .5), :, 1) = 1;
cross_mask( :, round(size/2 + .5)) = 1;
cross_mask_color = .7 * [1 1 1];

%image_to_make = colorAllRegions(image_to_make, boolean(cross_mask), cross_mask_color);

outline_mask = zeros(size, size);
outline_mask([1 size], :) = 1;
outline_mask( :, [1 size]) = 1;

yellow = [1 1 0];

outline_color = yellow * 0;
image_to_make = colorAllRegions(image_to_make, boolean(outline_mask), outline_color);

%imshow(mask)
%pause;
colored_image = image_to_make;




