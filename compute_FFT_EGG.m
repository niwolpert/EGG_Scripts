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
% Copyright (C) 2019, Laboratoire de Neurosciences Cognitives, Nicolai 
% Wolpert, Ignacio Rebello & Catherine Tallon-Baudry
% Email: nicolaiwolpert@gmail.com
% 
% DISCLAIMER:
% This code is provided without explicit or implicit guarantee, and without 
% any form of technical support. The code is not intended to be used for 
% clinical purposes. The functions are free to use and can be 
% redistributed, modified and adapted, under the terms of the CC BY-NC
% version of creative commons license (see
% <https://creativecommons.org/licenses/>).

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

% find channel with highest peak in normogastric range
frequencies_normrange = FFT_EGG.freq(low_freq_indx:high_freq_indx);

% note the frequencies of the peaks for each channel
frequencies_peaks = nan(1, length(FFT_EGG.label));
% note the power of the peaks for each channel
power_peaks = nan(1, length(FFT_EGG.label));
for ichannel=1:length(FFT_EGG.label)
    
    % note power for the respective channel in the normogastric range
    power_normrange = FFT_EGG.powspctrm(ichannel, low_freq_indx:high_freq_indx);
    
    % find peaks (local maxima) for this channel in normogastric range
    [power_peak, indx_peak] = findpeaks(power_normrange);
    
    % find largest peak for this channel channel
    [~, idx_maxpeak] = max(power_peak);
    
    % note frequency and power of that peak
    if ~isempty(idx_maxpeak)
        frequencies_peaks(ichannel) = frequencies_normrange(indx_peak(idx_maxpeak));
        power_peaks(ichannel) = power_peak(idx_maxpeak);
    else
        frequencies_peaks(ichannel) = nan;
        power_peaks(ichannel) = nan;
    end

end

% find peak with maximum power
[max_pow_max_chan, max_chan_indx] = max(power_peaks);

% get name of channel with maximum power
max_chan = FFT_EGG.label(max_chan_indx);

% note corresponding frequency
max_freq = frequencies_peaks(max_chan_indx);

% store all parameters in data matrix
FFT_EGG.max_chan          = max_chan;
FFT_EGG.max_freq          = max_freq;
FFT_EGG.max_chan_indx     = max_chan_indx;
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
hold on; plot(max_freq, max_pow_max_chan, '*', 'Color', colors{max_chan_indx}, 'MarkerSize', 15)
text(max_freq,max_pow_max_chan,FFT_EGG.label{max_chan_indx}, 'Color', colors{max_chan_indx})
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

fprintf(['Channel selected: ' FFT_EGG.max_chan{1} '\n']);
fprintf(['Peak frequency: ' num2str(FFT_EGG.max_freq) '\n']);
fprintf(['Power: ' num2str(max_pow_max_chan) '\n']);

end

