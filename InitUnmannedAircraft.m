function [Aircraft,Schedule]=InitUnmannedAircraft(Parameters,CBD_SubNetwork,CBD_Graph, Schedule)
% add to the schedule, a random assortment of connections from number of
% nodes in subnetwork
num_nodes=size(CBD_Graph.Nodes,1);
node_array=str2num(cell2mat(table2array(CBD_Graph.Nodes))); %str2double converts to a single value
desired_path=zeros(100,2);
for i=1:size(Schedule,1)
    random_pair=randi([1,num_nodes],[2,1]);
    % if they are the same, regenerate another pair
    while random_pair(1)==random_pair(2)
        random_pair=randi([1,num_nodes],[2,1]);
    end
    desired_path(i,:)=node_array(random_pair);
    % This generates random connections in the node array, agnostic of
    % valid, direct connections.
    
    % Therefore, if no direct connections, there will be a route by A*
end

% Aircraft.position=vertcat(prev_pos,curr_pos);
% Aircraft.heading=theta;
% Aircraft.x_dot=V*cosd(theta);
% Aircraft.y_dot=V*sind(theta);
% Aircraft.theta_dot=tand((y2-y1/(x2-x1)));
% Aircraft.delta_t=1; %1 sec prediction and update

end