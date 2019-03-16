clear all
close all
clc
%��ʼ����Ⱥ����
%load("Cities.mat")
%load("city_50.mat")
NP = 30;               
FoodNumber = NP/2;     %ʳ��Դ����Ŀ��˳�򷽰�����Ŀ��
Limit = 100;           %����ʳ��Դ�ľֲ���������
maxCycle = 15000;      %���ѭ������
%����λ�þ���
C=unifrnd (1, 100, 2, 14); %������ɳ�����Ŀ
x=C(1,:);
y=C(2,:);

%���������֮��ľ���
N=length(x);
% ����ȫ�ֱ���
global NC;
global d;
NC = N;
for m = 1:N
    for n = 1:N
        d(m,n) =sqrt((x(m)-x(n))^2+(y(m)-y(n))^2);
    end
end
%����ʼ·��ͼ
figure(1);
for m = 1:NC
    scatter(x(m),y(m),50,'r')
    hold on
end
x=[x x(1)];
y=[y y(1)];
plot(x,y)
title('��ʼ·��','Fontsize',18);
xlabel('����X����','Fontsize',14);
ylabel('����Y����','Fontsize',14);
runtime = 20;                                                  %%%%%%�ֲ�������������
GlobalMins = zeros(1,runtime);%��ʼ���ֲ����Ž�
for r = 1:runtime
    %��ʼ����Ⱥ
   a=initial(FoodNumber,NC);%�����ȥѰ��ʳ��Դ����ʼ�����з���˳��
for i = 1:FoodNumber 
    Foods(i,:) = a(i,:);%�ҵ���ʳ��Դ������
end
%������Ӧ�Ⱥ���ֵ
for i = 1:FoodNumber
    route = Foods(i,:);
    Fitness(i) = calculateFitness(route);%������Ӧ��
end
% ��ʼ���������������ں�Limit�Ƚ�
trial=zeros(1,FoodNumber);
%�ҳ���Ӧ�Ⱥ���ֵ����Сֵ
BestInd = find(Fitness == min(Fitness));
BestInd = BestInd(end);
GlobalMin = Fitness(BestInd);
GlobalParams = Foods(BestInd,:);
%������ʼ
iter = 1;
j = 1;
while ((iter <= maxCycle))
    %%%%%%%%����� %%%%%%%%
    for i = 1:FoodNumber
       %�������3�����е�˳�򣬸ı��ʱ��·��
        route_next = Foods(i,:);
        l = round(2+(N-2)*rand());
        m = round(2+(N-2)*rand());
        n = round(2+(N-2)*rand());
        temp = route_next(l);
        route_next(l) = route_next(m);
        route_next(m) = route_next(n);
        route_next(n) = temp;
        %��������Դ����Ӧ�Ⱥ���ֵ
        FitnessSol = calculateFitness(route_next);
        %ʹ��̰��׼��Ѱ��������Դ
        if (FitnessSol < Fitness(i))
            Foods(i,:) = route_next;
            Fitness(i) = FitnessSol;
            trial(i) = 0;
        else
            trial(i) = trial(i)+1;
        end
    end
    %%%%%%%%%%%������Ӧ��ֵ��������䱻��������ĸ���
    prob = (0.9*Fitness./max(Fitness))+0.1;
    %%%%%%%%%%%%%    �����     %%%%%%%%
    i = 1;
    t = 0;
    while(t < FoodNumber)
        
        if(rand < prob(i))
            t = t+1;
        %�������2�����е�˳�򣬸ı��ʱ��·��
       route_next = Foods(i,:);
        l = round(2+(N-2)*rand());
        m = round(2+(N-2)*rand());
        n = round(2+(N-2)*rand());
        temp = route_next(n);
        route_next(n) = route_next(m);
        route_next(m) = temp;
        %2-opt �㷨
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
        %��������Դ����Ӧ�Ⱥ���ֵ
        FitnessSol = calculateFitness(route_next);
        %ʹ��̰��׼��Ѱ��������Դ
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
    %��¼��ʱ���õĽ�
    ind = find(Fitness==min(Fitness));
    ind = ind(end);
    if (Fitness(ind)<GlobalMin)
        GlobalMin = Fitness(ind);
        GlobalParams = Foods(ind,:); 
    end
    %%%%%%%%����ģʽ %%%%%%%%
    ind = find(trial == max(trial));
    ind = ind(end);
    if (trial(ind) > Limit)     %������������������ֵ�������������������µĽ�
        Bas(ind) = 0;
        route_new = Foods(1+FoodNumber*fix(rand()),:);
        FitnessSol = calculateFitness(route_new);
        Foods(ind,:) = route_new;
        Fitness(ind) = FitnessSol;
    end
    %%%%%%%%����һ�����������Ž�ľ����Ա㻭ͼ %%%%%%
    Cishu(j) = iter;
    Zuiyou(j) = GlobalMin;
    j = j + 1;
    iter = iter + 1;
end
GlobalMins(r) = GlobalMin;
disp(['��',num2str(r),'�����еõ�������·���ǣ�',num2str(GlobalParams),'����·���ĳ�����:',num2str(GlobalMins(r))]);
end
%%%%%%%% ������ͼ %%%%%%%%%
figure(2)
plot(Cishu,Zuiyou,'b');
title('�Ż�����','Fontsize',18);
xlabel('��������','Fontsize',14);
ylabel('·������','Fontsize',14);
figure(3);
for m = 1:NC
    scatter(x(m),y(m),50,'r');
    hold on
end
GlobalParams=[GlobalParams GlobalParams(1)];
plot(x(GlobalParams),y(GlobalParams))
title('�Ż�·��','Fontsize',18);
xlabel('����X����','Fontsize',14);
ylabel('����Y����','Fontsize',14);
display("�Ż�����Сֵ"+min(GlobalMins))
