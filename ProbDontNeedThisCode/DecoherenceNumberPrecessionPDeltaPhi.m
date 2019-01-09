
clear all;
close all;

delta_phi = 0:.001:100;
dec_num_list = 1:.01:2;

for i_dec_num = 1:length(dec_num_list)
    cur_dec_num = dec_num_list(i_dec_num);
    time_spent_in_delta_phi = 1./(1  -sin(delta_phi)/cur_dec_num);
    precess_rate(i_dec_num) = 1./mean(time_spent_in_delta_phi);
end

precess_rate(dec_num_list<1) = 0;

plot(dec_num_list, precess_rate);


if(1)
    close all;
    
    dec_num_mult_list = [.5 .6 .7 .8 .9];
    for dec_num_multiplier = dec_num_mult_list
        
        for i_dec_num = 1:length(dec_num_list)
            cur_dec_num = dec_num_list(i_dec_num)
            sub_critical_shift(i_dec_num) = (80/(2*pi)) * asin(cur_dec_num * dec_num_multiplier); %Shift from subcritical decoherence number
        end
        
        plot(sub_critical_shift, precess_rate);
        xlabel('Gain Increase: Shift (CM)');
        ylabel('Gain Decrease: Increase in Number of Fields');
        hold on;
        
        hold on;
        set(gca, 'FontSize', 18);
    end
    
        %Shift of 13 CM
        scatter(13, .5,   200, 'k',  'filled');    
        xlim([0, 20]);
        ylim([0, 1]);
end