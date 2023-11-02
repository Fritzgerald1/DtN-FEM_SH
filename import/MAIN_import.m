clear
%% .mphtxt的文件名
% 更改路径
if ~contains(pwd,'import')
	cd import\
end
fileName = 'defect' ; %%
%% 子文件夹
addpath("mesh\");
%% 材料参数
MATERIAL.DENSITY=2.7*10^3;
MATERIAL.E = 69e9;
MATERIAL.NU = 0.33;
MATERIAL.LAMBDA = MATERIAL.NU*MATERIAL.E/(1-2*MATERIAL.NU)/(1+MATERIAL.NU);
MATERIAL.MU = MATERIAL.E/2/(1+MATERIAL.NU);
MATERIAL.CL = sqrt((MATERIAL.LAMBDA+2*MATERIAL.MU)/MATERIAL.DENSITY);
MATERIAL.CT = sqrt(MATERIAL.MU/MATERIAL.DENSITY);
%% 网格节点坐标
bnd = ["bnd_left", "bnd_right"]; % 标记出的边界，前缀为"bnd_"
area = ["area_sampling","area_defect"]; % 标记出的域，前缀为"area_"
[Nnode,Nelement,Coordinate,Ielement,n, Coordinate_origin, n_origin, order] = import_mesh_MPHTXT(fileName,bnd,area);
%% 几何参数
W=Coordinate(n.left(end),2)-Coordinate(n.left(1),2); % 板厚
B = W/2;
%% 坐标归一化
Coordinate = Coordinate/B;
%% 刚度矩阵
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,MATERIAL,B );
%% 保存为.mat
save([pwd, '\mesh\', fileName, '.mat'])