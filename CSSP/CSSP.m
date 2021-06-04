classdef CSSP < PROBLEM
    % <problem> <CSSP>
    %   计算三个目标函数：
    %   继承了PROBLEM类
    
    methods
        function obj = CSSP()
            
            [user,utasknum,st,NoType,NoE,~]  = TestCase(obj.Global.TEST);
            obj.Global.user       = user;
            obj.Global.utasknum   = utasknum;
            obj.Global.st         = st;
            obj.Global.cs         = NoE;

            if isempty(obj.Global.D)
                
                obj.Global.D = 2 * sum(obj.Global.st);
                
            end
            
            obj.Global.lower = [];
            obj.Global.upper = [];
            obj.Global.encoding = 'INTEGER';
            %  计算用户参数
%             obj.Global.ETC = SaveUserParameters(obj.Global.st,obj.Global.user,obj.Global.cs,NoType,obj.Global.TEST);
            % 加载用户参数
            obj.Global.ETC = LoadUserParameters(obj.Global.TEST);
            
        end
        
        function PopObj = CalObj(obj,PopDec)
            
            PopObj = Obj_CSSP(obj.Global,PopDec);
            
        end
        
       %% Calculate constraint violations
%         function PopCon = CalCon(obj,PopDec)
%             
%             [PopCon, ~] = ObjValue(obj,PopDec);
%             
%         end
        
       %% Sample reference points on Pareto front
        function P = PF(obj,N)
            P(:,1) = (0:1/(N-1):1)';
            P(:,2) = 1 - P(:,1).^0.5;
        end
    end
end

