function data_EGG = compute_filter_EGG(EGG_raw, FFT_EGG)
% This function selects the channel with the strongest peak in the 0.033-0.67 Hz range
% (specified in FFT_EGG), downsamples and filters the signal aroung the peak
% frequency (also specified in FFT_EGG) and computes the analytic phase and
% amplitude.
%
% Inputs
%     EGG_raw         Fieldtrip structure with raw EGG data
%     FFT_EGG         power spectrum obtained with 'compute_FFT_EGG.m'
% 
% Outputs
%     data_EGG        data structure containing EGG raw signal, filtered signal, 
%                     phase in radians and degrees, and amplitude
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

fprintf('\n###############\nFiltering EGG, extracting phase&amplitude...\n\n')

% select EGG channel with maximum power
cfg = [];
cfg.channel         = FFT_EGG.max_chan{1};
EGG_raw             = ft_selectdata(cfg, EGG_raw);

% prepare the filter: finite impulse response filter with a bandwith of 
% +/- 0.015 Hz of the peak frequency
srate               = EGG_raw.fsample;
center_frequency    = FFT_EGG.max_freq;        
bandwidth           = 0.015;
transition_width    = 0.15;
nyquist             = srate/2;
ffreq(1)            = 0;
ffreq(2)            = (1-transition_width)*(center_frequency-bandwidth);
ffreq(3)            = (center_frequency-bandwidth);
ffreq(4)            = (center_frequency+bandwidth);
ffreq(5)            = (1+transition_width)*(center_frequency+bandwidth);
ffreq(6)            = nyquist;
ffreq               = ffreq/nyquist;
fOrder              = 3; % in cycles
filterOrder         = fOrder*fix(srate/(center_frequency - bandwidth)); %in samples
idealresponse       = [ 0 0 1 1 0 0 ];
filterweights       = fir2(filterOrder,ffreq,idealresponse);

% filter
EGG_filt = EGG_raw;
disp('Filtering EGG - this will take some time');
EGG_filt.trial{1}   = filtfilt(filterweights,1,EGG_raw.trial{1});
EGG_filt.label      = {'filtered'};

% Hilbert-transform of the EGG
EGG_phase = EGG_raw;
EGG_phase.trial{1}      = angle(hilbert(EGG_filt.trial{1}'))';
EGG_phase.trial{1}(2,:) = abs(hilbert(EGG_filt.trial{1}'))';        
EGG_phase.label         = {'phase', 'amplitude'};

% append filtered EGG and EGG phase to the data structure
data_EGG = ft_appenddata([],EGG_raw,EGG_phase,EGG_filt);

EEG_phase_degrees       = data_EGG;
EEG_phase_degrees.label = {'phase_degrees'};
EEG_phase_degrees.trial = {radtodeg(data_EGG.trial{1}(2,:))};

data_EGG = ft_appenddata([],data_EGG,EEG_phase_degrees);

end

