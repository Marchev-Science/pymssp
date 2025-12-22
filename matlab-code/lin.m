function [f,mre,a]=lin(x,y,test_size,parallel)

%% Docs

% Single variable linear regression function with linear model
% where:
% x is independant data
% y is dependant data
% f is calculated data
% test_size is the relative size of the test subset in percent, should be
%  less than 0.5
% mre is 1-by-2 matrix of mean relative error
% mre(1) is for interpolation
% mre(2) is for extrapolation
% a is 1-by-2 matrix of parameters 
% a(1) is the intercept parameter
% a(2) is the sensitivity parameter

%% Train & validation

l=round(size(x)*test_size);

trainx=x(1:size(x)-l);

trainy=y(1:size(x)-l);

%% Pre-regression transformation

% No transformation needed

%% Calculations

a=regra(trainx,trainy,parallel);

a=a';

f=a(1)+a(2).*x;

%% Validation

mre=xvalid(f,y,test_size);

% mre(1,1)=mean(abs(f(1:size(trainx,1))./y(1:size(trainx,1))-1));
% 
% mre(1,2)=mean(abs(f(size(x)-l:size(x))./y(size(x)-l:size(x))-1));

end