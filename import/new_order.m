function [Coordinate, Ielement, n, e] = new_order(Coordinate, Ielement, n, order)
% 按照新节点顺序order重新排列网格信息
%% 重排单元节点信息Ielement
Ielement_o = Ielement;
for i1 = 1:size(Ielement,1)
	for i2 = 1:size(Ielement,2)
		Ielement_o(i1,i2) = find(order==Ielement(i1,i2));
	end
end
Ielement = Ielement_o;
%% 重排节点标识n
fieldName = fieldnames(n);
for ii = 1:length(fieldName)
	iField = fieldName{ii};
	new_node_number = sort_order(n.(iField), order);
	n.(iField) = new_node_number;
	e.(iField) = bound_element(Ielement, new_node_number)';
end
%% 重排节点坐标
Coordinate = Coordinate(order,:);
end

function number = sort_order(oldNum, order)
% 按照新节点顺序order重排节点编号oldNum
number = zeros(length(oldNum),1);
for i = 1:length(oldNum)
	number(i) = find(oldNum(i) == order);
end
end