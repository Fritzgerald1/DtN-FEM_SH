function bnd_order = order_bnd(refPoint,Coordinate, bnd)
% 参考点
refX = refPoint(1);
refY = refPoint(2);
% 边界点
bndX = Coordinate(bnd,1);
bndY = Coordinate(bnd,2);
% 距离
distance = (bndX-refX).^2+(bndY-refY).^2;
[~, order] = sort(distance);
bnd_order = bnd(order);
end