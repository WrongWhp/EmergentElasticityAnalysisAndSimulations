

close all;
clear all;
addAllPaths;

n_mice = 1;


%imshow(KirumotoLandmarkAndPhases(.5, 0, 55));
landmark_k = 0 * [1 0];
base_attract_k = 1 * [0 1] + .1 * [3 0];
%attract_noise = .4 * .04 * 1;

delta_x = 1./60.;

l_mark_strength = 4.0;

%attract_k_list = 1;
noise_list = .0;

%attract_k_list = 1:.1:2.4;

%attract_k_list = 1.8;
%attract_k_list = [.5 1 2];
lmark_hetero_list = [0];
gain_list = [.5 .8 1 1.2 1.5];
%attract_k_list = .6;
%attract_k_list = 0;
%attract_k_list = 1.75:.05:1.95;
%attract_k_list = [.7 1 1.4 1.7 2.0 2.3];
%noise_list = (0:.4:2) * .5;


for i_K = 1:length(gain_list)
    for i_noise = 1:length(noise_list)
        for lmark_hetero = lmark_hetero_list
            
            attract_k = gain_list(i_K) * base_attract_k;
            
            %            attract_phases = 0 * sign(randn(n_mice, 1))   + 2 * pi;
            attract_phase = vu2yxArray([.5 .5]); %XY Representation
            
            %        attract_phases = zeros(n_mice, 1) + 2 * pi;
            landmark_phase = vu2yxArray([.5 .5]);
            attract_noise = noise_list(i_noise);
            x_list  = 0:delta_x:20;
            
            
            corner_bound = 20;
            
            for iT = 1:length(x_list)
                x = x_list(iT);
                output_path = sprintf('../Outputs/Kiru2DOutput/Gain%f/x%f.png', i_K, x);
                MakeFilePath(output_path);
                if(1)
                    landmark_mark_color = [27 116 187]/255.; %From Malcolm Paper
                    
                    %com_color = [1 0 0];
                    grid_cell_color = [237 53 57]/255.; %From Malcolm Paper
                    
                    %frame_width = 200;
                    rh_width = 100;
                    cur_frame = zeros(190, 130, 3);
                    
                    
                    for iCorner = [0 1];
                        for jCorner = [0 1];
                            corner_phase = vu2yxArray([iCorner, jCorner]);
                            cur_frame =    ColorDot(cur_frame, corner_bound+ rh_width * corner_phase(1),  corner_bound + rh_width * corner_phase(2), 4, [1 1 1]);
                            
                        end
                    end
                    cur_frame =    ColorDot(cur_frame,corner_bound+  rh_width * attract_phase(1), corner_bound + rh_width * attract_phase(2), 4, grid_cell_color);
                    cur_frame =    ColorDot(cur_frame,corner_bound+  rh_width * landmark_phase(1),corner_bound + rh_width * landmark_phase(2), 4, landmark_mark_color);
                    
                    
                    
                    %$                     rh_width * landmark_k)
                    %    image_to_make = ColorDot(image_to_make, cur_com_posit(1), cur_com_posit(2),  4 * max(size/100, 2), com_color);
                    
                    %                    cur_frame = KirumotoLandmarkAndPhases(landmark_phase, attract_phases, 101);
                    %                    frames(iT) = im2frame(cur_frame);
                    imwrite(rot90(cur_frame), output_path);
                end
                if(1)
                    landmark_phase = landmark_phase + delta_x * landmark_k;
                    attract_phase = attract_phase + delta_x * attract_k;
                    
                    
                    attract_phase = attract_phase + delta_x * l_mark_strength * TwoBodyRhForceLaw(attract_phase, landmark_phase);
                    
                    attract_phase = vu2yxArray( mod(yx2vuArray(attract_phase), 1));
                    landmark_phase = vu2yxArray( mod(yx2vuArray(landmark_phase), 1));
                    
                    
                    
                    %                    cur_landmark_strength = lmark_base_strength * (1+ lmark_hetero * cos(x));
                    
                    %                    attract_phases = attract_phases + delta_x * sin(landmark_phase - attract_phases)*lmark_base_strength;
                    %                    attract_phases = attract_phases + sqrt(delta_x * attract_noise) * randn(n_mice, 1);
                    %                    coherence(iT) = abs(mean(exp(j*attract_phases)));
                    %                    mean_attract_phase(iT) = (mean(exp(j*attract_phases)));
                    %                    mean_landmark_phase(iT) = exp(j*landmark_phase);
                end
            end
            
            close all
            if(0)
                video_writer = VideoWriter(sprintf('%s/OutputVideo', output_path), '.mp4');
                
                %            video_writer = VideoWriter(sprintf('Outputs/KiruOutput/Gain%f/Noise%f/OutputVideoGain%f', attract_k,attract_noise, attract_k), '.mp4');
                open(video_writer);
                writeVideo(video_writer, frames);
                close(video_writer)
            end
        end
        
        
        
        
    end
end
return;


%% kjlfdsfsd


observed_shift = 1.2;%A shift of 2pi is one grid spacing. We see a shift of 15 cm. Given a 50 cm spacing, that's about 2 radians
observed_coherence_decrease = .2; %1 - .35/.55

if(1)
    close all;
    subplot(3,1,1);
    imagesc(mean_coherence_square)
    title('Coherence');
    set(gca, 'YTickLabel', attract_k_list);
    ylabel('Gain');
    set(gca, 'XTickLabel', noise_list);
    xlabel('Noise');
    colorbar
    subplot(3,1,2);
    imagesc(mean_shift_square)
    title('Shift');
    set(gca, 'YTickLabel', attract_k_list);
    ylabel('Gain');
    set(gca, 'XTickLabel', noise_list);
    xlabel('Noise');
    colorbar
    
    subplot(3,1,3);
    
    scaled_shift_deviation_from_model =    ((mean_shift_square -observed_shift)/observed_shift);
    scaled_coherence_deviation_from_model  = ( repmat(mean_coherence_square(1, :), [length(attract_k_list) 1]) - mean_coherence_square -observed_coherence_decrease)/observed_coherence_decrease;
    imagesc(abs(scaled_shift_deviation_from_model).^2 + abs(scaled_coherence_deviation_from_model).^2);
    title('Deviation From Model');
    set(gca, 'YTickLabel', attract_k_list);
    ylabel('Gain');
    set(gca, 'XTickLabel', noise_list);
    xlabel('Noise');
    colorbar
    
    
end


if(1)
    pause;
    close all;
    x_corr= xcorr(real(mean_attract_phase), real(mean_landmark_phase));
    plot(x_corr);
end


%shift_and_coherence_deviation_from_mode
%shift_and_coherence_deviation_from_model = abs((mean_shift_square -observed_shift)/observed_shift) + abs((coherence_decrease_from_model -observed_coherence_decrease)/observed_coherence_decrease);










%imshow(KirumotoLandmarkAndPhases(.11, 0, 55));