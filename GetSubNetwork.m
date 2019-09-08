function [subnetwork]=GetSubNetwork(nodes,NetworkExport)

% G is a graph that contains the network connections and their weight.
% Compare the element in the node array to the elems in the first column of
% G to find indices where this node exist in the graph.
 growing_path=cell([1,1]);
 node_pair=[0,0];
 path=cell([size(NetworkExport),1]);
 for i=1:size(NetworkExport,2)
    validDepNodeID(i)=NetworkExport(i).DepNodeId;
    validArrNodeID(i)=NetworkExport(i).ArrNodeId;
    path(i)=mat2cell(getfield(NetworkExport(i),'Path'),size(NetworkExport(i).Path,1),size(NetworkExport(i).Path,2));
 end
 
 for i=1:length(nodes)
     % In this nodes(elem), compare to all nodes in the graph.
     idx=find(validDepNodeID==nodes(i));
     idx2=[];
     for j=1:length(nodes)
        idx2_temp=find(validArrNodeID(idx)==nodes(j));
        % Then, using these indices, find all elems of nodes in second
        % column of G. There should be no self connections at this point.
        % This function does not protect against self-connections.
        idx2=[idx2 idx2_temp];
     end
     % Construct a temp cell array to hold the values
     temp_paths=path(idx(idx2));
     % concatentate the paths with the growing array
     growing_path=vertcat(growing_path,temp_paths');
     % Extract the start and end nodes
     temp_array=[validDepNodeID(idx(idx2))',validArrNodeID(idx(idx2))'];
     node_pair=vertcat(node_pair,temp_array);
 end
 % Remove the padded values 
 node_pair=node_pair([2:end],:);
 growing_path=growing_path(2:end);
 DepNodeLoc=zeros(length(node_pair),2);
 ArrNodeLoc=zeros(length(node_pair),2);
 for i=1:length(growing_path)
     slice=cell2mat(growing_path(i));
     DepNodeLoc(i,:)=slice(1,:);
     ArrNodeLoc(i,:)=slice(end,:);
     
 end
 % Pass out the values as a struct
 test=table();
 test.DepNode=node_pair(:,1);
 test.ArrNode=node_pair(:,2);
 test.DepNodeLoc=DepNodeLoc;
 test.ArrNodeLoc=ArrNodeLoc;
 test.Path=growing_path;
 subnetwork=table2struct(test);
end