%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Trainingline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Training, Training_Traj, 
% Training_velocity, Training_Gaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 400;     % trial number
target_num = 1;% target number
Base_NFB_num = 8;
num_c3d = {'01'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Training_Target = {};
Training_rotation = [];
Training_X = [];
Training_Y = [];
Training_Gaze_X = [];
Training_Gaze_Y = [];
Training_imv = [];
Training_endpoints = [];
Training_distance = [];
Training_time = [];
Training_Reaction_time = [];
Training_max_vel = [];
Training_Reaction_time_All = [];
Training_max_vel_All = [];
Training_imv_error = [];
Training_endpoint_error = [];
Training_mean_imv_error = [];
Training_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Training = [];
Traj_Training = [];
Gaze_Training = [];
Subject_Data_Training = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Training_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);

    for ii = 1:trial_num
        x = Training_Target{i}(ii).Gaze_X;
        y = Training_Target{i}(ii).Gaze_Y;
        t = Training_Target{i}(ii).Gaze_TimeStamp;
        trial = Training_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Training_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Gaze_Training = [Gaze_Training; trial target x y t];
    end
    
    for ii = 1:trial_num
        x = Training_Target{i}(ii).Right_HandX;
        y = Training_Target{i}(ii).Right_HandY;
        trial = Training_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Training_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Traj_Training = [Traj_Training; trial target x y];
    end    
    
    % Target Index    
    target_temp = []
    for ii = 1:trial_num
        Training_Target_num_temp = Training_Target{i}(ii).FILE_NAME;
        Training_Target_num_temp = Training_Target_num_temp(4:5);
        Training_Target_num_temp = str2num(Training_Target_num_temp);
        target_temp = [target_temp; Training_Target_num_temp];
    end
    idx_target_num = [idx_target_num; target_temp];
    
    % Trial Index
    trial_temp = []
    for ii = 1:trial_num
        Training_Trial_idx_temp = Training_Target{i}(ii).TRIAL(1).TRIAL_NUM
        trial_temp = [trial_temp; Training_Trial_idx_temp];
    end
    idx_trial_num = [idx_trial_num; trial_temp];    
    
    % Trajectory data for X and Y
    Training_X_temp = UnpackField('Right_HandX', Training_Target{i});
    Training_X = [Training_X; Training_X_temp];
    Training_Y_temp = UnpackField('Right_HandY', Training_Target{i});
    Training_Y = [Training_Y; Training_Y_temp];
    
    % Gaze data for X and Y
    Training_Gaze_X_temp = UnpackField('Gaze_X', Training_Target{i});
    Training_Gaze_X = [Training_Gaze_X; Training_Gaze_X_temp];
    Training_Gaze_Y_temp = UnpackField('Gaze_Y', Training_Target{i});
    Training_Gaze_Y = [Training_Gaze_Y; Training_Gaze_Y_temp];
    
    %Rotation data
    Training_rotation_temp = UnpackField('Rotation', Training_Target{i});
    Training_rotation_temp = Training_rotation_temp(2,:);
    Training_rotation_temp = Training_rotation_temp';
    Training_rotation = [Training_rotation; Training_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Training_imv_temp, Training_endpoints_temp, Training_velocity_temp, Training_distance_temp,...
        Training_time_temp, Training_Reaction_time_temp, Training_max_vel_temp]...
        = Find_endpoint(Training_X_temp,Training_Y_temp, i);
    
    Training_imv = [Training_imv; Training_imv_temp];
    Training_endpoints = [Training_endpoints; Training_endpoints_temp];
    Training_velocity_temp = Training_velocity_temp';
    Velocity_Training = [Velocity_Training; Training_velocity_temp];
    sz = size(Training_velocity_temp);
    idx_velocity =  [idx_velocity; ones(sz(1),1)*i];
    % idx_velocity =  [idx_velocity;ones(length(Training_velocity_temp),1)*i];
    Training_time = [Training_time; Training_time_temp]; 
    Training_Reaction_time = [Training_Reaction_time ;Training_Reaction_time_temp];
    Training_max_vel = [Training_max_vel; Training_max_vel_temp];
    
    % Create non baseline corrected Trainingline IMV Errors
    Training_imv_error_temp = calculate_heading_disparity_base(Training_imv_temp,i);
    Training_imv_error = [Training_imv_error;Training_imv_error_temp];
    Training_mean_imv_error_temp = nanmean(Training_imv_error_temp);
    idx_Training_mean_imv_error = [repmat(Training_mean_imv_error_temp,1,trial_num)];
    Training_mean_imv_error = [Training_mean_imv_error idx_Training_mean_imv_error];   
    
    % Create non baseline corrected Trainingline Endpoint Errors
    Training_endpoint_error_temp = calculate_heading_disparity_base(Training_endpoints_temp,i);
    Training_endpoint_error = [Training_endpoint_error;Training_endpoint_error_temp];
    Training_mean_endpoint_error_temp = nanmean(Training_endpoint_error_temp);
    idx_Training_mean_endpoint_error = [repmat(Training_mean_endpoint_error_temp,1,trial_num)];
    Training_mean_endpoint_error = [Training_mean_endpoint_error idx_Training_mean_endpoint_error];      
    
    %%baseline corrected
    % Baseline_endpoint_mean = nanmean(Base_endpoints_NFB(1:Base_NFB_num,:)); %Change index value if numtrials base_NFB changes
    % Training_error_temp = calculate_heading_disparity(Baseline_endpoint_mean, Training_endpoints_temp);
    
end

idx_Training_Excluded_imv = isnan(Training_imv);
num_Training_Excluded_imv = sum(idx_Training_Excluded_imv(:,1));

idx_Training_Excluded_endpoints = isnan(Training_endpoints);
num_Training_Excluded_endpoints = sum(idx_Training_Excluded_endpoints(:,1));

%--------------------------------------------------------------------------
%% Create Index colums for Trial and Target to add to the tables
% for j = 1:target_num
%     for k = 1:trial_num
%         idx_trial_num = [idx_trial_num k];
%         idx_target_num = [idx_target_num j];
%     end
% end


%--------------------------------------------------------------------------
%% Variables we may want to export to csv files later on
Velocity_Training = [idx_velocity Velocity_Training];
% Traj_Training = [Training_X Training_Y];
% Note: Gaze_Training is created at the top
Subject_Data_Training = [idx_target_num...
    idx_trial_num...
    Training_rotation...
    Training_imv...
    Training_endpoints...
    Training_imv_error...
    Training_endpoint_error...
    Training_mean_imv_error'...
    Training_mean_endpoint_error'...
    Training_time...
    Training_Reaction_time...
    Training_max_vel];

