function [y_new,x_new]=xtrapoly(y,x)

%% Docs
% Fill in real data for the dependent variable by extending it using the 
% method LVPF - last value put foreword
% Also fill-in the other variable if shorter than y
% where:
% y - dependant variable (to be extended)
% x - other variable to be matched be extending y

%% Operation
if size(x,1)>size(y,1)
    fill=abs(size(x,1)-size(y,1));
    last=y(end);
    y_new=[y; last*ones(fill,1)];
    x_new=x;
elseif size(x,1)<size(y,1)
    fill=abs(size(x,1)-size(y,1));
    last=x(end);
    x_new=[x; last*ones(fill,1)];
    y_new=y;
else
    x_new=x;
    y_new=y;
end

