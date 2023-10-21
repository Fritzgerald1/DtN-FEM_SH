function uModeBnd = u_mode(Nnode, CT1, f, he, root, Amp, mode, Coordinate, bnd)
%% 边界节点的模态位移
uMode=zeros(Nnode,1);

kth1 = 2*pi*f/CT1*he;
kh = root(mode);
for j = 1:length(bnd)
	inode = bnd(j);
    x = Coordinate(inode,1);
    y = Coordinate(inode,2);
    [ z_um,zderiv_um ] = SH_mode(mode,Amp,1,kth1,kth1,kh,x,y,1,0);
    uMode(inode,1) = z_um;
	uModeBnd = uMode(bnd);
end