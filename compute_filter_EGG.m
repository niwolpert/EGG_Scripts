function data_EGG = compute_filter_EGG(file_name, FFT_EGG, dsp_Fs, channel_labels)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright Nicolai Wolpert, 2019%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage: EGG_filter = compute_filter_EGG(file_name, FFT_EGG, dsp_Fs);
%Selects the channel with the strongest peak in the 0.033-0.67 Hz range
%(specified in FFT_EGG), downsamples and filters the signal aroung the peak
%frequency (also specified in FFT_EGG) and computes the analytic phase and
%amplitude.
%
%Inputs:
%   -file_name: String with the path and name of the raw data
%   -FFT_EGG: Power spectrum data obtained by 'compute_FFT_EGG'
%   -dsp_Fs: downsampling frequency in Hertz
%   -channel_labels: Cell matrix with channel labels as strings
%
%Outputs:
%   -data_EGG: Data structure containing raw (original) + filtered EGG,
%   phase and amplitude
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
% Copyright (C) 2009, Laboratoire de Neurosciences Cognitives, Nicolai 
% Wolpert
% Email: Nicolai.Wolpert@ens.fr
% 
% DISCLAIMER:
% This code is provided without explicit or implied guarantee, and  without 
% any form of technical support. The code is not intended for usage for 
% clinical purposes. The functions are free to be used and can be modified 
% and adapted, under the constraint of giving credit by citing the author's 
% name.

fprintf('\n###############\nFiltering EGG, extracting phase&amplitude...\n\n')

% read in raw EGG data
cfg                         = [];
cfg.continuous              = 'yes';
cfg.channel                 = channel_labels;
cfg.dataset                 = file_name;
EGG_orig                    = ft_preprocessing(cfg);

% select EGG channel with maximum power
cfg = [];
cfg.channel         = FFT_EGG.max_chan{1};
EGG_orig            = ft_selectdata(cfg, EGG_orig);

% downsample data to specified frequency
cfg = [];
cfg.resamplefs = dsp_Fs;
cfg.detrend    = 'no';
cfg.demean     = 'no';
EGG_dsp = ft_resampledata(cfg, EGG_orig);

% prepare the filter
srate               = EGG_dsp.fsample;
center_frequency    = FFT_EGG.max_freq_max_chan;        
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
EGG_filt = EGG_dsp;
disp('Filtering EGG - this will take some time');
EGG_filt.trial{1}   = filtfilt(filterweights,1,EGG_dsp.trial{1});
EGG_filt.label      = {'filtered'};

% Hilbert-transform of the EGG
EGG_phase = EGG_dsp;
EGG_phase.trial{1}      = angle(hilbert(EGG_filt.trial{1}'))';
EGG_phase.trial{1}(2,:) = abs(hilbert(EGG_filt.trial{1}'))';        
EGG_phase.label      = {'phase', 'amplitude'};

% append filtered EGG and EGG phase to rest of data
data_EGG = ft_appenddata([],EGG_dsp,EGG_phase,EGG_filt);

EEG_phase_degrees = data_EGG;
EEG_phase_degrees.label = {'phase_degrees'};
EEG_phase_degrees.trial = {radtodeg(data_EGG.trial{1}(2,:))};

data_EGG = ft_appenddata([],data_EGG,EEG_phase_degrees);

end

