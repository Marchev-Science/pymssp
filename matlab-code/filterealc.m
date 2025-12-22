function filtered_idx = filterealc(matrix)
% Mark columns NOT containing at least one NaN, Inf or complex number
% and return the remaining columns
summ=sum(matrix,1);
real_mask=logical(zeros(size(summ))); %#ok<LOGL> 
for i=1:length(summ)
    real_mask(1,i) = isreal(summ(1,i));
end
nan_mask = ~isnan(summ);
inf_mask = ~isinf(summ);
filtered_idx = any(real_mask & nan_mask & inf_mask, 1);
end
