function mre=xvalid(f,y,test_size)

%% Docs

% Calculate mean relative error of model f compared to data y, using l size
% of test set
% where:
% f - calculated values by model
% y - real data values
% test_size - relative size of test set
% mre - 1 by 2 vector
% mre(1,1) - interpolation error
% mre(1,2) - extrapolation error

%% Train & validation

lsize=round(size(y)*test_size);

trainy=y(1:size(y,1)-lsize);

trainf=f(1:size(f,1)-lsize);


%% Validation

if test_size==1
   mre(1,1)=1;
else
    %mre(1,1)=mean(abs(f(1:size(trainy,1))./y(1:size(trainf,1))-1));
    mre(1,1)=sum(abs(f(1:size(trainy,1))-y(1:size(trainf,1))))./sum(abs(y(1:size(trainf,1))));
end

if test_size==0
   mre(1,2)=1;
else
   %mre(1,2)=mean(abs(f(size(f,1)-lsize:size(f,1))./y(size(y,1)-lsize:size(y,1))-1));
   mre(1,2)=sum(abs(f(size(f,1)-lsize:size(f,1))-y(size(y,1)-lsize:size(y,1))))./sum(abs(y(size(y,1)-lsize:size(y,1))));
end

end