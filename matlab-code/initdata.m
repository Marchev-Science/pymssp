    %% to do
% ppt: self-org: Heinz von Foerster & Gordon Pask, Erich Jantsch, Ilya Prigogine, Fridrich Hayek, ?Per Bak, ?Herman Haker
% ppt: used methods: Bayes, Babage, Kolmogorov, Shannon, Bertalanfy, Stafford Beer external addition
% ppt: celluar automata(?John Conway), Genetic Algo (?John Holland),
%  Evolutional algo, Swarm intelligence, ?Artificial life
% ppt: Richard Dawkins/ biomorphs + other ideas
% ppt: comparison w/ : optimization, stochastic optimization, heuristic
%  optimisations
%
% mre as separate function
% option for weightening the latest data points
% random data points for validation (for cross section analysis)
% cross validation
% split forecast & gentree into functions
% chart as separate function
% create primitives as a function
% while multistage as a function
% all while criteria as functions
% all analyses as functions
% main file (initdata) as a function (multiple Ys)
% normalize better?
% analysis
% export to functions what is possible
% error check all functions
% review/expand of all docs in functions
% warnings
% organize git
%
% while criteria (n, time, min mre, average of generation, progress serror)
% cross w/ previous generations
% multiple Ys (one by one)(all non-currently Ys, are Xs)
% live charting - styling - intermediate charts semi-transparent
% 3d chart Xs
% notificatins while working & final song
% milena data set market depth
%
% profiller
% vectorize & remove loops as many as possible
% multitread
% gpu
% tall arrays
% GUI
% matlab toolbox
%
% soft selection criteria (in stead of number of solutions, solutions
%  corresponding a criterion
% polynomials (Kolmogorov-gabor, or other)
% validation method, apart from pseudo-forecasting (bootstrapping, random sampling)
% entirely sine functions (like Fourier transform)
% bayes rules MSSP
% classification - logistic regression (binary), poisson regression
%  (multiclass)
% once adjusted model - use in real time (w/ streaming data)


%% Initializationheight(log_table)
tic
clearvars

format long %rat

set(0,'DefaultFigureWindowStyle','docked')

lagn=6;

test_size=.2;

modlst={'lin';'lgn';'xpy';'pow';'rex';'rey';'sqr'};

sine_x=0;

nfun=size(modlst,1);

iter_limit=5;

autoreg=0;

nopowercross=0;

set_ssize=0;%set to 0 for auto set, 1 for setting it next line
ssize=100; %set number of selected ... not finished: error in gentree

disc=1/12;%unit of discretization

stamre_req = 0.0000005;

type_norm_x=1;
type_norm_y=0;
min_norm=1;

parallel=0;

if parallel==1
% Check if a parallel pool is already running
poolobj = gcp('nocreate');
    if isempty(poolobj)
    % If no pool is running, create a new one
        parpool();
    else
    % If a pool is already running, don't create a new one
    disp('A parallel pool is already running.');
    end
end

%warning('off', 'MATLAB:rankDeficientMatrix');
warning('off', 'all');
%% Data read
%read_covid;
% load('test_data.mat')
[x,y] = readmpudata('7. France.xlsx');
% [x,y] = readmpudata('22. Romania.xlsx');
% [x,y] = readmpudata('17. Spain.xlsx');
% [x,y] = readmpudata('25. Sweden.xlsx');
% [x,y] = readmpudata('28. Norway.xlsx');
% [x,y] = readmpudata('33. United States.xlsx');
% [x,y] = readmpudata('34. Japan.xlsx');
% [x,y] = readmpudata('41. Bulgaria.xlsx');
% [x,y] = readmpudata('39. Euro area (12 countries).xlsx');
% covid = xlsread('covid_daily_new_global.xls');
% x=covid(:,1);
% y=covid(:,2);
%y=datapf(:,1);
%x=datapf(:,2:end);

% %%=================
% %Innoair travels
%  data = readtable('/home/junior/development/innoair-2/ts_in_zone_0.csv');
%  data(data.datetime.Hour > 23 | data.datetime.Hour < 5, :) = [];
%  pydatetime = data(:, 'datetime'); % Get the column of data named 'x'
% x_sing = datenum(pydatetime.datetime); %#ok<DATNM> 
%  horizont=60;
%  logic_vector=[0 0 0 0 1 1 1 1 1 1 1];
%  x=datefeatures(data.datetime,0,logic_vector);
% 
% % x(:,1)=floor(dates_hours);
% % x(:,2)=mod(dates_hours,1);
% y = table2array(data(:, 'CNT_PEOPLE')); % Get the column of data named 'y'
% 
% y(y == 0) = 2;%randi(4);%2;
% clearvars pydatetime data
% %%==================

x_raw=x;
y_raw=y;


sz1=size(x,1);
sz2=size(x,2);
sz3=size(y,2);

if autoreg==1
    sz=lagn*(sz2+sz3)-1;
else
    sz=lagn*sz2;
end

if set_ssize==0
if sine_x==1
    ssize=sz*nfun*2; %size of selection
else
    ssize=sz*nfun;
end
end

%% Data prep

y_data=y(lagn:end,:);
%y_data=y(1:sz1-lagn+1,:);

if autoreg==1
x=[y x];
else
sz=lagn*sz2;
end

min_x=zeros(size(x,2),1);
max_x=zeros(size(x,2),1);

for i=1:size(x,2) %#ok<FORPF> % normalizing
    [x(:,i), min_x(i), max_x(i)] = xnormalize(x(:,i),type_norm_x,min_norm); 
end

min_y=zeros(size(y_data,2),1);
max_y=zeros(size(y_data,2),1);

for i=1:size(y_data,2) %#ok<FORPF> % normalizing
    [y_data(:,i), min_y(i), max_y(i)] = xnormalize(y_data(:,i),type_norm_y,min_norm); 
end


for i=1:size(x,2) %#ok<FORPF>
    m=x(:,i);
    x_data(:,(lagn*i-(lagn-1)):(i*lagn))=lags(m,lagn);
end

if autoreg==1
x_data(:,1)=[]; % delete unlagged Y data
else
end

clearvars sz1 i m

%% Chart initialize

% figure1 = figure;
% axes1 = axes('Parent',figure1);
% hold(axes1,'on');
% xlim(axes1,[1 size(x_data,1)]);
% ylim(axes1,[min(y_data) max(y_data)]);
% box(axes1,'on');
% set(axes1,'XGrid','on','YGrid','on');
% axes1.NextPlot = 'replacechildren';

%% Logging table

logvars={'generator','gener_num','parent1','parent2','a0','a1','a2','mre_int','mre_ext','rank','select'};
logvars_type={'string','uint8','uint16','uint16','double','double','double','double','double','double','logical'};
logtable=table('Size',[0 11],'VariableTypes',logvars_type,'VariableNames',logvars);
logtable_x=logtable;
logtable_f=logtable;
logtable_g=logtable;

combvny=combvec((1:lagn)-1,1:sz3)';
combvnx=combvec((1:lagn)-1,1:sz2)';

if autoreg==1
    combvn=[combvny; combvnx];
else
    combvn=combvnx;
end
%combvn(1,:)=[]; % delete unlagged Y data
combvn(:,3)=combvn(:,1).*combvn(:,2);
zcombv=find(combvn(:,3)==0);

j=1;

for i=1:size(combvn,1) %#ok<FORPF>
    if combvn(i,3)==0
        combvn(i,3)=zcombv(j);
        j=j+1;
    else
        combvn(i,3)=combvn(i-1,3);
    end
end
combvn(zcombv,3)=0;

if autoreg==1
    for i=1:lagn %#ok<FORPF>
        generatr=string(['y',num2str(combvn(i,2)),'_',num2str(combvn(i,1))]); 
        logtable_x=[logtable_x;{generatr,0,combvn(i,3),0,NaN,NaN,NaN,NaN,NaN,NaN,1}]; %#ok<AGROW,FORPF>
    end
    
    for i=lagn+1:size(combvn,1) %#ok<FORPF>
        generatr=string(['x',num2str(combvn(i,2)),'_',num2str(combvn(i,1))]); 
        logtable_x=[logtable_x;{generatr,0,combvn(i,3),0,NaN,NaN,NaN,NaN,NaN,NaN,1}]; %#ok<AGROW,FORPF>
    end
else
    
    for i=1:size(combvn,1) %#ok<FORPF>
        generatr=string(['x',num2str(combvn(i,2)),'_',num2str(combvn(i,1))]); 
        logtable_x=[logtable_x;{generatr,0,combvn(i,3),0,NaN,NaN,NaN,NaN,NaN,NaN,1}]; %#ok<AGROW,FORPF>
    end
end

log_table=[logtable;logtable_x];

clearvars x i y m combvn generatr logvars_type sz1 logtable logtable_g ...
    logtable_x combvny combvnx zcombv

%% Primitives

if sine_x==1
for i=1:sz %#ok<FORPF>
    x=x_data(:,i);
    fr=(i-1)*nfun*2+1;
    to=i*nfun*2;
    [f_calc(:,fr:to),mre_tmp,a]=linxmod(x,y_data,test_size,nfun,sine_x,parallel);
    
    for j=1:nfun
        zz={modlst(j),0,i+1,0,a(j,1),a(j,2),NaN,mre_tmp(j,1),mre_tmp(j,2),NaN,1};  
        logtable_f=[logtable_f;zz]; %#ok<AGROW,FORPF>
    end

    for k=nfun+1:nfun*2
        zz={"sinx",0,sz+k-nfun+1+(i-1)*nfun*2,0,a(k,1),a(k,2),NaN,mre_tmp(k,1),mre_tmp(k,2),NaN,1};  
        logtable_f=[logtable_f;zz]; %#ok<AGROW,FORPF>
    end
    clearvars mre_tmp a fr to j zz k
end
else 
for i=1:sz %#ok<FORPF>
    x=x_data(:,i);
    fr=((i-1)*nfun)+1;
    to=i*nfun;
    [f_calc(:,fr:to),mre_tmp,a]=linxmod(x,y_data,test_size,nfun,sine_x,parallel);
    
    for j=1:nfun
        zz={modlst(j),0,i+1,0,a(j,1),a(j,2),NaN,mre_tmp(j,1),mre_tmp(j,2),NaN,1};  
        logtable_f=[logtable_f;zz]; %#ok<AGROW,FORPF>
    end
    clearvars mre_tmp a fr to j zz k
end

if autoreg~=1
    logtable_f.parent1=logtable_f.parent1-1;
end

end

invalrows=table2array(logtable_f(:, [5,6,8,9]));
invalrows=filterealc(invalrows')';
logtable_f(~invalrows, :) = [];
f_calc(:,~invalrows')=[];

mre=[logtable_f.mre_int logtable_f.mre_ext];

logtable_f.rank = ranking(logtable_f.mre_int,0);

     ix = min(mre(:,1),[],1,'omitnan');
    
%     
     %plo=f_calc(:,mre(:,1)==ix);
%     
% 
%      plot(plo(:,1),'DisplayName','plo');
%      hold on;
%      plot(y_data,'DisplayName','y_data');
%      hold on;

log_table=[log_table;logtable_f];

%clearvars str i x zzz s varnam varnam logtable_f invalrows %x_data

%% Multi-stage selection
n=0;
stamre=std(mre(:,1));
sz_oldgen=sz;
%tic
while n<iter_limit  %stamre >stamre_req && n<iter_limit % 
%% Generate population
    [gener,mre,a]=genx(f_calc,y_data,test_size,parallel,nopowercross);
    
    if nopowercross==0
    generatr = repelem([{'xcross'}; {'xcrosspow'}], [size(mre,1)/2, size(mre,1)/2]);
    else
    generatr = repelem({'xcross'}, size(mre,1))';
    end

sz4=size(f_calc,2);



if set_ssize==0
    if sine_x==1
     combvn=repmat(nchoosek(1:sz4*2,2),2,1)+sz+n*sz*nfun+1;
    else
     combvn=repmat(nchoosek(1:sz4,2),2-nopowercross,1)+sz_oldgen;
    end
else
    combvn_tmp=repmat(nchoosek(1:sz4*2,2),2,1)+sz+n*sz*nfun+1;
    rand_indices = randperm(length(combvn_tmp),size(mre,1))';
    combvn = combvn_tmp(rand_indices,:);
end

     logtable_g=[table(generatr) array2table([ones(size(mre,1),1)*(n+1) combvn a mre zeros(size(mre,1),2)])];

invalrows=table2array(logtable_g(:, [5,6,7,8,9]));
invalrows=filterealc(invalrows')';
logtable_g(~invalrows, :) = [];


     logtable_g.Properties.VariableNames = logvars;
     logtable_g.rank = ranking(logtable_g.mre_int,0);
     ind=find(logtable_g.rank<ssize+1);
     logtable_g.select(ind)=1;



%% Select breeders    
    logtable_s=logtable_g;
    %logtable_s.select(ind==0)=[];
    logtable_s(logtable_s.select==0, :) = [];
    [f_calc, inx]=selec(mre(:,1), gener, ssize);
    stamre=std(logtable_s.mre_int);
    
    log_table=[log_table;logtable_s]; %#ok<AGROW>
    
    n=n+1;
sz_oldgen=sz_oldgen+sz4;
fprintf('!!!!!!!!!!!!!!!!!!!!!!!!!! %i selection, %f \r\n',n,toc);
%% Analysis    
    
%    ix=min(inx);
%    ppp=find(inx==ix);
    
%    plo=f_calc(:,ppp(1));
    
%     plot1 = plot(axes1,[plo y_data]);
%     set(plot1(1),'DisplayName','plo');
%     set(plot1(2),'DisplayName','y_data');
%     drawnow;
%     axes1.NextPlot = 'replacechildren';
%     hold on;
    
end

%clearvars a generatr ind inx ix logvars mre logtable_s plo ppp combvn logtable_g invalrows sz4 f_calc

log_table.id = (1:height(log_table)).';
log_table = log_table(:, [12 1 2 3 4 5 6 7 8 9 10 11]);
[tree_sel,symodel]=gentree(log_table,sz);


if type_norm_y==1
    y_data = xdenormalize(y_data, min_y, max_y,type_norm_y,min_norm);
else
end

% f=forecst(symodel, tree_sel, 0, x_long, lagn, y_raw,type_norm_x,type_norm_y, min_norm);
f=forecst(symodel, tree_sel, 0, x_raw, lagn, y_raw,type_norm_x,type_norm_y, min_norm);

% x_predict_axes= (max(x_raw)-(lagn*disc):disc:ceil(max(x_raw))+62)';
% x_predict_axes=[x_predict_axes,zeros(size(x_predict_axes))];
% x_predict_axes(1:lagn,2)=y_raw(end-lagn+1:end);



%f=forecst(symodel, tree_sel, 1, x_data, lagn, y_data,type_norm_x,type_norm_y, min_norm);

% plot(y_data,'DisplayName','y_data');
% xlim(axes1,[1 size(y_data,1)]);
% ylim(axes1,[min(y_data) max(y_data)]);
% box(axes1,'on');
% set(axes1,'XGrid','on','YGrid','on');
% hold on;
% plot(f,'DisplayName','f');
% hold off;
%
%plot(f,'DisplayName','f');hold on;plot(y_data,'DisplayName','y_data');hold off;

%simplify(symodel))
%expand(simplify(symodel))
%simplify(expand(symodel))
%lat_mod=latex(symodel)

%analysis
%regressfig(y_data, f)
% predictionchart(y_data, f, tree_sel.mre_ext(end))
%tree_obj = xtree(log_table,1)
%pruned_tree = xtree(tree_sel,0)
% view(tree_obj)
%view(pruned_tree)
% y=tmppp(tree_sel, disc,horizont,lagn,y_raw,x_sing,logic_vector)
toc