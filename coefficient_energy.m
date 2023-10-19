function [c_Tr, c_Re, c_in, eng_T, eng_R] = coefficient_energy(E, R, G, U, n, wd, kd, Amp_normalized, modes, mode_in)
%输出:
%	c_Tr=透射系数;
%	c_Re=反射系数;
%	c_in=入射系数;
%	eng_T=透射能量;
%	eng_R=反射能量;

	c_in = abs(inv(E.L.plus)/R*G.L*U.in(n.left));
	Re = inv(E.L.minus)/R*G.L*U.sc(n.left);
	Tr = inv(E.R.plus)/R*G.R*U.sc(n.right);
	[eng_R, eng_T] = mode_energy(modes, mode_in, wd, kd, Amp_normalized, Re, Tr);
	c_Re = abs(Re);
	c_Tr = abs(Tr);
end