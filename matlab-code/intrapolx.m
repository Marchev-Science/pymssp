function [y_new,x_new]=intrapolx(y,x)

%% Docs
% Cut off extrapolated data for non-dependent variable to match the size of 
% dependent variable
% Also cut-off the dеpendent variable if shorter than x
% where:
% y - dependant variable (to be match by cutting x)
% x - other variable to be cut back to the size of x

%% Operation
if size(x,1)>size(y,1)
    cut_size=abs(size(x,1)-size(y,1));
    x_new=x(1:end-cut_size,:);
    y_new=y;
elseif size(x,1)<size(y,1)
    cut_size=abs(size(x,1)-size(y,1));
    y_new=y(1:end-cut_size,:);
    x_new=x;    
else
    y_new=y;
    x_new=x;
end

