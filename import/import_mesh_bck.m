function [nNode,nElement,Coordinate,Ielement,n] = import_mesh(fileName,bnd)
n=struct; % n.边界=边界节点编号
%% 网格信息
fileNameMPHTXT = [fileName '.mphtxt'];
mesh_info = importMphtxt(fileNameMPHTXT);

[nNode, nElement, Coordinate, Ielement, nCentroid] =read_mesh_info(mesh_info);
%% 边界信息
for ii = 1:length(bnd)
	nameBnd = strrep(bnd(ii),"bnd_",'');
	nBnd = read_boudary_info(bnd(ii),mesh_info);
	n.(nameBnd) = nBnd;
end
% 将左右边界节点排序
minY = min(Coordinate(:,2));
refPoint = [0;minY-1];

n.left = order_bnd(refPoint,Coordinate, n.left);
n.right = order_bnd(refPoint,Coordinate, n.right);

% 节点编号重排（左边界-中间-右边界）
[Coordinate, Ielement, n.left, n.mid, n.right] = change_node_order(Coordinate, Ielement, n.left, n.right, nCentroid);
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