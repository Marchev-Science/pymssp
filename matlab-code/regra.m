function a=regra(x,y,parallel)

%% Docs
% function to run regression using matlab's \
% where:
% x is independant data
% y is dependant variable
% parallel is parameter whether to use the parallel computing
% a returns a vector of coefficients

%% Preliminary transformation

x_mat=[ones(size(x,1),1) x];

%% Calculations

if parallel==1

    x_mat = distributed(x_mat);

    a=x_mat\y;

    a = gather(a);

else

    a=x_mat\y;
end
