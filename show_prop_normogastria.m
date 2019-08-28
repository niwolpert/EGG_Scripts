function show_prop_normogastria(EGG_filter)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright Nicolai Wolpert, 2019%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Usage: show_prop_normogastria(EGG_filter)
% This function creates a plot with a histogram of cycle duration, with 
% dottee red lines marking the mean +/- 3 standard deviations.
%
%Inputs:
%   -EGG_filter: The filtered EGG signal (output from 'compute_filter_EGG
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

% specfify the range of normogastria in seconds
% 2-4 cpm = 15-30 seconds
range_normogastria = [15 30];

% compute cycle lengths in seconds
edges_cycles_samples = find(diff(EGG_filter.trial{1}(2,:))<-1);
edges_cycles_tmstp = EGG_filter.time{1}(edges_cycles_samples);
lengths_cycles = diff(edges_cycles_tmstp);

% compute proportion of normogastria
ind_outside = [find(lengths_cycles<range_normogastria(1)) find(range_normogastria>range_normogastria(2))];
prop_normogastria = (length(lengths_cycles)-length(ind_outside))/length(lengths_cycles)*100;

% plot distribution of cycle lengths
figure('units','normalized','outerposition',[0 0 1 1]); set(gcf,'color','w');
[N, X] = hist(lengths_cycles);
bar(X,N,'facecolor',[0 0.4 0]);
yl=ylim;
hold on;
h1 = plot([range_normogastria(1) range_normogastria(1)],yl, 'r');
set(h1, 'LineStyle', '--', 'LineWidth', 2);
hold on;
h2 = plot([range_normogastria(2) range_normogastria(2)],yl, 'r');
set(h2, 'LineStyle', '--', 'LineWidth', 2);
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',24);
title(['Cycle length distribution, Proportion normogastria=' num2str(round(prop_normogastria, 1)) '%'], 'FontSize', 30);
xlabel('Seconds', 'FontSize', 30);
l=legend([h1 h2], 'range normogastria'); l.FontSize=25;

end


