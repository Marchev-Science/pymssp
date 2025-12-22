function r=ranking(data,order)

%% Docs
% Ranking of list of numbers
% where
% data is n-by-1 vector of numbers
% order represents requrement for order, 0 = descending, 1 = ascending

%% Preliminary transformation
isre=filterealc(data');
% for i=1:length(data)
%     isre(i,1)=isreal(data(i,1));
% end

real_data = data(isre==1);  % extract real numbers
complex_data = data(isre==0);  % extract complex numbers

%% Calculation
if order==0
    [~,p1] = sort(real_data,'ascend', 'ComparisonMethod','real');
    [~,p2] = sort(complex_data,'ascend', 'ComparisonMethod','real');
else
    [~,p2] = sort(real_data,'descend', 'ComparisonMethod','real');
    [~,p1] = sort(complex_data,'descend', 'ComparisonMethod','real');
end
p=[p1;p2];
%[~, ~, ic] = unique(data,'stable'); also works with repeated data, but not real ranking  
r = 1:length(data);
r(p) = r;
r=r';

end