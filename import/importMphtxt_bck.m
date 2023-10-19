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