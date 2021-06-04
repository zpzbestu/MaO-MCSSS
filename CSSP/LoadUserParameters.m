function obj = LoadUserParameters(TEST)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

 path = fileparts(mfilename('fullpath'));
 
 load([path,'\resource\Group',num2str(TEST),'.mat']); 
 
end

