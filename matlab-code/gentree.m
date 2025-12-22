function [tree_sel,model]=gentree(logstable,sz)

%% Docs
% Find the route of genealogical tree of the model and reconstruct
% the full mathematical description of the model.
% Where:
% logstable is tabular log of the selection procedure
% sz is number of independant variables (i.e. "x1_3")
% modlst is list of primitive models
% tree is a table with the genealogical tree of the best model
% model is a string, describing the model

%% Initialization

logvars={'id','generator','gener_num','parent1','parent2','a0','a1','a2','mre_int','mre_ext','rank','select'};
logvars_type={'uint16','string','uint8','uint16','uint16','double','double','double','double','double','double','logical'};
tree_sel=table('Size',[0 12],'VariableTypes',logvars_type,'VariableNames',logvars); %#ok<NASGU> 

%% Find the best model in last population

lastpop=max(logstable.gener_num);

rows = logstable.gener_num==lastpop;

lastpop_tab=logstable(rows, :);

rows = lastpop_tab.rank==1;

tree_sel=lastpop_tab(rows, :);

parent=zeros(size(logstable,1),1);

parent(1,1)=tree_sel.id(1);

parent_tmp=tree_sel.id(1);

clearvars rows logvars logvars_type lastpop_tab

%% Add unique ancestors & genealogy

k=1;
i=0;
% for i=1:lastpop+4
while i~=k    
    
    %gen=lastpop+1-i;
     parent_tmp=table2array(logstable(parent_tmp,4:5));
     parent_tmp=reshape(unique(parent_tmp),[],1);
     if sum(parent_tmp)==0
         break
     end
     parent_tmp(parent_tmp==0)=[];
     parent(k+1:k+size(parent_tmp,1))=parent_tmp;
     parent=sortrows(unique(parent),'ascend');
    i=k;
     k=find(parent,1,"last");
    
     
end

parent=sortrows(unique(parent),'descend');

parent(parent==0)=[];

tree_sel =logstable(parent,:);

tree_sel=sortrows(tree_sel,'id','ascend');

%% Symbolic representation

for i=1:size(tree_sel,1)
    if tree_sel.id(i)<=sz%+1 %if it is an independant variable
        eval(['x',num2str(tree_sel.id(i)),'=sym(tree_sel.generator(i));'])
        
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'lin')
        eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*x',num2str(tree_sel.parent1(i)),');'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'lgn')
        eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*log(x',num2str(tree_sel.parent1(i)),'));'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'xpy')
        eval(['f',num2str(tree_sel.id(i)),'=(exp(tree_sel.a0(i)+tree_sel.a1(i).*x',num2str(tree_sel.parent1(i)),'));'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'pow')
        eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i).*x',num2str(tree_sel.parent1(i)),'.^tree_sel.a1(i));'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'rex')
        eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i)./x',num2str(tree_sel.parent1(i)),');'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'rey')
        eval(['f',num2str(tree_sel.id(i)),'=(1./((tree_sel.a0(i)+tree_sel.a1(i).*x',num2str(tree_sel.parent1(i)),')));'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'sqr')
        eval(['f',num2str(tree_sel.id(i)),'=((tree_sel.a0(i)+tree_sel.a1(i).*x',num2str(tree_sel.parent1(i)),').^2);'])
    elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'snx')
        eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*sin(x',num2str(tree_sel.parent1(i)),'));'])
        
    elseif tree_sel.gener_num(i)>0 && strcmp(tree_sel.generator(i),'xcross')
        eval(['f',num2str(tree_sel.id(i)),'=tree_sel.a0(i)+tree_sel.a1(i).*f',...
            num2str(tree_sel.parent1(i)),'+tree_sel.a2(i).*f',num2str(tree_sel.parent2(i)),';'])
    elseif tree_sel.gener_num(i)>0 && strcmp(tree_sel.generator(i),'xcrosspow')
        eval(['f',num2str(tree_sel.id(i)),'=tree_sel.a0(i).*f',...
            num2str(tree_sel.parent1(i)),'.^tree_sel.a1(i).*f',num2str(tree_sel.parent2(i)),'.^tree_sel.a2(i);'])
    else
        break
    end
end

model=eval(['f',num2str(max(tree_sel.id))]);

end