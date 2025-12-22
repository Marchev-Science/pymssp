function [gener,mre,a]=genx(x,y,test_size,parallel,nopowercross)

%% Docs
% Generation of new population through exhaustive crossing
% where
% x is the calculated data set from previous selection
% y is dependent data
% test_size is the relative size of the test subset in percent, should begener
%  less than 0.5
% parallel is parameter wheather to use the parallel computing
% nopowercross if=1, cross non-linear as well as linear

%% Initialization 

x2=x;

sz=size(x,2);

comb=nchoosek(sz,2);

gener_lin=zeros(size(y,1),comb);

gener_pow=zeros(size(y,1),comb);

mre_lin=zeros(comb,2);

mre_pow=zeros(comb,2);

a_lin=zeros(comb,3);

a_pow=zeros(comb,3);

% s=0;

permu=nchoosek(1:sz,2);

%% Calculation

for i=1:comb   %#ok<FORPF>
    [gener_lin(:,i), mre_lin(i,:),a_lin(i,:)]=...
        xross(x(:,permu(i,1)),x2(:,permu(i,2)),y,test_size,parallel);
    if mod(i/10000, 1) == 0
    fprintf('%i / %i generation, %f \r\n',i,(2-nopowercross)*comb,toc);
    end
end
if nopowercross==0
for i=1:comb   %#ok<FORPF>
    [gener_pow(:,i), mre_pow(i,:),a_pow(i,:)]=...
        xrosspow(x(:,permu(i,1)),x2(:,permu(i,2)),y,test_size,parallel);
    if mod(i/10000, 1) == 0
    fprintf('%i / %i generation, %f \r\n',i+comb,(2-nopowercross)*comb,toc);
    end
end
gener=[gener_lin gener_pow];

mre=[mre_lin; mre_pow];

a=[a_lin; a_pow];

else
gener=gener_lin;

mre=mre_lin;

a=a_lin;

end

% for i=1:sz %#ok<FORPF>
%     for j=1:sz
%         s=s+1;
%         [gener(:,s), mre(s,:),a(s,:)]=xross(x(:,i),x2(:,j),y);
%     end
% end
% 
% for i=1:sz %#ok<FORPF>
%     for j=1:sz
%         s=s+1;
%         [gener(:,s), mre(s,:),a(s,:)]=xrosspow(x(:,i),x2(:,j),y);
%     end
% end


end