function ret=select(individuals,sizepop)
% �ú������ڽ���ѡ�����
% individuals input    ��Ⱥ��Ϣ
% sizepop     input    ��Ⱥ��ģ
% ret         output   ѡ��������Ⱥ
%����Ӧ��ֵ����  
[a bestch]=min(individuals.fitness);
%b=individuals.chrom(bestch);
%c=individuals.fitness(bestch);
fitness1=10./individuals.fitness; %individuals.fitnessΪ������Ӧ��ֵ
%����ѡ�����
sumfitness=sum(fitness1);
sumf=fitness1./sumfitness;
%�������̶ķ�ѡ���¸���
index=[];
for i=1:sizepop   %sizepopΪ��Ⱥ��
    pick=rand;
    while pick==0   
        pick=rand;       
    end
    for i=1:sizepop   
        pick=pick-sumf(i);       
        if pick<0       
            index=[index i];           
            break; 
        end
    end
end
%index=[index bestch];
%����Ⱥ
individuals.chrom=individuals.chrom(index,:);   %individuals.chromΪ��Ⱥ�и���
individuals.fitness=individuals.fitness(index);
%individuals.chrom=[individuals.chrom;b];
%individuals.fitness=[individuals.fitness;c];
ret=individuals;%���۸����㷨�Ż���ȼ���ѧϰ������392503054