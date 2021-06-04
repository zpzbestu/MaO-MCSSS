function [objectvalue] = Obj_CSSP(Global,pop)

%   Obj_CSSP 计算目标函数
%   总完工时间、总完工成本、服务质量、 可靠性、  总能耗
%   总负载、平均等待时间、  总物流成本

[r,c]           = size(pop);

lt = 0.008;    lc = 0.005;     le = 0.002;   % 单位距离的物流时间、物流成本、物流能耗

t  = length(Global.st);  st = Global.st;    cs = Global.cs;    user = Global.user;

ETC =   Global.ETC;

stlj = cumsum(st); stlj1=[1,stlj+1];

uer_cumsum = cumsum(Global.utasknum);

% 每个用户

userT     =  zeros(r,user);       userC       = zeros(r,user); 
userE     =  zeros(r,user);       userQ       = zeros(r,user); % 存储每个用户所有任务的完工时间和总完工成本
userR       = zeros(r,user);

%  每个任务
taskT    =  zeros(r,t);          tasksumC    = zeros(r,t);   tasksumE   =zeros(r,t);% 存储每个任务的完工时间/完工成本
taskQ    =  zeros(r,t);          taskLT      = zeros(r,t);    taskLC    =zeros(r,t);
taskR    =  zeros(r,t); 


% 总的
Makespan    =  zeros(r,1);       Completecost = zeros(r,1);    TEC      = zeros(r,1);% 存储总完工时间和总完工成本

AvgserviceQ =  zeros(r,1);        Workload    = zeros(r,1);    Idle     = zeros(r,1);

AvgserviceR =  zeros(r,1); 


P = calculateP( pop(:,c/2+1:c) );

%  每个任务属于第几个用户
yi = 1;
for i = 1:length(Global.utasknum)
    U(yi:uer_cumsum(i))= i;
    yi = uer_cumsum(i)+1;
end

%% 解码。。。

for i = 1:r
    
    % Time -----1.云企业号   2. 资源类型  3.服务时间  4.服务成本+物流成本 5.服务质量 6.服务可靠性
    
    %        7. 服务能耗 8.ST(开始时间)  9.FT(结束时间)  10. 物流成本
    
    Time = zeros(c/2,10);
    
    for u = 1:size(ETC.EInform,1)
        
        t_record{u,1} = zeros(size(ETC.EInform{u,1})); % 每个企业的每种服务的完工时间记录
        
    end
    
    %% 计算最大完工时间
    
    for j = 1:c/2
        
            x = floor(P(i,j)/10);    y = round(rem(P(i,j),10)*10); % 第x个任务的第y个子任务
            
            position = stlj1(x) + y - 1;
            
            M = pop(i,position);  % 第M个企业
            
            POSITION = find( ETC.AE(position).s == M ); % 企业的第几种资源
            
            f = ETC.AE(position).index(POSITION);  % 企业M的第f种资源
            
            Time(position,1) = M;   Time(position,2) = ETC.StInform(position,1);
            
            Time(position,3) = ETC.EInform{M,2}(f);
            
            if y == 1 
                
               Time(position,4)     = ETC.EInform{M,3}(f);% 服务成本
               
               Time(position,5)     = ETC.EInform{M,4}(f); % 服务质量
               
               Time(position,6)     = ETC.EInform{M,5}(f); % 服务可靠性
               
               Time(position,7)     = ETC.EInform{M,6}(f); % 服务能耗
               
               Time(position,8)     = t_record{M,1}(f); % 开始时间
               
               Time(position,9)     = Time(position,8) +Time(position,3) ;% 完工时间
               
               t_record{M,1}(f)     = Time(position,9);  % 企业第i种资源的时间记录
               
               Time(position,10)    = 0;  % 物流成本
               
            else  
               
               Time(position,4)          = ETC.EInform{M,3}(f)+ETC.D(Time(position-1,1),M) * lc;  % 服务成本+物流成本
               Time(position,5)          = ETC.EInform{M,4}(f);                                   % 服务质量 
               Time(position,6)          = ETC.EInform{M,5}(f);                                   % 服务可靠性
               Time(position,7)          = ETC.EInform{M,6}(f) + ETC.D(Time(position-1,1),M) * le; % 服务能耗
               Time(position,8)          = max([t_record{M,1}(f),Time(position-1,9) + ETC.D(Time(position-1,1),M)*lt]);
               Time(position,9)          = Time(position,8) + Time(position,3);  % 结束时间
               t_record{M,1}(f)          = Time(position,9);
               Time(position,10)         = ETC.D(Time(position-1,1),M) * lc;
               
           end

    end 
    
    % 计算每个任务的完工时间、完工成本
    
    q = 1;
    
    for k = 1:t
        
        taskT(i,k)    = max(Time(q:stlj(k),9)) + ETC.D( pop(i,stlj(k)),cs+U(k))*lt;
        
        tasksumC(i,k) = sum(Time(q:stlj(k),4)) + ETC.D(pop(i,stlj(k)),cs+U(k)) *lc;
        
        tasksumE(i,k) = sum(Time(q:stlj(k),7)) + ETC.D(pop(i,stlj(k)),cs+U(k)) *le;
        
        taskQ(i,k)    = prod(Time(q:stlj(k),5));
        
        taskR(i,k)    = prod(Time(q:stlj(k),6));
        
        taskLC(i,k)   = sum(Time(q:stlj(k),10));
        
        q = stlj(k) + 1;
        
    end
    
        W = zeros(cs,1); E_Idle = zeros(cs,1);
        
        for g = 1:cs   % 企业数量
            
            index = find( Time(:,1)==g );
            
            if ~isempty(index)
                
                g2          = length(unique(Time(index,2))); % 资源类型数量
                
                W(g,1)      = sum(Time(index,3));        % 第g个企业的工作负载
                
                E_Idle(g,1) = g2 * max(Time(index,9)) -W(g,1);
                
            end
            
        end  
    
    
    % 计算每个用户的能耗
    
    
    p     = 1;
        
    for u = 1: user
            
            userT(i,u) = max(taskT(i,p:uer_cumsum(u)));       % 第i个用户的交工时间
            
            userC(i,u) = sum(tasksumC(i,p:uer_cumsum(u)));    % 第i个用户提交的任务的成本
            
            userE(i,u) = sum(tasksumE(i,p:uer_cumsum(u)));    % 第i个用户的任务的总能耗
            
            userQ(i,u) = sum(taskQ(i,p:uer_cumsum(u)))/Global.utasknum(u); % 第i个用户的平均服务质量
            
            userR(i,u) = sum(taskR(i,p:uer_cumsum(u)))/Global.utasknum(u); % 第i个用户的平均服务可靠性

            p = 1 + uer_cumsum(u);   
            
    end  
    
       Makespan(i,1)        = max(userT(i,:));    % 记录该种群中每个云服务上的完工时间，取最大值即为所有任务的完工时间
       
       Completecost(i,1)    = sum(userC(i,:));    % 所有用户的总成本
       
       AvgserviceQ(i,1)     = 1/min( userQ(i,:) );
       
       AvgserviceR(i,1)     = 1/min( userR(i,:) );
       
       TEC(i,1)             = sum(userE(i,:));    % 所有用户的能耗
       
       Workload(i,1)        = max(W);
       
       Idle(i,1)            = sum(E_Idle);
       
       
    
end

if Global.M == 5
    
    objectvalue = [Makespan,Completecost,AvgserviceQ,AvgserviceR,TEC];
    
elseif Global.M == 8
    
    objectvalue = [Makespan,Completecost,AvgserviceQ,AvgserviceR,TEC,Workload,Idle,sum(taskLC,2)];
    
end

% objectvalue = userT;


end












function P = calculateP(pop)

    t_number = length(unique(pop));
    
    [r,c] = size(pop);
    P = zeros(r,c);
    
    for i =1 : r
        a = ones(t_number,1);
        for j = 1:c                                        
            if pop(i,j) == 1
                P(i,j) = 10 + 0.1*a(1);
                 a(1) = a(1) + 1;
            end
        
            for p=2:t_number
                if pop(i,j) == p
                    P(i,j) = 10 * p + 0.1 * a(p);
                    a(p) = a(p) + 1;
                end
            end      
        end
    end
end
