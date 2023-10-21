function [Nnode,Nelement,Coordinate,Ielement,nLeft,nMid,nRight, nTop, nBottom] = import_mesh_pipe(fileName,bnd)
%% 网格信息
% [Nnode, Nelement, Coordinate, Ielement] = read_mesh_info_CQUAD8([fileName '.dat']); %%
% nCentroid = []; %%
fileNameMPHTXT = [fileName '.mphtxt'];
mesh_info = importMphtxt(fileNameMPHTXT);

[Nnode, Nelement, Coordinate, Ielement, nCentroid] =read_mesh_info(mesh_info);
%% 边界信息

 nbnd=read_boudary_info(bnd(),mesh_info);
 nLeft = nbnd{1};
nRight = nbnd{2};
nTop = nbnd{3};
nBottom = nbnd{4};
% [ nLeft, nRight, nTop, nBottom] = read_boudary_info(bnd,mesh_info);

% 将边界节点排序
refPoint = [0; -2];
nLeft = order_bnd(refPoint,Coordinate, nLeft);
nRight = order_bnd(refPoint,Coordinate, nRight);
% 节点编号重排（左边界-中间-右边界）
[Coordinate, Ielement, nLeft, nMid, nRight] = change_node_order(Coordinate,Ielement, nLeft,nRight,nCentroid);
end

function mesh = importMphtxt(filename, dataLines)
%% 输入处理
% 如果不指定 dataLines，请定义默认范围
if nargin < 2
	dataLines = [1, Inf];
end
%% 设置导入选项并导入数据
opts = delimitedTextImportOptions("NumVariables", 3);
% 指定范围和分隔符
opts.DataLines = dataLines;
opts.Delimiter = "#";
% 指定列名称和类型
opts.VariableNames = ["VarName1", "CreatedByCOMSOLMultiphysics", "VarName3"];
opts.VariableTypes = ["string", "string", "string"];
% 指定文件级属性
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
% 指定变量属性
opts = setvaropts(opts, ["VarName1", "CreatedByCOMSOLMultiphysics", "VarName3"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName1", "CreatedByCOMSOLMultiphysics", "VarName3"], "EmptyFieldRule", "auto");
% 导入数据
mesh = readmatrix(filename, opts);
mesh(ismissing(mesh)) ="";
end