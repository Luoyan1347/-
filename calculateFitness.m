%% ����ֵ����     
%���룺
%����ĳ��ȣ�TSP�ľ��룩
%�����
%�������Ӧ��ֵ
function FitnV= calculateFitness(route)
global d;
len = 0;
N=length(route);
for i = 1:N-1
    len = len +d(route(i),route(i+1));
end
len=len+d(route(1),route(N));%��β����
FitnV=len;