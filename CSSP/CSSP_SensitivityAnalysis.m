% % % %% 运行前修改保存路径
% runtime         = 20;
% 
% M               = [3,5,8];
% 
% N               = [120,210,240];
% 
% evaluation      = [30000,50000,80000];
% 
% coefficient     = {0.01,30};
% 
% % coefficient ={0,0.1,0.2,0.01,0.1,0.2,0.5,0.8,0.9,1};
% 
% % coefficient     ={0,0.01,0.1,0.5,1,2,5,10,20,30};
% 
% for i = 2:length(coefficient)
% 
%     problem =str2func('CSSP');
% 
% for j = 2:length(M)
%     
%     for l = 1:4
% 
%         for k = 1 : runtime
%             
%             main('-algorithm',@MOEAAES3, '-problem',problem,'-coefficient',coefficient{i},...
%                 '-M',M(j),'-N',N(j),'-evaluation',evaluation(j),'-TEST',l,'-run',k,'-save',1);
%             
%         end
%     end
% 
% end
% 
% end

%% Result group

% algorithm = 'MOEAAES3';
folder =  fileparts(mfilename('fullpath'));

problem     = 'CSSP';

algorithm   = {'MOEAAES','NSGAIII','RVEA','MOEADD','onebyoneEA','MOMBIII','KnEA','tDEA'};

M           = [3,5,8];

runtime     = 20;

coefficient = {0,0.01,0.1,0.5,1,2,5,10,20};

s ='cbkm'; % 颜色属性

color = [0.49 0.18 0.56;
    0 0.45 0.74;
    71/256 51/256 53/256;
    189/255 30/255 30/255];

u ='d*spvxp'; % 点标记属性

v ={'-','-','-','-','-',':','-.'};%线型

for i = 3:length(M)
    
    MeanHV = [];MeanIGD = [];
    
    for group = 1:4
        
        [user,~,~,~,~,D]             = TestCase(group);  % 决策变量的个数
        
        [HV_index,IGD_index]         =  cal_HV(algorithm,problem,M(i),user,D,runtime,group,coefficient);
        
        MeanHV                       = [MeanHV;mean(HV_index)];
        
        MeanIGD                      = [MeanIGD;mean(IGD_index)];
        
    end
    folder =  fileparts(mfilename('fullpath'));
    fontsize = 7;
    figure(1);
    for j = 1:4
        plot(MeanHV(j,:),[s(j),u(j),v{j}],'Color',color(j,:),'MarkerSize',3.5,'Linewidth',0.8,'MarkerFaceColor',color(j,:));       
        hold on;
    end
    legend({'g1','g2','g3','g4'},'Location','SouthWest');
    set(gcf,'unit','centimeters','position',[10 5 9 9]);
    set(gca,'xticklabel',coefficient,'Fontsize',fontsize );% 'XTickLabelRotation',46,
    set(gca,'LooseInset',get(gca,'TightInset'));
    if M(i) == 5
        tag = '(a)';
    else
        tag = '(c)';
    end
    xlabel({'\lambda',tag},'Fontname','Times New Roman','Fontsize',fontsize );
    ylabel('HV','Fontname','Times New Roman','Fontsize',fontsize );
    title(['HV with ', num2str(M(i)),' objective for group 1-4'],'Fontsize',fontsize );
    print(gcf,'-dtiff','-r600',[folder,'\HV-M',num2str(M(i))]);
    
    figure(2);
%     subplot(1,2,2);
    for j = 1:4
        plot(MeanIGD(j,:),[s(j),u(j),v{j}],'Color',color(j,:),'MarkerSize',3.5,'Linewidth',0.8,'MarkerFaceColor',color(j,:));
        hold on;
    end
    legend({'g1','g2','g3','g4'},'Location','NorthWest');
    set(gcf,'unit','centimeters','position',[10 5 9 9]);
    set(gca,'xticklabel',coefficient,'Fontsize',fontsize );% 'XTickLabelRotation',46,
    set(gca,'LooseInset',get(gca,'TightInset'));
    title(['IGD with ', num2str(M(i)),' objective for group 1-4']);
    if M(i) == 5
        tag = '(b)';
    else
        tag = '(d)';
    end
    xlabel({'\lambda',tag},'Fontname','Times New Roman','Fontsize',fontsize );
    ylabel('IGD','Fontname','Times New Roman','Fontsize',fontsize );
    print(gcf,'-dtiff','-r600',[folder,'\IGD-M',num2str(M(i))]);
    
end







function [HV_index,IGD_index] =  cal_HV(algorithm,problem,M,user,D,runtime,group,coefficient)

currentDepth = 2;                               % get the supper path of the current path
currPath = fileparts(mfilename('fullpath'));    % get current path
fsep = filesep;
pos_v = strfind(currPath,fsep);
p = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1);


for i = 1:length(algorithm)
          
     A =[];
     
     if i ~=1
     
         folder = fullfile(p,'Data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);
         
         for j = 1:runtime
             
             filename = [folder,'\',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,D,num2str(j))];
             
             load( filename );
             
             A = [A;result{1,2}'];
             
         end
         
     else 
         
         folder = fullfile(p,'Data',problem,algorithm{1,1},['SensitivityAnalysis',num2str(group)]);
         
         for j = 1:runtime
             
             filename = fullfile(folder,sprintf('%s_%s_M%d_D%d_%d_%s.mat',algorithm{1,1},problem,...
                 M,D,j,num2str(coefficient{i})));
             
             load(filename);
             
             A = [A;result{1,2}'];
         end
         
     end

Nondominated     = NDSort(A.objs,1) == 1; 
     
NondomIndividual = A(Nondominated,:);

allalgorithm{i,:} = {[algorithm{1,i},'_U',num2str(user)],NondomIndividual}; 
             
end


%% 计算所有算法结合的truePareto

allal =[]; 

for i = 1:length(algorithm) 
    
    allal = [allal;allalgorithm{i,1}{1,2}];  
    
end

FN         = NDSort(allal.objs,1) == 1;

truePareto = allal(FN,:);

TPS        = unique(truePareto.objs,'rows','stable');


folder     = fullfile(p,'Data',problem,algorithm{1,1},['SensitivityAnalysis',num2str(group)]);

HV_index   = zeros(runtime,length(coefficient));

IGD_index   = zeros(runtime,length(coefficient));

for i = 1:length(coefficient)
    
    for j = 1:runtime
        
        filename = fullfile(folder,sprintf('%s_%s_M%d_D%d_%d_%s.mat',algorithm{1,1},problem,...
            M,D,j,num2str(coefficient{i})));
        
        load(filename);
        
        Nondominated       =  NDSort(result{1,2}.objs,1) == 1;
        
        NondomIndividual   =  result{1,2}(Nondominated);
        
        NDS                =  unique(NondomIndividual.objs,'rows');
        
        HV_index(j,i)      =  HV(NDS,TPS);
        
        IGD_index(j,i)     =  IGD(NDS,TPS);
        
    end
    
    
end
figure;
boxplot(HV_index,'labels',coefficient);
set(gca,'XTickLabelRotation',46,'Fontsize',8);
xlabel('\lambda','Fontsize',8);ylabel('HV','Fontsize',8);
title([num2str(M),'-objective for group 1']);
set(gcf,'unit','centimeters','position',[10 5 8 6]);
print(gcf,'-dpng','-r600',[folder,'\HV-M',num2str(M)]);


figure;
boxplot(IGD_index,'labels',coefficient);
set(gca,'XTickLabelRotation',46,'Fontsize',8);
xlabel('\lambda','Fontsize',8);ylabel('IGD','Fontsize',8);
title([num2str(M),'-objective for group 1']);
set(gcf,'unit','centimeters','position',[10 5 8 6]);
print(gcf,'-dpng','-r600',[folder,'\IGD-M',num2str(M)]);


fprintf('%d目标案例的第%d组已经完成了',M,group);


end




