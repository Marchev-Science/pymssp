function f=predict(symodel, tree_sel, method,...
    x, lagn, y, type_norm_x, type_norm_y, min_norm, horizont, x_time)
% function [f,mre]=forecst(symodel, tree, method, x, lagn, y)
%% Docs
% OLD!!!
% Calculate forecast on a explited model from mssp
% where
% symodel is a symbolic math object with the explecited model
% tree is the genealogical tree in table form of the model
% method is the prefered method for calculation
%     0 = tree
%     1 = symodel  
% x m-by-n matrix with raw inputs, n is same as the number of inputs,
%     which were used to make the model
% lagn is number of lags used to transfor each element of x
% sz is the number of 
% y (m-lagn-1)-by-p matrix with test set, corresponding to x
% mre is scalar with mean relative error of forecast


%% Initialization



% % [y,x]=xtrapoly(y,x);
% if size(x,1)>size(y,1)
%     fill=size(x,1)-size(y,1);
%     last=y(end);
%     y=[y; last*ones(fill,1)];
%     %    x=x(1:size(y,1),:);
% else
% end

if x_time==1
    x=[x(end-lagn:end) x(end)+(1:1:horizont)]';
    y=[y(end-lagn:end) zeros(1,horizont)];
else
end

sz1=size(x,1);
sz2=size(x,2);
sz3=size(y,2);
sz=lagn*(sz2+sz3)-sz3;

y_data=y(1:sz1-lagn+1,:);

x=[y x];

min_x=zeros(size(x,2),1);
max_x=zeros(size(x,2),1);

for i=1:size(x,2) %#ok<FORPF> % normalizing
    [x(:,i), min_x(i), max_x(i)] = xnormalize(x(:,i),type_norm_x, min_norm);
end

min_y=zeros(size(y_data,2),1);
max_y=zeros(size(y_data,2),1);

for i=1:size(y_data,2) %#ok<FORPF> % normalizing
    [y_data(:,i), min_y(i), max_y(i)] = xnormalize(y_data(:,i),type_norm_y, min_norm); 
end


for i=1:size(x,2) %#ok<FORPF>
    m=x(:,i);
    x_data(:,(lagn*i-(lagn-1)):(i*lagn))=lags(m,lagn);
end
% x_data(:,1)=[]; % delete unlagged Y data

combvn=combvec((1:lagn)-1,1:sz3)';
% combvn(1,:)=[]; % delete unlagged Y data

for i=1:size(combvn,1) %#ok<FORPF>
    generatr_y(i)=string(['y',num2str(combvn(i,2)),'_',num2str(combvn(i,1))]);
end
combvn=combvec((1:lagn)-1,1:sz2)';

for i=1:sz2*lagn %#ok<FORPF>
    generatr(i)=string(['x',num2str(combvn(i,2)),'_',num2str(combvn(i,1))]);
end

generatr=[generatr_y generatr];

clearvars combvn generatr_y i lagn sz1 sz2 sz3 y

%% Compute forecast method = 0

if method == 0

    for i=1:size(tree_sel,1)
        if tree_sel.id(i)<=sz+1 %if it is an independant variable
            eval([char(tree_sel.generator(i)),'=x_data(:,tree_sel.id(i));'])        

        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'lin')
            eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),');'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'lgn')
            eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*log(',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),'));'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'xpy')
            eval(['f',num2str(tree_sel.id(i)),'=(exp(tree_sel.a0(i)+tree_sel.a1(i).*',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),'));'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'pow')
            eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i).*',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),'.^tree_sel.a1(i));'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'rex')
            eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i)./'...
                ,char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),');'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'rey')
            eval(['f',num2str(tree_sel.id(i)),'=(1./((tree_sel.a0(i)+tree_sel.a1(i).*',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),')));'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'sqr')
            eval(['f',num2str(tree_sel.id(i)),'=((tree_sel.a0(i)+tree_sel.a1(i).*',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),').^2);'])
        elseif tree_sel.parent1(i)>0 && strcmp(tree_sel.generator(i),'snx')
            eval(['f',num2str(tree_sel.id(i)),'=(tree_sel.a0(i)+tree_sel.a1(i).*sin(',...
                char(tree_sel.generator(tree_sel.id==tree_sel.parent1(i))),'));'])

        elseif tree_sel.gener_num(i)>0 && strcmp(tree_sel.generator(i),'xcross')
            eval(['f',num2str(tree_sel.id(i)),'=tree_sel.a0(i)',...
                '+tree_sel.a1(i).*f',num2str(tree_sel.parent1(i)),...
                '+tree_sel.a2(i).*f',num2str(tree_sel.parent2(i)),';'])
        elseif tree_sel.gener_num(i)>0 && strcmp(tree_sel.generator(i),'xcrosspow')
            eval(['f',num2str(tree_sel.id(i)),'=tree_sel.a0(i).*f',...
                num2str(tree_sel.parent1(i)),'.^tree_sel.a1(i).*f',...
                num2str(tree_sel.parent2(i)),'.^tree_sel.a2(i);'])
        else
            break
        end
    end
    
    eval(['f=f',num2str(max(tree_sel.id)),';']);
    
%% Compute forecast method = 1

else
    for i=1:size(x_data,1)
        symodel_tmp=symodel;
            for j=1:sz
                symodel_tmp=subs(symodel_tmp,generatr(j),x_data(i,j));
            end
        f(i,1)=double(symodel_tmp);
    end

end

%% Compute error

% mre=mean(abs((f./y_data)-1));

format bank

%% Denormalize
if type_norm_y==1
    f = xdenormalize(f, min_y, max_y,type_norm_y,min_norm);
else
end
       

end