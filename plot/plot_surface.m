function plot_surface(coordinate, u)
% 绘制位移云图
x = coordinate(:,1);
y = coordinate(:,2);
% figure()
[X,Y,Z]=griddata(x,y,u,linspace(min(x),max(x))',linspace(min(y),max(y)));%插值
%griddata起自动差值的作用，这样才能画出来一个三维面
%[X,Y,Z]=griddata(x,y,z,XI,YI,'v4'):这里要求XI为行向量，YI为列向量，'v4'属性用于生成平滑曲面
%linspace(x,y)是自动生成从x到y的100数组成的列向量
surface(X,Y,Z);
shading interp;%过渡均匀化，去掉网格线
%colormap (flipud(jet(24)))%这个可以翻转颜色
end