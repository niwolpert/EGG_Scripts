%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SCRIPT_EGG_main
%%% 
%%% This script calls the functions needed for EGG preprocessing, artifact 
%%% detection and EGG analysis.
%%% This Matlab code is intended to accompany the paper: Wolpert, et al. (2019).
%%%
%%% The scripts and functions were written in Matlab version R2017b.
%%%
%%% These functions make use of the fieldtrip toolbox, version 20170315
%%% (see http://www.fieldtriptoolbox.org/).
%%% Reference:
%%% Robert Oostenveld, Pascal Fries, Eric Maris, and Jan-Mathijs Schoffelen. 
%%% FieldTrip: Open Source Software for Advanced Analysis of MEG, EEG, and 
%%% Invasive Electrophysiological Data. Computational Intelligence and 
%%% Neuroscience, vol. 2011, Article ID 156869, 9 pages, 2011. 
%%% doi:10.1155/2011/156869.
%%% 
%%% The code comes with example of EGG datasets (EGG_raw_example1/2/3.mat).
%%% The files contains 7 channels of EGG recorded for approximately 12 
%%% minutes using a Biosemi amplifier (sampling rate: 1kHz).
%%%
%%% Copyright (C) 2019, Laboratoire de Neurosciences Cognitives, Nicolai 
%%% Wolpert, Ignacio Rebello & Catherine Tallon-Baudry
%%% Email: nicolaiwolpert@gmail.com
%%% 
%%% DISCLAIMER:
%%% This code is provided without explicit or implicit guarantee, and 
%%% without any form of technical support. The code is not intended to be 
%%% used for clinical purposes. The functions are free to use and can be
%%% redistributed, modified and adapted, under the terms of the CC BY-NC
%%% version of creative commons license (see
%%% <https://creativecommons.org/licenses/>).
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1) Initialization
clear all; close all;
clc

% specify location of scripts and data files
script_path = '';
file_name   = 'EGG_raw_example3.mat';

% add fieldtrip toolbox to path
fieldtrip_path = '';
addpath(fieldtrip_path);
ft_defaults;
% add EGG functions to path 
addpath(script_path);

% Load EGG raw data.
% A dataset in fieldtrip format (e.g. output of 'ft_preprocessing') is expected here. 
% For an overview of fieldtrip-compatible dataformats see:
% http://www.fieldtriptoolbox.org/faq/dataformat/
% 
% As a reminder, EGG data should be recorded without highpass-filter (DC recording)
% and referenced in an appropriate manner. 
% For more information on reading, filtering and re-referencing with fieldtrip, 
% see: http://www.fieldtriptoolbox.org/tutorial/continuous/
load(strcat([script_path filesep file_name]));

%% Power spectrum, channel selection
% Compute the EGG power spectrum for all channels and select the channel
% with the strongest peak between 0.033 and 0.067 Hz.

[FFT_EGG,figure_fft] = compute_FFT_EGG(EGG_raw);

%% Filtering
% Filter the raw EGG from the selected channel around the dominant
% frequency to extract the gastric rhythm using a finite impulse response
% filter (Matlab FIR2), with a banwith of +/- 0.015 Hz of the peak
% frequency.
% Also compute phase of the gastric cycle and the amplitude envelope of the
% filtered EGG, using the Hilbert method.

EGG_filtered = compute_filter_EGG(EGG_raw, FFT_EGG);

%% Visual inspection

[figure_EGG_filtered] = plot_EGG_visual_inspection(EGG_filtered);

%% Show proportion of normogastria

show_prop_normogastria(EGG_filtered)

%% Artifact detection

close all;
[art_def, figure_EGG_artifacts] = detect_EGG_artifacts(EGG_filtered);