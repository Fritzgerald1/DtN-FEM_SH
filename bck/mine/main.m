% clear;
addpath("import\");
addpath("plot\");
addpath("SH\");
addpath("import\mesh\")
% 	run import\MAIN_import.m
load simple.mat
%% 入射设置

% for mode_in = 1

mode_in = 2; % 入射模态
cutoff = [0.10, 1.5708, 3.1416, 4.7124, 6.2843, 7.85399]; % SH波截止频率(无量纲频率)
dw =0.25; % 采样间隔
wwd = cutoff(mode_in):dw:8; % 扫频采样点(无量纲频率)
nff = length(wwd);
% %{
wwd = 2; % 扫频采样点(无量纲频率)
nff = length(wwd);
%}
%% 散射系数
cR = cell(nff,1); cT = cell(nff,1);
eng_tot = zeros(nff,1);
%% 扫频
for iff = 1:nff
	wd = wwd(iff);
	Cf = wd*MATERIAL.CT/B; % 圆频率
	%% 动力刚度矩阵
	D=(K-Cf^2*M)/MATERIAL.MU;
	%% 频散方程
	[kd,  Amp_normalized, modes]= sh_wave_dispersion(wd, MATERIAL, B); % SH频散方程
	k = kd/B;

	%% 各子矩阵
	% R = <i阶模态位移, j阶模态位移>
	R = matrix_R(wd, kd, Amp_normalized, modes);

	% G = <模态位移, N>
	G.L = matrix_G(n.left, Coordinate, wd, kd, modes, Amp_normalized,-1);
	% 	G.R = matrix_G(n.right, Coordinate, wd, kd, modes, Amp_normalized,1);
	G.R = G.L;

	% E  = exp(i*kd*x1)
	E.L.plus = eye(modes,modes);
	E.L.minus = eye(modes,modes);
	E.R.plus = eye(modes,modes);
	%{
	E.L.plus = matrix_E(n.left, Coordinate, kd, 1);
	E.L.minus = matrix_E(n.left, Coordinate, kd, -1);
	E.R.plus = matrix_E(n.right, Coordinate, kd, 1);

	G.L = E.L.plus*G.L;
	G.R = E.R.plus*G.R;
	%}

	% Ki = i*kd
	Ki.plus = 1i*diag(kd);
	Ki.minus = 1i*diag(kd);

	% t = Dt*u
	% 	Dt.L = transpose(G.L)*E.L.minus*Ki.minus/R/E.L.minus*G.L;
	Dt.L = transpose(G.L)*Ki.minus/R*G.L;

	% 	Dt.R =  transpose(G.R)*E.L.plus*Ki.plus/R/E.L.plus*G.R;
	Dt.R =  transpose(G.R)*Ki.plus/R*G.R;
	%% 等式左端
	D_hat = D;
	D_hat(n.left,n.left) = D_hat(n.left,n.left)- Dt.L;
	D_hat(n.right,n.right) = D_hat(n.right,n.right)- Dt.R;
	%% 入射场(左边界)
	U.in = zeros(Nnode,1);

	% for ii =1:Nnode
	% 			iNode = ii;
	% 		[ U.in(iNode),~] = SH_u_t(mode_in, Amp_normalized, wd, kd, Coordinate(iNode,1),Coordinate(iNode,2), 1);
	% end

	for ii = 1:length(n.left)
		iNode = n.left(ii);
		[ U.in(iNode),~] = SH_u_t(mode_in, Amp_normalized, wd, kd, Coordinate(iNode,1),Coordinate(iNode,2), 1);
	end
	%% 等式右端
	F_in = zeros(Nnode,1);
	F_in_L =  f_in(n.left, Coordinate, wd, kd, mode_in, Amp_normalized,  -1);
	F_in(n.left) = -F_in_L;
	% 	F_in_R =  f_in(n.right, Coordinate, wd, kd, mode_in, Amp_normalized,  1);
	% 	F_in(n.right) = -F_in_R;

	F_e = F_in - D*U.in;
	F_hat = sparse(F_e);
	%% 散射场
	U.sc = D_hat\F_hat;
	%% 总场位移
	U.tot = U.sc + U.in;
	%% 散射系数
	[Tr, Re, c_in, eng_T, eng_R] = coefficient_energy(E, R, G, U, n, wd, kd, Amp_normalized, modes, mode_in);
	eng_tot (iff) = sum(eng_T+eng_R); % 总能量
% eng_tot(num) = sum(eng_T+eng_R);
% 	cT(iff,mode_in) = Tr(mode_in);	cR(iff,mode_in) = Re(mode_in);
% 	cR(1:2,num) = Re;
	cR{iff} = Re;	cT{iff} = Tr;
end
% 	ff{mode_in} = (wwd)';

%% 绘制频率-反射系数图
if ~(nff==1)
	if contains(fileName,'pipe')
% 		open plot\draw_coff.mlx
	else
% 		open plot\draw_coff_straight.mlx
	end
end
