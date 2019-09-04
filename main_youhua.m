%% 本程序用于多种优化算法的对比
% 分别为粒子群 遗传算法 鲸鱼算法  基于冯洛伊曼拓扑的鲸鱼算法
% 运行只需要取消对应算法的注释
% 将不需要的算法加上注释  即‘%’
% 由于运行比较慢  我已经保存了一次vnwoa的结果在trace中
% 未优化的程序在lssvm_putong中
clear
clc
close all
format compact
%% 加载数据
load data_kjade
input=data_kjade;
output=[1*ones(1,100) 2*ones(1,100) 3*ones(1,100) 4*ones(1,100) 5*ones(1,100) 6*ones(1,100) 7*ones(1,100) 8*ones(1,100) 9*ones(1,100) 10*ones(1,100)]';
rand('seed',0)
%% 随机取700为训练集  300为测试集
[m,n]=sort(rand(1,1000));
m=700;
X1=input(n(1:m),:);
y1=output(n(1:m),:);
Xt=input(n(m+1:end),:);
yt=output(n(m+1:end),:);
%%
N=5;
G=10;
% [x,trace]=psoforlssvm(N,G,X1,y1,Xt,yt);%粒子群算法
% [x,trace]=gaforlssvm(N,G,X1,y1,Xt,yt);%遗传算法
[x,trace]=woaforlssvm(N,G,X1,y1,Xt,yt);%鲸鱼算法
% [x,trace]=vnwoaforlssvm(N,G,X1,y1,Xt,yt);%改进鲸鱼算法
load trace 
figure
plot(trace)
xlabel('迭代次数')
ylabel('适应度值')
title('适应度曲线')
%%
gam = x(1)  
sig2 =x(2)
% 利用寻优得到的最优gam与sig2重新训练lssvm
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
xlabel('训练集样本编号')
ylabel('输出标签')
title('训练集分类输出')

%%% 测试集准确率
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

