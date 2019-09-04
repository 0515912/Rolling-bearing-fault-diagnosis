%% 普通 lssvm
clear
clc
close all
format compact
addpath LSSVMlab
%% 加载数据
load data_kjade
input=data_kjade;
output=[1*ones(1,100) 2*ones(1,100) 3*ones(1,100) 4*ones(1,100) 5*ones(1,100) 6*ones(1,100) 7*ones(1,100) 8*ones(1,100) 9*ones(1,100) 10*ones(1,100)        ]';
rand('seed',0)
%% 随机取700为训练集  300为测试集
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

%% 测试集准确率
Y = simlssvm(model,Xt);
predict_label = code(Y,old_codebook,[],codebook);
fprintf(1,'Accuracy: %2.2f\n',100*sum(predict_label==yt)/length(yt));
figure 
stem(yt)
hold on
plot(predict_label,'*')
xlabel('测试集样本编号')
ylabel('输出标签')
title('测试集分类输出')

