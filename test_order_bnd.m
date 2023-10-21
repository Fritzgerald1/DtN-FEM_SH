addpath("import\");
addpath("plot\");
%% 几何参数
L=1.5*10^(-2);
W=1*10^(-3);
h=1;
b = W/2;
%% 网格节点坐标
fileName = 'pipe';
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

refPoint = [0;-2*W/b];
bnd_401_O = order_bnd(refPoint,Coordinate, bnd_401);
bnd_501_O = order_bnd(refPoint,Coordinate, bnd_501);
