%% 初始化种群
%输入：
% NIND：种群大小
% N：   这里为城市的个数  
%输出：
%初始顺序方案
function order = initial(NIND,N)
order=zeros(NIND,N);%用于存储方按顺序
for i=1:NIND
    A = randperm(N);
    order(i,:)=[A];%随机生成初始顺序方案
end