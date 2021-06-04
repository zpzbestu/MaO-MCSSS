% 运行前先修改obj.save

% 运行前修改文件保存位置

runtime = 20;
M       = [3,5,8];
N       = [120,210,240];
evaluations = [60000,100000,100000];


TEST = 1; 
for k = 1:length(M)    
    for j = 1 : runtime
        main('-algorithm',@MOEAAES,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',TEST,'-run',j,'-save',1);
        main('-algorithm',@VariantI,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',TEST,'-run',j,'-save',1);
        main('-algorithm',@VariantII,'-problem',@CSSP,'-M',M(k),'-N',N(k),'-evaluation',evaluations(k),'-TEST',TEST,'-run',j,'-save',1);
    end
end


[user,utasknum,st,~,NoE,D]  = TestCase(1);

Score = FEs('NSGAIII','CSSP',M,D,runtime,50);

    