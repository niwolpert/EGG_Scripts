function [art_def, figure_EGG_artifacts] = detect_EGG_artifacts(EGG_filter)
% This function identifies artifacts in the EGG signal using the phase.
%
% Inputs
%     EGG_filter                  filtered EGG signal (output from
%                                 'compute_filter_EGG')
% 
% Outputs
%     art_def                     nx2 matrix with n being the number of artifacts and columns
%                                 indicating start and end sample of the artifact
%     figure_EGG_artifacts        figure showing the artifacts marked in the signal
%     figure_EGG_cycle_lengths    figure showing the distribution of cycle length
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

fprintf('\n###############\nSearching for EGG artifacts...\n\n')

%% Compute distribution of cycle length

% Compute distribution of cycle lengths to find the thresholds
edges_cycles_samples    = find(diff(EGG_filter.trial{1}(2,:))<-1);
edges_cycles_tmstp      = EGG_filter.time{1}(edges_cycles_samples);
cycle_lengths           = diff(edges_cycles_tmstp);
thresholds_length_cycle = [mean(cycle_lengths)-3*std(cycle_lengths) mean(cycle_lengths)+3*std(cycle_lengths)];

% Plot raw signal 
figure_EGG_artifacts = figure('units','normalized','outerposition',[0 0 1 1]); set(gcf,'color','w');
subplot(5,1,1:2);
% mean-center EGG signal
EGG_filter.trial{1}(1, :) = EGG_filter.trial{1}(1, :)-mean(EGG_filter.trial{1}(1, :));
plot(EGG_filter.time{1}, EGG_filter.trial{1}(1,:));
ax                 = gca;
ax.FontSize        = 16;
ax.XLim            = [EGG_filter.time{1}(1) EGG_filter.time{1}(end)];
ax.YLabel.String   = 'µV';
ax.YLabel.FontSize = 17;
title('Raw signal', 'FontSize', 25);

% Plot filtered signal
subplot(5,1,3);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(4,:));
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
xlabel('Time (seconds)', 'FontSize', 17);
ylabel('µV', 'FontSize', 17);
title('Filtered', 'FontSize', 25);

% Plot signal phase in rads
subplot(5,1,4);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(2,:));
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
ylabel('Phase (rad)', 'FontSize', 17);
title('Phase', 'FontSize', 25);

% Plot signal amplitude
subplot(5,1,5);
plot(EGG_filter.time{1}, EGG_filter.trial{1}(3,:));
xlim([EGG_filter.time{1}(1) EGG_filter.time{1}(end)]);
ax = gca;
ax.FontSize = 16;
ylabel('µV', 'FontSize', 17);
xlabel('Time (seconds)', 'FontSize', 17);
title('Amplitude', 'FontSize', 25);

% here we note samples of artifacts
art_def = [];

%%% artifact detection based on phase time series
% identify cycles with too short or long duration and mark those in the figure
subplot(5,1,4);
yl=ylim;
ind_outliers = find(cycle_lengths<thresholds_length_cycle(1));
ind_outliers = [ind_outliers find(cycle_lengths>thresholds_length_cycle(2))];
for ioutlier=1:length(ind_outliers)
    patch([edges_cycles_tmstp(ind_outliers(ioutlier)) edges_cycles_tmstp(ind_outliers(ioutlier)) edges_cycles_tmstp(ind_outliers(ioutlier)+1) edges_cycles_tmstp(ind_outliers(ioutlier)+1)],[yl(1) yl(2) yl(2) yl(1)],'r','FaceAlpha',0.3,'Edgecolor','none');
    art_def = [art_def; edges_cycles_samples(ind_outliers(ioutlier)) edges_cycles_samples(ind_outliers(ioutlier)+1)];
end

yl=ylim;

% identify cycles with non-monotonic increase in signal 
for icycle=1:length(cycle_lengths)+2
    if icycle==1
        samples_cycle = EGG_filter.trial{1}(2,1:edges_cycles_samples(icycle));
    elseif icycle == length(cycle_lengths)+2
        samples_cycle = EGG_filter.trial{1}(2,edges_cycles_samples(icycle-1)+1:end);
    else
        samples_cycle = EGG_filter.trial{1}(2,edges_cycles_samples(icycle-1)+1:edges_cycles_samples(icycle));
    end
    if ~issorted(samples_cycle)
        if icycle==1
            patch([1 1 edges_cycles_tmstp(icycle) edges_cycles_tmstp(icycle)],[yl(1) yl(2) yl(2) yl(1)],'r','FaceAlpha',0.3,'Edgecolor','none');
            art_def = [art_def; 1 edges_cycles_samples(icycle)];
        
        elseif icycle == length(cycle_lengths)+2
            patch([edges_cycles_tmstp(icycle-1) edges_cycles_tmstp(icycle-1) EGG_filter.time{1}(end) EGG_filter.time{1}(end)],[yl(1) yl(2) yl(2) yl(1)],'r','FaceAlpha',0.3,'Edgecolor','none');
            art_def = [art_def; edges_cycles_samples(icycle-1)+1 length(EGG_filter.trial{1}(2, :))];
        
        else            
            patch([edges_cycles_tmstp(icycle-1) edges_cycles_tmstp(icycle-1) edges_cycles_tmstp(icycle) edges_cycles_tmstp(icycle)],[yl(1) yl(2) yl(2) yl(1)],'r','FaceAlpha',0.3,'Edgecolor','none');
            art_def = [art_def; edges_cycles_samples(icycle-1)+1 edges_cycles_samples(icycle)];
        end
    end
end

% make sure artifacts are sorted
if ~isempty(art_def)
    [~, idx_sort] = sort(art_def(:,1));
    art_def = art_def(idx_sort, :);
end

end