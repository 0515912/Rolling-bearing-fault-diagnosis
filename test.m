function flag=test(chrom)
%此函数用来判断individuals.chrom里数值是否超过边界bound
%bound为（-1:1）

f1=isempty(find(chrom>1));
f2=isempty(find(chrom<-1));
if f1*f2==0
    flag=0;
else
    flag=1;
end%出售各类算法优化深度极限学习机代码392503054