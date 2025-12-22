function tree_obj = xtree(log_table,colorized)
%% Docs
% Function to produce visual tree object from table object,
% where:
% log_table is table with selected solutions by generations;
% if colorized =1, put color to ancestors of best solutions
% tree_obj is a graph object for visualization of the hierarchical tree of
% best solution


%% Initialization

si=size(log_table,1);
% skip_rows=si-size(find(log_table.generator=="xcross"),1)-...
%     size(find(log_table.generator=="xcrosspow"),1);

skip_rows=0;
% skip_rows=si-size(find(log_table.generator=="xcross"),1)-...
%     size(find(log_table.generator=="xcrosspow"),1)-...
%     size(find(log_table.generator=="lin"),1)-...
%     size(find(log_table.generator=="lgn"),1)-...
%     size(find(log_table.generator=="xpy"),1)-...
%     size(find(log_table.generator=="pow"),1)-...
%     size(find(log_table.generator=="rex"),1)-...
%     size(find(log_table.generator=="rey"),1)-...
%     size(find(log_table.generator=="sqr"),1)-...
%     size(find(log_table.generator=="snx"),1);
%skip_rows=sz*9; % 1 x sz + 8 functions x sz

%% Naming solutions

for i=1:si
log_table.name(i)=strcat(log_table.generator(i),"_",...
    num2str(log_table.parent1(i)),"_",num2str(log_table.parent2(i)));
end

%% Connection matrix

con_matrix=zeros(si);

parent=cat(2,log_table.id,log_table.parent1,log_table.parent2);

for i=skip_rows+1:si
    for j=2:3
        zz=find(parent(:,1)==parent(i,j));
        con_matrix(i,zz)=1;
        con_matrix(i,zz)=1;
    end
end

con_matrix=con_matrix';

%% Rationalize connection matrix

zz1=sum(con_matrix,1)';
zz2=sum(con_matrix,2);
zz3=zz1+zz2;
index_drop=find(zz3==0);

con_matrix(index_drop,:)=[];
con_matrix(:,index_drop)=[];

%% Graph object
log_table(index_drop,:)=[];
node_id=cellstr(log_table.name);

%BGobj = digraph(con_matrix, node_id);%,'LayoutType', 'hierarchical');
BGobj = biograph(con_matrix, node_id,'LayoutType', 'hierarchical');

%% Visualize best solution

sol = find(log_table.gener_num==max(log_table.gener_num)...
    &log_table.rank==min(log_table.rank));
tree_obj_selected = getancestors(BGobj.nodes(sol), max(log_table.gener_num));

if colorized==1
set(tree_obj_selected,'Color',[1 .7 .7], 'shape', 'ellipse');
end

% % Plot the graph using a layered layout
% figure('Color', 'w');
% p = plot(BGobj, ...
%     'Layout', 'layered', ...
%     'Direction', 'down', ...
%     'NodeLabel', BGobj.Nodes.Name, ...
%     'Interpreter', 'none', ...
%     'MarkerSize', 7, ...
%     'NodeColor', [0.2 0.2 0.8], ...
%     'EdgeColor', [0.6 0.6 0.6], ...
%     'LineWidth', 1.5, ...
%     'ArrowSize', 10);
% 
% % Tweak font and label appearance
% p.NodeFontSize = 8;
% p.NodeFontWeight = 'bold';
% p.NodeLabelColor = [0 0 0];
% 
% % Highlight ancestors if requested
% sol = find(log_table.gener_num == max(log_table.gener_num) & ...
%            log_table.rank == min(log_table.rank));
% if colorized == 1 && ~isempty(sol)
%     visited = dfsearch(BGobj, sol, 'allevents');
%     ancestorNodes = unique(cell2mat(visited(strcmp(visited(:,2), 'discover'), 1)));
%     highlight(p, ancestorNodes, ...
%         'NodeColor', [1 0.6 0.6], ...
%         'Marker', 'o', ...
%         'MarkerSize', 8);
% end
% 
% title('Solution Tree (Biograph Style Approximation)', 'FontSize', 12);
tree_obj = BGobj;
% isdag(tree_obj)

end