function F = matrix_F(nBnd, Coordinate, wd, kd, modes, Amp, MATERIAL, NormDirection)
% 输入：
%	NormDirection=左侧(-1) ; 右侧(1)
propagationDirection = 1;
n=8;
[xGauss,wGauss]=gauss_integration(n);
F = zeros(modes,length(nBnd));

for i1 = 1:modes
	ik = kd(i1);
	iAmp = Amp(:,i1);
	uMode = @(x2) SH_u_t(iAmp,wd,ik,0,x2,MATERIAL,propagationDirection);
	%% 边界单元累加
	for ielement = 1:(length(nBnd)-1)/2
		iNode = nBnd(2*ielement-1:2*ielement+1)';
		iCoordinate = Coordinate(iNode,:);
		iCoordinate(:,1) = 0; %%
		rs = sqrt((iCoordinate(3,1)-iCoordinate(1,1))^2+(iCoordinate(3,2)-iCoordinate(1,2))^2);
		qq = rs/2;
		yt = @(t) (iCoordinate(3,2)+iCoordinate(1,2)+t*(iCoordinate(3,2)-iCoordinate(1,2)))/2;
		xt = @(t) (iCoordinate(3,1)+iCoordinate(1,1)+t*(iCoordinate(3,1)-iCoordinate(1,1)))/2;
		int_x = zeros(8,1);
		%% 高斯积分
		for intPoint = 1:n
			ixGauss = xGauss(intPoint);
			iwGauss = wGauss(intPoint);
			ix = xt(ixGauss);
			iy = yt(ixGauss);
			iuMode = uMode(iy);
			N = shape(NormDirection,ixGauss);
			int_x = int_x+ 1i*ik*iwGauss*iuMode*N*qq;
		end
		if NormDirection == -1
			F(i1,2*ielement-1:2*ielement+1) = F(i1,2*ielement-1:2*ielement+1)+ int_x([1 8 4])';
		end
		if NormDirection == 1
			F(i1,2*ielement-1:2*ielement+1) = F(i1,2*ielement-1:2*ielement+1)+ int_x([2 6 3])';
		end
	end
end