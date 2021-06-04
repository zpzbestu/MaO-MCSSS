function Score = FEs(algorithm,problem,M,D,run,group)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


currentDepth = 2;                               % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));    % get current path
fsep = filesep;
pos_v = strfind(currPath,fsep);
p = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1); 

Score = zeros(run,group);

for i = 1:run
    
    load(fullfile(p,'Data',problem,'ComponentAnalysis',sprintf('%s_%s_M%d_D%d_%d.mat',algorithm,problem,M,D,i)));
    
    for j = 1:group
    
        Feasible     = find(all(result{j,2}.cons<=0,2));  % �ҳ�ÿ���������һ����Ⱥ��Լ��Υ��Ϊ0�ĸ���
    
        NonDominated = NDSort(result{j,2}(Feasible).objs,1) == 1; % �ҳ�ÿ���������һ����Ⱥ�з�֧��ȼ�Ϊ1�ĸ���
    
        Population   = result{j,2}(NonDominated);
    
        Score(i,j)   = HV(Population.objs,Population.objs);
    end

end

AvgScore = mean(Score,1);


% 
x = 1:group;
% 
y = AvgScore;

plot(x./10^(-3),y,'r-o');

xlabel('FEs');ylabel('HV');

end

% x = 1:50;s
% % 
% y = AvgScore;
% 
% cftool(x,y)

% f = polyfit(x,y,2)