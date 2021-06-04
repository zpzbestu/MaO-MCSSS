function obj = SaveUserParameters(st,NoU,NoE,NoType,TEST)
%   NoU 用户的个数  utasknum 每个用户的任务个数 
%   st每个任务的子任务个数

%   NoE 企业的个数

%   NoType  子任务类型个

L = sum(st);

D = round(unifrnd(200,500,NoE,NoE+NoU));

for i=1:NoE
    for j=1:NoE+NoU
        if i<j
            D(j,i)=D(i,j);        
        elseif i==j
            D(i,j)=0;
        end
    end
end

%  -------------------------->>>子任务信息<<<<------------------------------
StInform = zeros(L,1);

for i = 1:L
    
    StInform(i,1) = unidrnd(NoType);
    
end




% --------------->>>>>企业信息<<<<<-----------------  每个企业拥有的资源类型

   
EInform =cell(NoE,6);  % 第i个企业的第j种资源类型的参数（服务时间、服务成本、服务质量、服务可靠性，服务能耗）  

for i   =1 : NoType
    
    w =  round( unifrnd(NoE*0.2,NoE*0.4) );
    
    h =  randperm(NoE,w);  % 哪些企业拥有第i种资源（从企业中随机选择w个）
    
    for j = 1:length(h)
        
        
         ServiceTime    = round(unifrnd(2,10));  % 服务时间在2-10天之间
         
         ServiceCost    = round(unifrnd(10,30));
         
         ServiceQuality = round(unifrnd(0.85,0.99),2);
         
         ServiceRea     = round(unifrnd(0.9,0.99),2);
         
         EC             = round(unifrnd(10,30));
         
         EInform{h(j),1}  = [EInform{h(j),1},i];
         
         EInform{h(j),2}  = [EInform{h(j),2},ServiceTime];
         
         EInform{h(j),3}  =  [EInform{h(j),3},ServiceCost];
         
         EInform{h(j),4}  =  [EInform{h(j),4},ServiceQuality];
         
         EInform{h(j),5}  =  [EInform{h(j),5},ServiceRea];
         
         EInform{h(j),6}  =  [EInform{h(j),6},EC];
         
    end
    
    
    
end

% AE avalible enterprise

for i = 1:L
    
    AE(i).s =[]; AE(i).index =[];
    
    for j = 1:NoE
        
        if ismember(StInform(i,1),EInform{j,1}) == 1
            
            position = find(EInform{j,1}==StInform(i,1));
            
            AE(i).s = [AE(i).s,j];
            
            AE(i).index = [AE(i).index,position];
            
        end
    end
    
end


obj.StInform    = StInform;
obj.EInform     = EInform;
obj.AE          = AE;
obj.D           = D;


path = fileparts(mfilename('fullpath'));

save([path,'\Group',num2str(TEST),'.mat'],'obj');




end

