function Score = FEs(algorithm,problem,M,D,run,group)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明


currentDepth = 2;                               % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));    % get current path
fsep = filesep;
pos_v = strfind(currPath,fsep);
p = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1); 

Score = zeros(run,group);

for i = 1:run
    
    load(fullfile(p,'Data',problem,'ComponentAnalysis',sprintf('%s_%s_M%d_D%d_%d.mat',algorithm,problem,M,D,i)));
    
    for j = 1:group
    
        Feasible     = find(all(result{j,2}.cons<=0,2));  % 找出每次运行最后一代种群中约束违背为0的个体
    
        NonDominated = NDSort(result{j,2}(Feasible).objs,1) == 1; % 找出每次运行最后一代种群中非支配等级为1的个体
    
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