

close all;
clear all;
addAllPaths;

n_mice = 1;


show_lm_bar = 1;
show_attract_ball = 0; 
%For showing just one

%imshow(KirumotoLandmarkAndPhases(.5, 0, 55));
landmark_k = 1.;
attract_k = 1.;
%attract_noise = .4 * .04 * 1;
lmark_base_strength = .0;


%base_k = (2*pi /40);

%lmark_strength_list =(2 * pi/60)  *  [0 .8:.1:1.4] * 1;
lmark_strength_list =2./15 * [0 1];

%delta_x = (2* pi)/60. * (4);

delta_x = (2* pi)/60. * (6);




%attract_k_list = 1;
%noise_list = [.01:.01:.04];
noise_list = [.01] * 4/3 * 0;

%attract_k_list = 1:.1:2.4;

%attract_k_list = 1.8;
%attract_k_list = 1.5 * [1 1 1.25];
%lmark_k_list = 1.5 * [.5 1 1.5]


attract_k_list = fliplr((2 * pi/40) * (1.0));

%attract_k_list = fliplr((2 * pi/40) * (1.05:.1:2.0));
lmark_k_list = (2 * pi/40) + ( attract_k_list* 0);

%lmark_k_list = 1. * [1 1 1]
lmark_hetero_list = 0;
%lmark_hetero_list = [0 .33 .66 1];
%attract_k_list = [.5 .8 1 1.2 1.5];
%attract_k_list = .6;
%attract_k_list = 0;
%attract_k_list = 1.75:.05:1.95;
%attract_k_list = [.7 1 1.4 1.7 2.0 2.3];
%noise_list = (0:.4:2) * .5;

for i_lm_strength = 1:length(lmark_strength_list)
    lmark_base_strength = lmark_strength_list(i_lm_strength)
    for i_K = 1:length(attract_k_list)
        for i_noise = 1:length(noise_list)
            for lmark_hetero = lmark_hetero_list
                
                attract_k = attract_k_list(i_K);
                landmark_k = lmark_k_list(i_K);
                
                attract_phases = 0 * sign(randn(n_mice, 1))   + 2 * pi;
                
                %        attract_phases = zeros(n_mice, 1) + 2 * pi;
                landmark_phase = 0 + 2*pi;
                attract_noise = noise_list(i_noise);
                
                x_list  = 0:delta_x:400;
                for iT = 1:length(x_list)
                    x = x_list(iT);
                    output_path = sprintf('../Outputs/KiruOutput/Gain%fLM%f/Noise%f/LMStrength%f/Hetero%f/x%f.png', attract_k, landmark_k, attract_noise, lmark_base_strength, lmark_hetero, x);
                    MakeFilePath(output_path);
                    if(1)
                        cur_frame = KirumotoLandmarkAndPhases(landmark_phase, attract_phases, 101, show_lm_bar, show_attract_ball);
                        frames(iT) = im2frame(cur_frame);
                        imwrite(cur_frame, output_path);
                    end
                    if(1)
                        landmark_phase = landmark_phase + delta_x * landmark_k;
                        attract_phases = attract_phases + delta_x * attract_k;
                        cur_landmark_strength = lmark_base_strength * (1+ lmark_hetero * cos(landmark_phase));
                        
                        attract_phases = attract_phases + delta_x * sin(landmark_phase - attract_phases)*lmark_base_strength;
                        attract_phases = attract_phases + sqrt(delta_x * attract_noise) * randn(n_mice, 1);
                        coherence(iT) = abs(mean(exp(j*attract_phases)))^2; %Average dot product between two different firing rates
                        mean_attract_phase(iT) = (mean(exp(j*attract_phases)));
                        mean_landmark_phase(iT) = exp(j*landmark_phase);
                    end
                end
                mean_coherence = mean(coherence(x_list>max(x_list/2)));
                mean_shift_vs_t = imag(log(mean_attract_phase .* conj(mean_landmark_phase)));
                mean_shift = mean(mean_shift_vs_t(x_list>max(x_list/2)));
                fprintf(' AttractK %f, noise %f, Hetero %f  has ||| shift %f, coherence %f,  \n', attract_k, attract_noise, lmark_hetero, mean_shift, mean_coherence);
                close all;
                mean_coherence_square(i_K, i_noise) = mean_coherence;
                mean_shift_square(i_K, i_noise) = mean_shift;
                
                close all
                if(0)
                    video_writer = VideoWriter(sprintf('%s/OutputVideo', output_path), '.mp4');
                    
                    %            video_writer = VideoWriter(sprintf('Outputs/KiruOutput/Gain%f/Noise%f/OutputVideoGain%f', attract_k,attract_noise, attract_k), '.mp4');
                    open(video_writer);
                    writeVideo(video_writer, frames);
                    close(video_writer)
                end
                
                close all;
                plot(x_list, coherence, 'r', 'linewidth', 5);
                ylim([0 1]);
                
                xlim([0, max(x_list)]);
                %            output_path = sprintf('Outputs/KiruOutput/Gain%fLM%f/Noise%f/Hetero%f/', attract_k, landmark_k, attract_noise, lmark_hetero);
                output_path =  sprintf('Outputs/KiruOutput/Noise%f/CoherenceGain%fLM%fLMStrength%f.png',  attract_noise,  attract_k, landmark_k, lmark_base_strength)
                MakeFilePath(output_path);
                saveas(1, output_path);
                
            end
            
            
            
            
            close all;
            plot(x_list, .5 * (1+ real(mean_attract_phase)), 'r', 'linewidth', 5);
            ylim([-1 3]);
            xlim([-5, 35]);
            saveas(1, sprintf('%f.png', attract_k));
            
            %    pause;
        end
    end
end


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