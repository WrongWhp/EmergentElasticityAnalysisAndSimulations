%function [mouse_count, spike_count] = MouseAndSpikeCount(cur_mouse_data_struct, graining);


hist_spacing = 1/graining;
hist_range = ((1:graining) -1)* hist_spacing;


av_pos_x = .5 * (cur_mouse_data_struct.posx + cur_mouse_data_struct.posx2);
av_pos_y = .5 * (cur_mouse_data_struct.posy + cur_mouse_data_struct.posy2);

%%%%
max_x = prctile(av_pos_x, 99);
min_x = prctile(av_pos_x, 1);
max_y = prctile(av_pos_y, 99);
min_y = prctile(av_pos_y, 99);
%%%


norm_x = (av_pos_x - min_x)/(max_x - min_x);
norm_y = (av_pos_y - min_y)/(max_y - min_y);


not_nan = ~isnan(av_pos_x + av_pos_y);
norm_not_nan_x = (av_pos_x(not_nan) - min_x)/(max_x - min_x);
norm_not_nan_y = (av_pos_y(not_nan) - min_y)/(max_y - min_y);
not_nan_t = cur_mouse_data_struct.post(not_nan);






mouse_vec_for_hist = [norm_not_nan_y, norm_not_nan_x];
mouse_count = hist3(mouse_vec_for_hist, {hist_range hist_range});

%spkx,spky,spkInd] = spikePos(ts,posx,posy,post)
%[spkx,spky,spkInd] = spikePos(cur_mouse_data_struct.cellTS,norm_not_nan_x,norm_not_nan_y,not_nan_t);

[spkx,spky,spkInd] = spikePos(cur_mouse_data_struct.cellTS,norm_x,norm_y, cur_mouse_data_struct.post);

spike_vec_for_hist = [spky spkx];
spike_count = hist3(spike_vec_for_hist, {hist_range hist_range});



%imshow(imresize(normalizeImage(firing_rate_im), 50, 'nearest'));
%imshow(imresize((count), 50, 'nearest'));

%Need to do this step to keep consistent with prior convention. Not sure
%why it was defined this way in the first place
mouse_count = flipud(mouse_count);
spike_count = flipud(spike_count);
