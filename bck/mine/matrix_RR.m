function R = matrix_RR(wd, kd, Amp, modes)

R = zeros(modes,modes);
for imode = 1:modes
	for jmode = 1:modes
		R(imode,jmode) = RRij( imode, jmode, wd, kd, Amp, 0, 1);
	end
end

end