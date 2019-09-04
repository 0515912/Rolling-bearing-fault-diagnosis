%% ��ͨ lssvm
clear
clc
close all
format compact
addpath LSSVMlab
%% ��������
load data_kjade
input=data_kjade;
output=[1*ones(1,100) 2*ones(1,100) 3*ones(1,100) 4*ones(1,100) 5*ones(1,100) 6*ones(1,100) 7*ones(1,100) 8*ones(1,100) 9*ones(1,100) 10*ones(1,100)        ]';
rand('seed',0)
%% ���ȡ700Ϊѵ����  300Ϊ���Լ�
[m,n]=sort(rand(1,1000));
m=700;
X1=input(n(1:m),:);
y1=output(n(1:m),:);
Xt=input(n(m+1:end),:);
yt=output(n(m+1:end),:);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gam = 81.6492    ;  
sig2 =53.5081;
[yc,codebook,old_codebook] = code(y1,'code_MOC'); 
model = initlssvm(X1,yc,'c',gam,sig2,'RBF_kernel');
model = trainlssvm(model);

%% ���Լ�׼ȷ��
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

