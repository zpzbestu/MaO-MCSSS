function timeplot(time_mat,algorithms,M,group)

currPath     = fileparts(mfilename('fullpath'));    % get current path

[~,c] = size(time_mat);

time = zeros(2,c-1);

for j = 2:c
    
    s = char(time_mat(group+1,j));
    
    c = strsplit(s,'(');
    
    time(1,j-1) = str2num(c{1});
    
    s_std = strsplit(char(c(2)),')');
    
    std1 = str2num( s_std{1});
    
    time(2,j-1) = std1;
    
end

figure;

bar(time(1,:));

ylabel( 'CPU time (Sec)' );

hold on;

errorbar(time(1,:),time(2,:),'k','LineStyle','none');

for j = 1:length(algorithms)
    
    text_label = num2str(time(1,j));
    
    text(j,time(1,j)+6,text_label,'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',7);
    
end

title_name = sprintf('The average time for all MaOEAs for group %d with %d-objective',group,M);

% title(title_name);

set(gca,'xticklabel',algorithms,'XTickLabelRotation',46,'Fontname','Times New Roman','Fontsize',7,'LineWidth',0.5);

set(gca,'LooseInset',get(gca,'TightInset'))

set(gcf,'unit','centimeters','position',[10 5 10 6]);

savefig([currPath,'\output\',title_name,'.fig'])

print(gcf,'-djpeg','-r600',[currPath,'\output\',title_name]);

end

