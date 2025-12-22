function predictionchart(y, f, mre)

%% Docs
% Create chart prediction vs real data with extrapolated data points
% where:
% y is real data
% f is prediction
% mre is mean relative error for the prediction

%% Initial calculations

high=f+mre;
low=f-mre;

bound=size(y,1);

if size(f,1)>size(y,1)
    fill=size(f,1)-size(y,1);
    y=[y; nan(fill,1)];
else
end

YMatrix1= [y high low f];

%% Create figure

figure1 = figure('units','pixels','position',[0,0,1600,900]);
% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Real Data','LineWidth',3);
set(plot1(2),'DisplayName','Mean relative error','LineWidth',6,...
    'Color',[0.992156863212585 0.917647063732147 0.796078443527222]);
set(plot1(3),'DisplayName','Mean relative error','LineWidth',6,...
    'Color',[0.992156863212585 0.917647063732147 0.796078443527222]);
set(plot1(4),'DisplayName','Predicted data','MarkerSize',8,'Marker','x',...
    'LineWidth',2,...
    'LineStyle','--',...
    'Color',[1 0 0]);

%% Format chart

% Create xlabel
xlabel('Time steps');

% Create title
title('Real vs. Predicted data');

box(axes1,'on');

xlim(axes1,[0 size(f,1)]);
% Set the remaining axes properties
set(axes1,'XGrid','on','XTick',...
    [(0:1:size(f,1))],'YGrid','on');
% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','best');


%% Limit Ys
HWHM = 3.53; % Half width at half maximum
pos = get(gca, 'Position');

% Positins for the end of the Arrow in data units.
    xPosition = bound;
     % Create a textarrow annotation at the coordinates in data units
    % the textarrow coordinates are given [end_x, head_x], [end_y, head_y]
annotation(figure1,'line',[(xPosition + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1),...
         (xPosition + abs(min(xlim)))/diff(xlim) * pos(3) + pos(1)],...
    [0.11 0.93],'Color',[1 0 1],'LineStyle','--');

%% Save to PNG

saveas(gcf,'covid-messp-predict.png')