%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Baseline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Baseline_FB, Base_Traj_FB, 
% Base_velocity_FB, Base_Gaze_FB
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
Base_FB_Target = {};
Base_FB_X = [];
Base_FB_Y = [];
Base_FB_rotation = [];
Base_FB_Gaze_X = [];
Base_FB_Gaze_Y = [];
Base_FB_imv = [];
Base_FB_endpoints = [];
Base_FB_distance = [];
Base_FB_time = [];
Base_FB_Reaction_time = [];
Base_FB_max_vel = [];
Base_FB_Reaction_time_All = [];
Base_FB_max_vel_All = [];
Base_FB_imv_error = [];
Base_FB_endpoint_error = [];
Base_FB_mean_imv_error = [];
Base_FB_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Baseline_FB = [];
Traj_Baseline_FB = [];
Gaze_Baseline_FB = [];
Subject_Data_Baseline_FB = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Base_FB_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    % Trajectory data for X and Y
    Base_FB_X_temp = UnpackField('Right_HandX', Base_FB_Target{i});
    Base_FB_X = [Base_FB_X; Base_FB_X_temp];
    Base_FB_Y_temp = UnpackField('Right_HandY', Base_FB_Target{i});
    Base_FB_Y = [Base_FB_Y; Base_FB_Y_temp];
    
    % Gaze data for X and Y
    Base_FB_Gaze_X_temp = UnpackField('Gaze_X', Base_FB_Target{i});
    Base_FB_Gaze_X = [Base_FB_Gaze_X; Base_FB_Gaze_X_temp];
    Base_FB_Gaze_Y_temp = UnpackField('Gaze_Y', Base_FB_Target{i});
    Base_FB_Gaze_Y = [Base_FB_Gaze_Y; Base_FB_Gaze_Y_temp];
    
    %Rotation data
    Base_FB_rotation_temp=UnpackField('Rotation', Base_FB_Target{i});
    Base_FB_rotation_temp= Base_FB_rotation_temp(2,:);
    Base_FB_rotation_temp = Base_FB_rotation_temp';
    Base_FB_rotation = [Base_FB_rotation; Base_FB_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Base_FB_imv_temp, Base_FB_endpoints_temp, Base_FB_velocity_temp, Base_FB_distance_temp,...
        Base_FB_time_temp, Base_FB_Reaction_time_temp, Base_FB_max_vel_temp]...
        = Find_endpoint(Base_FB_X_temp,Base_FB_Y_temp, i);
    
    Base_FB_imv = [Base_FB_imv; Base_FB_imv_temp];
    Base_FB_endpoints = [Base_FB_endpoints; Base_FB_endpoints_temp];
    Base_FB_velocity_temp = Base_FB_velocity_temp';
    Velocity_Baseline_FB = [Velocity_Baseline_FB; Base_FB_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Base_FB_velocity_temp),1)*i];
    Base_FB_time = [Base_FB_time; Base_FB_time_temp]; 
    Base_FB_Reaction_time = [Base_FB_Reaction_time ;Base_FB_Reaction_time_temp];
    Base_FB_max_vel = [Base_FB_max_vel; Base_FB_max_vel_temp];
    
    % Create non baseline corrected Base_FBline IMV Errors
    Base_FB_imv_error_temp = calculate_heading_disparity_base(Base_FB_imv_temp,i);
    Base_FB_imv_error = [Base_FB_imv_error;Base_FB_imv_error_temp];
    Base_FB_mean_imv_error_temp = nanmean(Base_FB_imv_error_temp);
    idx_Base_FB_mean_imv_error = [repmat(Base_FB_mean_imv_error_temp,1,trial_num)];
    Base_FB_mean_imv_error = [Base_FB_mean_imv_error idx_Base_FB_mean_imv_error];   
    
    % Create non baseline corrected Base_FBline Endpoint Errors
    Base_FB_endpoint_error_temp = calculate_heading_disparity_base(Base_FB_endpoints_temp,i);
    Base_FB_endpoint_error = [Base_FB_endpoint_error;Base_FB_endpoint_error_temp];
    Base_FB_mean_endpoint_error_temp = nanmean(Base_FB_endpoint_error_temp);
    idx_Base_FB_mean_endpoint_error = [repmat(Base_FB_mean_endpoint_error_temp,1,trial_num)];
    Base_FB_mean_endpoint_error = [Base_FB_mean_endpoint_error idx_Base_FB_mean_endpoint_error];   
    
end

idx_Base_FB_Excluded_imv = isnan(Base_FB_imv);
num_Base_FB_Excluded_imv = sum(idx_Base_FB_Excluded_imv(:,1));

idx_Base_FB_Excluded_endpoints = isnan(Base_FB_endpoints);
num_Base_FB_Excluded_endpoints = sum(idx_Base_FB_Excluded_endpoints(:,1));

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
Velocity_Baseline_FB = [idx_velocity Velocity_Baseline_FB];
Traj_Baseline_FB = [Base_FB_X Base_FB_Y];
Gaze_Baseline_FB = [Base_FB_Gaze_X Base_FB_Gaze_Y];
Subject_Data_Baseline_FB = [idx_target_num'...
    idx_trial_num'...
    Base_FB_rotation...
    Base_FB_imv...
    Base_FB_endpoints...
    Base_FB_imv_error...
    Base_FB_endpoint_error...
    Base_FB_mean_imv_error'...
    Base_FB_mean_endpoint_error'...
    Base_FB_time...
    Base_FB_Reaction_time...
    Base_FB_max_vel];


