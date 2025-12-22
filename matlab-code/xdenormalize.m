function x = xdenormalize(x_n, min_x, max_x, type_norm,min_norm)

%% Docs
% Denormalize x through method of feature scaling between [min_x, max_x],
% where:
% x_n - scaled data
% min_x - min(x) which was calculated when normalizing
% max_x - max(x) which was calculated when normalizing
% Note: min_x & max_x must be corresponding to x, obtained at normalizing
% x - n-by-1 unscaled data
% min_norm is the lowest number of x_n
% type_norm - type of normalization, where:
% 0 - no normalization
% 1 - between [min_norm,min_norm+1]
% Note: the denormalization must match the type_norm

%% Initialize


%% Calculate

if type_norm==0
    x=x_n;
else
    x = min_x+x_n*(max_x-min_x)-min_norm;
end

end