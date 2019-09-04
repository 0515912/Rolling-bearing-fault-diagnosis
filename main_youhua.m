%% ���������ڶ����Ż��㷨�ĶԱ�
% �ֱ�Ϊ����Ⱥ �Ŵ��㷨 �����㷨  ���ڷ����������˵ľ����㷨
% ����ֻ��Ҫȡ����Ӧ�㷨��ע��
% ������Ҫ���㷨����ע��  ����%��
% �������бȽ���  ���Ѿ�������һ��vnwoa�Ľ����trace��
% δ�Ż��ĳ�����lssvm_putong��
clear
clc
close all
format compact
%% ��������
load data_kjade
input=data_kjade;
output=[1*ones(1,100) 2*ones(1,100) 3*ones(1,100) 4*ones(1,100) 5*ones(1,100) 6*ones(1,100) 7*ones(1,100) 8*ones(1,100) 9*ones(1,100) 10*ones(1,100)]';
rand('seed',0)
%% ���ȡ700Ϊѵ����  300Ϊ���Լ�
[m,n]=sort(rand(1,1000));
m=700;
X1=input(n(1:m),:);
y1=output(n(1:m),:);
Xt=input(n(m+1:end),:);
yt=output(n(m+1:end),:);
%%
N=5;
G=10;
% [x,trace]=psoforlssvm(N,G,X1,y1,Xt,yt);%����Ⱥ�㷨
% [x,trace]=gaforlssvm(N,G,X1,y1,Xt,yt);%�Ŵ��㷨
[x,trace]=woaforlssvm(N,G,X1,y1,Xt,yt);%�����㷨
% [x,trace]=vnwoaforlssvm(N,G,X1,y1,Xt,yt);%�Ľ������㷨
load trace 
figure
plot(trace)
xlabel('��������')
ylabel('��Ӧ��ֵ')
title('��Ӧ������')
%%
gam = x(1)  
sig2 =x(2)
% ����Ѱ�ŵõ�������gam��sig2����ѵ��lssvm
[yc,codebook,old_codebook] = code(y1,'code_OneVsOne'); 
%code_OneVsAll
%code_OneVsOne
%code_MOC
model = initlssvm(X1,yc,'c',gam,sig2,'RBF_kernel');
model = trainlssvm(model);
Y = simlssvm(model,X1);
predict_label = code(Y,old_codebook,[],codebook);
fprintf(1,'Accuracy: %2.2f\n',100*sum(predict_label==y1)/length(y1));
figure 
stem(y1)
hold on
plot(predict_label,'*')
xlabel('ѵ�����������')
ylabel('�����ǩ')
title('ѵ�����������')

%%% ���Լ�׼ȷ��
Y = simlssvm(model,Xt);
predict_label = code(Y,old_codebook,[],codebook);
fprintf(1,'Accuracy: %2.2f\n',100*sum(predict_label==yt)/length(yt));
figure 
stem(yt)
hold on
plot(predict_label,'*')
xlabel('���Լ��������')
ylabel('�����ǩ')
title('���Լ��������')

