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
%% 几何参数
W=4.76e-3; % 板厚
B = W/2; % 半板厚
%% 网格节点坐标
fileName = 'pipe_simple';
[Nnode,Nelement,Coordinate,Ielement,dL,dW,n.left,n.mid,n.right, n.top, n.bottom] = import_mesh_pipe(fileName);
Coordinate = Coordinate/B;
dL = dL/B;
dW = dW/B;
%% 原网格节点坐标2
%{
load mesh_original
n.left = bnd_401;
n.right = bnd_501;
eLeft = bnd_401_e;
eRight = bnd_501_e;
n.crack = bnd_crack;
n.mid = 1:Nnode;
n.mid([n.left n.right])=[];
dL = dL/B;
dW = dW/B;
%}
%% 刚度矩阵
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,MATERIAL,B );