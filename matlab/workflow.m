%% Example of data analysis workflow

%% Load data
% The input data comes from SpiQEPhysTools
% It is a .txt file with two columns
% This first column has all the spiketimes
% The second column has the number of the electrode where that spike was
% detected.

myDir = uigetdir; % Select a directory where the "spk.txt" and metadata file are located

allspks = readmatrix(fullfile(myDir,"spk.txt"));
allspks(:,1) = allspks(:,1) * 1000; % SpiQ output is in s, this converts it to ms

metafile = fullfile(myDir,'meta.toml');
toml_tmp = toml.read(metafile);
META = toml.map_to_struct(toml_tmp);

% TODO: If there as a stimulus, define what the stimulation file looks like and how to import it

% As a principle to maximize function compatibility,
% all sections and possible analyses will take as input the "allspks"
% spiketime variable and the "META" metadata file

%% Raster plot of the data
scatter(allspks(:,1),allspks(:,2))

%% Population spiketime histogram
% TODO

%% (optional) Stimulus alignment 
% TODO

%% Burst analysis
% TODO

%% Spatial analysis - Center of Activity Trajectory

CAT = meaCAT(10000,15000,allspks,META,5,1);
