function [x_n, min_x, max_x] = xnormalize(x,type_norm,min_norm)

%% Docs
% Normalize x through method of feature scaling,
% where:
% x - n-by-1 unscaled data
% x_n - scaled data
% min_x - min(x) to be used for denormalizing
% max_x - max(x) to be used for denormalizing
% min_norm is the lowest number of x_n
% type_norm - type of normalization, where:
% 0 - no normalization
% 1 - between [min_norm,min_norm+1]
% Note: the denormalization must match the type_norm

%% Initialize


%% Calculate

min_x = min(x);

max_x = max(x);

if type_norm==0
    x_n=x;
else
    x_n = (x-min_x)/(max_x-min_x)+min_norm;
end

end