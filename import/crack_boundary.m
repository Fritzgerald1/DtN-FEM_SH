function crack = crack_boundary(Coordinate,L_crack,W_crack,he)
x = Coordinate(:,1);
y = Coordinate(:,2);

%% 边界节点
L_crack = L_crack/he;
W_crack = W_crack/he;

crack =  find((y >= 1-W_crack) .* (x <= L_crack/2+he/10 ) .* (x >= -L_crack/2-he/10)); % 缺陷边界节点
crack = crack';
