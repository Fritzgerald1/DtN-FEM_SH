function [Re, Tr, U, eng, kd] =dtn_fem_sh(matName, wd, mode_in)
% [Re, Tr, U, eng] =dtn_fem_sh(matName, wd, mode_in)
%
% 输入:
%	matName = .mat的文件名; {string}
%	wd = 无量纲频率; {double}
%	mode_in = 入射模态; {double}
% 输出:
%	Re = 反射系数, Tr = 透射系数; {double} [mode*1]
%	U = 位移场{struct};
%	eng = 能量{struct};
%% 
load(matName); % 读取网格信息
Cf = wd*MATERIAL.CT/B; % 圆频率
D=(K-Cf^2*M)/MATERIAL.MU; % 动力刚度矩阵
[kd,  Amp, Amp_normalized, modes]= sh_wave_dispersion(wd, MATERIAL, B); % SH频散方程
%% 各子矩阵
% R = <i阶模态位移, j阶模态位移>
R = matrix_R(wd, kd, Amp_normalized, modes);
% G = <模态位移, N>
G.L = matrix_G(n.left, Coordinate, wd, kd, modes, Amp_normalized,-1);
G.R = G.L;
% E
E.L.plus = eye(modes,modes);
E.L.minus = eye(modes,modes);
E.R.plus = eye(modes,modes);
% K
Ki.plus = 1i*diag(kd);
Ki.minus = 1i*diag(kd);
% DL, DR
Dt.L = transpose(G.L)*Ki.minus/R*G.L;
Dt.R =  transpose(G.R)*Ki.plus/R*G.R;
%% 等式左端
D_hat = D;
D_hat(n.left,n.left) = D_hat(n.left,n.left)- Dt.L;
D_hat(n.right,n.right) = D_hat(n.right,n.right)- Dt.R;
%% 入射场(左边界)
U.in = zeros(Nnode,1);
for ii = 1:length(n.left)
	iNode = n.left(ii);
	[ U.in(iNode),~] = SH_u_t(mode_in, Amp_normalized, wd, kd, Coordinate(iNode,1),Coordinate(iNode,2), 1);
end
%% 等式右端
F_in = zeros(Nnode,1);
F_in_L =  f_in(n.left, Coordinate, wd, kd, mode_in, Amp_normalized,  -1);
F_in(n.left) = -F_in_L;
F_e = F_in - D*U.in;
F_hat = sparse(F_e);
%% 散射场
U.sc = D_hat\F_hat;
%% 总场位移
U.tot = U.sc + U.in;
%% 散射系数
[Tr, Re, c_in, eng.tr, eng.re] = coefficient_energy(E, R, G, U, n, wd, kd, Amp_normalized, modes, mode_in);
eng.tot = sum(eng.tr+eng.re); % 总能量