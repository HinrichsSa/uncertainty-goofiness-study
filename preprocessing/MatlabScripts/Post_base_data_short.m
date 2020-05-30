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
Post_Base_Target = {};
Post_Base_X = [];
Post_Base_Y = [];
Post_Base_rotation = [];
Post_Base_Gaze_X = [];
Post_Base_Gaze_Y = [];
Post_Base_imv = [];
Post_Base_endpoints = [];
Post_Base_distance = [];
Post_Base_time = [];
Post_Base_Reaction_time = [];
Post_Base_max_vel = [];
Post_Base_Reaction_time_All = [];
Post_Base_max_vel_All = [];
Post_Base_imv_error = [];
Post_Base_endpoint_error = [];
Post_Base_mean_imv_error = [];
Post_Base_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Postbaseline = [];
Traj_Postbaseline = [];
Gaze_Postbaseline = [];
Subject_Data_Postbaseline = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Post_Base_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    % Trajectory data for X and Y
    Post_Base_X_temp = UnpackField('Right_HandX', Post_Base_Target{i});
    Post_Base_X = [Post_Base_X; Post_Base_X_temp];
    Post_Base_Y_temp = UnpackField('Right_HandY', Post_Base_Target{i});
    Post_Base_Y = [Post_Base_Y; Post_Base_Y_temp];
    
    % Gaze data for X and Y
    Post_Base_Gaze_X_temp = UnpackField('Gaze_X', Post_Base_Target{i});
    Post_Base_Gaze_X = [Post_Base_Gaze_X; Post_Base_Gaze_X_temp];
    Post_Base_Gaze_Y_temp = UnpackField('Gaze_Y', Post_Base_Target{i});
    Post_Base_Gaze_Y = [Post_Base_Gaze_Y; Post_Base_Gaze_Y_temp];
    
    %Rotation data
    Post_Base_rotation_temp=UnpackField('Rotation', Post_Base_Target{i});
    Post_Base_rotation_temp= Post_Base_rotation_temp(2,:);
    Post_Base_rotation_temp = Post_Base_rotation_temp';
    Post_Base_rotation = [Post_Base_rotation; Post_Base_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Post_Base_imv_temp, Post_Base_endpoints_temp, Post_Base_velocity_temp, Post_Base_distance_temp,...
        Post_Base_time_temp, Post_Base_Reaction_time_temp, Post_Base_max_vel_temp]...
        = Find_endpoint(Post_Base_X_temp,Post_Base_Y_temp, i);
    
    Post_Base_imv = [Post_Base_imv; Post_Base_imv_temp];
    Post_Base_endpoints = [Post_Base_endpoints; Post_Base_endpoints_temp];
    Post_Base_velocity_temp = Post_Base_velocity_temp';
    Velocity_Postbaseline = [Velocity_Postbaseline; Post_Base_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Post_Base_velocity_temp),1)*i];
    Post_Base_time = [Post_Base_time; Post_Base_time_temp]; 
    Post_Base_Reaction_time = [Post_Base_Reaction_time ;Post_Base_Reaction_time_temp];
    Post_Base_max_vel = [Post_Base_max_vel; Post_Base_max_vel_temp];
    
    % Create non baseline corrected Post_Baseline IMV Errors
    Post_Base_imv_error_temp = calculate_heading_disparity_base(Post_Base_imv_temp,i);
    Post_Base_imv_error = [Post_Base_imv_error;Post_Base_imv_error_temp];
    Post_Base_mean_imv_error_temp = nanmean(Post_Base_imv_error_temp);
    idx_Post_Base_mean_imv_error = [repmat(Post_Base_mean_imv_error_temp,1,trial_num)];
    Post_Base_mean_imv_error = [Post_Base_mean_imv_error idx_Post_Base_mean_imv_error];   
    
    % Create non baseline corrected Post_Baseline Endpoint Errors
    Post_Base_endpoint_error_temp = calculate_heading_disparity_base(Post_Base_endpoints_temp,i);
    Post_Base_endpoint_error = [Post_Base_endpoint_error;Post_Base_endpoint_error_temp];
    Post_Base_mean_endpoint_error_temp = nanmean(Post_Base_endpoint_error_temp);
    idx_Post_Base_mean_endpoint_error = [repmat(Post_Base_mean_endpoint_error_temp,1,trial_num)];
    Post_Base_mean_endpoint_error = [Post_Base_mean_endpoint_error idx_Post_Base_mean_endpoint_error];   
    
end

idx_Post_Base_Excluded_imv = isnan(Post_Base_imv);
num_Post_Base_Excluded_imv = sum(idx_Post_Base_Excluded_imv(:,1));

idx_Post_Base_Excluded_endpoints = isnan(Post_Base_endpoints);
num_Post_Base_Excluded_endpoints = sum(idx_Post_Base_Excluded_endpoints(:,1));

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
Velocity_Postbaseline = [idx_velocity Velocity_Postbaseline];
Traj_Postbaseline = [Post_Base_X Post_Base_Y];
Gaze_Postbaseline = [Post_Base_Gaze_X Post_Base_Gaze_Y];
Subject_Data_Postbaseline = [idx_target_num'...
    idx_trial_num'...
    Post_Base_rotation...
    Post_Base_imv...
    Post_Base_endpoints...
    Post_Base_imv_error...
    Post_Base_endpoint_error...
    Post_Base_mean_imv_error'...
    Post_Base_mean_endpoint_error'...
    Post_Base_time...
    Post_Base_Reaction_time...
    Post_Base_max_vel];


