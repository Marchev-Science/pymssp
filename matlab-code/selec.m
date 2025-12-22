function [genn, inx]=selec(mre, gener, ssize)

%% Docs
% Bias selection
% where
% mre is vector of mean relative error
% gener is a generation of solutions
% genx is the new selected generation
% ssize size of selection

%% Calculation
% ssize=120; %size of selection

% Filterout columns with complex, infinite, or NaN values

sss=filterealc(gener);

gener=gener(:,sss);
mre=mre(sss,:);

zzzz=mean(mre,2);
[inx,sel]=mink(zzzz,ssize);
% [inx,sel]=mink(mre(:,1),ssize);

sel=sort(sel,'ascend');

inx=mre(sel,1);
 
leftover=size(inx,1)-ssize;

% if leftover>0
%     (inx==max(inx))=[];
% else
% end

genn=gener(:,sel);

end