function CSSP2excel(statistical_res,M)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   ��ÿ���㷨Ŀ�꺯����ƽ��ֵ����Сֵ��

% ��ʾ��i�飬 ��q���㷨
% 
% currentPath = fileparts(mfilename('fullpath'));
% 
% line_pos = char(abs('D')+q-1);
% 
% position = [line_pos,num2str(2*(i-1)*M+4),':',line_pos,num2str( 4+2*M*(i-1)+2*M-1 )]; % D4----D9
% 
% ins = num2cell([MinObj,MeanObj]');
% 
% xlswrite([currentPath,'\RESULT.xlsx'],ins,['Obj-M',num2str(M)],position);

% fprintf('��%d��ĵ�%d���㷨�ĸ�Ŀ�꺯��ֵ��������\n',i,q);
sheetname_IGD = ['IGD-M',num2str(M)];
sheetname_HV  = ['HV-M',num2str(M)];
sheetname_SM  = ['SM-M',num2str(M)];
sheetname_GS  = ['GS-M',num2str(M)];

statistical_res.IGD = Ranksum_evaluate(statistical_res.IGD);
statistical_res.HV = Ranksum_evaluate(statistical_res.HV);
statistical_res.SM = Ranksum_evaluate(statistical_res.SM);
statistical_res.GS = Ranksum_evaluate(statistical_res.GS);

[r,c]    = size( statistical_res.IGD );

currPath = fileparts( mfilename('fullpath') ); 

expand   = char(abs('A')+c-1);% A--->F

result_loc = ['A2:',expand,num2str(r+1)];

xlswrite([currPath,'\output\RESULT.xlsx'],statistical_res.IGD,sheetname_IGD,result_loc);

xlswrite([currPath,'\output\RESULT.xlsx'],statistical_res.HV,sheetname_HV,result_loc);

xlswrite([currPath,'\output\RESULT.xlsx'],statistical_res.SM,sheetname_SM,result_loc);

xlswrite([currPath,'\output\RESULT.xlsx'],statistical_res.GS,sheetname_GS,result_loc);

fprintf('results has filled the excel');

end



function IGD = Ranksum_evaluate(IGD)

[r,c] = size(IGD);
IGDc.better  = false(r-1,c-2);
IGDc.similar = false(r-1,c-2);
IGDc.worse   = false(r-1,c-2);

for i = 1:r-1
    
    for j = 1:c-2
        
        switch IGD{i+1,j+2}(end)
            case '+'
                IGDc.better(i,j) = true;
            case '-'
                IGDc.worse(i,j) = true;
            otherwise
                IGDc.similar(i,j) = true;
        end
             
    end
end



% IGDcomp = zeros(1c-2);

for j = 1:c-2
    
    IGD{r+1,j+2} = [num2str(sum(IGDc.better(:,j))),'/',num2str(sum(IGDc.similar(:,j))),'/',num2str(sum(IGDc.worse(:,j)))];
    
end





end
