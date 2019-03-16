%% 适配值函数     
%输入：
%个体的长度（TSP的距离）
%输出：
%个体的适应度值
function FitnV= calculateFitness(route)
global d;
len = 0;
N=length(route);
for i = 1:N-1
    len = len +d(route(i),route(i+1));
end
len=len+d(route(1),route(N));%首尾相连
FitnV=len;