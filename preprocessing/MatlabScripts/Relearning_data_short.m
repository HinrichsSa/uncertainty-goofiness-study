%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Relearningline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Relearning, Relearning_Traj, 
% Relearning_velocity, Relearning_Gaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 100;     % trial number
Base_NFB_num = 8;
target_num = 1;    % target number
num_c3d = {'01'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Relearning_Target = {};
Relearning_X = [];
Relearning_Y = [];
Relearning_rotation = [];
Relearning_Gaze_X = [];
Relearning_Gaze_Y = [];
Relearning_imv = [];
Relearning_endpoints = [];
Relearning_distance = [];
Relearning_time = [];
Relearning_Reaction_time = [];
Relearning_max_vel = [];
Relearning_Reaction_time_All = [];
Relearning_max_vel_All = [];
Relearning_imv_error = [];
Relearning_endpoint_error = [];
Relearning_mean_imv_error = [];
Relearning_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Relearning = [];
Traj_Relearning = [];
Gaze_Relearning = [];
Subject_Data_Relearning = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Relearning_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    % Trajectory data for X and Y
    Relearning_X_temp = UnpackField('Right_HandX', Relearning_Target{i});
    Relearning_X = [Relearning_X; Relearning_X_temp];
    Relearning_Y_temp = UnpackField('Right_HandY', Relearning_Target{i});
    Relearning_Y = [Relearning_Y; Relearning_Y_temp];
    
    %Rotation data
    Relearning_rotation_temp=UnpackField('Rotation', Relearning_Target{i});
    Relearning_rotation_temp= Relearning_rotation_temp(2,:);
    Relearning_rotation_temp = Relearning_rotation_temp';
    Relearning_rotation = [Relearning_rotation;Relearning_rotation_temp];
    
    % Gaze data for X and Y
    Relearning_Gaze_X_temp = UnpackField('Gaze_X', Relearning_Target{i});
    Relearning_Gaze_X = [Relearning_Gaze_X; Relearning_Gaze_X_temp];
    Relearning_Gaze_Y_temp = UnpackField('Gaze_Y', Relearning_Target{i});
    Relearning_Gaze_Y = [Relearning_Gaze_Y; Relearning_Gaze_Y_temp];
    
    % Create Output of Script function find_endpoints
     [Relearning_imv_temp, Relearning_endpoints_temp, Relearning_velocity_temp, Relearning_distance_temp,...
        Relearning_time_temp, Relearning_Reaction_time_temp, Relearning_max_vel_temp]...
        = Find_endpoint(Relearning_X_temp,Relearning_Y_temp, i);
    
    Relearning_imv = [Relearning_imv; Relearning_imv_temp]; 
    Relearning_endpoints = [Relearning_endpoints; Relearning_endpoints_temp];
    Relearning_velocity_temp = Relearning_velocity_temp';
    Velocity_Relearning = [Velocity_Relearning; Relearning_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Relearning_velocity_temp),1)*i];
    Relearning_time = [Relearning_time; Relearning_time_temp]; 
    Relearning_Reaction_time = [Relearning_Reaction_time ;Relearning_Reaction_time_temp];
    Relearning_max_vel = [Relearning_max_vel; Relearning_max_vel_temp];
    
    % Create non baseline corrected Relearning IMV Errors    
    Relearning_imv_error_temp = calculate_heading_disparity_base(Relearning_imv_temp,i);
    Relearning_imv_error = [Relearning_imv_error;Relearning_imv_error_temp];
    Relearning_mean_imv_error_temp = nanmean(Relearning_imv_error_temp);
    idx_Relearning_mean_imv_error = [repmat(Relearning_mean_imv_error_temp,1,trial_num)];
    Relearning_mean_imv_error = [Relearning_mean_imv_error idx_Relearning_mean_imv_error];    
    
    % Create non baseline corrected Relearning Endpoint Errors
    Relearning_endpoint_error_temp = calculate_heading_disparity_base(Relearning_endpoints_temp,i);
    Relearning_endpoint_error = [Relearning_endpoint_error;Relearning_endpoint_error_temp];
    Relearning_mean_endpoint_error_temp = nanmean(Relearning_endpoint_error_temp);
    idx_Relearning_mean_endpoint_error = [repmat(Relearning_mean_endpoint_error_temp,1,trial_num)];
    Relearning_mean_endpoint_error = [Relearning_mean_endpoint_error idx_Relearning_mean_endpoint_error];
      
end

idx_Relearning_Excluded_imv = isnan(Relearning_imv);
num_Relearning_Excluded_imv = sum(idx_Relearning_Excluded_imv(:,1));

idx_Relearning_Excluded_endpoints = isnan(Relearning_endpoints);
num_Relearning_Excluded_endpoints = sum(idx_Relearning_Excluded_endpoints(:,1));

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
Velocity_Relearning = [idx_velocity Velocity_Relearning];
Traj_Relearning = [Relearning_X Relearning_Y];
Gaze_Relearning = [Relearning_Gaze_X Relearning_Gaze_Y];
Subject_Data_Relearning = [idx_target_num'...
    idx_trial_num'... 
    Relearning_rotation...
    Relearning_imv...  
    Relearning_endpoints...
    Relearning_imv_error...
    Relearning_endpoint_error... 
    Relearning_mean_imv_error'... 
    Relearning_mean_endpoint_error'... 
    Relearning_time...
    Relearning_Reaction_time...
    Relearning_max_vel];
