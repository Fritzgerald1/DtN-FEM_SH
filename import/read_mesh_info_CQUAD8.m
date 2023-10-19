function [Nnode, Nelement, Coordinate, Ielement,dx,dy] = read_mesh_info_CQUAD8(fileName)
meshInfo = importDat(fileName);

x = meshInfo.Var1(meshInfo.Type == "GRID");
y = meshInfo.Var2(meshInfo.Type == "GRID");
Coordinate = [x, y];
Nnode = size(Coordinate,1);

[~,~,dx] = find(abs(diff(x)),1);
[~,~,dy] = find(abs(diff(y)),1);

Ielement = [meshInfo.Var1(meshInfo.Type == "CQUAD8"),	meshInfo.Var2(meshInfo.Type == "CQUAD8"),meshInfo.Var3(meshInfo.Type == "CQUAD8"),meshInfo.Var4(meshInfo.Type == "CQUAD8"),...
	meshInfo.Var5(meshInfo.Type == "CQUAD8"),meshInfo.Var6(meshInfo.Type == "CQUAD8"),meshInfo.Var7(meshInfo.Type == "CQUAD8"),meshInfo.Var8(meshInfo.Type == "CQUAD8"),];
Nelement = size(Ielement,1);

	function Untitled = importDat(filename, dataLines)
		%% 输入处理
		% 如果不指定 dataLines，请定义默认范围
		if nargin < 2
			dataLines = [1, Inf];
		end
		%% 设置导入选项并导入数据
		opts = delimitedTextImportOptions("NumVariables", 11);
		% 指定范围和分隔符
		opts.DataLines = dataLines;
		opts.Delimiter = ",";
		% 指定列名称和类型
		opts.VariableNames = ["Type", "Index", "space", "Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"];
		opts.VariableTypes = ["categorical", "double", "string", "double", "double", "double", "double", "double", "double", "double", "double"];
		% 指定文件级属性
		opts.ExtraColumnsRule = "ignore";
		opts.EmptyLineRule = "read";
		% 指定变量属性
		opts = setvaropts(opts, "space", "WhitespaceRule", "preserve");
		opts = setvaropts(opts, ["Type", "space"], "EmptyFieldRule", "auto");
		opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8"], "TrimNonNumeric", true);
		opts = setvaropts(opts, ["Var4", "Var5", "Var6", "Var7", "Var8"], "ThousandsSeparator", ",");
		% 导入数据
		Untitled = readtable(filename, opts);
	end
end