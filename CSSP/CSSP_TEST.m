% %%  数据生成
% for i = 1:16
%     
%     main('-algorithm',@NSGAIII, '-problem',@CSSP,'-M',5,'-N',120,'-TEST',i,'-run',1,'-save',1);
%     
% end

%%  数据测试

runtime = 20;

M       = [3,5,8];

N       = [120,210,240];

evaluations = [30000,50000,80000];

for k = 2:length(M)-1
    
for i = 1:2
    
    for j = 1 : runtime
        
%         main('-algorithm',@MOEAAES,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-coefficient',0.1,'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MaOEADES,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-coefficient',0.2,'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@VariantI,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-coefficient',5,'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@NSGAIII,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@tDEA, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@RVEA,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MOEADD, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@onebyoneEA,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@MOMBIII,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%         main('-algorithm',@KnEA, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
%          main('-algorithm',@SRA, '-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',i,'-run',j,'-save',1);
    
    end
    
end

end


%% 指标比较

problem             = 'CSSP';

algorithm           = {'MOEAAES','MaOEADES','NSGAIII','RVEA','MOEADD','onebyoneEA','MOMBIII','KnEA','tDEA'};

M                   =  [3,5,8];

runtime             =  1;

Q                   =  2;

statis_res          = {};

statis_res.IGD(1,:) = [' ',algorithm];statis_res.GS(1,:) = [' ',algorithm];

statis_res.HV(1,:)  = [' ',algorithm];statis_res.SM(1,:) = [' ',algorithm];

statis_res.Time(1,:) = [' ',algorithm];

for k = 2:length(M)-1
    
    for i = 1:1
        
        [user,~,~,~,~,NoV]  = TestCase(i);  % 决策变量的个数
        
        Metrics             = AlgorithmsEvaluate(problem,algorithm,M(k),user,runtime,NoV,i);
        
        statis_res.IGD(Q,:) = Metrics.IGD;statis_res.HV(Q,:)  = Metrics.HV;
        
        statis_res.GS (Q,:) = Metrics.GS; statis_res.SM(Q,:)  = Metrics.SM;
        
        statis_res.Time(Q,:)= Metrics.time;
        
                       Q    =  Q + 1;
                       
    end
    
%     CSSP2excel(statis_res,M(k));
    
    timeplot(statis_res.Time,algorithm,M,1);
    
end







