function G = matrix_G(nBnd, Coordinate, wd, kd, modes, Amp, NormDirection)
% 输入：
%	NormDirection=左侧(-1) ; 右侧(1)
propagationDirection = 1;
n = 8;
G = zeros(modes,length(nBnd));

for i1 = 1:modes

	uMode = @(x2) SH_u_t(i1, Amp, wd, kd, 0, x2, propagationDirection);

	%% 边界单元累加
	for ielement = 1:(length(nBnd)-1)/2
		iNode = nBnd(2*ielement-1:2*ielement+1)';
		iCoordinate = Coordinate(iNode,:);

		X = iCoordinate([1 3],2); % 积分上下限
		N =@(x2) shape(NormDirection,(x2*2-sum(X))/diff(X));
		int_N_u_mode = gauss_integration_Fun(n, uMode, N, X); % 得到N和uMode的积分

		if NormDirection == -1
			G(i1,2*ielement-1:2*ielement+1) = G(i1,2*ielement-1:2*ielement+1)+ int_N_u_mode([1 8 4])';
		end
		if NormDirection == 1
			G(i1,2*ielement-1:2*ielement+1) = G(i1,2*ielement-1:2*ielement+1)+ int_N_u_mode([2 6 3])';
		end
	end
end