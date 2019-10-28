function figure_EGG_filtered = plot_EGG_visual_inspection(EGG_filtered)
% This function plots the EGG raw signal, filtered signal, phase and amplitude
%
% Inputs
%     EGG_filtered          filtered EGG signal (output from 'compute_filter_EGG.m')
% 
% Outputs
%     figure_EGG_filtered figure showing EGG raw signal, filtered signal, phase
%                         and amplitude
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
% This code is provided without explicit or implied guarantee, and  without 
% any form of technical support. The code is not intended for usage for 
% clinical purposes. The functions are free to be used and can be modified 
% and adapted, under the constraint of giving credit by citing the author's 
% name.

% Plot EGG raw signal
figure_EGG_filtered = figure('units','normalized','outerposition',[0 0 1 1]); set(gcf,'color','w');
subplot(5,1,1:2);
% mean-center signal
EGG_filtered.trial{1}(1, :) = EGG_filtered.trial{1}(1, :)-mean(EGG_filtered.trial{1}(1, :));
plot(EGG_filtered.time{1}, EGG_filtered.trial{1}(1, :));
ax = gca;
ax.XLim            = [EGG_filtered.time{1}(1) EGG_filtered.time{1}(end)];
ax.FontSize        = 16;
ax.YLabel.String   = 'µV';
ax.YLabel.FontSize = 17;
title('Raw signal', 'FontSize', 25);

% Plot filtered signal
subplot(5,1,3);
plot(EGG_filtered.time{1}, EGG_filtered.trial{1}(4, :), 'g', 'LineWidth', 1);
ax = gca;
ax.XLim            = [EGG_filtered.time{1}(1) EGG_filtered.time{1}(end)];
ax.FontSize        = 16;
ax.YLabel.String   = 'µV';
ax.YLabel.FontSize = 17;
title('Filtered signal', 'FontSize', 25);

% Plot signal phase in rads
subplot(5,1,4);
plot(EGG_filtered.time{1}, EGG_filtered.trial{1}(2, :), 'g', 'LineWidth', 1);
ax = gca;
ax.XLim            = [EGG_filtered.time{1}(1) EGG_filtered.time{1}(end)];
ax.FontSize        = 16;
ax.YLabel.String   = 'Phase (rad)';
ax.YLabel.FontSize = 17;
title('Phase', 'FontSize', 25);

% Plot signal amplitude
subplot(5,1,5);
plot(EGG_filtered.time{1}, EGG_filtered.trial{1}(3, :), 'r', 'LineWidth', 1);
ax = gca;
ax.XLim            = [EGG_filtered.time{1}(1) EGG_filtered.time{1}(end)];
ax.FontSize        = 16;
ax.XLabel.String   = 'Time (seconds)';
ax.XLabel.FontSize = 17;
ax.YLabel.String   = 'µV';
ax.YLabel.FontSize = 17;
title('Amplitude', 'FontSize', 25);

end