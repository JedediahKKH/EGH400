clc; clear all; close all;
%% EGH 400 Network Data
% Load the MATLAB Data
load 'NetworkExample-C.mat';
% This produces a 1x2680x5 struct containing:
% 1. DepNodeId  -> Current Node
% 2. ArrNodeId  -> Next Node to Visit (Valid Connection)
% 3. DepNodeLoc -> (Lat, Long) of DepNode
% 4. ArrNodeLoc -> (Lat, Long) of ArrNode
% 5. Path       -> Path of NodeLocs to visit 

% Memory Preallocation
s=zeros(1,size(NetworkExport,2));
t=zeros(1,size(NetworkExport,2));

s(1)=NetworkExport(1).DepNodeId;
t(1)=NetworkExport(1).ArrNodeId;
DepNodeLoc(1,:)=NetworkExport(1).DepNodeLoc;
for k=2:size(NetworkExport,2)
    % Extract All Nodes
    s(k)=NetworkExport(k).DepNodeId;
    t(k)=NetworkExport(k).ArrNodeId;
    DepNodeLoc(k,:)=NetworkExport(k).DepNodeLoc;  

    % Check if connection is unique
    
    for i=1:k
        % if new slice is the same as any other previous slice, replace
        % with NaN
        if [s(k) t(k)]==[t(i) s(i)]
            s(k)=NaN;
            t(k)=NaN;
        end

    end
end


% Extract valid paths
validIdx=find(isnan(s)==0);
% Construct a cell object as big as the number of unique connections
path=cell(size(validIdx,2),1);

% Extract the path data from the stuct and paste into the cell obj
for k=1:length(validIdx)
    path(k)=mat2cell(getfield(NetworkExport(validIdx(k)),'Path'),size(NetworkExport(validIdx(k)).Path,1),size(NetworkExport(validIdx(k)).Path,2));
end
PATH_LAT=[];
PATH_LONG=[];
% Extract the lat and lon data from the path to pass into drawline
for k=1:length(path)
   % For every entry in path:
   local_x=[];
   local_y=[];
   temp=[];
   % Extract the path data (long, lat)
   temp=cell2mat(path(k));
   local_x=temp(:,1)';
   local_y=temp(:,2)';
   PATH_LAT=[PATH_LAT, local_y];
   PATH_LONG=[PATH_LONG, local_x];
end

% Remove all NaNs
s=s(~isnan(s));
t=t(~isnan(t));

% Make a Unique Node Table
DepNodeLoc=unique(DepNodeLoc(:,[1 2]),'rows');

for r=1:size(DepNodeLoc,1)
    nodeName(r)={num2str(r)};
end

weights=ones(1,length(s));
G=graph(s,t,weights,'OmitSelfLoops'); % how to remove duplicate edges?
G.Nodes.Names=nodeName';
p=plot(G,'NodeLabel',G.Nodes.Names);
p.Marker='s';
p.NodeColor='r';
p.MarkerSize=5;
% For every unique dep node, place its loc value into the index

p.XData=DepNodeLoc(:,1);
p.YData=DepNodeLoc(:,2);
title('Plot of Node and Edges in Lat/Lon (2D)')

% Save all latitudes into a Lat Vector
LAT=p.YData;
% Save all longitudes into a Long Vector
LONG=p.XData;
% Save all the points name?
NAME=G.Nodes.Names;
% Export the points into a KML file in a while loop to continuously update
% the file in the KMLReader

kmlwritepoint('EGH_400_Test_KML',LAT,LONG,'Name',NAME)
kmlwriteline('EGH_400_Test_KML',PATH_LAT,PATH_LONG,'Color','g')

%% Get SubNetwork
nodes = [179 190 217 200 202];
CBD_SubNetwork = GetSubNetwork(nodes,NetworkExport(validIdx));

% Make a graph of CBD
CBD_s=CBD_SubNetwork(1).DepNode;
CBD_t=CBD_SubNetwork(1).ArrNode;
CBD_DepNodeLoc(1,:)=CBD_SubNetwork(1).DepNodeLoc;
for i=2:length(CBD_SubNetwork)
   CBD_s(i)=CBD_SubNetwork(i).DepNode;
   CBD_t(i)=CBD_SubNetwork(i).ArrNode;
   CBD_DepNodeLoc(i,:)=CBD_SubNetwork(i).DepNodeLoc;
end

CBDPATH_LAT=[];
CBDPATH_LONG=[];
% Extract the lat and lon data from the path to pass into drawline
for k=1:length(CBD_SubNetwork)
   % For every entry in path:
   local_x=[];
   local_y=[];
   temp=[];
   % Extract the path data (long, lat)
   temp=CBD_SubNetwork(k).Path;
   local_x=temp(:,1)';
   local_y=temp(:,2)';
   CBDPATH_LAT=[CBDPATH_LAT, local_y];
   CBDPATH_LONG=[CBDPATH_LONG, local_x];
end
% unique CBD_DepNodeLoc?
CBD_DepNodeLoc_unique=unique(CBD_DepNodeLoc(:,[1 2]),'rows');
CBD_DepNode_unique=unique(CBD_s);
for k=1:length(nodes)
    CBD_nodeName(k)={num2str(nodes(k))};
end
CBD_weights=ones(1,length(CBD_s));
CBD_Graph=graph([1,1,2,2,2,3],[2,3,4,3,5,5],CBD_weights,'OmitSelfLoops');
CBD_Graph.Nodes.Name=CBD_nodeName';
% Output CBD Subnet to a separate KML file
CBD_LONG=[153.0060,153.0222,153.0330,153.0357,153.0465];
CBD_LAT=[-27.4535,-27.4670,-27.4487,-27.4589,-27.4859];
%CBD_NAME=cell([5,1]);
% for i=1:length(CBD_LAT)
%     CBD_NAME(i)=CBD_SubNetwork(i).DepNode;
%     
% end
CBD_NAME={'179','190','200','202','217'};
kmlwritepoint('EGH_400_CBD_Subnet',CBD_LAT,CBD_LONG,'Name',CBD_NAME)
kmlwriteline('EGH_400_CBD_Subnet',CBDPATH_LAT,CBDPATH_LONG,'Color','r','LineWidth',3)
%% Get Flight Schedules
Schedule=generateFlightRequest(); % input params as needed

%% Simulate Network
Parameters = GetSimParameters();
[UnmannedAircraft,Schedule] = InitUnmannedAircraft(Parameters,CBD_SubNetwork,CBD_Graph, Schedule);


