function [f,mre,a]=pow(x,y,test_size,parallel)

%% Docs

% Single variable linear regression function with power model
% where:
% x is independant data
% y is dependant data
% f is calculated data
% test_size is the relative size of the test subset in percent, should be
%  less than 0.5
% parallel is parameter wheather to use the parallel computing
% mre is 1-by-2 matrix of mean relative error
% mre(1) is for interpolation
% mre(2) is for extrapolation
% a is 1-by-2 matrix of parameters 
% a(1) is the intercept parameter
% a(2) is the sensitivity parameter

%% Train & validation

l=round(size(x)*test_size);

trainx=x(1:size(x)-l-1);

trainy=y(1:size(x)-l-1);

%% Pre-regression transformation

trainx=log(trainx);

trainy=log(trainy);

%% Calculations

a=regra(trainx,trainy,parallel);

a(1)=exp(a(1));

a=a';

f=a(1).*x.^a(2);

%% Validation

mre=xvalid(f,y,test_size);

% mre(1,1)=mean(abs(f(1:size(trainx,1))./y(1:size(trainx,1))-1));
% 
% mre(1,2)=m1,2)=mean(abs(f(size(x)-l:size(x))./y(size(x)-l:size(x))-1));

end