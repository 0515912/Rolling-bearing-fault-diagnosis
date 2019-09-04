function fit=fun(x,p_train,t_train,p_test,t_test)
gam = x(1)    ;  
sig2 =x(2);
[t_train1,codebook,old_codebook] = code(t_train,'code_OneVsOne'); 
%code_OneVsAll
%code_OneVsOne
%code_MOC
model = initlssvm(p_train,t_train1,'c',gam,sig2,'RBF_kernel');
model = trainlssvm(model);
Y0 = simlssvm(model,p_test);
Y1 = code(Y0,old_codebook,[],codebook);
fit=sum(Y1==t_test)/length(Y1);%利用分类准确率作为适应度函数

