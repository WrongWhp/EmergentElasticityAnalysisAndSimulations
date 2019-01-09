


clear mean_trial_lengths;
for i_struct = 1:length(filtered_ratemap_list)
    cur_ratemap_struct = filtered_ratemap_list{i_struct};
    cur_manip_list = cur_ratemap_struct.manipulation_trial;    
    manip_label_list = cur_manip_list + 1;
    
    for manip_label = 1:2
        mean_trial_lengths(i_struct, manip_label) = mean(cur_ratemap_struct.trial_lengths(manip_label == manip_label_list));
        
    end
    
end

mean(mean_trial_lengths)

%for gain .5 i'ts    22.3919   33.2924
%For gain 1.5 it's   38.1389   21.8826

%For gain reduction, delta K is +1(Speed cells) with resepct to vr space.
%For gain increase it's -.15? tha'ts about right I think..., if we really
%sp

%Comparing average times, gain 1.5 is 1.5 faster than gain .5, therefore,
%the "effective" delta K is 4 times higher. 

%If the force function is a sin function, then the shift from model must be
%> .25 radians, but also less than 1.5 radians(The critical point)

%15 centimeter shift means that the grid spacing is between 15 * 24 (.5
%gain is barely critical), and 15 * 4(1.5 gain is almost critical)


%We're closer to the .5 is critical point, which is grid spacings of 60 cm 