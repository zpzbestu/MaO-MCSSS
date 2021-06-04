IGDvalue = [];HVvalue = [];

for i = 1:length(Me)
    
    IGDvalue = [IGDvalue,Me{i,2}.IGD]; 
    
    HVvalue = [HVvalue,Me{i,2}.HV];
    
end



figure(2); 

tag = []; p = 1;

for i = 1:length(Me)
    
    k = 1;
    
    for j = 1:length(algorithm)
        
        tag{1,p} = [algorithm{1,j},'-',num2str(i)];
        
        p = p+1;
        
        k = k+1;
    end
    
end
   
filename = fileparts(mfilename('fullpath'));
figure(1);boxplot(IGDvalue,'labels',tag);ylabel('IGD');
set(gca,'XTickLabelRotation',46,'Fontsize',6);
set(gcf,'unit','centimeters','position',[6 6 8 6]);
print(gcf,'-dpng','-r600',[filename,'\boxplot of IGD for M-3']); 

figure(2);boxplot(HVvalue*10^3,'labels',tag);ylabel('HV');
set(gca,'XTickLabelRotation',46,'Fontsize',6);
set(gcf,'unit','centimeters','position',[6 6 8 6]);
print(gcf,'-dpng','-r600',[filename,'\boxplot of HV for M-3']);