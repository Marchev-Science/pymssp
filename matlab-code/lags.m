function [x_hen]=lags(x,lags)

%% Docs
% Making lag variables from x
% where
% x is single variable data input
% lags is number of lags to be shifted including 0 lag

%% Size check
limit=(lags-1)^2;

%% Calculate
h=hankel(x);
% if size(x,1)<limit
   x_hen=h(1:(size(h,1)-(lags-1)),1:lags);
% else
%    x_hen=h(1:limit,1:lags);
% end