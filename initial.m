%% ��ʼ����Ⱥ
%���룺
% NIND����Ⱥ��С
% N��   ����Ϊ���еĸ���  
%�����
%��ʼ˳�򷽰�
function order = initial(NIND,N)
order=zeros(NIND,N);%���ڴ洢����˳��
for i=1:NIND
    A = randperm(N);
    order(i,:)=[A];%������ɳ�ʼ˳�򷽰�
end