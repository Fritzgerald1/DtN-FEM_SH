function labeled_node = read_boudary_info(fileName,bnd)
mesh_info = importMphtxt(fileName);
%% 获得标记label的编号
a=strfind(mesh_info,bnd);
ind = ~cellfun('isempty', a);
[r,~] = find(ind);
nEntity = str2double(mesh_info(r+3,1));
label = str2double(mesh_info(r+5:r+5+nEntity-1,1));

%% 按Type分块
str1 = " Type ";
[ind_buck,~] = find(mesh_info==str1); % 信息块之间分隔的行号

str1 = " --------- Object 1 ----------";
[ind_end,~] = find(mesh_info==str1); % 单元信息块的最后一行

vertex_info = mesh_info(ind_buck(1):ind_buck(2)-1,:); % 顶点单元信息
edge_info = mesh_info(ind_buck(2):ind_buck(3)-1,:); % 边界单元信息
quad_info = mesh_info(ind_buck(3):ind_end-1,:); % 体单元信息

%% 由label找edge信息块里的entity indices
str1 = " number of geometric entity indices";
[iEntityIndices,~] = find(edge_info==str1);

nGeometricEntityIndices = str2double(edge_info(iEntityIndices));
iEntityIndices = iEntityIndices+2;
indices=str2double(edge_info(iEntityIndices:iEntityIndices+nGeometricEntityIndices-1,1));
labeldNodeInRow = [];
for ii1 = 1:length(label)
	rowNodeLabeled = find(indices==label(ii1)); % 标记的边界单元编号
	%%
	str2 = " number of elements";
	[iNumberElement,~] = find(edge_info==str2);
	% 边界单元个数
	nElement = str2double(edge_info(iNumberElement));
	% 提取边界单元的节点信息
	iNumberElement = iNumberElement+2;
	tmp = (edge_info(iNumberElement:iNumberElement+nElement-1,1));
	% 边界单元的节点信息
	for ii2 = 1:length(tmp)
		edgeElementInfo(ii2,:) = str2num(strip(tmp(ii2)));
	end
	tmp = edgeElementInfo(rowNodeLabeled,:); % 被标记的边界单元对应的节点编号
	labeldNodeInRow = [labeldNodeInRow;tmp];
end
labeled_node = sort(unique(reshape(labeldNodeInRow,1,[])));
labeled_node = labeled_node'+1;
labeled_node = labeled_node';

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
end