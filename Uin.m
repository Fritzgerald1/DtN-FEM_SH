
U_in=zeros(Nnode,1);
F=zeros(Nnode,1);
U=zeros(Nnode,1);

for j = 1:Nnode
    x = Coordinate(j,1);
    y = Coordinate(j,2);
	iAmp = Amp_normalized(:,mode_in);
	ik = kd(mode_in);
    [ z_um,zderiv_um ] = SH_u_t(iAmp,wd,ik,x,y,MATERIAL,1);
    U_in(j,1) = z_um;
end