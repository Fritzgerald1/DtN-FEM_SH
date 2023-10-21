clear
%% .mphtxt的文件名
cd import\
fileName = 'pipe_simple'; %%
%% 子文件夹
addpath("mesh\");
%% 材料参数
MATERIAL.DENSITY=2.7*10^3;
MATERIAL.E = 69e9;
MATERIAL.NU = 0.33;
MATERIAL.LAMBDA = MATERIAL.NU*MATERIAL.E/(1-2*MATERIAL.NU)/(1+MATERIAL.NU);
MATERIAL.MU = MATERIAL.E/2/(1+MATERIAL.NU);
% MATERIAL.MU = 26.1e9;
MATERIAL.CT = sqrt(MATERIAL.MU/MATERIAL.DENSITY);
% %% 几何参数
% W=4.76e-3; % 板厚
% B = W/2; % 半板厚
%% 网格节点坐标
bnd = [ "bnd_left", "bnd_right","bnd_top", "bnd_bottom"]; % 标记出的边界，前缀为"bnd_"
[Nnode,Nelement,Coordinate,Ielement,n] = import_mesh(fileName,bnd);
%% 几何参数
W=Coordinate(n.left(end),2)-Coordinate(n.left(1),2); % 板厚
B = W/2;
%% 坐标归一化
Coordinate = Coordinate/B;
%% 刚度矩阵
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,MATERIAL,B );
%% 保存为.mat
save([pwd, '\mesh\', fileName, '.mat'])