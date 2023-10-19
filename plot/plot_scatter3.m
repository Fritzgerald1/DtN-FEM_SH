function plot_scatter3(coordinate, u)
% 绘制位移云图
x = coordinate(:,1);
y = coordinate(:,2);
figure()
scatter3(x,y,u,36,u,'filled')
end