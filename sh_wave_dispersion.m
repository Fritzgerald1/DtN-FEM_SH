function  [kd, Amp_normalized,modes]= sh_wave_dispersion(wd, material, b)
density = material.DENSITY;
lambda = material.LAMBDA;
mu = material.MU;

Fun = @SH;

[kd,~,modes] = get_wavenumber(wd,lambda,mu,density,b,Fun);
Amp = get_amplitude(kd,wd,lambda,mu,density,b,Fun);


P = zeros(modes,1);
for imode = 1:modes
	P(imode) = power_eval( imode, imode, wd, kd, Amp, 0, 1);
end

Amp_normalized = zeros(size(Amp));
for imode = 1:modes
	Amp_normalized(:,imode) = Amp(:,imode)./sqrt(abs(P(imode)));
end

end