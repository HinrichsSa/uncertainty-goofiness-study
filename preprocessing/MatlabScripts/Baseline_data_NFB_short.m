%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script Creating Variables for Baseline Data
% -------------------------------------------------------------------------
% Principle Output: csv files of Subject_Data_Baseline_NFB, Base_Traj_NFB, 
% Base_velocity_NFB, Base_Gaze_NFB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


target_order = [7 8 9 10 11 12 12 1 2 3 4 5 6];
trial_num = 10;     % trial number
target_num = 12;    % target number
num_c3d = {'13' '14' '15' '16' '17' '18' '19' '20' '21' '22' '23' '24'};
num_c3d = cellstr(num_c3d);

%--------------------------------------------------------------------------
%% Initialising Variables
idx_target_num = [];
idx_trial_num = [];
Base_NFB_Target = {};
Base_NFB_X = [];
Base_NFB_Y = [];
Base_NFB_rotation = [];
Base_NFB_Gaze_X = [];
Base_NFB_Gaze_Y = [];
Base_NFB_imv = [];
Base_NFB_endpoints = [];
Base_NFB_distance = [];
Base_NFB_time = [];
Base_NFB_Reaction_time = [];
Base_NFB_max_vel = [];
Base_NFB_Reaction_time_All = [];
Base_NFB_max_vel_All = [];
Base_NFB_imv_error = [];
Base_NFB_endpoint_error = [];
Base_NFB_mean_imv_error = [];
Base_NFB_mean_endpoint_error = [];
idx_velocity = [];
Velocity_Baseline_NFB = [];
Traj_Baseline_NFB = [];
Gaze_Baseline_NFB = [];
Subject_Data_Baseline_NFB = [];

%--------------------------------------------------------------------------
%% Creating Variables for each target
for i = 1:target_num
    
    % Loading the c3d files
    Base_NFB_Target{i} = c3d_load(['*_' num_c3d{i} '_*.c3d']);
    
    for ii = 1:trial_num
        x = Base_NFB_Target{i}(ii).Gaze_X;
        y = Base_NFB_Target{i}(ii).Gaze_Y;
        t = Base_NFB_Target{i}(ii).Gaze_TimeStamp;
        trial = Base_NFB_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Base_NFB_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Gaze_Baseline_NFB = [Gaze_Baseline_NFB; trial target x y t];
    end
    
    for ii = 1:trial_num
        x = Base_NFB_Target{i}(ii).Right_HandX;
        y = Base_NFB_Target{i}(ii).Right_HandY;
        trial = Base_NFB_Target{i}(ii).TRIAL(1).TRIAL_NUM * ones(size(x));
        target = str2num(Base_NFB_Target{i}(ii).FILE_NAME(4:5)) * ones(size(x));
        Traj_Baseline_NFB = [Traj_Baseline_NFB; trial target x y];
    end      
    
    % Target Index    
    target_temp = []
    for ii = 1:trial_num
        Base_NFB_Target_num_temp = Base_NFB_Target{i}(ii).FILE_NAME;
        Base_NFB_Target_num_temp = Base_NFB_Target_num_temp(4:5);
        Base_NFB_Target_num_temp = str2num(Base_NFB_Target_num_temp);
        target_temp = [target_temp; Base_NFB_Target_num_temp];
    end
    idx_target_num = [idx_target_num; target_temp];
    
    % Trial Index
    trial_temp = []
    for ii = 1:trial_num
        Base_NFB_Trial_idx_temp = Base_NFB_Target{i}(ii).TRIAL(1).TRIAL_NUM
        trial_temp = [trial_temp; Base_NFB_Trial_idx_temp];
    end
    idx_trial_num = [idx_trial_num; trial_temp];    
    
    % Trajectory data for X and Y
    Base_NFB_X_temp = UnpackField('Right_HandX', Base_NFB_Target{i});
    Base_NFB_X = [Base_NFB_X; Base_NFB_X_temp];
    Base_NFB_Y_temp = UnpackField('Right_HandY', Base_NFB_Target{i});
    Base_NFB_Y = [Base_NFB_Y; Base_NFB_Y_temp];
    
    % Gaze data for X and Y
    Base_NFB_Gaze_X_temp = UnpackField('Gaze_X', Base_NFB_Target{i});
    Base_NFB_Gaze_X = [Base_NFB_Gaze_X; Base_NFB_Gaze_X_temp];
    Base_NFB_Gaze_Y_temp = UnpackField('Gaze_Y', Base_NFB_Target{i});
    Base_NFB_Gaze_Y = [Base_NFB_Gaze_Y; Base_NFB_Gaze_Y_temp];
    
    %Rotation data
    Base_NFB_rotation_temp=UnpackField('Rotation', Base_NFB_Target{i});
    Base_NFB_rotation_temp= Base_NFB_rotation_temp(2,:);
    Base_NFB_rotation_temp = Base_NFB_rotation_temp';
    Base_NFB_rotation = [Base_NFB_rotation; Base_NFB_rotation_temp];
    
    % Create Output of Script function find_endpoint
    [Base_NFB_imv_temp, Base_NFB_endpoints_temp, Base_NFB_velocity_temp, Base_NFB_distance_temp,...
        Base_NFB_time_temp, Base_NFB_Reaction_time_temp, Base_NFB_max_vel_temp]...
        = Find_endpoint(Base_NFB_X_temp,Base_NFB_Y_temp, i);   
    
    Base_NFB_imv = [Base_NFB_imv; Base_NFB_imv_temp];
    Base_NFB_endpoints = [Base_NFB_endpoints; Base_NFB_endpoints_temp];
    Base_NFB_velocity_temp = Base_NFB_velocity_temp';
    Velocity_Baseline_NFB = [Velocity_Baseline_NFB; Base_NFB_velocity_temp];
    idx_velocity =  [idx_velocity;ones(length(Base_NFB_velocity_temp),1)*i];
    Base_NFB_time = [Base_NFB_time; Base_NFB_time_temp]; 
    Base_NFB_Reaction_time = [Base_NFB_Reaction_time ;Base_NFB_Reaction_time_temp];
    Base_NFB_max_vel = [Base_NFB_max_vel; Base_NFB_max_vel_temp];
    
    % Create non baseline corrected Base_NFBline IMV Errors
    Base_NFB_imv_error_temp = calculate_heading_disparity_base(Base_NFB_imv_temp,i);
    Base_NFB_imv_error = [Base_NFB_imv_error;Base_NFB_imv_error_temp];
    Base_NFB_mean_imv_error_temp = nanmean(Base_NFB_imv_error_temp);
    idx_Base_NFB_mean_imv_error = [repmat(Base_NFB_mean_imv_error_temp,1,trial_num)];
    Base_NFB_mean_imv_error = [Base_NFB_mean_imv_error idx_Base_NFB_mean_imv_error];   
    
    % Create non baseline corrected Base_NFBline Endpoint Errors
    Base_NFB_endpoint_error_temp = calculate_heading_disparity_base(Base_NFB_endpoints_temp,i);
    Base_NFB_endpoint_error = [Base_NFB_endpoint_error;Base_NFB_endpoint_error_temp];
    Base_NFB_mean_endpoint_error_temp = nanmean(Base_NFB_endpoint_error_temp);
    idx_Base_NFB_mean_endpoint_error = [repmat(Base_NFB_mean_endpoint_error_temp,1,trial_num)];
    Base_NFB_mean_endpoint_error = [Base_NFB_mean_endpoint_error idx_Base_NFB_mean_endpoint_error];     
    
end

idx_Base_NFB_Excluded_imv = isnan(Base_NFB_imv);
num_Base_NFB_Excluded_imv = sum(idx_Base_NFB_Excluded_imv(:,1));

idx_Base_NFB_Excluded_endpoints = isnan(Base_NFB_endpoints);
num_Base_NFB_Excluded_endpoints = sum(idx_Base_NFB_Excluded_endpoints(:,1));

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
Velocity_Baseline_NFB = [idx_velocity Velocity_Baseline_NFB];
% Traj_Baseline_NFB = [Base_NFB_X Base_NFB_Y];
% NOTE: Gaze_Baseline_NFB is created at the top
Subject_Data_Baseline_NFB = [idx_target_num...
    idx_trial_num...
    Base_NFB_rotation...
    Base_NFB_imv...
    Base_NFB_endpoints...
    Base_NFB_imv_error...
    Base_NFB_endpoint_error...
    Base_NFB_mean_imv_error'...
    Base_NFB_mean_endpoint_error'...
    Base_NFB_time...
    Base_NFB_Reaction_time...
    Base_NFB_max_vel];


