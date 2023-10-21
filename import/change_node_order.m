function [Coordinate_changed, Ielement_changed,  nLeft, nMid, nRight] = change_node_order(Coordinate,Ielement, nLeft,nRight, nCentroid)

% narginchk(4,4+1); % 验证可变输出参数数目为0个或1个
% if nargin == 4+1
% 	nCentroid = varargin{1}; % 形心的节点编号
% else
% 	nCentroid = [];
% end

nMid = 1:length(Coordinate);
nMid([nLeft, nRight, nCentroid])=[]; % 中间边界节点的行号

order = [nLeft,nMid,nRight, nCentroid];

Coordinate_changed = Coordinate(order,:);

Ielement_o = Ielement;
for i1 = 1:size(Ielement,1)
	for i2 = 1:size(Ielement,2)
		Ielement_o(i1,i2) = find(order==Ielement(i1,i2));
	end
end
Ielement_changed = Ielement_o;

iNode = 1:length(order)-length(nCentroid);
nLeft = iNode(1:length(nLeft));
nMid = iNode(length(nLeft)+1:end-length(nRight));
nRight =iNode(end-length(nRight)+1:end);

Coordinate_changed = Coordinate_changed(iNode,:);
end