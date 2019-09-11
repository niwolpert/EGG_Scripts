%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SCRIPT_EGG_main
%%% 
%%% This script calls the functions needed for EGG preprocessing, artifact detection and analysis.
%%% This Matlab code is intended to accompany the paper: Wolpert, N. et al. (2019).
%%%
%%% The script and functions were written in Matlab version R2017b.
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
%%% Copyright (C) 2009, Laboratoire de Neurosciences Cognitives, Nicolai Wolpert
%%% Email: Nicolai.Wolpert@ens.fr
%%% 
%%% DISCLAIMER:
%%% This code is provided without explicit or implicit guarantee, and 
%%% without any form of technical support. The code is not intended for 
%%% usage for clinical purposes. The functions are free to be used and can 
%%% be modified and adapted, under the constraint of giving credit by 
%%% citing the author's name.
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1) Initialization
clear all; close all;
clc

% specify location of scripts and data file
script_path = 'C:\Users\Etudiant\Documents\Methodological EGG paper\Github Scripts\';
file_name   = 'EGG_raw_example3.mat';

% Load EGG raw data.
% These should be in fieldtrip format (e.g. output of 'ft_preprocessing'), 
% without any highpass-filter and already been re-referenced properly.
% For an overview of filedtrip-compatible dataformats see:
% http://www.fieldtriptoolbox.org/faq/dataformat/
load(strcat([script_path filesep file_name]));

% add fieldtrip toolbox to path
fieldtrip_path = strcat(['Z:' filesep 'MEG' filesep 'Toolboxes' filesep 'fieldtrip-20170315']);
addpath(fieldtrip_path);
ft_defaults;
% add EGG functions to path 
addpath(script_path);

%% Power spectrum, channel selection
% Compute the EGG power spectrum for all channels and select the channel
% with the strongest peak between 0.033 and 0.067 Hz

[FFT_EGG,figure_fft] = compute_FFT_EGG(EGG_raw);

%% Filtering
% Filter the raw EGG from the selected channel around the dominant
% frequency to extract the gastric rhythm. using a finite impulse response
% filter (Matlab FIR2), with a banwith of +/- 0.015 Hz of the peak
% frequency.
% Also compute phase of the gastric cycle and the amplitude envelope of the
% filtered EGG.

EGG_filtered = compute_filter_EGG(EGG_raw, FFT_EGG);

%% Visual inspection

[figure_EGG_filtered] = plot_EGG_visual_inspection(EGG_filtered);

%% Show proportion of normogastria

show_prop_normogastria(EGG_filtered)

%% Artifact detection

close all;
[art_def, figure_EGG_artifacts] = detect_EGG_artifacts(EGG_filtered);
