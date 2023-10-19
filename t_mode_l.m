function LT = t_mode_l(Nnode, mode, bnd, bnd_e, f, CT1, he, root, Amp, Coordinate, Ielement)

L_int_NTtm = zeros(Nnode,1);

for i1 = 1:length(bnd_e)
	indx_e = bnd_e(i1);
	kh = root(mode);
	kth1 = 2*pi*f/CT1*he;

	xs(1,1) = 0;
	xs(1,2) = Coordinate(Ielement(indx_e,1),2);
	xs(2,1) = 0;
	xs(2,2) = Coordinate(Ielement(indx_e,8),2);
	xs(3,1) = 0;
	xs(3,2) = Coordinate(Ielement(indx_e,4),2);
	[ zint_NTtm ] = int_NT_tm( mode,1,1,xs,Amp,kth1,kth1,kh,0 );
	L_int_NTtm(Ielement(indx_e,1)) = L_int_NTtm(Ielement(indx_e,1))+zint_NTtm(1,1);
	L_int_NTtm(Ielement(indx_e,8)) = L_int_NTtm(Ielement(indx_e,8))+zint_NTtm(2,1);
	L_int_NTtm(Ielement(indx_e,4)) = L_int_NTtm(Ielement(indx_e,4))+zint_NTtm(3,1);
end

LT = L_int_NTtm(bnd);