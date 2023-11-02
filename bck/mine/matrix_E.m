function E = matrix_E(nBnd, Coordinate, k, propagationDirection)
% 输入：
%	propagation=向左传(-1) ; 向右传(1)
iCoordinate = Coordinate(nBnd,:);
x1 = iCoordinate(1,1);
E_diag = exp(propagationDirection*1i*k*x1);
E = diag(E_diag);
end