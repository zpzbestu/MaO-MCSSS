function ins = AlgorithmsEvaluate(problem,algorithm,M,user,runtime,NoV,Q)
% 计算 算法指标IGD和HV
%   先生成True Pareto

allalgorithm = cell(length(algorithm),1);
currentDepth = 2;                               % get the supper path of the current path
currPath     = fileparts(mfilename('fullpath'));    % get current path
fsep         = filesep;
pos_v        = strfind(currPath,fsep);
p            = currPath(1:pos_v(length(pos_v)-currentDepth+1)-1); % -1: delete the last character '/' or '\'


for i = 1:length(algorithm)
          
     A =[];
     
     folder = fullfile(p,'Data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);

     for j = 1:runtime

         filename = [folder,'\',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,NoV,num2str(j))];

         load( filename );                                   

         A = [A;result{1,2}']; 
         
     end
     
Nondominated     = NDSort(A.objs,1) == 1; 
NondomIndividual = A(Nondominated,:);
allalgorithm{i,:}= {[algorithm{1,i},'_U',num2str(user)],NondomIndividual}; 
             
end

%% 计算所有算法结合的truePareto

allal =[]; 

for i = 1:length(algorithm) 
    
    allal = [allal;allalgorithm{i,1}{1,2}];  
    
end

FN         = NDSort(allal.objs,1) == 1;

truePareto = allal(FN,:);

TPS        = unique(truePareto.objs,'rows','stable');


%% 目标函数的相关系数分析
% TPS_normal = (TPS-min(TPS,[],1))./repmat(max(TPS)-min(TPS),size(TPS,1),1);

TPS_normal = TPS;
TPS_normal(:,3) = 1./TPS(:,3);
TPS_normal(:,4) = 1./TPS(:,4);

if M==5
    
    order = [1 3 4 2 5];
    
else
    
    order = [1 3 4 2 5 8 6 7];
    
end

TPS_normal = TPS_normal(:,order);

% 生成表格，按列生成

result_table=array2table(TPS_normal);
writetable(result_table,'D:\Matlab2019b\bin\matlab代码\PlatEMO-master\PlatEMO\Problems\CSSP\paiplot\temp.csv'); 

%% 画出每个算法的得出的目标函数的箱线图
f = {'CT','SQ','SR','CC','EC','LC','WL','WT'};

if Q == 1 && runtime ==1
    
    figure;
    
    ha = tight_subplot(2,4,[0.06,0.045],[0.06,0.03],[0.05,0.02]);
    
    for i = 1:M
        
        Obj = [];group = [];
        
        for j = 1:length(algorithm)
            
            u     = allalgorithm{j,1}{1,2}.objs;
            
           % order = [1 3 4 2 5 8 6 7];
            u      = u(:,order);
            
            group = [group;repmat({num2str(j)},length(u),1)];
            
            if i==2 || i==3
                Obj   = [Obj;1./u(:,i)];
            else
                Obj   = [Obj;u(:,i)];
            end
        end
        
        axes(ha(i));
        h = boxplot(Obj,group);
%         set(h,'LineWidth',0.8);
        fontsize = 8;
        ylabel(f{1,i},'Fontsize',fontsize,'Fontname','Times New Roman');
        set(gca,'xticklabel',algorithm,'XTickLabelRotation',46,'Fontname','Times New Roman','Fontsize',fontsize,'LineWidth',0.5);
        hold on;
    end
    set(gcf,'unit','centimeters','position',[10 5 19 11.7]);
    savefig([currPath,'\output\solution for group',num2str(Q),'.fig']);
    print(gcf,'-djpeg','-r600',[currPath,'\output\solution for group',num2str(Q)]);
end


% g=1;
% figure;
% ha = tight_subplot(M,M,[0.001,0.001],[0.1,0.01],[0.05,0.02]);
% 
% for q = 1:M
%     
%     for r = 1:M
%         
%         axes(ha(g));
%         s = get(ha(g),'position');
%         correc   = corr(TPS_normal(:,q), TPS_normal(:,r), 'type' , 'Spearman');
%         text(s(1)+s(3),s(2)+s(4),num2str(round(correc,2)));
%         if q== r % 归一化的直方图
% %             [histFreq, histXout] = hist(TPS_normal(:,q), 10);
% %             binWidth = histXout(2)-histXout(1);
% %             bar(histXout, histFreq/binWidth/sum(histFreq)); 
%             histogram(TPS_normal(:,q));
%         else
%             
%             plot(TPS_normal(:,q),TPS_normal(:,r),'m.');
%             
%         end
%         
%         fontsize = 6; 
%         if r==1 && q~=M
%             set(gca,'xticklabel',[],'Fontsize',fontsize);
%             ylabel(['f_',num2str(q)],'Fontname','Times New Roman');
%         elseif q == M && r~=1
%             set(gca,'yticklabel',[],'Fontsize',fontsize);
%             xlabel(['f_',num2str(r)],'Fontname','Times New Roman');
%         elseif r==1 && q == M
%             set(gca,'Fontsize',fontsize);
%             ylabel(['f_',num2str(q)],'Fontname','Times New Roman'); 
%             xlabel(['f_',num2str(r)],'Fontname','Times New Roman');
%         else
% %             set(gca,'xlim',[min(TPS_normal(:,r))*0.5,max(TPS_normal(:,r))*1.5],'ylim',[min(TPS_normal(:,q))*0.5,max(TPS_normal(:,q))*1.5]);
%             set(gca,'yticklabel',[],'xticklabel',[],'Fontsize',fontsize); 
%         end
% %         legend(['',num2str(round(correc,2))],'Location','NorthWest')
%         
%         hold on;
%         g=g+1;
%     end
% end
% % set(gcf,'unit','centimeters','position',[10 1 19 16]);
% print(gcf,'-dpng','-r900',[currPath,'\corre for group',num2str(Q)]);




%%  --------->>>>>>>  计算每次运行后的IGD  HV

Metrics = {};

% smaller is better

IGD_index  = zeros(runtime,length(algorithm));  

GS_index   = zeros(runtime,length(algorithm));  

SM_index   = zeros(runtime,length(algorithm));

Time_index = zeros(runtime,length(algorithm));

% larger is better
HV_index   = zeros(runtime,length(algorithm));    

for i = 1:length(algorithm)
    
    folder = fullfile(p,'Data',problem,algorithm{1,i},[algorithm{1,i},'_U',num2str(user)]);
          
    for j = 1:runtime
        
        filename = [folder,'\',sprintf('%s_%s_M%d_D%d_%s.mat',algorithm{1,i},problem,M,NoV,num2str(j))];
           
        load(filename);
         
        Nondominated       =  NDSort(result{1,2}.objs,1) == 1; 
        
        NondomIndividual   =  result{1,2}(Nondominated); 
        
        NDS                =  unique(NondomIndividual.objs,'rows');
        
%         NDS                =  (NDS - min(TPS,[],1))./repmat(max(TPS,[],1)-min(TPS,[],1),size(NDS,1),1);
%         
%         TPS1               =  ones(1,M);
         
        IGD_index(j,i)     =  IGD(NDS,TPS);
         
        HV_index(j,i)      =  HV(NDS,TPS); 
        
        GS_index(j,i)      =  Spread(NDS,TPS);
        
        SM_index(j,i)      =  Spacing(NDS,TPS);
        
        Time_index(j,i)    =  metric.time;
             
    end
    
           
end

ins.IGD = CSSPresult(IGD_index,'min',algorithm,Q);

ins.HV  = CSSPresult(HV_index,'max',algorithm,Q);

ins.GS  = CSSPresult(GS_index,'min',algorithm,Q);

ins.SM  = CSSPresult(SM_index,'min',algorithm,Q);

ins.time  = CSSPresult(Time_index,'min',algorithm,Q);

fprintf('=====================Test%d has finished !! ======================\n',Q);

end

