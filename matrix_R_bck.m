function R = matrix_R(nBnd, Coordinate, Cf, k, modes, Amp, MATERIAL)
% 输入：
%	NormDirection=左侧(-1) ; 右侧(1)
propagationDirection = 1;
n=8;
[xGauss,wGauss]=gauss_integration(n);
R = zeros(modes,modes);

iCoordinate = Coordinate(nBnd,:);

for i1 = 1:modes
	ki = k(i1);
	Ampi = Amp(:,i1);
	uMode_i = @(x2) SH_u_t(Ampi,Cf,ki,0,x2,MATERIAL,propagationDirection);
	for j1 = 1:modes
		kj = k(j1);
		Ampj= Amp(:,j1);
		uMode_j = @(x2) SH_u_t(Ampj,Cf,kj,0,x2,MATERIAL,propagationDirection);
		%% 边界单元累加
		
		yt = @(t) (iCoordinate(end,2)+iCoordinate(1,2)+t*(iCoordinate(end,2)-iCoordinate(1,2)))/2;
		xt = @(t) (iCoordinate(end,1)+iCoordinate(1,1)+t*(iCoordinate(end,1)-iCoordinate(1,1)))/2;
		int_y = 0;
		%% 高斯积分
		for intPoint = 1:n
			ixGauss = xGauss(intPoint);
			iwGauss = wGauss(intPoint);
			ix = xt(ixGauss);
			iy = yt(ixGauss);
			int_y = int_y+ iwGauss*uMode_i(iy)*uMode_j(iy);
		end
		R(i1,j1) = R(i1,j1)+ int_y;
	end
end
end