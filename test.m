function flag=test(chrom)
%�˺��������ж�individuals.chrom����ֵ�Ƿ񳬹��߽�bound
%boundΪ��-1:1��

f1=isempty(find(chrom>1));
f2=isempty(find(chrom<-1));
if f1*f2==0
    flag=0;
else
    flag=1;
end%���۸����㷨�Ż���ȼ���ѧϰ������392503054