%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Generalisationline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Generalisation, Generalisation_Traj, 
% Generalisation_velocity, Generalisation_Gaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 6;     % trial number
target_num = 12;    % target number
num_c3d = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Generalisation_Target = {};
Generalisation_rotation = [];
Generalisation_X = [];
Generalisation_Y = [];
Generalisation_Gaze_X = [];
Generalisation_Gaze_Y = [];
Generalisation_imv = [];
Generalisation_endpoints = [];
Generalisation_distance = [];
Generalisation_time = [];
Generalisation_Reaction_time = [];
Generalisation_max_vel = [];
Generalisation_Reaction_time_All = [];
Generalisation_max_vel_All = [];
Generalisation_imv_error = [];
Generalisation_endpoint_error = [];
Generalisation_mean_imv_error = [];
Generalisation_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Generalisation = [];
Traj_Generalisation = [];
Gaze_Generalisation = [];
Subject_Data_Generalisation = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Generalisation_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    for ii = 1:trial_num
        x = Generalisation_Target{i}(ii).Gaze_X;
        y = Generalisation_Target{i}(ii).Gaze_Y;
        t = Generalisation_Target{i}(ii).Gaze_TimeStamp;
        trial = Generalisation_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Generalisation_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Gaze_Generalisation = [Gaze_Generalisation; trial target x y t];
    end
    
    for ii = 1:trial_num
        x = Generalisation_Target{i}(ii).Right_HandX;
        y = Generalisation_Target{i}(ii).Right_HandY;
        trial = Generalisation_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Generalisation_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Traj_Generalisation = [Traj_Generalisation; trial target x y];
    end      
    
    % Target Index    
    target_temp = []
    for ii = 1:trial_num
        Generalisation_Target_num_temp = Generalisation_Target{i}(ii).FILE_NAME;
        Generalisation_Target_num_temp = Generalisation_Target_num_temp(4:5);
        Generalisation_Target_num_temp = str2num(Generalisation_Target_num_temp);
        target_temp = [target_temp; Generalisation_Target_num_temp];
    end
    idx_target_num = [idx_target_num; target_temp];
    
    % Trial Index
    trial_temp = []
    for ii = 1:trial_num
        Generalisation_Trial_idx_temp = Generalisation_Target{i}(ii).TRIAL(1).TRIAL_NUM
        trial_temp = [trial_temp; Generalisation_Trial_idx_temp];
    end
    idx_trial_num = [idx_trial_num; trial_temp];    
    
    % Trajectory data for X and Y
    Generalisation_X_temp = UnpackField('Right_HandX', Generalisation_Target{i});
    Generalisation_X = [Generalisation_X; Generalisation_X_temp];
    Generalisation_Y_temp = UnpackField('Right_HandY', Generalisation_Target{i});
    Generalisation_Y = [Generalisation_Y; Generalisation_Y_temp];
    
    %Calculate Rotation
    Generalisation_rotation_temp = UnpackField('Rotation', Generalisation_Target{i});
    Generalisation_rotation_temp= Generalisation_rotation_temp(2,:);
    Generalisation_rotation_temp = Generalisation_rotation_temp';
    Generalisation_rotation = [Generalisation_rotation;Generalisation_rotation_temp];
    
    % Gaze data for X and Y
    Generalisation_Gaze_X_temp = UnpackField('Gaze_X', Generalisation_Target{i});
    Generalisation_Gaze_X = [Generalisation_Gaze_X; Generalisation_Gaze_X_temp];
    Generalisation_Gaze_Y_temp = UnpackField('Gaze_Y', Generalisation_Target{i});
    Generalisation_Gaze_Y = [Generalisation_Gaze_Y; Generalisation_Gaze_Y_temp];
    
    % Create Output of Script function find_endpoint
    [Generalisation_imv_temp, Generalisation_endpoints_temp, Generalisation_velocity_temp, Generalisation_distance_temp,...
        Generalisation_time_temp, Generalisation_Reaction_time_temp, Generalisation_max_vel_temp]...
        = Find_endpoint(Generalisation_X_temp,Generalisation_Y_temp, i);
    
    Generalisation_imv = [Generalisation_imv; Generalisation_imv_temp];
    Generalisation_endpoints = [Generalisation_endpoints; Generalisation_endpoints_temp];
    Generalisation_velocity_temp = Generalisation_velocity_temp';
    Velocity_Generalisation = [Velocity_Generalisation; Generalisation_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Generalisation_velocity_temp),1)*i];
    Generalisation_time = [Generalisation_time; Generalisation_time_temp]; 
    Generalisation_Reaction_time = [Generalisation_Reaction_time ;Generalisation_Reaction_time_temp];
    Generalisation_max_vel = [Generalisation_max_vel; Generalisation_max_vel_temp];
    
    % Create non baseline corrected Generalisationline IMV Errors
    Generalisation_imv_error_temp = calculate_heading_disparity_base(Generalisation_imv_temp,i);
    Generalisation_imv_error = [Generalisation_imv_error;Generalisation_imv_error_temp];
    Generalisation_mean_imv_error_temp = nanmean(Generalisation_imv_error_temp);
    idx_Generalisation_mean_imv_error = [repmat(Generalisation_mean_imv_error_temp,1,trial_num)];
    Generalisation_mean_imv_error = [Generalisation_mean_imv_error idx_Generalisation_mean_imv_error];   
    
    % Create non baseline corrected Generalisationline Endpoint Errors
    Generalisation_endpoint_error_temp = calculate_heading_disparity_base(Generalisation_endpoints_temp,i);
    Generalisation_endpoint_error = [Generalisation_endpoint_error;Generalisation_endpoint_error_temp];
    Generalisation_mean_endpoint_error_temp = nanmean(Generalisation_endpoint_error_temp);
    idx_Generalisation_mean_endpoint_error = [repmat(Generalisation_mean_endpoint_error_temp,1,trial_num)];
    Generalisation_mean_endpoint_error = [Generalisation_mean_endpoint_error idx_Generalisation_mean_endpoint_error];
    
end

idx_Generalisation_Excluded_imv = isnan(Generalisation_imv);
num_Generalisation_Excluded_imv = sum(idx_Generalisation_Excluded_imv(:,1));

idx_Generalisation_Excluded_endpoints = isnan(Generalisation_endpoints);
num_Generalisation_Excluded_endpoints = sum(idx_Generalisation_Excluded_endpoints(:,1));

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
Velocity_Generalisation = [idx_velocity Velocity_Generalisation];
% Traj_Generalisation = [Generalisation_X Generalisation_Y];
% NOTE: Gaze_Generalisation is created at the top
Subject_Data_Generalisation = [idx_target_num...
    idx_trial_num...
    Generalisation_rotation...
    Generalisation_imv...
    Generalisation_endpoints...
    Generalisation_imv_error...
    Generalisation_endpoint_error...
    Generalisation_mean_imv_error'...
    Generalisation_mean_endpoint_error'...
    Generalisation_time...
    Generalisation_Reaction_time...
    Generalisation_max_vel];

