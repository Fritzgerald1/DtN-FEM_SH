clc;
clear;
%% 子文件夹
addpath("import\");
addpath("plot\")
%% 材料参数
density1 = 2.7*10^3;
density2 = 2.7*10^3;
mu1 = 26.1*10^9;
mu2 = 26.1*10^9;
%% 入射波设置
nff = 30;
ff = linspace(.5e6,4e6,nff);
nff = 1;
ff = 3e6;

mode_in = 2;
cR = cell(nff,1);
cT = cell(nff,1);
%% 几何网格参数
L=1.5*10^(-2);
W=1*10^(-3);

h=1;
b = W/2;
dL=L/80;
dW=W/20;

L_crack = 0;
A = dL*dW;
Nelement=round(L/dL*W/dW);
Nelement_crack = round(L_crack/dL);
% Nnode_crack = 2*Nelement_crack-1;
Nnode_crack = 0;
Nnode=round((2*L/dL+1)*(2*W/dW+1)+Nnode_crack-fix((2*W/dW+1)/2)*L/dL); % crack area added nodes
%% 节点信息设置
[ Coordinate ] = Node_setting( Nnode,Nnode_crack,L_crack,L,dL,dW  );
Coordinate = Coordinate/b; % 坐标归一化
%% 单元/边界信息设置
L_ele = round(L/dL);
L_nod_s = 2*L_ele+1;
L_nod_d = L_ele+1;
[ bnd_401_e,bnd_501_e,bnd_101_e,bnd_401,bnd_501,bnd_101,Ielement ] = Ele_indx_and_bnd( L_ele,L_nod_s,L_nod_d,Nelement,Nelement_crack,Nnode,Nnode_crack);
%% 缺陷设置
L_crack = 1e-3;
W_crack = 0.1e-3;
bnd_crack = crack_boundary(Coordinate,L_crack,W_crack,b);
% bnd_crack_e =  bound_element(Ielement, bnd_crack);
%% 刚度矩阵
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,mu1,mu2,h,density1,density2,b );

for iff = 1:nff
	f=ff(iff);
	Cf = 2*pi*f;

	Kg=(K-Cf^2*M)/mu1;
	Kg_o = Kg;
% 		Kg(bnd_crack,:) = 0;
% 		Kg(:,bnd_crack) = 0;

	% SH dispersion
	CT1 = sqrt(mu1/density1);
	CT2 = sqrt(mu2/density2);
	[ root,root_d,zamp_mode,Amp ] = SH_dispersion( mu1,mu2,density1,density2,f,b );

	% Traction_Known_R (-Kg*U_in+t_401_in+t_501_in)
	[ F,U_in ] = Traction_Known_R( Nnode,mode_in,f,CT1,CT2,b,Coordinate,Ielement,root,Kg,W,dW,dL,L_nod_s,L_nod_d,Amp,bnd_401_e,bnd_501_e,mu1,mu2 );

	% UnKnown Traction (left hand side)
	[ Kg,zint_inv ] = Traction_scatter_401_501( bnd_401,bnd_501,bnd_401_e,bnd_501_e,root,f,CT1,CT2,b,mu1,mu2,Coordinate,Ielement,dW,Amp,Kg );

	U_sc = Kg\F;
	U_tot = U_sc+U_in;

	for i = 1:size(bnd_401,2)
		indx_n = bnd_401(1,i);
		Usc_401(i,1)= U_sc(indx_n,1);
	end

	for i = 1:size(bnd_501,2)
		indx_n = bnd_501(1,i);
		Usc_501(i,1)= U_sc(indx_n,1);
	end

	% Re,Tr,eng_R,eng_T
	n_mode_max = size(root,2);
	[ Re,Tr,eng_R,eng_T ] = Co_Eng_RaT( n_mode_max,mode_in,bnd_401_e,bnd_501_e,Coordinate,Ielement,root,f,CT1,CT2,mu1,mu2,b,dW,Amp,zint_inv,U_sc );

	cR{iff} = Re;
	cT{iff} = Tr;
end

% open draw_coff.mlx
