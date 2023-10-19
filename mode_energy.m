function [eng_R, eng_T] = mode_energy(modes, mode_in, wd, kd, Amp_normalized, Re, Tr)

P = zeros(modes,1);
for imode = 1:modes
	P(imode) = power_eval( imode, imode, wd, kd, Amp_normalized, 0, 1); % 能流密度
end

eng_R = zeros(modes,1);
eng_T = zeros(modes,1);

for imode = 1:modes
	eng_R(imode) = eng_R(imode) + abs(P(imode)/P(mode_in)*conj(Re(imode))*Re(imode));
	eng_T(imode) = eng_T(imode) + abs(P(imode)/P(mode_in)*conj(Tr(imode))*Tr(imode));
end