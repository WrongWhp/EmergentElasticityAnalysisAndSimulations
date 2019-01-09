function [colored_image] = MakeClockAngle(complex_num, size)

%Makes an image of a particular clock angle

angle = imag(log(complex_num));
image_to_make = zeros(size, size, 3);

center = (.5 * size) * [1 1];
offset = .5 * (size -1) * [cos(angle), - sin(angle)];


ring_color = [1 .5 .5];
image_to_make = ColorDot(image_to_make, center(1), center(2), (size/2 -2), ring_color);
image_to_make = ColorDot(image_to_make, center(1), center(2), (size/2 -4), [0 0 0]);

bar_color = [.2 .2 1];

%bar_color = [.2 1 1];
if(abs(complex_num)>0)
    if(0)
        for frac = 0:.02:1
            cur_dot_posit = center + frac * offset;
            image_to_make = ColorDot(image_to_make, cur_dot_posit(1), cur_dot_posit(2), max(size/100, 1), bar_color);
        end
    else
        [x, y] = meshgrid(1:size, 1:size);
        clock_mask = ClockMask(x, y, angle);
%        clock_mask
        
%        image_to_make
%        size(clock_mask)
        image_to_make = colorAllRegions(image_to_make, clock_mask, bar_color);
        
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

%image_to_make = colorAllRegions(image_to_make, boolean(outline_mask), yellow);

%imshow(mask)
%pause;
colored_image = image_to_make;




