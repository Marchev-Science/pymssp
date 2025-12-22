function [f,mre,a]=xrosspow(x1,x2,y,test_size,parallel)

%% Docs
% Cross breeding parents through multiplicative multiple linear regression
% where:
% x1, x2 are parent 1 and parent 2
% y is dependant data
% f is offspring
% test_size is the relative size of the test subset in percent, should be
%  less than 0.5
% parallel is parameter wheather to use the parallel computing
% mre is 1-by-2 matrix of mean relative error
% mre(1) is for interpolation
% mre(2) is for extrapolation
% a is 1-by-3 matrix of parameters 
% a(1) is the intercept parameter
% a(2) is the sensitivity parameter for x1
% a(3) is the sensitivity parameter for x2

%% Train & validation

x=[x1 x2];

l=round(size(x)*test_size);

trainx=x(1:size(x)-l-1,:);

trainy=y(1:size(x)-l-1);

%% Pre-regression transformation

trainx=log(trainx);

trainy=log(trainy);

%% Calculations

a=regra(trainx,trainy,parallel);

a(1)=exp(a(1));

a=a';

f=a(1).*x1.^a(2).*x2.^a(3);

%% Validation

mre=xvalid(f,y,test_size);

% mre(1,1)=mean(abs(f(1:size(trainx,1))./y(1:size(trainx,1))-1));
% 
% mre(1,2)=m1,2)=mean(abs(f(size(x)-l:size(x))./y(size(x)-l:size(x))-1));

end