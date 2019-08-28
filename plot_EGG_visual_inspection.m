function figure_EGG_filtered = plot_EGG_visual_inspection(EGG_filter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright Nicolai Wolpert, 2019%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage: [figure_EGG_filtered] = plot_EGG_visual_inspection(EGG_filter)
%Plots the EGG including raw signal, filtered signal, phase and amplitude
%
%Inputs:
%   -EGG_filter: The filtered EGG signal (output from 'compute_filter_EGG')
%
%Outputs:
%   -figure_EGG_filtered: Figure showing the raw and filtered signal, phase
%   and amplitude
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

figure_EGG_filtered = figure('units','normalized','outerposition',[0 0 1 1]); set(gcf,'color','w');
subplot(5,1,1:2);
% mean-center EGG signal
EGG_filter.trial{1}(1, :) = EGG_filter.trial{1}(1, :)-mean(EGG_filter.trial{1}(1, :));
plot(EGG_filter.time{1}, EGG_filter.trial{1}(1, :));
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
ylabel('µV', 'FontSize', 17);
title('Raw signal', 'FontSize', 25);
subplot(5,1,3);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(4, :), 'g', 'LineWidth', 1);
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
xlabel('Time (seconds)', 'FontSize', 17);
ylabel('µV', 'FontSize', 17);
title('Filtered', 'FontSize', 25);
subplot(5,1,4);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(2, :), 'g', 'LineWidth', 1);
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
xlabel('Time (seconds)', 'FontSize', 17);
ylabel('Phase (rad)', 'FontSize', 17);
title('Phase', 'FontSize', 25);
subplot(5,1,5);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(3, :), 'r', 'LineWidth', 1);
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
ylabel('µV', 'FontSize', 17);
xlabel('Time (seconds)', 'FontSize', 17);
title('Amplitude', 'FontSize', 25);

end