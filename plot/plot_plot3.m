function plot_plot3(coordinate, u)
% 绘制位移云图
x = coordinate(:,1);
y = coordinate(:,2);
figure()
plot3(x,y,u,'.')
end