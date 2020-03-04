function stds_cycle_durations = compute_std_cycle_duration(EGG_filtered)
% This function computes the standard deivation of cycle duration of an EGG
% recording.
%
% Inputs
%     EGG_filtered  filtered EGG signal (output from 'compute_filter_EGG.m')
% 
% When using this function in any published study, please cite: Wolpert, 
% N., Rebollo, I., Tallon-Baudry, C. (2019). Electrogastrography for 
% psychophysiological research: practical guidelines and normative data.
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
% redistributed, modified and adapted, under the terms of the CC BY-NC-SA
% version of creative commons license (see
% <https://creativecommons.org/licenses/>).

edges_cycles_samples = diff(EGG_filtered.trial{1}(2,:))<-1;
edges_cycles_tmstp = EGG_filtered.time{1}(edges_cycles_samples);
cycle_durations = diff(edges_cycles_tmstp);
stds_cycle_durations = std(cycle_durations);

fprintf(['\nStandard deviation of cycle duration: ' num2str(stds_cycle_durations) '\n']);

end