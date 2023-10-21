function R = maxtrix_R()


R = zeros(modes,modes);

for imode = 1:modes
	for jmode = 1:modes
		R(imode,jmode) = Rij( imode, jmode, wd, kd, Amp_normalized, 0, 1);
	end
end
end