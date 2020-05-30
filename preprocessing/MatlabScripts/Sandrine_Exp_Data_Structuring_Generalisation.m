%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Pilot Data Sandrine 2019
% ---------------------------------------------------------
% Running pre data analysis for all subjects and all blocks respectively
% Output: Matlab Workspace, overview csv file, and detailed csv files 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;
clear global;

%% Set path and directory
% Set current working directory and path
cur_dir = cd('C:\Users\BKIN TECHNOLOGIES\Documents\BKIN Dexterit-E Data\Sandrine Experiment 2019');
cur_dir = [];

addpath('C:\Users\BKIN TECHNOLOGIES\Documents\BKIN Dexterit-E Data\2019');
cur_dir = cd('C:\Users\BKIN TECHNOLOGIES\Documents\BKIN Dexterit-E Data\Sandrine Experiment 2019');

% Load required function from other folder
copyfile('C:\Users\BKIN TECHNOLOGIES\Documents\BKIN Dexterit-E Data\2018\TEST\VMR\dirdir.m', cur_dir);
cd(cur_dir);


%--------------------------------------------------------------------------
%% Define Variables
% Names of the subject folders
all_subs = dirdir; %get dirdir from file-ex (attached)
names = {all_subs.name}';
names = char(names);

% Extract only the subject numbers
subj_ind = names(:,13:14);
names = cellstr(names);


block_names = {'1Prebaseline', '2Familiarisation', '3Baseline', '4Postbaseline', '5Training', '6Generalisation', '7Relearning', '8Washout'};
function_names = {'Pre_base_data_short.m', 'Familiarisation_data_short.m', 'Baseline_data_FB_short.m', 'Post_base_data_short.m', 'Training_data_short.m', 'Generalisation_data_short.m', 'Relearning_data_short.m', 'Washout_data_short.m'};
%save_names = {'Pre_base_data', 'Familiarisation_data', 'Baseline_data_FB', 'Training_data', 'Generalisation_data', 'Relearning_data', 'Washout_data'};


%--------------------------------------------------------------------------
%% Create directory structure for Analysis
% In cur_dir create Analysis and the respective Block subfolders
mkdir('Analysis');
cd('Analysis');

for idx1_block_names=1:length(block_names)
    mkdir(block_names{idx1_block_names});
end
cd(cur_dir);


%--------------------------------------------------------------------------
%% Loop over subjects
for idx_all_subs = 1:length(all_subs)
 
    
    % Define block names variables and their variable type
    cd([cd,'\',all_subs(idx_all_subs).name]) % go inside subject folder
    all_files = dir('*.zip'); % make a struct with the zip names
    names_zip = {all_files.name}';
    names_zip = char(names_zip);
    names_unzip = names_zip(:, 1:29);
    names_unzip = cellstr(names_unzip);
    names_zip = cellstr(names_zip);
    
    
    %----------------------------------------------------------------------
    %% Loop over blocks within a subject
    for idx_names_zip = 1:length(names_zip)
        % Copy the block zip folders and unzip them
        nu_cur = names_unzip(idx_names_zip); % Name of the current unzipped folder
        nu_cur = char(nu_cur);
        mkdir(nu_cur);
        names_zip = cellstr(names_zip);
        names_zip_k = char(names_zip(idx_names_zip));
        unzip(names_zip_k, nu_cur); 
        
        % Go back to the respective subjetcs block directory level
        cd(cur_dir);
        cd([cd,'\',all_subs(idx_all_subs).name])
    end
    
    
    %----------------------------------------------------------------------
    %% Analysis Loop over blocks for the respective subject
    n=3; % Change this variable depending on where the Baseline block is in the zip order 
    cd([cur_dir '\' names{idx_all_subs} '\' names_unzip{n} '\raw']);
    run('Baseline_data_NFB_short');
        
    cd(cur_dir);
    csvwrite(['Analysis\3Baseline\San_Exp_S' subj_ind(idx_all_subs, :) '_3Baseline_NFB_SubjData.csv'], Subject_Data_Baseline_NFB);  
    csvwrite(['Analysis\3Baseline\San_Exp_S' subj_ind(idx_all_subs, :) '_3Baseline_NFB_VelData.csv'], Velocity_Baseline_NFB);  
    csvwrite(['Analysis\3Baseline\San_Exp_S' subj_ind(idx_all_subs, :) '_3Baseline_NFB_TrajData.csv'], Traj_Baseline_NFB);  
    csvwrite(['Analysis\3Baseline\San_Exp_S' subj_ind(idx_all_subs, :) '_3Baseline_NFB_GazeData.csv'], Gaze_Baseline_NFB);  
    
    for idx2_block_names = 1:length(block_names)
        % Run the block analysis functions with the cd3 files
        cd([cur_dir '\' names{idx_all_subs} '\' names_unzip{idx2_block_names} '\raw']);
        run(char(function_names{idx2_block_names}));
        cd(cur_dir);
    end
    
    % Create Funnction Variables for the csv loop
    Subject_Data_names = {Subject_Data_Pre_base, Subject_Data_Familiarisation, Subject_Data_Baseline_FB, Subject_Data_Postbaseline, Subject_Data_Training, Subject_Data_Generalisation, Subject_Data_Relearning, Subject_Data_Washout};
    Traj_names = {Traj_Pre_base, Traj_Familiarisation, Traj_Baseline_FB, Traj_Postbaseline, Traj_Training, Traj_Generalisation, Traj_Relearning, Traj_Washout};
    Velocity_names = {Velocity_Pre_base, Velocity_Familiarisation, Velocity_Baseline_FB, Velocity_Postbaseline, Velocity_Training, Velocity_Generalisation, Velocity_Relearning, Velocity_Washout};
    Gaze_names = {Gaze_Pre_base, Gaze_Familiarisation, Gaze_Baseline_FB, Gaze_Postbaseline, Gaze_Training, Gaze_Generalisation, Gaze_Relearning, Gaze_Washout};
    
    for idx2_block_names = 1:length(block_names)
        % Save a csv file with the respectively important variables
        csvwrite(['Analysis\' block_names{idx2_block_names} '\San_Exp_S' subj_ind(idx_all_subs, :) '_' block_names{idx2_block_names} '_SubjData.csv'], Subject_Data_names{idx2_block_names}); 
        csvwrite(['Analysis\' block_names{idx2_block_names} '\San_Exp_S' subj_ind(idx_all_subs, :) '_' block_names{idx2_block_names} '_VelData.csv'], Velocity_names{idx2_block_names}); 
        csvwrite(['Analysis\' block_names{idx2_block_names} '\San_Exp_S' subj_ind(idx_all_subs, :) '_' block_names{idx2_block_names} '_TrajData.csv'], Traj_names{idx2_block_names}); 
        csvwrite(['Analysis\' block_names{idx2_block_names} '\San_Exp_S' subj_ind(idx_all_subs, :) '_' block_names{idx2_block_names} '_GazeData.csv'], Gaze_names{idx2_block_names}); 
        cd(cur_dir);
    end
    
    % Save a matlab workspace for each subject
    save(['Analysis\San_Exp_S' subj_ind(idx_all_subs, :)]);    
    
    
end       

cd(cur_dir);

