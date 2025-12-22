mre_int=log_table.mre_int;
mre_ext=log_table.mre_ext;

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
plot(mre_ext,'DisplayName','mre_ext');
hold on;
plot(mre_int,'DisplayName','mre_int');
hold off;

xlim(axes1,[0 size(mre_int,1)]);
ylim(axes1,[0 max(mre_ext)])%((sz+2*ssize+1):end))]);
box(axes1,'on');
set(axes1,'XGrid','on','YGrid','on','YScale', 'log');

legend('mre\_ext', 'mre\_int', 'Location', 'northeast');
