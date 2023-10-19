function R = matrix_R(wd, kd, Amp, modes)

R = zeros(modes,modes);
for imode = 1:modes
	for jmode = 1:modes
		R(imode,jmode) = Rij( imode, jmode, wd, kd, Amp, 0, 1);
	end
end


end