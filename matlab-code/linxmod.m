function [f,mre,a]=linxmod(x,y,test_size,nfun,sine_x,parallel)

%% Docs
% Modeling data with all linear estimation models
% where
% x is input data
% y is the resulting data
% f is output array with calculated predictions by every model
% test_size is the relative size of the test subset in percent, should be
%  less than 0.5
% nfun is number of models
% mre is n-by-2 matrix of mean relative error
% mre(n,1) is for interpolation
% mre(n,2) is for extrapolation
% The models are:
% lin - linear
% lgn - logarithmic
% xpy - exponential
% pow - power
% rex - reciprocal
% rey - reverse reciprocal
% sqr - quadratic sum
% sine_x is parameter whether we use sine functions on top of every other
% function
% snx - sine

%% Initialization

% nfun=8; 

f=zeros(size(x,1),nfun);

mre=zeros(nfun,2);

a=zeros(nfun,2);

%% Calculation
n=1;
[f(:,n),mre(n,:),a(n,:)]=lin(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=lgn(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=xpy(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=pow(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=rex(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=rey(x,y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=sqr(x,y,test_size,parallel);
if sine_x==1
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,1),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,2),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,3),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,4),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,5),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,6),y,test_size,parallel);
n=n+1;
[f(:,n),mre(n,:),a(n,:)]=snx(f(:,7),y,test_size,parallel);
else
end
% f1=f(:,1);
% f2=f(:,2);
% f3=f(:,3);
% f4=f(:,4);
% f5=f(:,5);
% f6=f(:,6);
% f7=f(:,7);
%f8=f(:,8);


end