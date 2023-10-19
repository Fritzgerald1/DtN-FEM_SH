function int_x = gauss_integration_Fun(n, Fun1, Fun2, X)
% 通过高斯积分,计算Fun1和Fun2的内积
% 	int_x = Gauss_intergration(n, Fun1, Fun2, X)
% 输入:
% 	n = 积分阶次;
% 	Fun1,Fun2 = 被积函数;
% 	X = [积分下限, 积分上限];

rs = diff(X); % 积分域长度
qq = rs/2;

xt = @(t) (sum(X)+t*(diff(X)))/2;

[Gauss,wGauss]=gauss_integration(n);
int_x = zeros(size(Fun1(0)*Fun2(0)));

for intPoint = 1:n
	iGauss = Gauss(intPoint);
	iwGauss = wGauss(intPoint);

	it = xt(iGauss);

	iFun1 = Fun1(it);
	iFun2 =Fun2(it);

	int_x = int_x + iwGauss*iFun1*iFun2*qq;
end