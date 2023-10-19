function [Nnode,Nelement,Coordinate,Ielement,dL,dW,nLeft,nMid,nRight] = import_mesh(fileName,b)

[Nnode, Nelement, Coordinate, Ielement,dL,dW] = read_mesh_info_CQUAD8([fileName '.dat']);
% Coordinate = Coordinate/b;
%% 边界信息
fileNameMPHTXT = [fileName '.mphtxt'];
nLeft = read_boudary_info(fileNameMPHTXT,"bnd_left");
nRight = read_boudary_info(fileNameMPHTXT,"bnd_right");
nMid = 1:Nnode;
nMid([nLeft;nRight])=[]; % 中间边界节点的行号

% 边界单元
% %{
% bnd_top_e = bound_element(Ielement, bnd_top);
% bnd_bottom_e = bound_element(Ielement, bnd_bottom);
% eLeft = bound_element(Ielement, nLeft);
% eRight = bound_element(Ielement, nRight);
%}

% 将边界节点排序
refPoint = [0;-2*b];
nLeft = order_bnd(refPoint,Coordinate, nLeft);
nRight = order_bnd(refPoint,Coordinate, nRight);
 % 节点编号重排（左边界-中间-右边界）
[Coordinate, Ielement, nLeft, nMid, nRight] = change_node_order(Coordinate,Ielement, nLeft,nMid,nRight);
%% 缺陷定义
% L_crack = 2*b;
% W_crack = 0.2*b;
% % nCrack = crack_boundary(Coordinate,L_crack,W_crack,b);
% nCrack = tr_crack_boundary(Coordinate,L_crack,W_crack,b);
% % eCrack =  bound_element(Ielement, nCrack);