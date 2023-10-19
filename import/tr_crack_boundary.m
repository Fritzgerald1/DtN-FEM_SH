function crack = tr_crack_boundary(Coordinate,L_crack,W_crack,he)
x = Coordinate(:,1);
y = Coordinate(:,2);

%% 边界节点
L_crack = L_crack/he;
W_crack = W_crack/he;

crack = find((x>=-L_crack/2) .*(x<=L_crack/2) .*(y>=(2*W_crack/L_crack)*x + 1-W_crack) .*(y>=(-2*W_crack/L_crack)*x+ 1-W_crack)); % 缺陷边界节点
crack = crack';