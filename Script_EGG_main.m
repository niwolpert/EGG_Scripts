%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SCRIPT_EGG_main
%%% From this script, functions for EGG preprocessing, artifact detection 
%%% and analysis are called.
%%% This Matlab code is intended to accompany the paper: Wolpert, N. et al. 
%%%(2019).
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
%%% Copyright (C) 2009, Laboratoire de Neurosciences Cognitives, Nicolai 
%%% Wolpert
%%% Email: Nicolai.Wolpert@ens.fr
%%% 
%%% DISCLAIMER:
%%% This code is provided without explicit or implied guarantee, and 
%%% without any form of technical support. The code is not intended for 
%%% usage for clinical purposes. The functions are free to be used and can 
%%% be modified and adapted, under the constraint of giving credit by 
%%% citing the author's name.
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 1) Initialization
clear all; close all;
clc

% specify location of scripts and the file
script_path = 'C:\Users\Etudiant\Documents\Methodological EGG paper\Github Scripts';
file_name = 'C:\Users\Etudiant\Documents\Methodological EGG paper\Github Scripts\Example_data2.bdf';

% add fieldtrip to path
fieldtrip_path = strcat(['Z:' filesep 'MEG' filesep 'Toolboxes' filesep 'fieldtrip-20170315']);
addpath(fieldtrip_path);
ft_defaults;
addpath(script_path);

% specify EGG channel labels here
channel_labels = {'EXG1', 'EXG2', 'EXG3', 'EXG4', 'EXG5', 'EXG6', 'EXG7'};

% downsample frequency
dsp_Fs = 1000;

%% Power spectrum, channel selection

[FFT_EGG,figure_fft] = compute_FFT_EGG(file_name, channel_labels);

%% Filtering

EGG_filter = compute_filter_EGG(file_name, FFT_EGG, dsp_Fs, channel_labels);

%% Visual inspection

[figure_EGG_filtered] = plot_EGG_visual_inspection(EGG_filter);

%% Show proportion of normogastria

show_prop_normogastria(EGG_filter)

%% Artifact detection

close all;
[art_def, figure_EGG_artifacts] = detect_EGG_artifacts(EGG_filter);
