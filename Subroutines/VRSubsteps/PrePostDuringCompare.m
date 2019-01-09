


close all;
v1 = pre_during_post_array(:, 1);
v2 = pre_during_post_array(:, 3);
ScatterWithSpine(v1, v2);
title(sprintf('Post vs Pre, gain is %f,  p value is %f \n',cur_ratemap_struct.gain_value, signFlipPValue(sign(v1-v2))));
[a, b] = InterIndCorrTest(v1-v2, filtered_mouse_labels);
fprintf('Inter Ind Pval is %f \n', b);
pause;





close all
v1 = .5 * (pre_during_post_array(:, 1) +pre_during_post_array(:, 3));
v2 = pre_during_post_array(:, 2);
ScatterWithSpine(v1, v2);
title(sprintf('Manip vs nonmanip, gain is %f,  p value is %f \n',cur_ratemap_struct.gain_value, signFlipPValue(sign(v1-v2))));
[a, b] = InterIndCorrTest(v1-v2, filtered_mouse_labels);
fprintf('Inter Ind Pval is %f \n', b);

pause;
close all;
