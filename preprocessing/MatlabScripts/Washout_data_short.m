%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Washoutline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Washout, Washout_Traj, 
% Washout_velocity, Washout_Gaze
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 100;     % trial number
target_num = 1;    % target number
Base_NFB_num = 8;
num_c3d = {'01' '02' '03' '04' '05' '06' '07' '08' '09' '10' '11' '12'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Washout_Target = {};
Washout_rotation = [];
Washout_X = [];
Washout_Y = [];
Washout_Gaze_X = [];
Washout_Gaze_Y = [];
Washout_imv = [];
Washout_endpoints = [];
Washout_distance = [];
Washout_time = [];
Washout_Reaction_time = [];
Washout_max_vel = [];
Washout_Reaction_time_All = [];
Washout_max_vel_All = [];
Washout_imv_error = [];
Washout_endpoint_error = [];
Washout_mean_imv_error = [];
Washout_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Washout = [];
Traj_Washout = [];
Gaze_Washout = [];
Subject_Data_Washout = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Washout_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    for ii = 1:trial_num
        x = Washout_Target{i}(ii).Gaze_X;
        y = Washout_Target{i}(ii).Gaze_Y;
        t = Washout_Target{i}(ii).Gaze_TimeStamp;
        trial = Washout_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Washout_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Gaze_Washout = [Gaze_Washout; trial target x y t];
    end
    
    for ii = 1:trial_num
        x = Washout_Target{i}(ii).Right_HandX;
        y = Washout_Target{i}(ii).Right_HandY;
        trial = Washout_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Washout_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Traj_Washout = [Traj_Washout; trial target x y];
    end          
    
    % Target Index    
    target_temp = []
    for ii = 1:trial_num
        Washout_Target_num_temp = Washout_Target{i}(ii).FILE_NAME;
        Washout_Target_num_temp = Washout_Target_num_temp(4:5);
        Washout_Target_num_temp = str2num(Washout_Target_num_temp);
        target_temp = [target_temp; Washout_Target_num_temp];
    end
    idx_target_num = [idx_target_num; target_temp];
    
    % Trial Index
    trial_temp = []
    for ii = 1:trial_num
        Washout_Trial_idx_temp = Washout_Target{i}(ii).TRIAL(1).TRIAL_NUM
        trial_temp = [trial_temp; Washout_Trial_idx_temp];
    end
    idx_trial_num = [idx_trial_num; trial_temp];
    
    % Trajectory data for X and Y
    Washout_X_temp = UnpackField('Right_HandX', Washout_Target{i});
    Washout_X = [Washout_X; Washout_X_temp];
    Washout_Y_temp = UnpackField('Right_HandY', Washout_Target{i});
    Washout_Y = [Washout_Y; Washout_Y_temp];
    
    % Gaze data for X and Y
    Washout_Gaze_X_temp = UnpackField('Gaze_X', Washout_Target{i});
    Washout_Gaze_X = [Washout_Gaze_X; Washout_Gaze_X_temp];
    Washout_Gaze_Y_temp = UnpackField('Gaze_Y', Washout_Target{i});
    Washout_Gaze_Y = [Washout_Gaze_Y; Washout_Gaze_Y_temp];
    
    %Rotation data
    Washout_rotation_temp = UnpackField('Rotation', Washout_Target{i});
    Washout_rotation_temp = Washout_rotation_temp(2,:);
    Washout_rotation_temp = Washout_rotation_temp';
    Washout_rotation = [Washout_rotation; Washout_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Washout_imv_temp, Washout_endpoints_temp, Washout_velocity_temp, Washout_distance_temp,...
        Washout_time_temp, Washout_Reaction_time_temp, Washout_max_vel_temp]...
        = Find_endpoint(Washout_X_temp,Washout_Y_temp, i);
    
    Washout_imv = [Washout_imv; Washout_imv_temp];
    Washout_endpoints = [Washout_endpoints; Washout_endpoints_temp];
    Washout_velocity_temp = Washout_velocity_temp';
    Velocity_Washout = [Velocity_Washout; Washout_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Washout_velocity_temp),1)*i];
    Washout_time = [Washout_time; Washout_time_temp]; 
    Washout_Reaction_time = [Washout_Reaction_time ;Washout_Reaction_time_temp];
    Washout_max_vel = [Washout_max_vel; Washout_max_vel_temp];
    
    % Create non baseline corrected Washoutline IMV Errors
    Washout_imv_error_temp = calculate_heading_disparity_base(Washout_imv_temp,i);
    Washout_imv_error = [Washout_imv_error;Washout_imv_error_temp];
    Washout_mean_imv_error_temp = nanmean(Washout_imv_error_temp);
    idx_Washout_mean_imv_error = [repmat(Washout_mean_imv_error_temp,1,trial_num)];
    Washout_mean_imv_error = [Washout_mean_imv_error idx_Washout_mean_imv_error];   
    
    % Create non baseline corrected Washoutline Endpoint Errors
    Washout_endpoint_error_temp = calculate_heading_disparity_base(Washout_endpoints_temp,i);
    Washout_endpoint_error = [Washout_endpoint_error;Washout_endpoint_error_temp];
    Washout_mean_endpoint_error_temp = nanmean(Washout_endpoint_error_temp);
    idx_Washout_mean_endpoint_error = [repmat(Washout_mean_endpoint_error_temp,1,trial_num)];
    Washout_mean_endpoint_error = [Washout_mean_endpoint_error idx_Washout_mean_endpoint_error];     
    
    %%baseline corrected
    % Baseline_endpoint_mean = nanmean(Base_endpoints_NFB(1:Base_NFB_num,:));
    % Washout_error_temp = calculate_heading_disparity(Baseline_endpoint_mean, Washout_endpoints_temp);
    
end

idx_Washout_Excluded_imv = isnan(Washout_imv);
num_Washout_Excluded_imv = sum(idx_Washout_Excluded_imv(:,1));

idx_Washout_Excluded_endpoints = isnan(Washout_endpoints);
num_Washout_Excluded_endpoints = sum(idx_Washout_Excluded_endpoints(:,1));

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
Velocity_Washout = [idx_velocity Velocity_Washout];
% Traj_Washout = [Washout_X Washout_Y];
% NOTE: Gaze_Washout is created at the top
Subject_Data_Washout = [idx_target_num...
    idx_trial_num...
    Washout_rotation...
    Washout_imv...
    Washout_endpoints...
    Washout_imv_error...
    Washout_endpoint_error...
    Washout_mean_imv_error'...
    Washout_mean_endpoint_error'...
    Washout_time...
    Washout_Reaction_time...
    Washout_max_vel];


