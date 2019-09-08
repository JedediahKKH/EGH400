function [parameters]= GetSimParameters()

% This function is to generate the parameters for the drone and other
% params

% The model currently in use: {DJI Mavic 2 Pro}

max_ascend_speed=5; %m/s
max_descend_speed=3; %m/s
max_speed=72000/3600; %m/s
max_flight_distance=18000; %m
max_flight_time=31*3600; %s at 25kph

% x_dot=V*cos(theta);
% y_dot=V*sin(theta);
% theta_dot=delta_theta;
parameters.maximums=[max_ascend_speed,max_descend_speed,max_speed,max_flight_distance,max_flight_time];
parameters.minimums=[0,0,0,0,0];
end