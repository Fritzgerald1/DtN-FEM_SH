function [ u,u_deriv ] = SH_u_t(mode, Amp,wd, kd, x1, x2, i_pm)
% SH_MODE 此处显示有关此函数的摘要
% [ u,u_deriv ] = SH_u_t(mode, Amp,w,k,x1,x2,i_pm)
% 输入：
%		i_pm = 1(positive direction), -1(negative direction)
% 输出：
%	u = 模态位移；
%	u_deriv = 模态位移偏导；
% 说明：

iAmp = Amp(:,mode);
ikd = kd(mode);

q = sqrt(wd^2-ikd^2);

u_harmonic = iAmp(1)*exp(1i*q*x2) + iAmp(2)*exp(-1i*q*x2) ;
u = u_harmonic*exp(i_pm*1i*ikd*x1);

u_deriv_harmonic(1,1)=i_pm*1i*ikd*u_harmonic;  % t13
u_deriv_harmonic(2,1)=1i*q*iAmp(1)*exp(1i*q*x2) -1i*q*iAmp(2)*exp(-1i*q*x2); % t23

u_deriv = u_deriv_harmonic.*exp(i_pm*1i*ikd*x1);
end