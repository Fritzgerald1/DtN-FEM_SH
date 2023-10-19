clear;
tic %开始记录命令执行时间
% FEM SH wave %
% Input %
% density:matterial parameter %
% h:unit length of x3 direction %
% mu:shear modulus %
% Cf:cicular frequency %
density1=2.7*10^3;  %上层密度
density2=7.8*10^3;  %下层密度
mu1=26.1*10^9;  %上层的mu
mu2=79*10^9;    %下层的mu
h=1; %板的半高度
he = 0.5*10^(-3); %无量纲化
f=2.0*10^6; %激发频率
Cf = 2*pi*f; %角频率
mode_in = 2;
L=1.5*10^(-2);  %截取板的长度
W=1*10^(-3);    %板的宽度
dL=L/600; %长度切分600份
dW=W/20; %宽度切分20份
% Element settings %
% L:length of Plate, W:width of Plate %
% dL:length of element, dW:width of element %
% Nelement: number of elements, Nnode:number of Nodes %
% Ielement: Index of every nodes in local element %
L_crack = W; %缺陷信息赋值给L_crack 长为1mm
A = dL*dW; %一个单元的面积
Nelement=round(L/dL*W/dW); %四舍五入计算单元的数量
Nelement_crack = round(L_crack/dL);%缺陷单元的数量 1mm有40个单元，0-79个节点；
Nnode_crack = 2*Nelement_crack-1;%计算缺陷节点数量   缺陷就是一条线 有两层从-0.5到0.5mm
Nnode=round((2*L/dL+1)*(2*W/dW+1)+Nnode_crack-fix((2*W/dW+1)/2)*L/dL); % crack area added nodes  %一个单元8个节点，中间是中空的所以要剪掉12000个点（包括缺陷处节点）

% Node settings %
% Coordinate: coordinate of nodes %
[ Coordinate ] = Node_setting( Nnode,Nnode_crack,L_crack,L,dL,dW  ); %设定坐标

L_ele = round(L/dL); %600个横轴节点
L_nod_s = 2*L_ele+1;    %1201
L_nod_d = L_ele+1;  %601
[ bnd_401_e,bnd_501_e,bnd_101_e,bnd_401,bnd_501,bnd_101,Ielement ] = Ele_indx_and_bnd( L_ele,L_nod_s,L_nod_d,Nelement,Nelement_crack,Nnode,Nnode_crack);
Coordinate = Coordinate/he; %这里做了一个归一化

% Stiffness matrix %
% ngq:integration points, total integration points is 8*8 %
% xgq:si or ti, wgq:wi or wj %
% K: global stiffness matrix %
% M: global mass matrix %
% Ke: local stiffness matrix, Me: local Mass matrix % 
[ K,M ] = Stiffness_Mass_matrix( Nnode,Nelement,Ielement,Coordinate,mu1,mu2,h,density1,density2,he );
Kg=(K-Cf^2*M)/mu1;
% SH dispersion 
CT1 = sqrt(mu1/density1);
CT2 = sqrt(mu2/density2);
[ root,root_d,zamp_mode,Amp ] = SH_dispersion( mu1,mu2,density1,density2,f,he );

% Traction_Known_R (-t_101_in)
[ F ] = Traction_Known_R_tsc_only( Nnode,Nelement,Nelement_crack,L_ele,f,Coordinate,Ielement,bnd_101_e,CT1,CT2,he,root,Amp,mode_in,mu1,mu2,dW,dL );

% UnKnown Traction (left hand side)
[ Kg,zint_inv,zint_amp_mode  ] = Traction_scatter_401_501( bnd_401,bnd_501,bnd_401_e,bnd_501_e,root,f,CT1,CT2,he,mu1,mu2,Coordinate,Ielement,dW,Amp,Kg );

U_sc = Kg\F;

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
[ Re,Tr,eng_R,eng_T,zbeta_R,zbeta_T ] = Co_Eng_RaT( n_mode_max,mode_in,bnd_401_e,bnd_501_e,Coordinate,Ielement,root,f,CT1,CT2,mu1,mu2,he,dW,Amp,zint_inv,U_sc );
%Re反射系数 Tr透射系数 eng r t能量
toc %结束命令执行时间

%%
% kth1 = 2*pi*f/CT1*he;
%kth2 = 2*pi*f/CT2*he;

%count = 0;
%for j=1:1201
%    sum = 0;
%    count=count+1;
%    for i = 1:size(root,2)
%        if j <= 601
%            [ z_um,zderiv_um ] = SH_mode(i,Amp,1,kth1,kth2,root(1,i),Coordinate(j,1),Coordinate(j,2),-1,0);
%            sum = sum+zbeta_R(i,1)*z_um;
%        else
%            [ z_um,zderiv_um ] = SH_mode(i,Amp,1,kth1,kth2,root(1,i),Coordinate(j,1),Coordinate(j,2),1,0);
%            sum = sum+zbeta_T(i,1)*z_um;
%        end
%    end
%    A_store(count,1)=U_sc(j,1)/sum;
%end
%count=0;
%for j=36041:37241
%    sum = 0;
%    count=count+1;
%    for i = 1:size(root,2)
%        if j <= 36641
%            [ z_um,zderiv_um ] = SH_mode(i,Amp,2,kth1,kth2,root(1,i),Coordinate(j,1),Coordinate(j,2),-1,0);
%            sum = sum+zbeta_R(i,1)*z_um;
%        else
%            [ z_um,zderiv_um ] = SH_mode(i,Amp,2,kth1,kth2,root(1,i),Coordinate(j,1),Coordinate(j,2),1,0);
%            sum = sum+zbeta_T(i,1)*z_um;
%        end
%    end
%    B_store(count,1)=U_sc(j,1)/sum;
%end
%plot(Coordinate(1:1201,1),abs(A_store),Coordinate(36041:37241,1),abs(B_store));
%legend('ti-s-Bot','ti-s-Top');
%[X,Y] = meshgrid(-15:0.005:15,-1:0.01:1);
%Z=griddata(Coordinate(:,1),Coordinate(:,2),real(full(U_sc(:,1))),X,Y);
%mesh(X,Y,Z)
%%
