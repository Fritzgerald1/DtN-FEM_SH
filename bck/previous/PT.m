nmode = length(root);
%% 左边界入射模态的节点位移/力
bnd = bnd_401;
bnd_e = bnd_401_e;
mode = mode_in;
P_inc = zeros(length(bnd_401),1);
T_inc = zeros(length(bnd_401),1);
P_inc =  u_mode(Nnode, CT1, f, he, root, Amp, mode, Coordinate, bnd);
T_inc = t_mode_l(Nnode, mode, bnd, bnd_e, f, CT1, he, root, Amp, Coordinate, Ielement);
%% 左边界反射模态的节点位移/力
bnd = bnd_401;
bnd_e = bnd_401_e;
P_L = zeros(length(bnd_401),nmode);
T_L = zeros(length(bnd_401),nmode);
for imode = 1:nmode
	mode = imode;
	P_L(:,imode)  =  u_mode(Nnode, CT1, f, he, root, Amp, mode, Coordinate, bnd);
	T_L(:,imode)  = t_mode_l(Nnode, mode, bnd, bnd_e, f, CT1, he, root, Amp, Coordinate, Ielement);
end

%% 右边界透射模态的节点位移/力
bnd = bnd_501;
bnd_e = bnd_501_e;
P_R = zeros(length(bnd_501),nmode);
T_R = zeros(length(bnd_501),nmode);
for imode = 1:nmode
	mode = imode;
	P_R(:,imode)  =  u_mode(Nnode, CT1, f, he, root, Amp, mode, Coordinate, bnd);
	T_R(:,imode)  = t_mode_r(Nnode, mode, bnd, bnd_e, f, CT1, he, root, Amp, Coordinate, Ielement);
end

%% 用系数代替边界节点位移
[Ko,Kl,Kr,l,r,o] = Stiffness_Changed_Position(Kg,bnd_401,bnd_501, Nnode);

KP = [Ko, Kl*P_L, Kr*P_R];

T = zeros(size(KP));
% T1 = [T_L, zeros(size(T_R));
% 	zeros(size(T_L)), T_R] ;
T1 = blkdiag(T_L,T_R);
% r = 2*(bnd_L+bnd_R); c = 1+nmode*2;
[R,C] = size(T1);
T(end-R+1:end,end-C+1:end) = T1;
T = sparse(T);

KPT = KP+T;
Ti = sparse(Nnode,1);
[R,C] = size(T_inc);
Ti(end-R+1:end,end-C+1:end) = T_inc;

c_inc = 1; % 令入射系数c_inc为1e-6
F = sparse((-(Kl*P_inc)+Ti)*c_inc);

%% 判断矩阵KPT是否病态
% cond(KPT) % KPT的条件数
% dKPT = decomposition(KPT);
% isIllConditioned(dKPT)

%% 求解 KPT*[u;coeff]=F
sol = KPT\sparse(F);
coeff = sol(end-2*nmode+1:end);
c_RE = coeff(1:nmode)./c_inc
c_TR = coeff(nmode+1:end)./c_inc

u(l)=P_inc*c_inc+P_L*c_RE;
u(r)=P_R*c_TR;
u(o) = sol(1:end-2*nmode);%% 左右端位移
%% 后处理绘图结果
plot_wave_structure(min(Coordinate(:,1)),Coordinate,u); % 绘制厚度方向位移
plot_wave_structure(max(Coordinate(:,1)),Coordinate,u); % 绘制厚度方向位移
% plot_plot3(coordinate, u); % 绘制位移云图
plot_surface_displacement(u,coordinate,bnd_T); % 绘画出上表面的位移
