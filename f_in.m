function F_in = f_in(nBnd, Coordinate,  wd, kd, mode_in, Amp,  NormDirection )
% 输入：
%	NormDirection=左侧(-1) ; 右侧(1)
% NormDirection = 1;
% nBnd = nRight;
% Amp = Amp_normalized;
propagationDirection = 1;
n=8;
[xGauss,wGauss]=gauss_integration(n);
F_in = zeros(length(nBnd),1);


%% 边界单元累加
for ielement = 1:(length(nBnd)-1)/2
	iNode = nBnd(2*ielement-1:2*ielement+1)';
	iCoordinate = Coordinate(iNode,:);
	dCoordinate = diff(iCoordinate);
% 	dx(1) = sum(dCoordinate(:,1))/dL;
% 	dx(2) = sum(dCoordinate(:,2))/dW;
	dx  =[0 -1];

	dx = dx*NormDirection;

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
		[~,iuMode] = SH_u_t(mode_in, Amp,wd,kd,ix,iy,propagationDirection);
		N = shape(NormDirection,ixGauss);
		Tin = iuMode(2)*dx(1)+iuMode(1)*dx(2);
		int_x = int_x+ iwGauss*Tin*N*qq;
	end
	if NormDirection == -1
% 		F_in(iNode) = F_in(iNode)+int_x([1 8 4]);
					F_in(2*ielement-1:2*ielement+1) = F_in(2*ielement-1:2*ielement+1)+ int_x([1 8 4]);
	end
	if NormDirection == 1
% 		F_in(iNode) = F_in(iNode)+int_x([2 6 3]);
					F_in(2*ielement-1:2*ielement+1) = F_in(2*ielement-1:2*ielement+1)+ int_x([2 6 3]);
	end
end