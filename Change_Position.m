function [Coordinate_changed, Ielement_changed] = Change_Position(Coordinate,Ielement, order)
Coordinate_changed = Coordinate(order,:);

Ielement_o = Ielement;
for i1 = 1:size(Ielement,1)
	for i2 = 1:size(Ielement,2)
		Ielement_o(i1,i2) = find(order==Ielement(i1,i2));
	end
end
Ielement_changed = Ielement_o;
end