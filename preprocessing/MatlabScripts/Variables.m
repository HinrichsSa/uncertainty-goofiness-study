function [imv, endpoint, velocity, distance, time, reaction_time, max_vel] = Variables(X,Y,target)
    
    %Hard code targets
    start_target =  [0,0.2];
    %targets = [0,0.350000000000000;0.0750000000000000,0.329903810567666;0.129903810567666,0.275000000000000;0.150000000000000,0.200000000000000;0.129903810567666,0.125000000000000;0.0750000000000000,0.0700961894323342;1.83697019872103e-17,0.0500000000000000;-0.0750000000000000,0.0700961894323342;-0.129903810567666,0.125000000000000;-0.150000000000000,0.200000000000000;-0.129903810567666,0.275000000000000;-0.0750000000000000,0.329903810567666];
    cirrad_end = 0.09;
    cirrad_start = 0.006;
    cirrad_imv_min = 0.006;



    
    %% Pull out XY values for a single tial. Iterate over each trial 
    
    for p=1:size(X,2) % number of trials
        reach = [X(:,p),Y(:,p)];
      
        % Calculate radii of all points from center ...
        radii = hypot((X(:,p)-start_target(1)), (Y(:,p)-start_target(2)) );     
        
         % calculate distance
        for j=2:length(reach)
            distance(j) =norm(reach((j),:)- reach((j-1),:));
        end
        %calculate velocity
        % velocity = % If velocity is pulled as a vector, then create an input variable and set it at the start, out of the loop
        velocity  = distance/(1/1000);
        time = length(distance(~isnan(distance)))*(1/1000);
        max_vel = max(velocity);
        min_vel = max_vel;
        imv_vel_l = 0.4*max_vel;
        imv_vel_h = 0.5*max_vel;
        min_vel_RT = 0.05*max_vel;
        
        %% Reaction time
        RT = find(velocity <= min_vel_RT);
        RT_vec = max(RT);
        reaction_time = RT_vec *(1/1000);

        
        % Find the radii <= defined radius
%         incirc_end_idx = find(radii_temp <= cirrad_end);
        circ_imv_min_idx = find(radii > cirrad_imv_min);
 
%         excirc_end_idx = setdiff([1:size(reach,1)],incirc_end_idx);
          excirc_end_idx = find(radii > cirrad_end);

        
        % Index reach data via velocity criterion
        vel_imv_idx = find(velocity >= imv_vel_l & velocity <= imv_vel_h);
        
        %cross reference circle region and velocity idx
        grand_end_idx = excirc_end_idx;
        grand_imv_idx = intersect(vel_imv_idx,circ_imv_min_idx);

        
        % cross reference xy index with velocity index
        if isempty(grand_imv_idx)
            imv(p,:) = [NaN NaN];
        else
              grand_imv_idx = grand_imv_idx(1);
            imv(p,:) = reach(grand_imv_idx,:); 
        end
        
         if isempty(grand_end_idx)
            endpoints(p,:) = [NaN NaN];
         else
              grand_end_idx = grand_end_idx(1);
            endpoints(p,:) = reach(grand_end_idx,:); 
        end
        time_temp(p,:) = time-reaction_time;
        velocity_temp(p,:)= velocity;
        max_vel_temp(p,:) = max_vel;
        distance_temp(p,:)= distance;
        reaction_time_temp(p,:) = reaction_time;
%         
        if time_temp(p,:) > 0.6
            imv(p,:) = NaN;
            endpoints(p,:) = NaN;
        else
            imv(p,:) = imv(p,:);
             endpoints(p,:) = endpoints(p,:);
        end

        
    end
   velocity = velocity_temp;
   max_vel = max_vel_temp;
   time = time_temp;
   distance = distance_temp;
   endpoint = endpoints;
   imv = imv;
   reaction_time = reaction_time_temp;
end



