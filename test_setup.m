addpath("import\");
addpath("plot\");
%% 材料参数
density1=2.7*10^3;
density2=2.7*10^3;
mu1=26.1*10^9;
mu2=26.1*10^9;
%% 入射设置
nff = 10;
ff = linspace(2e6,4e6,nff);
% %{
nff = 1;
ff = 2e6;
%}
mode_in = 2;

cR = cell(nff,1);
cT = cell(nff,1);
%% 几何参数
L=1.5*10^(-2);
W=1*10^(-3);
h=1;
b = W/2;
%% 网格节点坐标
fileName = 'simple';
[Nnode, Nelement, Coordinate, Ielement,dL,dW] = read_mesh_info_CQUAD8([fileName '.dat']);
Coordinate = Coordinate/b;
%% 边界信息
fileNameMPHTXT = [fileName '.mphtxt'];
bnd_top = read_boudary_info(fileNameMPHTXT,"bnd_top");
bnd_bottom = read_boudary_info(fileNameMPHTXT,"bnd_bottom");
bnd_401 = read_boudary_info(fileNameMPHTXT,"bnd_left");
bnd_501 = read_boudary_info(fileNameMPHTXT,"bnd_right");

bnd_top_e = bound_element(Ielement, bnd_top);
bnd_bottom_e = bound_element(Ielement, bnd_bottom);
bnd_401_e = bound_element(Ielement, bnd_401);
bnd_501_e = bound_element(Ielement, bnd_501);

% 将边界节点排序
refPoint = [0;-2*W/b];
bnd_401 = order_bnd(refPoint,Coordinate, bnd_401);
bnd_501 = order_bnd(refPoint,Coordinate, bnd_501);
%% 缺陷定义
L_crack = 2*b;
W_crack = 0.2*b;
bnd_crack = crack_boundary(Coordinate,L_crack,W_crack,b);
% bnd_crack = tr_crack_boundary(Coordinate,L_crack,W_crack,b);
bnd_crack_e =  bound_element(Ielement, bnd_crack);
%% 刚度矩阵
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,mu1,mu2,h,density1,density2,b );

for iff = 1:nff
	f=ff(iff);
	Cf = 2*pi*f;

	Kg=(K-Cf^2*M)/mu1;
	Kg_o = Kg;
% 	Kg(bnd_crack,:) = 0;
% 	Kg(:,bnd_crack) = 0;

	% SH dispersion
	CT1 = sqrt(mu1/density1);
	CT2 = sqrt(mu2/density2);
	[ root,root_d,zamp_mode,Amp ] = SH_dispersion( mu1,mu2,density1,density2,f,b );

	L_nod_s = 0;
	L_nod_d = 0;
end