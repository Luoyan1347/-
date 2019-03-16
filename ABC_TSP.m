clear all
close all
clc
%初始化种群参数
%load("Cities.mat")
%load("city_50.mat")
NP = 30;               
FoodNumber = NP/2;     %食物源的数目（顺序方案的数目）
Limit = 100;           %放弃食物源的局部搜索次数
maxCycle = 15000;      %最大循环次数
%城市位置矩阵
C=unifrnd (1, 100, 2, 14); %随机生成城市数目
x=C(1,:);
y=C(2,:);

%计算各城市之间的距离
N=length(x);
% 定义全局变量
global NC;
global d;
NC = N;
for m = 1:N
    for n = 1:N
        d(m,n) =sqrt((x(m)-x(n))^2+(y(m)-y(n))^2);
    end
end
%画初始路径图
figure(1);
for m = 1:NC
    scatter(x(m),y(m),50,'r')
    hold on
end
x=[x x(1)];
y=[y y(1)];
plot(x,y)
title('初始路径','Fontsize',18);
xlabel('城市X坐标','Fontsize',14);
ylabel('城市Y坐标','Fontsize',14);
runtime = 20;                                                  %%%%%%局部搜索修正次数
GlobalMins = zeros(1,runtime);%初始化局部最优解
for r = 1:runtime
    %初始化蜂群
   a=initial(FoodNumber,NC);%侦查蜂出去寻找食物源（初始化城市方案顺序）
for i = 1:FoodNumber 
    Foods(i,:) = a(i,:);%找到了食物源并带回
end
%计算适应度函数值
for i = 1:FoodNumber
    route = Foods(i,:);
    Fitness(i) = calculateFitness(route);%计算适应度
end
% 初始化搜索次数，用于和Limit比较
trial=zeros(1,FoodNumber);
%找出适应度函数值的最小值
BestInd = find(Fitness == min(Fitness));
BestInd = BestInd(end);
GlobalMin = Fitness(BestInd);
GlobalParams = Foods(BestInd,:);
%迭代开始
iter = 1;
j = 1;
while ((iter <= maxCycle))
    %%%%%%%%引领蜂 %%%%%%%%
    for i = 1:FoodNumber
       %随机交换3个城市的顺序，改变此时的路线
        route_next = Foods(i,:);
        l = round(2+(N-2)*rand());
        m = round(2+(N-2)*rand());
        n = round(2+(N-2)*rand());
        temp = route_next(l);
        route_next(l) = route_next(m);
        route_next(m) = route_next(n);
        route_next(n) = temp;
        %计算新蜜源的适应度函数值
        FitnessSol = calculateFitness(route_next);
        %使用贪婪准则，寻找最优蜜源
        if (FitnessSol < Fitness(i))
            Foods(i,:) = route_next;
            Fitness(i) = FitnessSol;
            trial(i) = 0;
        else
            trial(i) = trial(i)+1;
        end
    end
    %%%%%%%%%%%根据适应度值计算引领蜂被跟随蜂跟随的概率
    prob = (0.9*Fitness./max(Fitness))+0.1;
    %%%%%%%%%%%%%    跟随蜂     %%%%%%%%
    i = 1;
    t = 0;
    while(t < FoodNumber)
        
        if(rand < prob(i))
            t = t+1;
        %随机交换2个城市的顺序，改变此时的路线
       route_next = Foods(i,:);
        l = round(2+(N-2)*rand());
        m = round(2+(N-2)*rand());
        n = round(2+(N-2)*rand());
        temp = route_next(n);
        route_next(n) = route_next(m);
        route_next(m) = temp;
        %2-opt 算法
        s=randi(N-4);  
        d1=d(route_next(1,s),route_next(1,s+1));
        d2=d(route_next(1,s),route_next(1,s+2));
        d3=d(route_next(1,s),route_next(1,s+3));
        d4=d(route_next(1,s),route_next(1,s+4));
        d_min=min(d(s,:));
        check_d=[d1 d2 d3 d4];
        n = find(check_d == min(check_d));
        k=route_next(s+1);
        if route_next(s+1)~=route_next(s+n)
            route_next(s+1)=route_next(s+n);
            route_next(s+n)=k;
        end
        %计算新蜜源的适应度函数值
        FitnessSol = calculateFitness(route_next);
        %使用贪婪准则，寻找最优蜜源
        if (FitnessSol < Fitness(i))
            Foods(i,:) = route_next;
            Fitness(i) = FitnessSol;
            trial(i) = 0;
        else
            trial(i)=trial(i)+1;
        end
        end
        i = i+1;
        if (i == (FoodNumber +1))
            i = 1;
        end
    end
    %记录此时更好的解
    ind = find(Fitness==min(Fitness));
    ind = ind(end);
    if (Fitness(ind)<GlobalMin)
        GlobalMin = Fitness(ind);
        GlobalParams = Foods(ind,:); 
    end
    %%%%%%%%侦察蜂模式 %%%%%%%%
    ind = find(trial == max(trial));
    ind = ind(end);
    if (trial(ind) > Limit)     %若搜索次数超过极限值，则进行随机搜索产生新的解
        Bas(ind) = 0;
        route_new = Foods(1+FoodNumber*fix(rand()),:);
        FitnessSol = calculateFitness(route_new);
        Foods(ind,:) = route_new;
        Fitness(ind) = FitnessSol;
    end
    %%%%%%%%建立一个次数和最优解的矩阵，以便画图 %%%%%%
    Cishu(j) = iter;
    Zuiyou(j) = GlobalMin;
    j = j + 1;
    iter = iter + 1;
end
GlobalMins(r) = GlobalMin;
disp(['第',num2str(r),'次运行得到的最优路径是：',num2str(GlobalParams),'此条路径的长度是:',num2str(GlobalMins(r))]);
end
%%%%%%%% 画曲线图 %%%%%%%%%
figure(2)
plot(Cishu,Zuiyou,'b');
title('优化曲线','Fontsize',18);
xlabel('迭代次数','Fontsize',14);
ylabel('路径长度','Fontsize',14);
figure(3);
for m = 1:NC
    scatter(x(m),y(m),50,'r');
    hold on
end
GlobalParams=[GlobalParams GlobalParams(1)];
plot(x(GlobalParams),y(GlobalParams))
title('优化路径','Fontsize',18);
xlabel('城市X坐标','Fontsize',14);
ylabel('城市Y坐标','Fontsize',14);
display("优化后最小值"+min(GlobalMins))
