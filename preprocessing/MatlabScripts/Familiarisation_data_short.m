%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Familiarisationline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Familiarisation, Familiarisation_Traj, 
% Familiarisation_velocity, Familiarisation_Gaze
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
Familiarisation_Target = {};
Familiarisation_X = [];
Familiarisation_Y = [];
Familiarisation_rotation = [];
Familiarisation_Gaze_X = [];
Familiarisation_Gaze_Y = [];
Familiarisation_imv = [];
Familiarisation_endpoints = [];
Familiarisation_distance = [];
Familiarisation_time = [];
Familiarisation_Reaction_time = [];
Familiarisation_max_vel = [];
Familiarisation_Reaction_time_All = [];
Familiarisation_max_vel_All = [];
Familiarisation_imv_error = [];
Familiarisation_endpoint_error = [];
Familiarisation_mean_imv_error = [];
Familiarisation_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Familiarisation = [];
Traj_Familiarisation = [];
Gaze_Familiarisation= [];
Subject_Data_Familiarisation = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Familiarisation_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    % Trajectory data for X and Y
    Familiarisation_X_temp = UnpackField('Right_HandX', Familiarisation_Target{i});
    Familiarisation_X = [Familiarisation_X; Familiarisation_X_temp];
    Familiarisation_Y_temp = UnpackField('Right_HandY', Familiarisation_Target{i});
    Familiarisation_Y = [Familiarisation_Y; Familiarisation_Y_temp];
    
    % Gaze data for X and Y
    Familiarisation_Gaze_X_temp = UnpackField('Gaze_X', Familiarisation_Target{i});
    Familiarisation_Gaze_X = [Familiarisation_Gaze_X; Familiarisation_Gaze_X_temp];
    Familiarisation_Gaze_Y_temp = UnpackField('Gaze_Y', Familiarisation_Target{i});
    Familiarisation_Gaze_Y = [Familiarisation_Gaze_Y; Familiarisation_Gaze_Y_temp];
    
    %Rotation data
    Familiarisation_rotation_temp = UnpackField('Rotation', Familiarisation_Target{i});
    Familiarisation_rotation_temp= Familiarisation_rotation_temp(2,:);
    Familiarisation_rotation_temp = Familiarisation_rotation_temp';
    Familiarisation_rotation = [Familiarisation_rotation; Familiarisation_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Familiarisation_imv_temp, Familiarisation_endpoints_temp, Familiarisation_velocity_temp, Familiarisation_distance_temp,...
        Familiarisation_time_temp, Familiarisation_Reaction_time_temp, Familiarisation_max_vel_temp]...
        = Find_endpoint(Familiarisation_X_temp,Familiarisation_Y_temp, i);
    
    Familiarisation_imv = [Familiarisation_imv; Familiarisation_imv_temp];
    Familiarisation_endpoints = [Familiarisation_endpoints; Familiarisation_endpoints_temp];
    Familiarisation_velocity_temp = Familiarisation_velocity_temp';
    Velocity_Familiarisation = [Velocity_Familiarisation; Familiarisation_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Familiarisation_velocity_temp),1)*i];
    Familiarisation_time = [Familiarisation_time; Familiarisation_time_temp]; 
    Familiarisation_Reaction_time = [Familiarisation_Reaction_time; Familiarisation_Reaction_time_temp];
    Familiarisation_max_vel = [Familiarisation_max_vel; Familiarisation_max_vel_temp];
    
    % Create non baseline corrected Familiarisationline IMV Errors
    Familiarisation_imv_error_temp = calculate_heading_disparity_base(Familiarisation_imv_temp,i);
    Familiarisation_imv_error = [Familiarisation_imv_error;Familiarisation_imv_error_temp];
    Familiarisation_mean_imv_error_temp = nanmean(Familiarisation_imv_error_temp);
    idx_Familiarisation_mean_imv_error = [repmat(Familiarisation_mean_imv_error_temp,1,trial_num)];
    Familiarisation_mean_imv_error = [Familiarisation_mean_imv_error idx_Familiarisation_mean_imv_error];    
    
    % Create non baseline corrected Familiarisationline Endpoint Errors
    Familiarisation_endpoint_error_temp = calculate_heading_disparity_base(Familiarisation_endpoints_temp,i);
    Familiarisation_endpoint_error = [Familiarisation_endpoint_error;Familiarisation_endpoint_error_temp];
    Familiarisation_mean_endpoint_error_temp = nanmean(Familiarisation_endpoint_error_temp);
    idx_Familiarisation_mean_endpoint_error = [repmat(Familiarisation_mean_endpoint_error_temp,1,trial_num)];
    Familiarisation_mean_endpoint_error = [Familiarisation_mean_endpoint_error idx_Familiarisation_mean_endpoint_error];
    
end

idx_Familiarisation_Excluded_imv = isnan(Familiarisation_imv);
num_Familiarisation_Excluded_imv = sum(idx_Familiarisation_Excluded_imv(:,1));

idx_Familiarisation_Excluded_endpoints = isnan(Familiarisation_endpoints);
num_Familiarisation_Excluded_endpoints = sum(idx_Familiarisation_Excluded_endpoints(:,1));

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
Velocity_Familiarisation = [idx_velocity Velocity_Familiarisation];
Traj_Familiarisation = [Familiarisation_X Familiarisation_Y];
Gaze_Familiarisation = [Familiarisation_Gaze_X Familiarisation_Gaze_Y];
Subject_Data_Familiarisation = [idx_target_num'...
    idx_trial_num'...
    Familiarisation_rotation...
    Familiarisation_imv...
    Familiarisation_endpoints...
    Familiarisation_imv_error...
    Familiarisation_endpoint_error...
    Familiarisation_mean_imv_error'...
    Familiarisation_mean_endpoint_error'...
    Familiarisation_time...
    Familiarisation_Reaction_time...
    Familiarisation_max_vel];
