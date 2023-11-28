function [bnd_e] = bound_element(Ielement, bnd)
%% 边界单元
[A,~] = arrayfun(@(x) find(ismember(Ielement,x)),bnd(:),'UniformOutput',false);
bnd_e = unique(cell2mat(A)); % 节点对应的单元编号
bnd_e = bnd_e';
end