research_vars={'casen','type_norm_x','type_norm_y','mre_int','mre_ext','nrow','solrow','time','rem'};
vars_type={'uint8','uint8','uint8','double','double','uint16','uint16','double','string'};
research_table=table('Size',[9 9],'VariableTypes',vars_type,'VariableNames',research_vars);

research_table.casen=[1;2;3;4;5;6;7;8;9];
research_table.type_norm_x=[0;0;0;1;1;1;2;2;2];
research_table.type_norm_y=[0;1;2;0;1;2;0;1;2];
research_table.mre_int=[Inf;0.005622396;0.006176776;Inf;0.007690637;0.008325181;Inf;0.005992798;0.006450215];
research_table.mre_ext=[0.141684816;0.027509429;0.022140933;0.08769145;0.069976513;0.132392289;0.041885889;13.80608205;0.067448564];
research_table.nrow=[69;102;117;69;115;124;69;87;91];
research_table.solrow=[1540;1550;1550;1540;1592;1570;1540;1591;1540];
research_table.time=[11.998621;8.546457;9.040092;10.364684;8.334472;8.574775;10.119575;11.430326;25.343896];
research_table.rem=[{'chart chaos'};{'sinx/lin only'};{'sinx/lin only'};{'chart chaos'};{'lgn/rex mainly'};{'lgn/rex mainly'};{'chart chaos'};{'rey/pow mainly'};{'rey mainly'}];

clearvars vars_type research_vars