%% Center of Activity Trajectory (CAT) analysis

% INPUTS:
%   t1 - in ms, the beginning of the analysis window
%   t2 - in ms, the ending of the analysis window
%   allspks - matrix with [spiketimes(ms) electrode_nr]
%   binningWindow - Binning window (in ms) for the analysis
%   doPlot - set to 1 if you want the plot, set to 0 otherwise

% Apr 2025, Adam Armada-Moreira

function CAT = meaCAT(t1, t2, allspks, metafile, binningWindow, doPlot)
% check if time points are well defined
if t2 < t1
    warning('The ending timepoint is smaller than the starting!');
    CAT = [];
    return
end
% Make the STH according to the defined bin size
time_bins = t1:binningWindow:t2;
nrElectrodes = max(allspks(:,2));
for ch=1:nrElectrodes
    [elec_x, elec_y] = get_electrode_xy(ch,metafile);%TODO: Dictionary with xy location for each electrode,
    %      in integers (1,1), (1,2),...
    mask = allspks(:,2) == ch;
    local_spk_times = allspks(mask,1);
    spatialSTH(elec_y,elec_x,:) = histc(local_spk_times,time_bins); % output matrix: y * x * time
end %end STH loop

x_dim = size(spatialSTH,2);
y_dim = size(spatialSTH,1);
[x, y] = meshgrid(1:x_dim,1:y_dim);

% TEMPORARY HARD-CODED VARIABLE
ELECTRODE_DISTANCE = 0.1;
x = x * ELECTRODE_DISTANCE; % TODO: how do we
y = y * ELECTRODE_DISTANCE; % get the inter electrode distance in mm?


for t = 1:size(spatialSTH,3)
    frame = spatialSTH(:,:,t);
    weightedx = x .* frame;
    weightedy = y .* frame;
    CAx(t) = sum(weightedx(:)) / sum(frame(:));
    CAy(t) = sum(weightedy(:)) / sum(frame(:));

    % Try to define a threshold to
end
CAT.x = CAx;
CAT.y = CAy;

if doPlot == 1
    if strcmp(metafile.info.type,"MCS")
        xlim = [0.05 1.25];
        ylim = xlim;
        %TODO: prepare the x and y scales for 3Brain
    end

    plot_x = [CAT.x nan];
    plot_y = [CAT.y nan];
    d = numel(CAT.x):-1:1;
    plot_d = [d nan];

    patch(plot_x,plot_y,plot_d, 'EdgeColor', 'interp','LineWidth',1)
    colorbar('Direction','reverse');
    colormap(jet)
    set(gca,...
        'XLim',xlim,'YLim',ylim,...
        'Color',[.1 .1 .1],'PlotBoxAspectRatio',[1 1 1],...
        'XColor','none','YColor','none')
end % end plotting
end %end function