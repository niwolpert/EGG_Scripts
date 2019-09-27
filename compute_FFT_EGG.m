function [FFT_EGG, figure_fft] = compute_FFT_EGG(EGG_raw)
% This function computes the EGG power spectrum for all channels and selects the channel
% with the strongest peak in the between 0.033 and 0.067 Hz.
% Note: Sometimes the peak might have to be selected manually.
%
% Inputs
%     EGG_raw         Fieldtrip structure with raw EGG data
% 
% Outputs
%     FFT_EGG         data structure containing the power spectrums, selected channel and peak frequency
%     figure_fft      figure showing the power spectrum for all channels
%
% This function was written in Matlab version R2017b.
%
% This function make use of the fieldtrip toolbox, version 20170315
% (see http://www.fieldtriptoolbox.org/).
% Reference:
% Robert Oostenveld, Pascal Fries, Eric Maris, and Jan-Mathijs Schoffelen. 
% FieldTrip: Open Source Software for Advanced Analysis of MEG, EEG, and 
% Invasive Electrophysiological Data. Computational Intelligence and 
% Neuroscience, vol. 2011, Article ID 156869, 9 pages, 2011. 
% doi:10.1155/2011/156869.
%
% Copyright (C) 2009, Laboratoire de Neurosciences Cognitives, Nicolai Wolpert
% Email: Nicolai.Wolpert@ens.fr
% 
% DISCLAIMER:
% This code is provided without explicit or implicit guarantee, and without 
% any form of technical support. The code is not intended for usage for 
% clinical purposes. The functions are free to be used and can be modified 
% and adapted, under the constraint of giving credit by citing the author's 
% name.

fprintf('\n###############\nEstimating power spectra...\n\n')

% define the window inside which we search for the maximum peak
window = [0.033 0.067];

% cut data into trials by defining the length (in sec) of the data and the 
% overlap between segments (ratio)
cfg = [];
cfg.length                  = 200;
cfg.overlap                 = 0.75;
EGG_trials                  = ft_redefinetrial(cfg, EGG_raw);

%% Filtering

cfg                 = [];
cfg.output          = 'pow';
cfg.channel         = 'all';
cfg.method          = 'mtmfft';
cfg.taper           = 'hann';
cfg.keeptrials      = 'no';
cfg.foilim          = [0 2];        % frequencies of interest
cfg.pad             = 1000;
FFT_EGG     = ft_freqanalysis(cfg, EGG_trials);

% find indeces of normogastric frequencies
low_freq_indx             = find(FFT_EGG.freq > window(1), 1, 'first');
high_freq_indx            = find(FFT_EGG.freq < window(2), 1, 'last');

% find maximum power within normogastria for each electrode
[max_pow,max_freq_indx] = max(FFT_EGG.powspctrm(:,low_freq_indx:high_freq_indx)');

% recover frequency index
max_freq_indx           = max_freq_indx + low_freq_indx - 1;

% get corresponding frequency
max_freq                = FFT_EGG.freq(max_freq_indx);

% get electrode with maximum power
[max_pow_max_chan ,max_chan_indx] = max(max_pow);

max_freq_max_chan = max_freq(max_chan_indx);

% get name of electrode with maximum power
max_chan = FFT_EGG.label(max_chan_indx);

% store all parameters in data matrix
FFT_EGG.max_chan          = {max_chan};
FFT_EGG.max_freq          = max_freq;
FFT_EGG.max_chan_indx     = max_chan_indx;
FFT_EGG.max_freq_max_chan = max_freq_max_chan;
FFT_EGG.max_pow_max_chan  = max_pow_max_chan;

% show the power spectrum
figure_fft = figure('units','normalized','outerposition',[0 0 1 1]);
colors     = {[1 0 1];  [1 0 0]; [0 1 0];  [0 0 1]; [1 0.5 0]; [0.5 0 0]; [0 1 1]};   % 1. pink 2. red 3. green 4. dark blue 5. orange 6. dark red/ brown 7. light blue
for nchan=1:length(FFT_EGG.label)
    hold on;
    % mark selected channel with a thicker line
    if nchan == max_chan_indx
        plot(FFT_EGG.freq, FFT_EGG.powspctrm(nchan, :), 'Color', colors{nchan}, 'LineWidth', 2.5);
    else
        plot(FFT_EGG.freq, FFT_EGG.powspctrm(nchan, :), 'Color', colors{nchan}, 'LineWidth', 1.5);
    end
end
hold on; plot(max_freq_max_chan, max_pow_max_chan, '*', 'Color', colors{max_chan_indx}, 'MarkerSize', 15)
text(max_freq_max_chan,max_pow_max_chan,FFT_EGG.label{max_chan_indx}, 'Color', colors{max_chan_indx})
xlim([0.01 0.09]); ylim([0 max_pow_max_chan+max_pow_max_chan*0.1]);
shade = patch([window(1) window(2) window(2) window(1)], [0 0 max_pow_max_chan*1.5 max_pow_max_chan*1.5], [0.5 0.5 0.5]);
set(shade, 'FaceColor', [0.5 0.5 0.5]);
alpha(.05);
ax = gca;
ax.FontSize = 16;
xlabel('Frequency (Hz)' , 'FontSize', 20);
ylabel('Power', 'FontSize', 20);
title(['Power spectrum'], 'FontSize', 20);
set(gcf,'units','normalized','outerposition',[0  0  1  1])

fprintf(['Peak frequency: ' num2str(FFT_EGG.max_freq_max_chan) '\n']);
fprintf(['Power: ' num2str(max_pow_max_chan) '\n']);

end

