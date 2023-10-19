function [Coordinate_changed, Ielement_changed,  nLeft, nMid, nRight] = change_node_order(Coordinate,Ielement, nLeft,nMid,nRight)

order = [nLeft,nMid,nRight];
Coordinate_changed = Coordinate(order,:);

Ielement_o = Ielement;
for i1 = 1:size(Ielement,1)
	for i2 = 1:size(Ielement,2)
		Ielement_o(i1,i2) = find(order==Ielement(i1,i2));
	end
end
Ielement_changed = Ielement_o;

iNode = 1:length(order);
nLeft = iNode(1:length(nLeft));
nMid = iNode(length(nLeft)+1:end-length(nRight));
nRight =iNode(end-length(nRight)+1:end);
end