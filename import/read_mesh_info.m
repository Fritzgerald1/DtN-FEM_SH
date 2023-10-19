function [nNode, nElement, Coordinate, Ielement, nodeCentroid,n] =read_mesh_info(mesh_info,bnd)
%% 节点总数
r = find_string_row("Mesh vertex coordinates",mesh_info);
r = r-3;
r_nNode = r;
nNode = str2double(mesh_info(r_nNode,1)); % 节点数
%% 节点信息
r = r+3;
r_Coordinate = r;
Coordinate = zeros(nNode,2);
for ii = 1:nNode
	Coordinate(ii,:) = str2num(mesh_info(r_Coordinate+ii,1)); %#ok<ST2NM>
end
%% 每个单元的节点数
r = find_string_row("5 quad2",mesh_info);
r = r+3;
r_nodePerElement = r;
nodePerElement = str2double(mesh_info(r_nodePerElement,1)); % 每个单元的节点数
% nodePerElement = nodePerElement_plus_one-1; % 每个单元的节点数
%% 单元总数
r = r+1;
r_nElement = r;
nElement = str2double(mesh_info(r_nElement,1)); % 单元数
%% 单元信息
r = r+1;
r_infoElement = r;
infoElement = zeros(nElement,nodePerElement);
infoElement(1,:) = str2num(mesh_info(r_infoElement+1,1)); %#ok<ST2NM>
for ii = 1:nElement
	infoElement(ii,:) = str2num(mesh_info(r_infoElement+ii,1)); %#ok<ST2NM>
end

% Ielement = infoElement(:,2:end);
infoElement = infoElement+1;
Ielement = infoElement;
if nodePerElement == 9
	Ielement(:,7) = [];	% 去掉第7列的单元编号（单元的形心节点）
	Ielement = Ielement(:,[1 2 4 3 5 7 8 6]); % 调整单元节点编号的顺序
	nodeCentroid = infoElement(:,7)';
% 	nCentroid = length(nodeCentroid);
	nNode = nNode - length(nodeCentroid);
else
	nodeCentroid = [];
end
%% 边界信息
for ii = 1:length(bnd)
	nameBnd = strrep(bnd(ii),"bnd_",'');
	nBnd = read_boudary_info(bnd(ii),mesh_info);
	n.(nameBnd) = nBnd;
end
end
%% 子函数
function row = find_string_row(tex_string,mesh_info)
%% 找到tex_string所在的行
a=strfind(mesh_info,tex_string);
ind = ~cellfun('isempty', a);
[row,~] = find(ind);
end
