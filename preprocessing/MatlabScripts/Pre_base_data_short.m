%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Pre_baseline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Pre_base, Pre_base_Traj, 
% Pre_base_velocity, Pre_base_Gaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 10;     % trial number
target_num = 12;    % target number
num_c3d = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Pre_base_Target = {};
Pre_base_rotation = [];
Pre_base_X = [];
Pre_base_Y = [];
Pre_base_Gaze_X = [];
Pre_base_Gaze_Y = [];
Pre_base_imv = [];
Pre_base_endpoints = [];
Pre_base_distance = [];
Pre_base_time = [];
Pre_base_Reaction_time = [];
Pre_base_max_vel = [];
Pre_base_Reaction_time_All = [];
Pre_base_max_vel_All = [];
Pre_base_imv_error = [];
Pre_base_endpoint_error = [];
Pre_base_mean_imv_error = [];
Pre_base_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Pre_base = [];
Traj_Pre_base = [];
Gaze_Pre_base = [];
Subject_Data_Pre_base = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Pre_base_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    % Trajectory data for X and Y
    Pre_base_X_temp = UnpackField('Right_HandX', Pre_base_Target{i});
    Pre_base_X = [Pre_base_X; Pre_base_X_temp];
    Pre_base_Y_temp = UnpackField('Right_HandY', Pre_base_Target{i});
    Pre_base_Y = [Pre_base_Y; Pre_base_Y_temp];
    
    % Gaze data for X and Y
    Pre_base_Gaze_X_temp = UnpackField('Gaze_X', Pre_base_Target{i});
    Pre_base_Gaze_X = [Pre_base_Gaze_X; Pre_base_Gaze_X_temp];
    Pre_base_Gaze_Y_temp = UnpackField('Gaze_Y', Pre_base_Target{i});
    Pre_base_Gaze_Y = [Pre_base_Gaze_Y; Pre_base_Gaze_Y_temp];
    
    %Rotation data
    Pre_base_rotation_temp=UnpackField('Rotation', Pre_base_Target{i});
    Pre_base_rotation_temp= Pre_base_rotation_temp(2,:);
    Pre_base_rotation_temp = Pre_base_rotation_temp';
    Pre_base_rotation = [Pre_base_rotation; Pre_base_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Pre_base_imv_temp, Pre_base_endpoints_temp, Pre_base_velocity_temp, Pre_base_distance_temp,...
        Pre_base_time_temp, Pre_base_Reaction_time_temp, Pre_base_max_vel_temp]...
        = Find_endpoint(Pre_base_X_temp,Pre_base_Y_temp, i);
    
    Pre_base_imv = [Pre_base_imv; Pre_base_imv_temp];
    Pre_base_endpoints = [Pre_base_endpoints; Pre_base_endpoints_temp];
    Pre_base_velocity_temp = Pre_base_velocity_temp';
    Velocity_Pre_base = [Velocity_Pre_base; Pre_base_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Pre_base_velocity_temp),1)*i];
    Pre_base_time = [Pre_base_time; Pre_base_time_temp]; 
    Pre_base_Reaction_time = [Pre_base_Reaction_time ;Pre_base_Reaction_time_temp];
    Pre_base_max_vel = [Pre_base_max_vel; Pre_base_max_vel_temp];
    
    % Create non baseline corrected Pre_baseline IMV Errors
    Pre_base_imv_error_temp = calculate_heading_disparity_base(Pre_base_imv_temp,i);
    Pre_base_imv_error = [Pre_base_imv_error;Pre_base_imv_error_temp];
    Pre_base_mean_imv_error_temp = nanmean(Pre_base_imv_error_temp);
    idx_Pre_base_mean_imv_error = [repmat(Pre_base_mean_imv_error_temp,1,trial_num)];
    Pre_base_mean_imv_error = [Pre_base_mean_imv_error idx_Pre_base_mean_imv_error];   
    
    % Create non baseline corrected Pre_baseline Endpoint Errors
    Pre_base_endpoint_error_temp = calculate_heading_disparity_base(Pre_base_endpoints_temp,i);
    Pre_base_endpoint_error = [Pre_base_endpoint_error;Pre_base_endpoint_error_temp];
    Pre_base_mean_endpoint_error_temp = nanmean(Pre_base_endpoint_error_temp);
    idx_Pre_base_mean_endpoint_error = [repmat(Pre_base_mean_endpoint_error_temp,1,trial_num)];
    Pre_base_mean_endpoint_error = [Pre_base_mean_endpoint_error idx_Pre_base_mean_endpoint_error];  
    
end

idx_Pre_base_Excluded_imv = isnan(Pre_base_imv);
num_Pre_base_Excluded_imv = sum(idx_Pre_base_Excluded_imv(:,1));

idx_Pre_base_Excluded_endpoints = isnan(Pre_base_endpoints);
num_Pre_base_Excluded_endpoints = sum(idx_Pre_base_Excluded_endpoints(:,1));

%--------------------------------------------------------------------------
%% Create Index colums for Trial and Target to add to the tables
for j = 1:target_num
    for k = 1:trial_num
        idx_trial_num = [idx_trial_num k];
        idx_target_num = [idx_target_num j];
    end
end

%--------------------------------------------------------------------------
%% Variables we may want to export to csv files later on
Velocity_Pre_base = [idx_velocity Velocity_Pre_base];
Traj_Pre_base = [Pre_base_X Pre_base_Y];
Gaze_Pre_base = [Pre_base_Gaze_X Pre_base_Gaze_Y];
Subject_Data_Pre_base = [idx_target_num'...
    idx_trial_num'...
    Pre_base_rotation...
    Pre_base_imv...
    Pre_base_endpoints...
    Pre_base_imv_error...
    Pre_base_endpoint_error...
    Pre_base_mean_imv_error'...
    Pre_base_mean_endpoint_error'...
    Pre_base_time...
    Pre_base_Reaction_time...
    Pre_base_max_vel];

