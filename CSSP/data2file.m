
for g = 1:16
    
    
    load(['Group',num2str(g),'.mat'])
    
    data.taskinfo = obj.StInform;
    
    NoE = size(obj.EInform,1);
    
    csinfo = cell(NoE+1,6);
    
    name = {'subtasktype','ServiceTime','ServiceCost',...
        'ServiceQuality','ServiceRea','EC'};
    
    for j =1:6
        
        csinfo{1,j} = name{1,j};
        
    end
    
    
    for i = 1:NoE
        
        for j =1:6
        
            csinfo{i+1,j} =  obj.EInform{i,j};
       
        end
    end
    
    data.csinfo = csinfo;
    
    data.D = obj.D;
    
    
    save(['resource\group_',num2str(g),'.mat']);
    
end