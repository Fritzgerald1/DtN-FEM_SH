function [error,varargout] = SH(kd,wd,~,mu,density,h)
%% 材料属性
CT = sqrt(mu/density)/1e3; 
%% 量纲还原
k = kd/h;
w = wd*CT/h;
% k = kd;
% w = wd;
% h = 1;
q = sqrt((w/CT)^2-k^2);
%% 频散方程
% M(1,1) = cos(q*h);
% M(1,2) = sin(q*h);
% M(2,1) = cos(-q*h);
% M(2,2) = sin(-q*h);
% 
M(1,1) = exp(1i*q*h);
M(1,2) = -exp(-1i*q*h);
M(2,1) = exp(-1i*q*h);
M(2,2) = -exp(1i*q*h);

error = det(M);

if nargout == 2
	flag=1;
% 	if abs(KL)<1e-1,	flag=0;	end
% 	if abs(KT)<1e-1,	flag=0;	end
	varargout{1} = flag;
end

if nargout == 3
	flag=1;
	varargout{1}=flag;

	M(1,:) = 0;
	M(1,1) = 1;
	[L,U] = lu(M);
	z = [1;0];
	V = U\(L\z);
	varargout{2} = V;
end
