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
