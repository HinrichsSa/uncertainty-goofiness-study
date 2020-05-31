Reach_data = c3d_load('*_01_*.c3d');

Reach_X = UnpackField('Right_HandX', Reach_data);
Reach_Y = UnpackField('Right_HandY', Reach_data);

[imv_temp, endpoints, velocity, distance,...
 time, reaction_time,max_vel]...
 = Variables(Reach_X,Reach_Y, 1);