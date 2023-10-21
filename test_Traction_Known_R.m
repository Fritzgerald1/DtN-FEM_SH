run test_setup.m
U_in=zeros(Nnode,1);
F=zeros(Nnode,1);
for j = 1:Nnode
	kh = root(1,mode_in);
	kth1 = 2*pi*f/CT1*b;
	kth2 = 2*pi*f/CT2*b;
	x = Coordinate(j,1);
	y = Coordinate(j,2);
	i_layer = 1;

	[ z_um,zderiv_um ] = SH_mode(mode_in,Amp,i_layer,kth1,kth2,kh,x,y,1,0);
	U_in(j,1) = z_um;
end

F = F-Kg*U_in;

% 401,501 boundary  (incident component int_NT_tin)
for j = 1:(length(bnd_401)-1)/2
	indx_node = bnd_401(2*j-1:2*j+1)';
	indx_node = indx_node(end:-1:1);
	kh = root(1,mode_in);
	kth1 = 2*pi*f/CT1*b;
	kth2 = 2*pi*f/CT2*b;
	i_layer = 1;
	mu = 1;

	xs = Coordinate(indx_node(:),:);
	any(1,1)= (xs(3,2)-xs(1,2))/dW*b;
	any(1,2)= (xs(3,1)-xs(1,1))/dL*b;
	[int_NT_tin ] = inwv(mode_in,mu,i_layer,Amp,kth1,kth2,kh,xs,any,501);
	F(indx_node) = F(indx_node) + int_NT_tin(:);
end

for j = 1:(length(bnd_501)-1)/2
	indx_node = bnd_501(2*j-1:2*j+1)';
	kh = root(1,mode_in);
	kth1 = 2*pi*f/CT1*b;
	kth2 = 2*pi*f/CT2*b;
	i_layer = 1;
	mu = 1;

	xs = Coordinate(indx_node(:),:);
	any(1,1)= (xs(3,2)-xs(1,2))/dW*b;
	any(1,2)= (xs(3,1)-xs(1,1))/dL*b;
	[int_NT_tin ] = inwv(mode_in,mu,i_layer,Amp,kth1,kth2,kh,xs,any,501);
	F(indx_node) = F(indx_node) + int_NT_tin(:);
end
pause
