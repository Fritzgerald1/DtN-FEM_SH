function [ R ] = power_eval( imode,jmode,wd,kd,Amp,x1,ipm )
R = 0;
kdi = kd(imode);
kdj = kd(jmode);

n = 8;
[x,w]=gauss_integration(n);

rmu=1;
y2=1;
y1=-1;
qq = 0.5*(y2-y1);

ri = sqrt(wd^2-kdi^2);
rj = sqrt(wd^2-kdj^2);

for iw=1:n
	ys1=x1;
	ys2=((y2-y1)*x(iw)+y1+y2)*0.5;
	ui = (Amp(1,imode)*exp(1i*ri*ys2) + Amp(2,imode)*exp(-1i*ri*ys2)) * exp(ipm*1i*kdi*ys1);
	uj = (Amp(1,jmode)*exp(1i*rj*ys2)+Amp(2,jmode)*exp(-1i*rj*ys2))*exp(ipm*1i*kdj*ys1);
	R= R + 0.5*(kdi*rmu*ui*uj*qq*w(iw));
end

end